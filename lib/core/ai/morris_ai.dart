import '../game/game_definition.dart';
import '../game/game_models.dart';
import '../game/morris_engine.dart';
import '../match/match_models.dart';

enum AiCommandKind { place, move, capture }

class AiCommand {
  const AiCommand._({required this.kind, this.from, required this.to});

  const AiCommand.place(int target)
    : this._(kind: AiCommandKind.place, to: target);

  const AiCommand.move({required int from, required int to})
    : this._(kind: AiCommandKind.move, from: from, to: to);

  const AiCommand.capture(int target)
    : this._(kind: AiCommandKind.capture, to: target);

  final AiCommandKind kind;
  final int? from;
  final int to;

  @override
  String toString() => switch (kind) {
    AiCommandKind.place => 'place($to)',
    AiCommandKind.move => 'move($from->$to)',
    AiCommandKind.capture => 'capture($to)',
  };
}

abstract final class AiTiming {
  /// A deliberate pause before the computer commits a move. It makes the
  /// opponent readable without making the match feel sluggish.
  static const thinkDelay = Duration(milliseconds: 850);

  /// Time reserved for the stone to visibly travel to its destination.
  static const moveReveal = Duration(milliseconds: 1150);

  /// Human moves stay responsive but still have enough time for the stone and
  /// settle sound to be perceived.
  static const humanMoveReveal = Duration(milliseconds: 420);

  /// A short beat between forming a mill and the computer removing a stone.
  static const capturePause = Duration(milliseconds: 720);

  /// Visible travel from the board to the captured-stone tray.
  static const aiCaptureReveal = Duration(milliseconds: 820);
  static const humanCaptureReveal = Duration(milliseconds: 560);
}

/// Pure decision layer for all Morris variants.
///
/// The AI never mutates a board directly. Every selected command is applied
/// through [MorrisEngine], so 3/9/12 Stone always share the exact same rules.
class MorrisAiEngine {
  MorrisAiEngine({int seed = 1}) : _seed = seed;

  final int _seed;

  AiCommand chooseCommand({
    required MorrisGameDefinition definition,
    required MorrisGameState state,
    required AiDifficulty difficulty,
    required PlayerSide aiSide,
  }) {
    final commands = legalCommands(definition, state);
    if (commands.isEmpty) {
      throw StateError('AI requested a move in a state with no legal command.');
    }

    if (difficulty == AiDifficulty.beginner) {
      return commands[_stableIndex(state, commands.length)];
    }

    if (difficulty == AiDifficulty.easy) {
      return _chooseEasy(definition, state, commands, aiSide);
    }

    final profile = switch (difficulty) {
      AiDifficulty.beginner => const _SearchProfile(depth: 1, nodeLimit: 1),
      AiDifficulty.easy => const _SearchProfile(depth: 1, nodeLimit: 150),
      AiDifficulty.medium => const _SearchProfile(depth: 2, nodeLimit: 1800),
      AiDifficulty.hard => const _SearchProfile(depth: 3, nodeLimit: 8000),
      AiDifficulty.master => _SearchProfile(
        depth: state.phase == MatchPhase.placement ? 3 : 4,
        nodeLimit: 24000,
      ),
    };

    final budget = _NodeBudget(profile.nodeLimit);
    final maximizing = state.turn == aiSide;
    final ordered = _orderedCommands(
      definition,
      state,
      commands,
      aiSide,
      maximizing,
    );
    AiCommand best = ordered.first;
    var bestScore = maximizing ? -_infinity : _infinity;
    var alpha = -_infinity;
    var beta = _infinity;

    for (final command in ordered) {
      final next = applyCommand(definition, state, command);
      final score = _search(
        definition,
        next,
        aiSide,
        profile.depth - 1,
        alpha,
        beta,
        budget,
      );
      if (maximizing ? score > bestScore : score < bestScore) {
        bestScore = score;
        best = command;
      }
      if (maximizing) {
        if (bestScore > alpha) {
          alpha = bestScore;
        }
      } else {
        if (bestScore < beta) {
          beta = bestScore;
        }
      }
      if (alpha >= beta) {
        break;
      }
    }
    return best;
  }

