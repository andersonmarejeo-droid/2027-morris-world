import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_catalog.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/core/game/morris_engine.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/match/match_models.dart';

void main() {
  test('match session round-trips through database map', () {
    var state = MorrisEngine.initial(GameCatalog.nine);
    state = MorrisEngine.place(GameCatalog.nine, state, 0);
    final original = MatchSession(
      config: const MatchConfig(
        sessionId: 'test-session',
        gameId: MorrisGameId.nine,
        mode: MatchMode.offlineAi,
        difficulty: AiDifficulty.medium,
      ),
      state: state,
      status: MatchSessionStatus.active,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(123456789),
      visualTrace: const MatchVisualTrace(
        actor: PlayerSide.light,
        to: 0,
        millPoints: <int>[],
      ),
      moveCount: 1,
    );

    final restored = MatchSession.fromDatabaseMap(original.toDatabaseMap());
    expect(restored.config.sessionId, original.config.sessionId);
    expect(restored.config.gameId, MorrisGameId.nine);
    expect(restored.config.difficulty, AiDifficulty.medium);
    expect(restored.state.board, original.state.board);
    expect(restored.state.turn, original.state.turn);
    expect(restored.state.lightToPlace, original.state.lightToPlace);
    expect(restored.updatedAt, original.updatedAt);
    expect(restored.visualTrace?.to, 0);
    expect(restored.visualTrace?.actor, PlayerSide.light);
    expect(restored.moveCount, 1);
  });
}
