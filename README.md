# Morris World v1.1.0+28 — Visual Quality Sprint

This source overlay upgrades the shared 3 Taş / 9 Taş / 12 Taş project from the v0.4 foundation into a polished offline-first Morris platform.

## What is immediately testable
- Morris World branded, motion-aware opening experience
- Visual quality sprint covering responsive navigation, premium surfaces,
  settings board previews, refined match HUD, guided learning and social views
- Localized UTF-8 copy protection for every supported language
- premium board states: selected / legal target / capturable / mill / last move
- accessible tap-to-move interaction
- four board surfaces, three renderer views and three piece styles
- centralized low-latency sound assets and haptics
- five AI levels with expanded evaluation
- persisted visual trace, save/resume and lifecycle protection
- 7-step tutorial
- profile, friends, rankings and challenge client foundation
- 9-language parity, RTL, Reduce Motion and Color Assist
- release validation script and additional contract tests

## Online security rule
Ranked online play is intentionally not faked. The package includes the deterministic server-side 3/9/12 Morris validator, challenge-match creation, revision/turn/participant checks, trusted completion writes, and default-deny Firestore/Realtime Database rules. `OnlineMatchGateway` remains disabled until the real Firebase/Auth/App Check project is configured and these backend assets are deployed.

See `docs/V120_VISUAL_QUALITY_SPRINT.md` for the visual sprint, `docs/SPRINTS_01_20_IMPLEMENTATION.md` for the wider implementation history, and `docs/FIREBASE_PRODUCTION_ACTIVATION.md` for the production online activation checklist.

## Validate
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\MW_V100_VALIDATE.ps1
```

## Validate + build release APK to Desktop
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\MW_V100_VALIDATE.ps1 -BuildRelease
```