  List<AiCommand> legalCommands(
    MorrisGameDefinition definition,
    MorrisGameState state,
  ) {
    if (state.phase == MatchPhase.finished) {
      return const [];
    }

    if (state.pendingCaptureBy != null) {
      final opponent = state.turn.opponent;
      final allOpponent = <int>[];
      final outsideMills = <int>[];
      for (var i = 0; i < state.board.length; i++) {
        if (state.board[i] != opponent) {
          continue;
        }
        allOpponent.add(i);
        if (!MorrisEngine.formsMill(definition, state.board, i, opponent)) {
          outsideMills.add(i);
        }
      }
      final targets = outsideMills.isNotEmpty ? outsideMills : allOpponent;
      return [for (final target in targets) AiCommand.capture(target)];
    }

    if (state.phase == MatchPhase.placement) {
      return [
        for (var i = 0; i < state.board.length; i++)
          if (state.board[i] == null) AiCommand.place(i),
      ];
    }

    final side = state.turn;
    final canFly =
        definition.allowFlying &&
        state.stonesOnBoard(side) == definition.flyingThreshold;
    final commands = <AiCommand>[];
    for (var from = 0; from < state.board.length; from++) {
      if (state.board[from] != side) {
        continue;
      }
      if (canFly) {
        for (var to = 0; to < state.board.length; to++) {
          if (state.board[to] == null) {
            commands.add(AiCommand.move(from: from, to: to));
          }
        }
      } else {
        for (final to in definition.board.adjacency[from] ?? const <int>[]) {
          if (state.board[to] == null) {
            commands.add(AiCommand.move(from: from, to: to));
          }
        }
      }
    }
    return commands;
  }

  MorrisGameState applyCommand(
    MorrisGameDefinition definition,
    MorrisGameState state,
    AiCommand command,
  ) => switch (command.kind) {
    AiCommandKind.place => MorrisEngine.place(definition, state, command.to),
    AiCommandKind.move => MorrisEngine.move(
      definition,
      state,
      from: command.from!,
      to: command.to,
    ),
    AiCommandKind.capture => MorrisEngine.capture(
      definition,
      state,
      command.to,
    ),
  };

  AiCommand _chooseEasy(
    MorrisGameDefinition definition,
    MorrisGameState state,
    List<AiCommand> commands,
    PlayerSide aiSide,
  ) {
    AiCommand best = commands.first;
    var bestScore = -_infinity;
    for (final command in commands) {
      final next = applyCommand(definition, state, command);
      var score = _evaluate(definition, next, aiSide);
      score += _jitter(state, command, 55);
      if (score > bestScore) {
        bestScore = score;
        best = command;
      }
    }
    return best;
  }

  int _search(
    MorrisGameDefinition definition,
    MorrisGameState state,
    PlayerSide aiSide,
    int depth,
    int alpha,
    int beta,
    _NodeBudget budget,
  ) {
    if (!budget.take() || depth <= 0 || state.phase == MatchPhase.finished) {
      return _evaluate(definition, state, aiSide);
    }

    final commands = legalCommands(definition, state);
    if (commands.isEmpty) {
      return _evaluate(definition, state, aiSide);
    }

    final maximizing = state.turn == aiSide;
    final ordered = _orderedCommands(
      definition,
      state,
      commands,
      aiSide,
      maximizing,
    );
    if (maximizing) {
      var value = -_infinity;
      var localAlpha = alpha;
      for (final command in ordered) {
        final child = applyCommand(definition, state, command);
        final score = _search(
          definition,
          child,
          aiSide,
          depth - 1,
          localAlpha,
          beta,
          budget,
        );
        if (score > value) {
          value = score;
        }
        if (value > localAlpha) {
          localAlpha = value;
        }
        if (localAlpha >= beta) {
          break;
        }
      }
      return value;
    }

    var value = _infinity;
    var localBeta = beta;
    for (final command in ordered) {
      final child = applyCommand(definition, state, command);
      final score = _search(
        definition,
        child,
        aiSide,
        depth - 1,
        alpha,
        localBeta,
        budget,
      );
      if (score < value) {
        value = score;
      }
      if (value < localBeta) {
        localBeta = value;
      }
      if (alpha >= localBeta) {
        break;
      }
    }
    return value;
  }

