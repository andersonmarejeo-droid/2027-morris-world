# Firebase production activation — Morris World v1.0.0

The source package contains the server-authoritative Morris validator and trusted write rules. Online ranked play must remain disabled until the real cloud project is configured.

## Required before enabling Online
1. Register Android and iOS apps in the real Firebase project.
2. Add the real Android `google-services.json` and iOS `GoogleService-Info.plist` through the normal Firebase/Flutter workflow.
3. Enable the chosen Firebase Authentication providers.
4. Enable Firestore and Realtime Database in the intended production region.
5. Deploy `firestore.rules` and `database.rules.json`.
6. In `functions/`, install dependencies, build TypeScript, then deploy Cloud Functions.
7. Register App Check providers. For Android production, configure Play Integrity; configure the matching Apple provider for iOS.
8. Verify callable requests carry valid Auth + App Check tokens.
9. Test challenge accept → live match creation → submitMove revision/turn validation → capture → completion → match history.
10. Only after emulator/test-device validation, replace the disabled client gateway with the Firebase-backed gateway and flip the feature flag.

## Security invariants
- Clients never write `liveMatches` directly.
- `submitMove` is the move write path and validates participant, side, turn, optimistic revision and Morris legality.
- Challenge creation/accept/decline/rematch go through callable functions.
- Completed match history is backend-written.
- App Check is enforced on callable functions in source; production provider setup is still a console/project action.
- Do not enable ranked matchmaking with a client-authoritative fallback.
