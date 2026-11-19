# Firebase Emulator integration tests

These tests exercise the local Firebase Emulator Suite only. They must never
use a real Firebase project, production credentials, or a production project
ID.

## Coverage

- Firestore profile ownership and backend-only challenge writes.
- Realtime Database participant reads and client-write denial for live matches.
- Spark private-room creation, invitation access, participant-only reads,
  three board sizes, turn ownership, and malformed-data rejection.
- Callable Function flow: anonymous Auth users create and accept a challenge,
  then the active player submits one legal move.

## Required local tooling

The Functions package needs these development dependencies before the tests can
run:

- `firebase-tools`
- `firebase`
- `@firebase/rules-unit-testing`

The package script should start the emulators with the safe demo project and
then execute Node's built-in test runner:

```json
{
  "test:emulator": "firebase emulators:exec --project demo-morris-world --only auth,firestore,database,functions \"node --test test/emulator\""
}
```

Run the TypeScript build first so the Functions emulator loads `lib/index.js`:

```powershell
npm --prefix functions run build
npm --prefix functions run test:emulator
```

The committed Firebase configuration must define the same local emulator
services and expose the default ports through the usual emulator environment
variables. CI must run this suite after linting and before any deployment step.

The Spark room rules can also be tested independently without downloading or
starting the Firestore or Functions emulators:

```powershell
npm --prefix functions run test:database-emulator
```

That focused test is the required security gate before deploying
`database.rules.json` for Spark private rooms.
