import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_catalog.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/game/morris_repetition.dart';

void main() {
  test('same movement position is a draw on its fifth occurrence', () {
    final board =
        List<PlayerSide?>.filled(GameCatalog.nine.board.pointCount, null)
          ..[0] = PlayerSide.light
          ..[2] = PlayerSide.light
          ..[4] = PlayerSide.light
          ..[1] = PlayerSide.dark
          ..[3] = PlayerSide.dark
          ..[5] = PlayerSide.dark;
    final state = MorrisGameState(
      board: board,
      turn: PlayerSide.light,
      lightToPlace: 0,
      darkToPlace: 0,
    );
    final counts = <String, int>{};

    for (var occurrence = 1; occurrence < 5; occurrence++) {
      expect(MorrisRepetition.record(state, counts), isFalse);
    }
    expect(MorrisRepetition.record(state, counts), isTrue);
  });

  test('position repetition distinguishes whose turn it is', () {
    final state = MorrisGameState(
      board: List<PlayerSide?>.filled(GameCatalog.nine.board.pointCount, null),
      turn: PlayerSide.light,
      lightToPlace: 0,
      darkToPlace: 0,
    );
    final counts = <String, int>{};
    MorrisRepetition.record(state, counts);

    expect(
      MorrisRepetition.record(state.copyWith(turn: PlayerSide.dark), counts),
      isFalse,
    );
    expect(counts.values, everyElement(1));
  });

  test('placement positions are ignored', () {
    final state = MorrisGameState(
      board: List<PlayerSide?>.filled(GameCatalog.nine.board.pointCount, null),
      turn: PlayerSide.light,
      lightToPlace: 1,
      darkToPlace: 1,
    );

    expect(MorrisRepetition.record(state, <String, int>{}), isFalse);
  });
}
