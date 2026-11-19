import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/ai/morris_ai.dart';
import 'package:nine_tas/core/game/game_catalog.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/game/morris_engine.dart';
import 'package:nine_tas/core/match/match_models.dart';

void main() {
  test('AI generates only engine-valid commands for 3/9/12 Stone', () {
    final ai = MorrisAiEngine(seed: 7);
    for (final definition in GameCatalog.all) {
      var state = MorrisEngine.initial(definition);
      for (var ply = 0; ply < 80 && state.phase != MatchPhase.finished; ply++) {
        final commands = ai.legalCommands(definition, state);
        expect(commands, isNotEmpty);
        for (final command in commands) {
          expect(
            () => ai.applyCommand(definition, state, command),
            returnsNormally,
            reason: '${definition.id.name}: $command',
          );
        }
        final command = ai.chooseCommand(
          definition: definition,
          state: state,
          difficulty: AiDifficulty.beginner,
          aiSide: state.turn,
        );
        state = ai.applyCommand(definition, state, command);
      }
    }
  });

  test('hard AI takes an immediate winning line in 3 Stone', () {
    final definition = GameCatalog.three;
    const state = MorrisGameState(
      board: [
        PlayerSide.dark,
        PlayerSide.dark,
        null,
        PlayerSide.light,
        null,
        null,
        PlayerSide.light,
        null,
        null,
      ],
      turn: PlayerSide.dark,
      lightToPlace: 1,
      darkToPlace: 1,
    );
    final ai = MorrisAiEngine(seed: 11);
    final command = ai.chooseCommand(
      definition: definition,
      state: state,
      difficulty: AiDifficulty.hard,
      aiSide: PlayerSide.dark,
    );
    expect(command.kind, AiCommandKind.place);
    expect(command.to, 2);
    final next = ai.applyCommand(definition, state, command);
    expect(next.winner, PlayerSide.dark);
  });

  test('hard AI blocks an immediate 3 Stone loss', () {
    final definition = GameCatalog.three;
    const state = MorrisGameState(
      board: [
        PlayerSide.light,
        PlayerSide.light,
        null,
        PlayerSide.dark,
        null,
        null,
        null,
        null,
        null,
      ],
      turn: PlayerSide.dark,
      lightToPlace: 1,
      darkToPlace: 2,
    );
    final ai = MorrisAiEngine(seed: 19);
    final command = ai.chooseCommand(
      definition: definition,
      state: state,
      difficulty: AiDifficulty.hard,
      aiSide: PlayerSide.dark,
    );
    expect(command.kind, AiCommandKind.place);
    expect(command.to, 2);
  });

  test('master AI returns a legal move without an unbounded search', () {
    const state = MorrisGameState(
      board: [
        PlayerSide.light,
        PlayerSide.dark,
        PlayerSide.light,
        PlayerSide.dark,
        PlayerSide.light,
        PlayerSide.dark,
        PlayerSide.light,
        PlayerSide.dark,
        PlayerSide.light,
        PlayerSide.dark,
        PlayerSide.light,
        PlayerSide.dark,
        PlayerSide.light,
        PlayerSide.dark,
        PlayerSide.light,
        PlayerSide.dark,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
      ],
      turn: PlayerSide.light,
      lightToPlace: 0,
      darkToPlace: 0,
    );
    final ai = MorrisAiEngine(seed: 23);
    final stopwatch = Stopwatch()..start();
    final command = ai.chooseCommand(
      definition: GameCatalog.twelve,
      state: state,
      difficulty: AiDifficulty.master,
      aiSide: PlayerSide.light,
    );
    stopwatch.stop();

    expect(
      ai
          .legalCommands(GameCatalog.twelve, state)
          .any(
            (candidate) =>
                candidate.kind == command.kind &&
                candidate.from == command.from &&
                candidate.to == command.to,
          ),
      isTrue,
    );
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 4)));
  });
}
