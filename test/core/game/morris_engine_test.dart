import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_catalog.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/game/morris_engine.dart';

void main() {
  test('catalog exposes 3, 9 and 12 stone definitions', () {
    expect(GameCatalog.three.piecesPerPlayer, 3);
    expect(GameCatalog.three.board.pointCount, 9);
    expect(GameCatalog.nine.piecesPerPlayer, 9);
    expect(GameCatalog.nine.board.pointCount, 24);
    expect(GameCatalog.twelve.piecesPerPlayer, 12);
    expect(GameCatalog.twelve.board.pointCount, 24);
  });

  test('3 Stone ends immediately when a line is completed', () {
    final def = GameCatalog.three;
    var state = MorrisEngine.initial(def);
    state = MorrisEngine.place(def, state, 0); // light
    state = MorrisEngine.place(def, state, 3); // dark
    state = MorrisEngine.place(def, state, 1); // light
    state = MorrisEngine.place(def, state, 4); // dark
    state = MorrisEngine.place(def, state, 2); // light completes top row

    expect(state.winner, PlayerSide.light);
    expect(state.pendingCaptureBy, isNull);
  });

  test('9 Stone creates a capture right after a mill', () {
    final def = GameCatalog.nine;
    var state = MorrisEngine.initial(def);
    state = MorrisEngine.place(def, state, 0);
    state = MorrisEngine.place(def, state, 3);
    state = MorrisEngine.place(def, state, 1);
    state = MorrisEngine.place(def, state, 4);
    state = MorrisEngine.place(def, state, 2);

    expect(state.pendingCaptureBy, PlayerSide.light);
    state = MorrisEngine.capture(def, state, 3);
    expect(state.board[3], isNull);
    expect(state.turn, PlayerSide.dark);
  });

  test('12 Stone recognizes the added corner diagonal as a mill', () {
    final def = GameCatalog.twelve;
    var state = MorrisEngine.initial(def);
    state = MorrisEngine.place(def, state, 0);
    state = MorrisEngine.place(def, state, 1);
    state = MorrisEngine.place(def, state, 3);
    state = MorrisEngine.place(def, state, 2);
    state = MorrisEngine.place(def, state, 6);

    expect(state.pendingCaptureBy, PlayerSide.light);
    expect(MorrisEngine.formsMill(def, state.board, 6, PlayerSide.light), isTrue);
  });
}
