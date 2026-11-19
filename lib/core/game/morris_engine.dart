import 'game_definition.dart';
import 'game_models.dart';

enum MoveErrorCode {
  matchFinished,
  captureRequired,
  placementFinished,
  pointOccupied,
  notMovementPhase,
  notYourPiece,
  targetOccupied,
  notAdjacent,
  noCaptureRight,
  opponentPieceRequired,
  protectedMillPiece,
  invalidPoint,
  boardMismatch,
}

class InvalidMove implements Exception {
  const InvalidMove(this.code);
  final MoveErrorCode code;
}

abstract final class MorrisEngine {
  static const int drawAfterMovesWithoutCapture = 100;

  static MorrisGameState initial(MorrisGameDefinition definition) =>
      MorrisGameState.initial(
        pointCount: definition.board.pointCount,
        piecesPerPlayer: definition.piecesPerPlayer,
      );

  static MorrisGameState place(
    MorrisGameDefinition definition,
    MorrisGameState state,
    int target,
  ) {
    _ensureCompatible(definition, state);
    _ensureActive(state);
    _ensureIndex(definition, target);
    if (state.pendingCaptureBy != null) {
      throw const InvalidMove(MoveErrorCode.captureRequired);
    }
    if (state.toPlace(state.turn) <= 0) {
      throw const InvalidMove(MoveErrorCode.placementFinished);
    }
    if (state.board[target] != null) {
      throw const InvalidMove(MoveErrorCode.pointOccupied);
    }

    final board = List<PlayerSide?>.from(state.board)..[target] = state.turn;
    final remaining = state.toPlace(state.turn) - 1;
    var next = state.copyWith(
      board: board,
      movesWithoutCapture: 0,
      lightToPlace:
          state.turn == PlayerSide.light ? remaining : state.lightToPlace,
      darkToPlace:
          state.turn == PlayerSide.dark ? remaining : state.darkToPlace,
    );

    if (formsMill(definition, board, target, state.turn)) {
      if (definition.winOnMill) {
        return next.copyWith(winner: state.turn);
      }
      if (definition.captureOnMill) {
        return next.copyWith(pendingCaptureBy: state.turn);
      }
    }

    next = next.copyWith(turn: state.turn.opponent);
    return _resolveTerminal(definition, next);
  }

  static MorrisGameState move(
    MorrisGameDefinition definition,
    MorrisGameState state, {
    required int from,
    required int to,
  }) {
    _ensureCompatible(definition, state);
    _ensureActive(state);
    _ensureIndex(definition, from);
    _ensureIndex(definition, to);
    if (state.pendingCaptureBy != null) {
      throw const InvalidMove(MoveErrorCode.captureRequired);
    }
    if (state.phase != MatchPhase.movement) {
      throw const InvalidMove(MoveErrorCode.notMovementPhase);
    }
    if (state.board[from] != state.turn) {
      throw const InvalidMove(MoveErrorCode.notYourPiece);
    }
    if (state.board[to] != null) {
      throw const InvalidMove(MoveErrorCode.targetOccupied);
    }

    final canFly = definition.allowFlying &&
        state.stonesOnBoard(state.turn) == definition.flyingThreshold;
    if (!canFly && !(definition.board.adjacency[from]?.contains(to) ?? false)) {
      throw const InvalidMove(MoveErrorCode.notAdjacent);
    }

    final board = List<PlayerSide?>.from(state.board)
      ..[from] = null
      ..[to] = state.turn;
    var next = state.copyWith(
      board: board,
      movesWithoutCapture: state.movesWithoutCapture + 1,
    );

    if (formsMill(definition, board, to, state.turn)) {
      if (definition.winOnMill) {
        return next.copyWith(winner: state.turn);
      }
      if (definition.captureOnMill) {
        return next.copyWith(pendingCaptureBy: state.turn);
      }
    }

    next = next.copyWith(turn: state.turn.opponent);
    return _resolveTerminal(definition, next);
  }

