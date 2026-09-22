# Morris World v1.0.1+21 — Fix 1

This package is the corrected full 20-sprint overlay after the first real Flutter analyzer run.

Resolved analyzer findings:
- `MorrisBoard.board` was shadowed by a local widget variable. The local widget is now `boardWidget`; board state reads explicitly use `this.board`.
- Hit target values produced by `math.max` are normalized to `double`.
- Intro board sizing/timing/stroke values produced by `math.min`/`math.max` are normalized to `double`.
- Board painter node radius is normalized to `double`.
- Level progress and trail opacity are normalized to `double`.
- Product contract test uses single quotes for a simple literal.

The installer still performs automatic rollback if `flutter analyze`, tests, architecture/security contracts, or release build fail.
