import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _arbFileName = RegExp(r'app_[A-Za-z_]+\.arb$');

/// Common signatures produced when UTF-8 text is decoded as a legacy
/// single-byte encoding. This deliberately targets sequences rather than
/// individual accented characters so valid localized copy remains valid.
final _commonMojibake = RegExp(
  r'(?:'
  r'[\u00C2\u00C3\u00C4\u00C5\u00D0\u00D1\u00D8\u00D9]'
  r'[\u0080-\u00BF\u0152\u0153\u0160\u0161\u0178\u017D\u017E]'
  r'|\u00E2\u20AC.'
  r'|\u00E0\u00A4'
  r'|\uFFFD'
  r')',
);

List<File> _arbFiles() {
  final dir = Directory('lib/l10n');
  return dir
      .listSync()
      .whereType<File>()
      .where((file) => _arbFileName.hasMatch(file.path))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
}

Map<String, dynamic> _readArb(File file) =>
    jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

Iterable<String> _stringValues(Object? value) sync* {
  switch (value) {
    case String value:
      yield value;
    case Map<String, dynamic> value:
      for (final entry in value.values) {
        yield* _stringValues(entry);
      }
    case List<dynamic> value:
      for (final entry in value) {
        yield* _stringValues(entry);
      }
  }
}

void main() {
  test('all ARB locales contain the same message keys', () {
    final files = _arbFiles();

    expect(files, isNotEmpty);

    Set<String> messageKeys(File file) {
      final json = _readArb(file);
      return json.keys
          .where((key) => !key.startsWith('@') && key != '@@locale')
          .toSet();
    }

    final reference = messageKeys(files.first);
    final failures = <String>[];
    for (final file in files.skip(1)) {
      final keys = messageKeys(file);
      final missing = reference.difference(keys);
      final extra = keys.difference(reference);
      if (missing.isNotEmpty || extra.isNotEmpty) {
        failures.add('${file.path}: missing=$missing extra=$extra');
      }
    }

    expect(failures, isEmpty, reason: failures.join('\n'));
  });

  test('decoded ARB values contain no common mojibake signatures', () {
    final failures = <String>[];

    for (final file in _arbFiles()) {
      for (final value in _stringValues(_readArb(file))) {
        if (_commonMojibake.hasMatch(value)) {
          failures.add('${file.path}: $value');
        }
      }
    }

    expect(failures, isEmpty, reason: failures.join('\n'));
  });

  test(
    'all language selectors preserve native names and bullet separators',
    () {
      const nativeLanguageNames = <String, String>{
        'languageTurkish': 'Türkçe',
        'languageSpanish': 'Español',
        'languageFrench': 'Français',
        'languagePortugueseBrazil': 'Português (Brasil)',
        'languageArabic': 'العربية',
        'languageHindi': 'हिन्दी',
      };
      const bulletSeparatedMessages = <String>[
        'computerModeSubtitle',
        'piecesToPlaceStatus',
        'recordValue',
      ];

      for (final file in _arbFiles()) {
        final arb = _readArb(file);
        for (final entry in nativeLanguageNames.entries) {
          expect(
            arb[entry.key],
            entry.value,
            reason: '${file.path} should preserve ${entry.value}.',
          );
        }
        for (final key in bulletSeparatedMessages) {
          expect(
            arb[key],
            contains('•'),
            reason: '${file.path} should use a bullet in $key.',
          );
        }
      }
    },
  );
}
