import 'game_definition.dart';
import 'game_models.dart';
import 'morris_engine.dart';

/// Read-only rule queries used by UI, AI and tests.
///
/// The widget layer must never re-implement Morris legality. It asks this
/// class/engine for all legal targets and capture candidates.
abstract final class MorrisRules {
  static Set<int> legalPlacements(
    MorrisGameDefinition definition,
    MorrisGameState state,
  ) {
    if (state.phase == MatchPhase.finished || state.pendingCaptureBy != null) {
      return const <int>{};
    }
    if (state.toPlace(state.turn) <= 0) return const <int>{};
    return {
      for (var i = 0; i < definition.board.pointCount; i++)
        if (state.board[i] == null) i,
    };
  }

  static Set<int> legalMovesFrom(
    MorrisGameDefinition definition,
    MorrisGameState state,
    int from,
  ) {
    if (state.phase != MatchPhase.movement ||
        state.pendingCaptureBy != null ||
        from < 0 ||
        from >= definition.board.pointCount ||
        state.board[from] != state.turn) {
      return const <int>{};
    }

    final canFly = definition.allowFlying &&
        state.stonesOnBoard(state.turn) == definition.flyingThreshold;
    if (canFly) {
      return {
        for (var i = 0; i < definition.board.pointCount; i++)
          if (state.board[i] == null) i,
      };
    }

    return {
      for (final target in definition.board.adjacency[from] ?? const <int>[])
        if (state.board[target] == null) target,
    };
  }

  static Set<int> capturablePoints(
    MorrisGameDefinition definition,
    MorrisGameState state,
  ) {
    final capturer = state.pendingCaptureBy;
    if (capturer == null || capturer != state.turn) return const <int>{};
    final opponent = capturer.opponent;
    final outside = <int>{};
    final all = <int>{};
    for (var i = 0; i < state.board.length; i++) {
      if (state.board[i] != opponent) continue;
      all.add(i);
      if (!MorrisEngine.formsMill(definition, state.board, i, opponent)) {
        outside.add(i);
      }
    }
    return outside.isNotEmpty ? outside : all;
  }

  static Set<int> millPointsAt(
    MorrisGameDefinition definition,
    Board board,
    int point,
    PlayerSide side,
  ) {
    final result = <int>{};
    for (final mill in definition.board.mills) {
      if (mill.contains(point) && mill.every((p) => board[p] == side)) {
        result.addAll(mill);
      }
    }
    return result;
  }

  static Set<int> allMillPoints(
    MorrisGameDefinition definition,
    Board board,
    PlayerSide side,
  ) {
    final result = <int>{};
    for (final mill in definition.board.mills) {
      if (mill.every((p) => board[p] == side)) result.addAll(mill);
    }
    return result;
  }

  static bool canSelectPoint(
    MorrisGameDefinition definition,
    MorrisGameState state,
    int point,
  ) {
    if (point < 0 || point >= definition.board.pointCount) return false;
    if (state.pendingCaptureBy != null) {
      return capturablePoints(definition, state).contains(point);
    }
    if (state.phase == MatchPhase.placement) {
      return legalPlacements(definition, state).contains(point);
    }
    if (state.phase == MatchPhase.movement) {
      return state.board[point] == state.turn;
    }
    return false;
  }
}
