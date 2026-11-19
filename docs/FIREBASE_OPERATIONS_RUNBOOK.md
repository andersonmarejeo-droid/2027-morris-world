# Firebase operations runbook

**Product:** Morris World
**Current source release:** v1.1.0+29
**Scope:** future Blaze-backed trusted online services; current Spark room mode is documented separately
**Last reviewed:** 2026-09-27

This runbook defines the operational controls for future trusted online
services. The current implementation also has an optional, casual Spark mode
for invite-code rooms; see [Spark private rooms](FIREBASE_SPARK_PRIVATE_ROOMS.md).
This document's Cloud Functions, Firestore history, public matchmaking, and
ranked-play procedures are not part of that free mode.

The client-side online feature gate is fail-closed by default. Do not enable
Spark rooms until their Realtime Database rules have passed the focused
emulator suite and those rules have been deployed. No ranked gameplay or
competitive result should depend on client-authored Spark room state.

Related document: [Firebase production activation runbook](FIREBASE_PRODUCTION_ACTIVATION.md).

## 1. Service inventory and data boundaries

| Service | Intended use | Source-of-truth rule |
| --- | --- | --- |
| Firebase Authentication | player identity | never trust a UID supplied in a callable payload |
| Cloud Functions (2nd gen) | authoritative challenge and move validation | callable operations require Auth and App Check |
| Cloud Firestore | profiles, challenges, match history, leaderboards, quick messages | trusted backend writes protected match data |
| Realtime Database | presence, matchmaking, live match state | clients may read only their allowed data and cannot write live matches |
| Realtime Database `sparkRooms` | optional Spark invite-code casual matches | only authenticated room participants may read; current-turn player may submit casual state; never use for rankings or prizes |
| App Check | app attestation at callable boundary | rejection rate is a security and rollout signal |
| Cloud Logging / Monitoring | operations evidence and alerting | retain only as long as the approved data policy permits |

Realtime Database live match state is operationally important but should not be
the only durable record of a completed result. Match history must be verified
in Firestore after completion. The source persists a non-secret RTDB
finalization marker and exposes an idempotent participant reconciliation
callable if Firestore finalization is interrupted. Public ranked play remains
blocked until that recovery path is proven in the Emulator Suite, observed in
staging, and monitored in production.

## 2. Roles, ownership, and access

Use named identities, group-managed access, and least privilege. Do not use
shared human accounts, personal service-account keys, Firebase project Owner,
or broad Editor access for routine work.

| Role | Typical responsibilities | Access boundary |
| --- | --- | --- |
| Product owner | retention choices, user communication, rollout approval | no routine production write access |
| Release owner | approved deployment and release record | deploy only through approved workflow |
| Operations/on-call | triage, alert response, rollback coordination | read-only observability by default; time-bound break-glass elevation |
| Security owner | rules/App Check/IAM review and incident severity | security configuration review; separate approver |
| Developer | local emulator and staging development | no production admin by default |
| CI deploy identity | deploy one approved project/environment | narrowly scoped, keyless, audited |

Maintain an IAM matrix outside the app repository with principal, group,
project, role, ticket, approval date, expiry, and owner. Review it at least
quarterly and immediately after a team member changes role or leaves.

### Break-glass access

1. Grant a time-bound elevation only for an active incident or approved
   recovery exercise.
2. Record the incident/change ID, requestor, approver, start time, end time,
   and commands performed.
3. Remove the elevation immediately after resolution.
4. Review all break-glass actions at the next operational review.

## 3. Monitoring, logs, and alerting

Create dashboards before public enablement. Each alert must have an owner,
severity, notification route, runbook link, and a known action. Avoid alerts
that page on normal zero-traffic behavior.

### Required dashboard panels

- Callable request count, success/error/unauthenticated/permission-denied
  rate, p50/p95/p99 latency, cold starts, concurrency, and instance count.
- Per-function error breakdown for createChallenge, respondToChallenge,
  createRematch, submitMove, sendQuickMessage, and validateChallengeState.
- App Check valid/invalid/missing-token rejections, split by app version and
  platform when available.
- Firebase Auth sign-in failures, account creation/deletion issues, and
  provider errors.
