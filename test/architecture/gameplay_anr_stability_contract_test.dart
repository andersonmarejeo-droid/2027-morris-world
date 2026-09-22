import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'gameplay first frame keeps single-painter safe animation architecture',
    () {
      final board =
          File(
            'lib/features/gameplay/presentation/widgets/morris_board.dart',
          ).readAsStringSync();
      expect(board.contains('AnimationController'), isFalse);
      expect(board.contains('LongPressDraggable'), isFalse);
      expect(board.contains('DragTarget<'), isFalse);
      expect(board, contains('TweenAnimationBuilder<double>'));
      expect(board, contains('moveSequence'));
      expect(board, contains('_drawMovingPiece'));
    },
  );

  test('gameplay route boots before session work', () {
    final router = File('lib/app/app_router.dart').readAsStringSync();
    final screen =
        File(
          'lib/features/gameplay/presentation/game_screen.dart',
        ).readAsStringSync();
    expect(router, contains("state.uri.path.startsWith('/play/')"));
    expect(screen, contains('addPostFrameCallback'));
  });

  test('AI pacing and reserve stones are explicit product contracts', () {
    final ai = File('lib/core/ai/morris_ai.dart').readAsStringSync();
    final controller =
        File(
          'lib/features/gameplay/application/match_session_controller.dart',
        ).readAsStringSync();
    final bar =
        File(
          'lib/features/gameplay/presentation/widgets/match_player_bar.dart',
        ).readAsStringSync();
    expect(ai, contains('moveReveal'));
    expect(ai, contains('humanMoveReveal'));
    expect(controller, contains('_aiMoveReveal'));
    expect(controller, contains('visualMoveDuration'));
    expect(bar, contains('_ReserveRack'));
    expect(bar, contains('_ActiveReserveStone'));
  });
}