  List<AiCommand> _orderedCommands(
    MorrisGameDefinition definition,
    MorrisGameState state,
    List<AiCommand> commands,
    PlayerSide aiSide,
    bool maximizing,
  ) {
    final scored = [
      for (final command in commands)
        (
          command: command,
          score: _evaluate(
            definition,
            applyCommand(definition, state, command),
            aiSide,
          ),
        ),
    ];
    scored.sort(
      (a, b) =>
          maximizing ? b.score.compareTo(a.score) : a.score.compareTo(b.score),
    );
    return [for (final entry in scored) entry.command];
  }

  int _evaluate(
    MorrisGameDefinition definition,
    MorrisGameState state,
    PlayerSide aiSide,
  ) {
    if (state.winner == aiSide) {
      return 900000;
    }
    if (state.winner == aiSide.opponent) {
      return -900000;
    }
    if (state.isDraw) {
      return 0;
    }

    final opponent = aiSide.opponent;
    var score = 0;
    final aiMaterial = state.stonesOnBoard(aiSide) + state.toPlace(aiSide);
    final opponentMaterial =
        state.stonesOnBoard(opponent) + state.toPlace(opponent);
    score += (aiMaterial - opponentMaterial) * 125;
    score +=
        (_millCount(definition, state.board, aiSide) -
            _millCount(definition, state.board, opponent)) *
        (definition.winOnMill ? 180 : 80);
    score +=
        (_potentialMillCount(definition, state.board, aiSide) -
            _potentialMillCount(definition, state.board, opponent)) *
        (definition.winOnMill ? 115 : 28);
    score +=
        (_mobility(definition, state, aiSide) -
            _mobility(definition, state, opponent)) *
        4;
    score +=
        (_positionScore(definition, state.board, aiSide) -
            _positionScore(definition, state.board, opponent)) *
        2;
    score +=
        (_forkPotential(definition, state.board, aiSide) -
            _forkPotential(definition, state.board, opponent)) *
        44;
    score +=
        (_blockedPieces(definition, state, opponent) -
            _blockedPieces(definition, state, aiSide)) *
        18;
    score +=
        (_immediateThreats(definition, state.board, aiSide) -
            _immediateThreats(definition, state.board, opponent)) *
        24;

    if (state.pendingCaptureBy == aiSide) {
      score += 150;
    }
    if (state.pendingCaptureBy == opponent) {
      score -= 150;
    }
    return score;
  }

  int _forkPotential(
    MorrisGameDefinition definition,
    Board board,
    PlayerSide side,
  ) {
    var score = 0;
    for (var point = 0; point < board.length; point++) {
      if (board[point] != side) {
        continue;
      }
      var openMillLinks = 0;
      for (final mill in definition.board.mills.where(
        (m) => m.contains(point),
      )) {
        final own = mill.where((p) => board[p] == side).length;
        final empty = mill.where((p) => board[p] == null).length;
        if (own >= 1 && empty >= 1) {
          openMillLinks++;
        }
      }
      if (openMillLinks >= 2) {
        score += openMillLinks - 1;
      }
    }
    return score;
  }

