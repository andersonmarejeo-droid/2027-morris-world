import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('professional gameplay and release foundations are present', () {
    final board =
        File(
          'lib/features/gameplay/presentation/widgets/morris_board.dart',
        ).readAsStringSync();
    final controller =
        File(
          'lib/features/gameplay/application/match_session_controller.dart',
        ).readAsStringSync();
    final settings =
        File('lib/core/settings/app_settings_models.dart').readAsStringSync();
    final router = File('lib/app/app_router.dart').readAsStringSync();
    final feedback =
        File('lib/core/feedback/app_feedback_service.dart').readAsStringSync();

    expect(board, contains('legalTargets'));
    expect(board, contains('capturablePoints'));
    expect(board, contains('lastMoveFrom'));
    expect(board, contains('GestureDetector'));
    expect(board, contains('CustomPaint'));
    expect(board.contains('LongPressDraggable'), isFalse);
    expect(board.contains('DragTarget<'), isFalse);
    expect(controller, contains('MorrisRules.legalMovesFrom'));
    expect(settings, contains('reduceMotion'));
    expect(settings, contains('colorAssist'));
    expect(router, contains('TutorialScreen'));
    expect(router, contains('OnlineLobbyScreen'));
    expect(feedback, contains('AssetSource'));
  });

  test('audio asset pack is complete', () {
    const required = [
      'piece_drop.wav',
      'slide_wood.wav',
      'slide_marble.wav',
      'slide_stone.wav',
      'piece_move_swoosh.mp3',
      'match_gong.wav',
      'mill.wav',
      'capture.wav',
      'success.wav',
      'button.wav',
    ];
    for (final name in required) {
      expect(File('assets/audio/$name').existsSync(), isTrue, reason: name);
    }
    final feedback =
        File('lib/core/feedback/app_feedback_service.dart').readAsStringSync();
    expect(feedback, contains("'audio/piece_move_swoosh.mp3'"));
    expect(feedback, contains("'audio/match_gong.wav'"));
  });

  test(
    'firebase security foundation never grants client live-match writes',
    () {
      final databaseRules = File('database.rules.json').readAsStringSync();
      final firestoreRules = File('firestore.rules').readAsStringSync();
      expect(databaseRules, contains('"liveMatches"'));
      expect(databaseRules, contains('".write": false'));
      expect(firestoreRules, contains('allow write: if false'));
    },
  );

  test('server authoritative online validator is wired', () {
    final index = File('functions/src/index.ts').readAsStringSync();
    final validator = File('functions/src/morris.ts').readAsStringSync();
    expect(index, contains('applyMorrisCommand'));
    expect(index, contains('expectedRevision'));
    expect(index, contains('enforceAppCheck: !isFunctionsEmulator'));
    expect(index, contains("FUNCTIONS_EMULATOR === 'true'"));
    expect(index, contains("status: completed ? 'completed' : 'inProgress'"));
    expect(validator, contains('export function applyMorrisCommand'));
    expect(validator, contains('protected-mill-piece'));
  });
}
