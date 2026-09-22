# V0.3.1 validation fixes

- Added `app_pt.arb` as the required base fallback for `pt_BR`.
- Removed deprecated `synthetic-package` from `l10n.yaml`.
- Fixed the RTL/large-text widget test: collection `for` is no longer inside a const expression.
- Validation now stops immediately when any Flutter native command returns a non-zero exit code.
- Validation rejects non-ASCII project paths because Flutter 3.47 has an analysis-server regression that can crash `flutter analyze` on such paths.
- Recommended Windows project path: `C:\Users\GiresuN\StudioProjects\morris_world`.
