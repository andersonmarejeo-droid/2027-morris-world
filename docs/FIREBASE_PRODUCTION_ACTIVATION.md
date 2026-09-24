# Firebase production activation runbook

**Product:** Morris World
**Current source release:** v1.1.0+28 (from pubspec.yaml)
**Runbook status:** pre-activation; online ranked play is intentionally disabled
**Last reviewed:** 2026-09-24
**Applies to:** the exact Git commit and release version recorded in the release record below

This is the controlled path for enabling Morris World's Firebase-backed online
play. It is not a Firebase Console setup guide and it does not authorize a
production change by itself. The release owner must complete every applicable
gate, record the evidence, and obtain the required approvals before enabling
any client-facing online flag.

> **Stop condition:** Do not enable online ranked play just because Firebase
> initialization succeeds. The current client deliberately injects
> DisabledOnlineMatchGateway and onlineBackendConfigured is false. Replacing
> that protection is a separately reviewed product release after all backend,
> security, operational, and client gates below have passed.

## 1. Release record

Create one record for every activation, reactivation, or backend release.
Do not reuse an old record when the app version, backend revision, Firebase
project, or target environment changes.

| Field | Record before deployment |
| --- | --- |
| Mobile release | v____+____ |
| Git commit / immutable tag | ________ |
| Functions source commit | ________ |
| Firebase project ID | <production-project-id> |
| Environment | development / staging / production |
| Firestore and RTDB locations | ________ |
| Functions region(s) | ________ |
| Firebase CLI version | ________ |
| Node.js version | 22.x (matches functions/package.json) |
| Deployer identity | named human or CI service account |
| Change ticket / approval | ________ |
| Rollback release / commit | ________ |
| Start and completion UTC | ________ |

### Version rule

This document names v1.1.0+28 only as the current source baseline. Update
the header and perform the release gates again whenever pubspec.yaml,
functions/package.json, security rules, database schema, callable contract,
or Firebase project selection changes. A production deployment may only use
the immutable Git revision that was tested in the target environment.

## 2. What this repository currently provides

The source contains the following server-authoritative pieces:

- TypeScript Cloud Functions under functions/src, using second-generation
  callable functions.
- Callable operations: createChallenge, respondToChallenge, createRematch,
  submitMove, sendQuickMessage, and validateChallengeState.
- Firestore rules in firestore.rules and Realtime Database rules in
  database.rules.json.
- App Check enforcement in callable options for every deployed environment;
  the local Functions emulator is the sole explicit exception because it has
  no App Check emulator.
- A Firebase transport foundation, Auth/App Check bootstrap, Remote Config
  two-key rollout gate, and a deliberately disabled-by-default client gateway.
  The app does not expose a public online match flow until the remaining
  platform, backend, and release gates are complete.

The repository now contains reviewed Firebase resource mapping, a demo-project
emulator configuration, an empty explicit Firestore index manifest, and a
`.firebaserc.example` template. It deliberately does **not** contain a real
`.firebaserc` project mapping, generated Flutter Firebase options, Android/iOS
application files, or a credential-bearing production deployment workflow.
Those environment-specific items remain release blockers, not items to work
around manually in the Firebase Console.

## 3. Non-negotiable security invariants

Verify these properties in staging and production after each relevant change:

1. Clients cannot write liveMatches, match history, leaderboards, challenges,
   friend state, matchmaking tickets, or quick messages directly.
2. submitMove is the only supported live-match move path. It verifies the
   caller, side, active turn, optimistic revision, and Morris legality.
3. Challenge creation, response, rematch, and completion state transitions
   occur through trusted callable functions only.
4. A callable request requires both Firebase Authentication and a valid App
   Check token. A missing or invalid token must be rejected.
5. Ranked matchmaking has no client-authoritative fallback and remains off if
   its backend is unavailable, degraded, or unverified.
6. Production rules are deployed from reviewed source control, never edited
   only in the Firebase Console.
7. Production credentials, service-account keys, and operator tokens are not
   added to the app, repository, chat, screenshots, or issue tracker.

## 4. Environment model and ownership

Use separate Firebase projects for at least staging and production.
Development/emulator data must never share a production project, database,
or credentials.