- Firestore and RTDB read/write/delete volume, throttling, permission-denied
  rule events, connection count, storage, and unusual path growth.
- Cross-database consistency: completed RTDB matches without a matching
  Firestore history record, stale in-progress matches, duplicate completions,
  and failed reconciliation attempts.
- Deployment/change markers, current app version cohort, active feature flags,
  backup status, PITR status, and budget burn.

### Initial alert policy

Tune thresholds with staging and a production baseline. The values below are
starting points, not an excuse to ignore a smaller player-impacting anomaly.

| Signal | Initial trigger | Severity | First action |
| --- | --- | --- | --- |
| Callable 5xx/internal error rate | >1% for 5 minutes or any widespread match failure | high | stop rollout; inspect deploy/change and function logs |
| submitMove p95 latency | >2 seconds for 10 minutes after baseline is known | medium | inspect function/RTDB/Firestore latency and capacity |
| Auth/App Check rejection surge | >3x baseline for 10 minutes, or affects a new release cohort | high | halt cohort; verify provider, app config, and abuse traffic |
| Protected-path permission-denied anomaly | sustained/new spike above baseline | high | check client regression and rules; do not loosen rules reactively |
| RTDB completed match without Firestore history | any unresolved item beyond agreed recovery SLO | high | disable ranked cohort; begin reconciliation incident |
| Firestore/RTDB quota or throttling | 70% warning, 85% urgent of a known quota or budgeted capacity | medium/high | reduce rollout/load and inspect unexpected reads/writes |
| Cost forecast | 50%, 80%, and 100% of monthly approved budget | advisory/high/critical | notify owner; apply rollout or service controls |
| Backup/PITR failure or overdue drill | any missed successful expected run | high | investigate before next production change |

Set notifications so high severity reaches the on-call route and the release
owner; medium severity creates a tracked incident; advisory signals reach the
weekly operational review. Test every alert route before public launch.

### Log hygiene

- Never log raw App Check tokens, ID tokens, Authorization headers, service
  account keys, private user content, or full move payloads if they contain
  personal data.
- Use a non-secret correlation ID, match ID where policy permits, function
  name, release SHA, app version, and sanitized error category.
- Define log retention with the privacy owner. Restrict log viewers because
  operational logs can contain identifiers and behavior data.
- Preserve deployment output, incident timeline, and recovery evidence with
  the release record; do not use screenshots as the only audit trail.

## 4. Cost controls and budgets

Cloud Functions deployment requires an approved billing plan. Before any
production deployment:

1. Link the billing account owned by the organization, not an individual.
2. Create a monthly project budget with notification thresholds at 50%, 80%,
   and 100%, plus a forecast alert where available.
3. Route budget notifications to the product owner, operations owner, and a
   durable team channel.
4. Label releases/cost centres where the organization uses labels, and review
   Firestore, RTDB, Cloud Functions, Cloud Build, Artifact Registry, and log
   costs together.
5. Document a cost incident action: pause rollout, turn off online cohort,
   reduce nonessential traffic, then investigate. A budget alert is not a
   hard spend cap by itself.
6. Review actual versus forecast cost weekly during launch and monthly after
   stabilization.

Do not deploy a change that can fan out reads, retries, message writes, or
matchmaking polling without a load/cost estimate and monitoring query.

## 5. Backup, PITR, and recovery controls

### Firestore

Enable and verify both of the following for the production Firestore database:

- **Point-in-time recovery (PITR):** enable before launch, record the earliest
  recoverable timestamp, and monitor it. Firebase documentation currently
  describes a seven-day PITR window after data has accumulated; it does not
  backfill historical versions from before enablement.
- **Scheduled backups:** configure daily or weekly backup schedules with an
  approved retention period. Firebase documentation currently allows up to 14
  weeks. Record schedule, location, retention, last-success time, and owner.

Use the product's approved privacy/retention policy to choose backup retention.
Backups include data and index configuration but not every external service or
application setting. Keep source-controlled rules, indexes, Functions source,
release tags, and deployment records independently recoverable.

### Realtime Database and Functions

