# Morris World v1.0.0+20 — Master Release Manifest

This package consolidates the 20-sprint upgrade into one guarded installation.

Included product layers:
- Shared product/design contract and architecture guards.
- Hardened 3/9/12 Morris rule engine and query layer.
- Premium board rendering, themes, pieces, legal-target/capture/last-move/mill states.
- Tap + optional drag/drop, enlarged hit targets and localized semantics.
- Central motion, audio and haptic feedback with Reduce Motion / Sound / Haptic controls.
- Seven-step interactive tutorial.
- SQLite offline match continuation and lifecycle persistence.
- Multi-level bounded AI with richer evaluation.
- Profile, friends, challenges, rankings and localized quick-message foundations.
- Server-authoritative Cloud Functions validator for challenge matches and 3/9/12 move legality.
- Default-deny Firestore/RTDB security rules and App Check enforcement contract.
- Nine localization files in parity, including Arabic RTL support through Flutter localization.
- ZP GAMES animated intro and launcher icon family.
- Unit/widget/architecture/regression tests plus a release validation script.

Production boundary:
- Offline/local gameplay is self-contained in the package.
- Real ranked online activation still requires the user's Firebase/Auth/App Check project credentials and deployment steps. No insecure client-authoritative fallback is enabled.
