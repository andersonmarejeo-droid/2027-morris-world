# V0.3.2 Analyze Cleanup

This patch is intentionally small. It only removes analyzer/lint blockers found by the first real Windows validation run.

- Removed obsolete non-null assertions from `AppLocalizations.of(context)`.
- Removed unused `flutter/widgets.dart` import from `app_tokens.dart`.
- Converted the SQLite multiline SQL literal to single quotes.
- Converted the dialog callback binding to a function declaration.
- Made validation-script error text ASCII-only so Windows PowerShell 5 does not display mojibake.
- Validation still stops immediately on the first failing Flutter command.

No Morris game rules, persistence schema, navigation contract, or UI behavior was changed.