  static MorrisGameState capture(
    MorrisGameDefinition definition,
    MorrisGameState state,
    int target,
  ) {
    _ensureCompatible(definition, state);
    _ensureActive(state);
    _ensureIndex(definition, target);
    final capturer = state.pendingCaptureBy;
    if (!definition.captureOnMill || capturer == null || capturer != state.turn) {
      throw const InvalidMove(MoveErrorCode.noCaptureRight);
    }

    final opponent = capturer.opponent;
    if (state.board[target] != opponent) {
      throw const InvalidMove(MoveErrorCode.opponentPieceRequired);
    }

    final opponentOutsideMills = <int>[];
    for (var i = 0; i < state.board.length; i++) {
      if (state.board[i] == opponent &&
          !formsMill(definition, state.board, i, opponent)) {
        opponentOutsideMills.add(i);
      }
    }
    if (opponentOutsideMills.isNotEmpty &&
        formsMill(definition, state.board, target, opponent)) {
      throw const InvalidMove(MoveErrorCode.protectedMillPiece);
    }

    final board = List<PlayerSide?>.from(state.board)..[target] = null;
    var next = state.copyWith(
      board: board,
      clearPendingCapture: true,
      turn: opponent,
      movesWithoutCapture: 0,
    );
    next = _resolveTerminal(definition, next);
    return next;
  }

  static bool formsMill(
    MorrisGameDefinition definition,
    Board board,
    int point,
    PlayerSide side,
  ) {
    return definition.board.mills.any(
      (mill) => mill.contains(point) && mill.every((p) => board[p] == side),
    );
  }

  static bool hasLegalMove(
    MorrisGameDefinition definition,
    MorrisGameState state,
    PlayerSide side,
  ) {
    if (state.toPlace(side) > 0) return state.board.any((p) => p == null);

    final stones = state.stonesOnBoard(side);
    if (stones < definition.minimumPiecesToContinue) return false;
    if (definition.allowFlying && stones == definition.flyingThreshold) {
      return state.board.any((p) => p == null);
    }

    for (var from = 0; from < state.board.length; from++) {
      if (state.board[from] != side) continue;
      for (final to in definition.board.adjacency[from] ?? const <int>[]) {
        if (state.board[to] == null) return true;
      }
    }
    return false;
  }

  static MorrisGameState _resolveTerminal(
    MorrisGameDefinition definition,
    MorrisGameState state,
  ) {
    if (state.lightToPlace > 0 || state.darkToPlace > 0) return state;

    if (definition.fullBoardAfterPlacementIsDraw &&
        state.board.every((point) => point != null)) {
      return state.copyWith(isDraw: true);
    }

    if (definition.winOnMill) {
      if (!hasLegalMove(definition, state, state.turn)) {
        return state.copyWith(winner: state.turn.opponent);
      }
    } else {
      final playerToAct = state.turn;
      if (state.stonesOnBoard(playerToAct) <
              definition.minimumPiecesToContinue ||
          !hasLegalMove(definition, state, playerToAct)) {
        return state.copyWith(winner: playerToAct.opponent);
      }
    }
    if (state.movesWithoutCapture >= drawAfterMovesWithoutCapture) {
      return state.copyWith(isDraw: true);
    }
    return state;
  }

  static void _ensureCompatible(
    MorrisGameDefinition definition,
    MorrisGameState state,
  ) {
    if (state.board.length != definition.board.pointCount) {
      throw const InvalidMove(MoveErrorCode.boardMismatch);
    }
  }

  static void _ensureActive(MorrisGameState state) {
    if (state.winner != null || state.isDraw) {
      throw const InvalidMove(MoveErrorCode.matchFinished);
    }
  }

  static void _ensureIndex(MorrisGameDefinition definition, int index) {
    if (index < 0 || index >= definition.board.pointCount) {
      throw const InvalidMove(MoveErrorCode.invalidPoint);
    }
  }
}