Do not assume Firestore PITR or Firestore backups protect Realtime Database.
Before production launch, document and test a Realtime Database export/restore
strategy appropriate to its selected region, data classification, and service
SLO. Until that exists, treat RTDB live state as recoverable only through the
approved canonical Firestore history/reconciliation design, not as an archive.

For Functions, recovery relies on the immutable source revision, pinned
package lock, deployment record, and CI artifact/provenance. Never rely on a
personal workstation as the only copy of production code or configuration.

### Backup verification checklist

- [ ] PITR is enabled and its earliest version time is recorded.
- [ ] Scheduled Firestore backup has completed successfully.
- [ ] Backup schedule/retention meet the approved data policy.
- [ ] RTDB export/restore plan is documented and tested.
- [ ] Source rules, indexes, function release SHA, and configuration are
  recoverable from version control and deployment records.
- [ ] Recovery owners and emergency contacts are current.

## 6. Data retention and deletion

Retention must be approved by the product/privacy owner before real player
records are stored. The repository currently has no complete TTL or deletion
implementation for every data type; this is a public-launch gate.

Create a retention register containing the following minimum rows:

| Data class | Examples | Required decision |
| --- | --- | --- |
| Identity/profile | users/{uid} fields and Auth identity | account deletion process, legal basis, retention after deletion |
| Social graph | users/{uid}/friends | deletion/cancellation behavior and support access |
| Challenge and live match metadata | challenges, RTDB liveMatches | expiry, abandoned-match cleanup, anti-fraud retention |
| Match history/rankings | matchHistory, leaderboards | player-visible history period, aggregation/anonymization policy |
| Quick messages/presence | quickMessages, RTDB presence | short TTL and moderation/abuse retention |
| Operational logs/backups | Cloud logs, PITR, scheduled backups | access restriction, retention, deletion and legal-hold process |

For each row, record the owner, purpose, location, deletion mechanism,
retention duration, restoration behavior, and verification evidence. Test
account deletion and data-expiry behavior in staging. Do not promise deletion
from backups/PITR outside the provider's documented lifecycle; document that
boundary honestly in the user-facing privacy notice.

## 7. Restore drill procedure

Run a recovery drill before public launch, after a major schema/recovery
change, and at least quarterly thereafter. A drill is successful only if a
person who did not build the feature can follow the record and verify the
result.

### Safe drill: restore to an isolated target

1. Open an approved change ticket; name a drill owner, observer, and rollback
   owner.
2. Choose a non-production or isolated restore target. Do not test against the
   active production database.
3. Record the source database, backup/PITR timestamp, target database, tool
   versions, expected document counts/checksums, and expected indexes.
4. Restore a scheduled backup or clone/recover from PITR according to the
   current official Firebase/Google Cloud documentation.
5. Verify document counts, sample match histories, rules/index configuration,
   access boundaries, and application read-only behavior against the release
   record.
6. Prove that the restored target cannot accidentally receive production
   traffic. Destroy or retain it only according to the approved test-data
   policy.
7. Attach timings, evidence, deviations, and remediation actions to the
   operations record.

### Production restore: break-glass only

An in-place Firestore restore is destructive and may require downtime. Do not
start one from a chat request, alert, or a single-person decision. First disable
online write traffic, preserve incident evidence, obtain the incident commander
and data-owner approvals, and select the known recovery point. Prefer recovery
to an isolated target and selective repair whenever it meets the incident SLO.