  int _blockedPieces(
    MorrisGameDefinition definition,
    MorrisGameState state,
    PlayerSide side,
  ) {
    if (state.toPlace(side) > 0) {
      return 0;
    }
    final stones = state.stonesOnBoard(side);
    if (definition.allowFlying && stones == definition.flyingThreshold) {
      return 0;
    }
    var blocked = 0;
    for (var from = 0; from < state.board.length; from++) {
      if (state.board[from] != side) {
        continue;
      }
      final hasExit = (definition.board.adjacency[from] ?? const <int>[]).any(
        (to) => state.board[to] == null,
      );
      if (!hasExit) {
        blocked++;
      }
    }
    return blocked;
  }

  int _immediateThreats(
    MorrisGameDefinition definition,
    Board board,
    PlayerSide side,
  ) =>
      definition.board.mills.where((mill) {
        var own = 0;
        var empty = 0;
        for (final point in mill) {
          if (board[point] == side) {
            own++;
          }
          if (board[point] == null) {
            empty++;
          }
        }
        return own == 2 && empty == 1;
      }).length;

  int _millCount(
    MorrisGameDefinition definition,
    Board board,
    PlayerSide side,
  ) =>
      definition.board.mills
          .where((mill) => mill.every((point) => board[point] == side))
          .length;

  int _potentialMillCount(
    MorrisGameDefinition definition,
    Board board,
    PlayerSide side,
  ) {
    var count = 0;
    for (final mill in definition.board.mills) {
      var own = 0;
      var empty = 0;
      for (final point in mill) {
        if (board[point] == side) {
          own++;
        }
        if (board[point] == null) {
          empty++;
        }
      }
      if (own == 2 && empty == 1) {
        count++;
      }
    }
    return count;
  }

  int _mobility(
    MorrisGameDefinition definition,
    MorrisGameState state,
    PlayerSide side,
  ) {
    if (state.toPlace(side) > 0) {
      return state.board.where((point) => point == null).length;
    }
    final stones = state.stonesOnBoard(side);
    if (definition.allowFlying && stones == definition.flyingThreshold) {
      return stones * state.board.where((point) => point == null).length;
    }
    var count = 0;
    for (var from = 0; from < state.board.length; from++) {
      if (state.board[from] != side) {
        continue;
      }
      for (final to in definition.board.adjacency[from] ?? const <int>[]) {
        if (state.board[to] == null) {
          count++;
        }
      }
    }
    return count;
  }

  int _positionScore(
    MorrisGameDefinition definition,
    Board board,
    PlayerSide side,
  ) {
    var score = 0;
    for (var i = 0; i < board.length; i++) {
      if (board[i] == side) {
        score += definition.board.adjacency[i]?.length ?? 0;
      }
    }
    return score;
  }

  int _stableIndex(MorrisGameState state, int length) {
    var hash = _seed & 0x7fffffff;
    for (var i = 0; i < state.board.length; i++) {
      final cell = switch (state.board[i]) {
        null => 0,
        PlayerSide.light => 1,
        PlayerSide.dark => 2,
      };
      hash = ((hash * 31) + cell + i) & 0x7fffffff;
    }
    hash =
        ((hash * 31) + state.lightToPlace * 3 + state.darkToPlace * 7) &
        0x7fffffff;
    return hash % length;
  }

  int _jitter(MorrisGameState state, AiCommand command, int amplitude) {
    var hash = _stableIndex(state, 2147483629);
    hash =
        ((hash * 37) + command.kind.index * 101 + command.to * 13) & 0x7fffffff;
    hash = ((hash * 37) + (command.from ?? 0) * 17) & 0x7fffffff;
    return (hash % (amplitude * 2 + 1)) - amplitude;
  }

  static const _infinity = 1000000000;
}

class _NodeBudget {
  _NodeBudget(this.remaining);
  int remaining;

  bool take() {
    if (remaining <= 0) {
      return false;
    }
    remaining--;
    return true;
  }
}

class _SearchProfile {
  const _SearchProfile({required this.depth, required this.nodeLimit});
  final int depth;
  final int nodeLimit;
}
