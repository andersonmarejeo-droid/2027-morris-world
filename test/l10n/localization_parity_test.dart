import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all ARB locales contain the same message keys', () {
    final dir = Directory('lib/l10n');
    final files = dir
        .listSync()
        .whereType<File>()
        .where((file) => RegExp(r'app_[A-Za-z_]+\.arb$').hasMatch(file.path))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    expect(files, isNotEmpty);

    Set<String> messageKeys(File file) {
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      return json.keys.where((key) => !key.startsWith('@') && key != '@@locale').toSet();
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
}
