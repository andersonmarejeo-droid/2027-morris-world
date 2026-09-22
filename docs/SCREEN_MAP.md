# Morris World Screen Map — v1.0

- `/` — Game selection + continue active match
- `/game/:gameId` — Online / Meydan Oku / Offline mode selection
- `/learn/:gameId` — 7-step interactive visual tutorial
- `/online/:gameId` — Online Arena foundation (ranked locked until secure backend deployment)
- `/play/:gameId/:mode` — gameplay
- `/friends` — friends / presence / challenge
- `/rankings` — world / country / friends rankings
- `/profile` — local/cloud-profile surface
- `/settings` — language, sound, haptic, motion, hints, accessibility and board customization

Unknown routes always land on the controlled route-error screen, never silently on Home.
