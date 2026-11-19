enum PlayerSide { light, dark }

enum MatchPhase { placement, movement, finished }

typedef Board = List<PlayerSide?>;

extension PlayerSideX on PlayerSide {
  PlayerSide get opponent =>
      this == PlayerSide.light ? PlayerSide.dark : PlayerSide.light;
}

class MorrisGameState {
  const MorrisGameState({
    required this.board,
    required this.turn,
    required this.lightToPlace,
    required this.darkToPlace,
    this.pendingCaptureBy,
    this.winner,
    this.isDraw = false,
    this.movesWithoutCapture = 0,
  });

  factory MorrisGameState.initial({
    required int pointCount,
    required int piecesPerPlayer,
  }) =>
      MorrisGameState(
        board: List<PlayerSide?>.filled(pointCount, null),
        turn: PlayerSide.light,
        lightToPlace: piecesPerPlayer,
        darkToPlace: piecesPerPlayer,
      );

  final Board board;
  final PlayerSide turn;
  final int lightToPlace;
  final int darkToPlace;
  final PlayerSide? pendingCaptureBy;
  final PlayerSide? winner;
  final bool isDraw;
  final int movesWithoutCapture;

  MatchPhase get phase {
    if (winner != null || isDraw) return MatchPhase.finished;
    if (lightToPlace > 0 || darkToPlace > 0) return MatchPhase.placement;
    return MatchPhase.movement;
  }

  int toPlace(PlayerSide side) =>
      side == PlayerSide.light ? lightToPlace : darkToPlace;

  int stonesOnBoard(PlayerSide side) => board.where((p) => p == side).length;

  MorrisGameState copyWith({
    Board? board,
    PlayerSide? turn,
    int? lightToPlace,
    int? darkToPlace,
    PlayerSide? pendingCaptureBy,
    bool clearPendingCapture = false,
    PlayerSide? winner,
    bool clearWinner = false,
    bool? isDraw,
    int? movesWithoutCapture,
  }) {
    return MorrisGameState(
      board: board ?? this.board,
      turn: turn ?? this.turn,
      lightToPlace: lightToPlace ?? this.lightToPlace,
      darkToPlace: darkToPlace ?? this.darkToPlace,
      pendingCaptureBy:
          clearPendingCapture ? null : (pendingCaptureBy ?? this.pendingCaptureBy),
      winner: clearWinner ? null : (winner ?? this.winner),
      isDraw: isDraw ?? this.isDraw,
      movesWithoutCapture: movesWithoutCapture ?? this.movesWithoutCapture,
    );
  }
}
