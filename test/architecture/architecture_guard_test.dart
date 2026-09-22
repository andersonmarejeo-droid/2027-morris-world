import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('feature screens use shared navigation, shell and feedback infrastructure', () {
    final root = Directory('lib/features');
    final dartFiles = root
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    final forbidden = <String, RegExp>{
      'direct Scaffold': RegExp(r'\bScaffold\s*\('),
      'direct Navigator.push': RegExp(r'Navigator\.(push|pushNamed|pushReplacement)'),
      'direct haptics': RegExp(r'HapticFeedback\.'),
      'direct system sound': RegExp(r'SystemSound\.'),
      'direct audio player': RegExp(r'AudioPlayer\s*\('),
      'direct bottom sheet': RegExp(r'showModalBottomSheet\s*<'),
      'direct dialog': RegExp(r'showDialog\s*<'),
      'custom animation duration': RegExp(r'Duration\s*\(milliseconds:'),
      'hardcoded visible Text': RegExp(r'''Text\s*\(\s*['"]'''),
    };

    final failures = <String>[];
    for (final file in dartFiles) {
      final source = file.readAsStringSync();
      for (final entry in forbidden.entries) {
        if (entry.value.hasMatch(source)) {
          failures.add('${file.path}: ${entry.key}');
        }
      }
    }
    expect(failures, isEmpty, reason: failures.join('\n'));
  });
}
