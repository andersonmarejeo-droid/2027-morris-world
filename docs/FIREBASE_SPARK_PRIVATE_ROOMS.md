# Firebase Spark private rooms

**Product:** Morris World / 3-9-12 Taş  
**Mode:** casual online matches by invite code  
**Billing:** Firebase Spark (no-cost); no Cloud Functions deployment

## What the free mode provides

- One player creates a private room for 3, 9, or 12 Stone.
- The other player joins by entering the room's opaque Firebase-generated code.
- Realtime Database synchronizes the board and turn between the two clients.
- Firebase anonymous Authentication identifies each session. App Check remains
  initialized by the client before room requests, and the SDK attaches a token
  when available. Because Realtime Database App Check enforcement is still off
  until a real Android Play Integrity token has been verified, a missing token
  must not block casual invite rooms. Authenticated, participant-scoped RTDB
  rules continue to protect room data.
- There is no public room list, automatic matchmaking, chat, ranking, prize,
  persistent match history, or trusted result verification.

This is a casual friend/family mode. The current-turn player calculates and
writes the next game state on their own device. Realtime Database rules restrict
room membership, data shape, and turn order, but they cannot prove every Morris
move is legal. A technically motivated participant could therefore cheat.
Do not use these matches for competitive results or rewards. A trusted,
server-validated mode remains a separate future project and would require
Cloud Functions (Blaze).

## Free-plan boundaries

Firebase currently lists Spark Realtime Database limits of 1 GB stored data,
10 GB/month downloads, and 100 simultaneous connections. These are project
quotas, not a promise that any volume of players will fit; monitor the Firebase
Console's Realtime Database Usage view. No automatic Cloud Function cleanup is
included, so close finished rooms in the app and periodically inspect old room
data if use grows.

Firebase Remote Config is published with `online_backend_enabled=true` and
`online_backend_minimum_build=29`. Release-mode builds opt into the online
candidate by default; local debug builds remain offline unless explicitly
configured for the Emulator Suite. The current release build baseline is
`1.1.10+40`, so older production binaries remain disabled and the remote
minimum-build check continues to protect the rollout. The Realtime Database
rules are deployed and the focused emulator tests have passed. Realtime
Database App Check enforcement remains off until Play Integrity has been
verified on an actual Android installation; do not turn it on earlier.

## Safe activation sequence

1. Anonymous sign-in is enabled for the project.
2. The Android app is registered and Firebase options are present in the app.
   Keep iOS out of scope until it is configured and tested.
3. The Android App Check app is registered. Do not use a debug token in a
   public release; verify the Play Integrity token from an actual Android
   installation before enabling API enforcement.
4. Start only the Realtime Database Emulator and run:

   ```powershell
   npm --prefix functions run test:database-emulator
   ```

5. Focused emulator tests have passed and **only** the Realtime Database rules
   from `database.rules.json` have been deployed. No Cloud Functions or
   Firestore deployment, and no billing-plan change, is needed for Spark rooms.
6. For a private two-device test, install release build 38 or newer from the
   closed test track. Test create, copy/share code, join, turns, reconnect,
   room closure, and denied non-participant access. The Remote Config parameters live in
   `remoteconfig.template.json`; deploy them only with
   `firebase deploy --only remoteconfig --project tas-4e90e`.
7. If candidate or App Check tests fail, set `online_backend_enabled=false`
   immediately. Keep App Check enforcement off until valid production tokens
   have been observed, then check RTDB usage after a small, known-user rollout.

## Startup without an age prompt

The app does not ask for age at launch. Offline play is available immediately,
and Firebase remains dormant until the player opens the online lobby. Only
then can a candidate build initialize Firebase, and private-room access still
requires App Check plus the Remote Config kill switch. Anonymous Auth is only
created when the player creates or joins a room. The Android Firebase
initialization provider is removed so the native SDK does not initialize
before that explicit online action. The registered Android package is
`com.zpgames.ucdokuzoniki`; `google-services.json` contains the matching
Firebase client entry and App Check is registered for that app.

## Data and family-safety boundaries

Room records contain a random room key, anonymous Firebase UIDs, game state,
turn metadata, and timestamps. They do not contain player names, email
addresses, free-form messages, or contact information. Share room codes only
with people the player already knows. Private-code rooms have no messaging or
open discovery. The codebase also contains four fixed quick-message choices in
the separate ranked/challenge match flow; they do not allow custom text. If
those routes are shipped or reachable, review them as social features and
reflect them accurately in the store declarations. This technical shape does
not replace the store's family/children policy review or adult supervision.

## Future upgrade path

When usage no longer fits Spark, first review Firebase's current quota and
cost details. A move to Blaze must be a deliberate owner decision. Trusted
ranked play, global matchmaking, verified match history, or moderation features
should use the existing Cloud Functions path only after its separate production
activation runbook is completed. No plan change is performed by this document.
