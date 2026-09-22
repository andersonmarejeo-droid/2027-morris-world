import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'immersive gameplay pacing, reserves, captures and WhatsApp are present',
    () {
      final ai = File('lib/core/ai/morris_ai.dart').readAsStringSync();
      final board =
          File(
            'lib/features/gameplay/presentation/widgets/morris_board.dart',
          ).readAsStringSync();
      final bar =
          File(
            'lib/features/gameplay/presentation/widgets/match_player_bar.dart',
          ).readAsStringSync();
      final friends =
          File(
            'lib/features/social/presentation/friends_screen.dart',
          ).readAsStringSync();
      final share =
          File(
            'lib/features/social/application/challenge_share_service.dart',
          ).readAsStringSync();
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final whatsAppSurface = '$friends\n$share';

      expect(
        RegExp(
          r'thinkDelay\s*=\s*Duration\(\s*milliseconds:\s*850\s*\)',
        ).hasMatch(ai),
        isTrue,
      );
      expect(
        RegExp(
          r'moveReveal\s*=\s*Duration\(\s*milliseconds:\s*1150\s*\)',
        ).hasMatch(ai),
        isTrue,
      );
      expect(board, contains('_drawCapturedTrays'));
      expect(board, contains('_drawCapturedPieceMotion'));
      expect(board, contains('_drawMaterialDetail'));
      expect(board, contains('capturedLight'));
      expect(board, contains('capturedDark'));

      // Phase 1 intentionally makes the reserve rack slightly tighter so the
      // fixed-height player cards cannot push the board when the turn changes.
      expect(RegExp(r'overlapFactor\s*=\s*0\.(?:48|50)').hasMatch(bar), isTrue);
      expect(bar, contains('_ActiveReserveStone'));
      expect(bar, contains('height: 86'));

      // WhatsApp may live on the legacy Friends screen or the shared challenge
      // service. The product contract is the behavior, not one source file.
      expect(whatsAppSurface, contains('whatsapp://send'));
      expect(whatsAppSurface, contains('Uri.https'));
      expect(whatsAppSurface, contains('wa.me'));
      expect(whatsAppSurface, contains('launchUrl'));
      expect(pubspec, contains('url_launcher:'));
    },
  );

  test('ANR safe board architecture remains intact', () {
    final board =
        File(
          'lib/features/gameplay/presentation/widgets/morris_board.dart',
        ).readAsStringSync();
    expect(board.contains('AnimationController'), isFalse);
    expect(board.contains('LongPressDraggable'), isFalse);
    expect(board.contains('DragTarget<'), isFalse);
    expect(board, contains('TweenAnimationBuilder<double>'));
  });
}
