import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_catalog.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/game/morris_rules.dart';

void main() {
  final definition = GameCatalog.byId(MorrisGameId.nine);

  test('placement targets are every empty point', () {
    final state = MorrisGameState.initial(
      pointCount: definition.board.pointCount,
      piecesPerPlayer: definition.piecesPerPlayer,
    );
    expect(MorrisRules.legalPlacements(definition, state).length, 24);
  });

  test('movement targets come from adjacency before flying', () {
    final board = List<PlayerSide?>.filled(24, null)
      ..[0] = PlayerSide.light
      ..[1] = PlayerSide.dark
      ..[9] = null
      ..[3] = PlayerSide.light
      ..[4] = PlayerSide.light
      ..[6] = PlayerSide.light;
    final state = MorrisGameState(
      board: board,
      turn: PlayerSide.light,
      lightToPlace: 0,
      darkToPlace: 0,
    );
    expect(MorrisRules.legalMovesFrom(definition, state, 0), {9});
  });

  test('capture protects mill when another opponent stone is outside mills', () {
    final board = List<PlayerSide?>.filled(24, null)
      ..[0] = PlayerSide.dark
      ..[1] = PlayerSide.dark
      ..[2] = PlayerSide.dark
      ..[3] = PlayerSide.dark
      ..[9] = PlayerSide.light
      ..[10] = PlayerSide.light
      ..[11] = PlayerSide.light;
    final state = MorrisGameState(
      board: board,
      turn: PlayerSide.light,
      lightToPlace: 0,
      darkToPlace: 0,
      pendingCaptureBy: PlayerSide.light,
    );
    expect(MorrisRules.capturablePoints(definition, state), {3});
  });
}