If an in-place restore is truly required, follow the current official
[Firestore restore documentation](https://firebase.google.com/docs/firestore/restore-in-place)
exactly and record the irreversible deletion/restore decision. After recovery,
redeploy the approved rules/indexes/functions as required, run rule and data
verification, then re-enable traffic gradually.

## 8. Incident response and rollback

### Triage levels

| Level | Example | Response |
| --- | --- | --- |
| SEV-1 | data exposure, unauthorized protected write, widespread lost/corrupt matches | immediately disable online cohort/writes; page security and incident commander |
| SEV-2 | high error rate, App Check outage, cross-database finalization failure | stop rollout; investigate and recover within the agreed SLO |
| SEV-3 | isolated player issue or noncritical dashboard anomaly | create tracked issue; monitor and remediate in normal release process |

### First 15 minutes

1. Open an incident record with UTC timeline, reporter, affected release, and
   impact estimate.
2. Freeze deployments and preserve logs, function revisions, rules versions,
   affected IDs, and deployment output.
3. Use the approved feature-off/kill switch or cohort control to stop new
   online matches. Do not loosen database rules to make errors disappear.
4. Identify whether the fault is client, callable function, Auth/App Check,
   Firestore, RTDB, rules, configuration, or abuse traffic.
5. Escalate to security immediately for any suspected unauthorized read/write,
   token misuse, secret exposure, or player-data disclosure.

### Rollback paths

| Problem | Preferred rollback |
| --- | --- |
| Client regression | disable online cohort/feature, halt rollout, release known-good client only after validation |
| Function regression | redeploy the known-good, immutable Functions commit through the approved workflow; verify callers and logs |
| Rules regression | redeploy the reviewed known-good rules from source control; Firebase does not provide a simple rules rollback button |
| Data corruption | preserve evidence; use approved PITR/backup recovery procedure; avoid destructive in-place restore unless authorised |
| App Check/provider fault | pause cohort, validate provider/configuration on test accounts, do not globally bypass enforcement without security approval |
| Cost/abuse spike | reduce/disable cohort, preserve forensic logs, apply reviewed rate/abuse controls, then investigate |

Every rollback requires post-rollback security and functional validation:
protected direct writes still fail, callable auth/App Check still work, match
states reconcile, monitoring recovers, and the release record identifies the
restored version.

## 9. Release gates

No online release may pass if any required gate is missing.

### Engineering gate

- Immutable source tag, clean build, dependency lock, successful lint/build,
  emulator test, integration test, and mobile release validation.
- Reviewed firebase.json, .firebaserc, Firestore indexes, database rules,
  Firestore rules, generated client options, and platform configuration.
- Tested auth failure, App Check failure, direct-write denial, happy path,
  retry/reconnect path, and cross-database recovery path.

### Security gate

- Auth + App Check enforcement verified on real release builds.
- Least-privilege IAM review complete; no long-lived developer key is used by
  the deployment path.
- Secret scanning and repository review completed.
- Rules reviewed with negative tests; no client-authoritative ranked path.
- Abuse/rate-limit/spam and challenge/message expiry design approved and
  tested before public exposure.

### Operations gate

- Dashboards, alerts, alert-routing test, budget/forecast alerts, and on-call
  ownership are active.
- Firestore PITR, scheduled backup, RTDB recovery plan, retention register,
  and restore drill evidence are current.
- Incident channel, feature-off procedure, known-good rollback commit, and
  production change approval are recorded.

### Product gate

- Cohort plan, support copy, privacy/retention disclosure, player reporting
  path, and status communication owner are ready.
- Online functionality is labelled accurately during beta/limited rollout.
- Rollout starts with allowlisted/internal users, then a measured cohort; it
  does not jump directly to every player.

## 10. Operational cadence

| Frequency | Required activity |
| --- | --- |
| Each deployment | complete activation checklist, watch post-deploy signals, archive release record |
| Daily during launch | review error/latency/App Check/data-consistency/cost dashboards |
| Weekly | review alert noise, functions errors, unusual database use, forecast cost, unresolved incidents |
| Monthly | review budgets, retention jobs, access changes, backup success, and release trends |
| Quarterly | access/IAM review, restore drill, incident tabletop exercise, App Check/provider review |
| After any incident | post-incident review, corrective actions, runbook update, test the fix |

## 11. Reference material

- [Firebase CLI and deployment source of truth](https://firebase.google.com/docs/cli)
- [Firebase App Check for Cloud Functions](https://firebase.google.com/docs/app-check/cloud-functions)
- [Firestore disaster recovery](https://firebase.google.com/docs/firestore/disaster-recovery)
- [Firestore backups](https://firebase.google.com/docs/firestore/backups)
- [Firestore point-in-time recovery](https://firebase.google.com/docs/firestore/enterprise/pitr)
- [Firestore in-place restore warning and procedure](https://firebase.google.com/docs/firestore/restore-in-place)