| Environment | Purpose | Who may enable online play |
| --- | --- | --- |
| Local emulator | unit, contract, and rules testing | developers only |
| Staging | integration, App Check, real-device, load, and recovery rehearsal | release owner for test accounts only |
| Production | real player data and ranked matches | two-person approved release only |

Assign a release owner, security approver, and operations/on-call owner before
the first staging deploy. The current owner names and escalation routes belong
in FIREBASE_OPERATIONS_RUNBOOK.md, not in source code.

## 5. Pre-activation blockers and prerequisites

All items in this section must be complete before the first public production
activation.

### 5.1 Project and application setup

- Create the intended Firebase projects and record immutable project IDs.
- Select Firestore, Realtime Database, and Functions regions deliberately.
  Record the privacy, latency, and recovery rationale. Regions cannot be
  treated as an afterthought once player data exists.
- Register Android and iOS applications in each Firebase project.
- Generate Flutter Firebase options using the standard FlutterFire workflow.
  Keep environment-specific application configuration separated and do not
  copy production settings into development builds.
- Verify the release-network permission and complete the platform Firebase
  plugin setup through a reviewed mobile change. The Android main manifest now
  declares INTERNET, but the project still lacks Android/iOS Firebase service
  configuration for a real environment.
- Enable only the Authentication providers that have an approved account,
  abuse-prevention, deletion, and support flow.

### 5.2 Deployment-as-code setup

- Verify the reviewed firebase.json configuration maps Functions, Firestore
  rules/indexes, Realtime Database rules, Storage's default-deny rules, and
  the local emulator suite.
- Create the local .firebaserc from .firebaserc.example and replace every
  placeholder with a reviewed project alias. It may contain project IDs, but it must
  never contain secrets. The production alias must be unambiguous.
- Add and review firestore.indexes.json before queries that require composite
  indexes are introduced.
- Keep the committed Functions dependency lockfile and TypeScript typecheck
  gate current. The project intentionally uses strict TypeScript typechecking
  as its lint gate; a deployment gate must fail instead of silently skipping it.
- Add a reviewed CI release workflow with least-privilege workload identity or
  another approved secretless deployment method. A personal developer login
  is not a production release mechanism.
- Ensure .env files, service account files, local runtime configuration,
  Firebase debug logs, and generated platform configuration are handled
  according to the project's secret-management policy before they are created.

### 5.3 Service readiness

- Upgrade the Firebase project to an approved billing plan before deploying
  Cloud Functions, then configure cost budgets and alerting first.
- Enable Cloud Firestore and Realtime Database in the selected production
  locations.
- Configure App Check providers for each production app: Play Integrity for
  Android and the approved Apple provider for iOS. Test provider coverage with
  test accounts before enforcing the public client rollout.
- Grant the Functions runtime identity only the database access it needs and
  grant it the Firebase App Check token-verifier permission required by the
  enforcement model. Check the current Firebase documentation before assigning
  roles.
- Establish monitoring, log retention, backups/PITR, restore drills, and
  incident ownership as defined in FIREBASE_OPERATIONS_RUNBOOK.md.

## 6. Required validation before any deployment

Run the mobile repository validation from the release commit:

~~~powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./tools/MW_V100_VALIDATE.ps1
~~~

For Functions, use a clean working directory and the pinned Node.js toolchain.
The following commands are examples only; run them after the reviewed Firebase
configuration and lockfile exist. Replace placeholders locally; never paste a
real project ID or token into a shared document.

~~~powershell
Set-Location functions
npm ci
npm run lint
npm run build
~~~

If any command cannot run because the repository has not yet supplied its
required configuration or dependency, stop the release. Do not substitute a
global package, manually edit deployed code, or bypass a failed validation.

In the emulator/staging test suite, prove all of the following with recorded
inputs and outputs:

- unauthenticated callable requests fail;
- authenticated requests with an invalid/missing App Check token fail;
- non-participants cannot read a live match or match history;
- direct writes to protected RTDB and Firestore paths fail;
- replayed/stale revisions, wrong-turn moves, invalid moves, and forged
  captures fail;
- a happy path completes: challenge -> accept -> live match -> valid moves ->
  capture -> completion -> match history;
- a duplicate callable request, an interrupted client, and a retry do not
  produce contradictory match state;
- failure between Realtime Database match completion and Firestore
  finalization is detected, recovered, or safely blocked according to a
  reviewed design;
- accessibility, localization, large text, and offline behavior remain correct
  when Firebase is unavailable.

## 7. Deployment procedure

### Gate A - prepare an immutable candidate

1. Create a signed release candidate and an immutable Git tag/commit.
2. Record its details in the release record.
3. Confirm no uncommitted tracked changes and no secret-bearing files are in
   the candidate.
4. Confirm the selected Firebase alias resolves to the intended staging or
   production project. Read the project ID aloud during a two-person
   production deploy.
5. Confirm the rollback commit, feature-off mechanism, and on-call contact are
   ready before deploying.

### Gate B - deploy and verify staging

From the repository root, after firebase.json and aliases have been reviewed,
inspect the active project and use an explicitly named target:

~~~powershell
firebase --version
firebase use <staging-alias>
firebase projects:list
~~~

Build Functions before deployment. Then deploy only the intended resources;
the exact selector names must match the checked-in firebase.json:

~~~powershell
Set-Location functions
npm ci
npm run lint
npm run build
Set-Location ..
firebase deploy --project <staging-project-id> --only functions,firestore,database --message "Morris World v<version> <git-sha>"
~~~

Firebase CLI deployments of Firestore/Realtime Database rules overwrite the
corresponding Console rules. Treat the reviewed repository state as the source
of truth and save the deployment output with the release record.

Run the full validation matrix against staging: real Android/iOS devices,
valid App Check, invalid App Check, every callable operation, security rules,
retries, reconnection, observability, cost labeling, and a limited load test.
Do not use production players or production credentials in this gate.

### Gate C - production deployment with online feature still off

1. Obtain recorded approvals from release, security, and operations owners.
2. Re-run the candidate validation without code changes since staging approval.
3. Confirm production budgets, monitoring, backup/PITR, retention controls,
   restore rehearsal, and incident channel are active.
4. Deploy the same immutable commit using the explicit production project ID.
5. Verify deployed function names, region, rules, App Check enforcement, and
   logs against the release record.
6. Keep onlineBackendConfigured effectively off for public players. Use only
   allowlisted test accounts during post-deploy smoke testing.

### Gate D - controlled public enablement

Do not make the online client available until a reviewed Firebase-backed client
gateway, safe feature flag/kill switch, and production release have been
implemented. Enable in a small, measured cohort first. Watch the defined error,
latency, App Check rejection, data-consistency, and cost signals throughout the
observation window.

Immediately disable the cohort if a security invariant fails, a player can
write a protected path, move authority is inconsistent, or the online state is
not recoverable. Escalate using the incident procedure in the operations
runbook.

## 8. Production sign-off checklist

The release owner must mark every item as complete in the deployment record.

- [ ] Exact mobile version and Git commit are recorded.
- [ ] Staging and production project IDs, regions, and aliases were verified.
- [ ] Firebase configuration, rules, indexes, Functions source, dependencies,
  and generated client options were code-reviewed.
- [ ] Functions build, lint, emulator/integration, and release validation
  passed from the immutable candidate.
- [ ] Auth and App Check both reject unauthorised traffic as expected.
- [ ] Direct-client write attempts to protected data failed as expected.
- [ ] Full match lifecycle and failure/retry cases passed in staging.
- [ ] Cost budget, dashboards, alert routes, backup/PITR, retention plan, and
  restore drill evidence satisfy the operations runbook.
- [ ] The production deployment is linked to an incident channel and a known
  rollback/feature-off plan.
- [ ] Security, operations, and release owners approved the public rollout.
- [ ] Public enablement is staged and monitored; no client fallback exists.

## 9. References

- [Firebase CLI deployment and configuration](https://firebase.google.com/docs/cli)
- [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite)
- [Cloud Functions callable protocol](https://firebase.google.com/docs/functions/callable-reference)
- [App Check enforcement for Cloud Functions](https://firebase.google.com/docs/app-check/cloud-functions)
- [Firestore disaster recovery](https://firebase.google.com/docs/firestore/disaster-recovery)
