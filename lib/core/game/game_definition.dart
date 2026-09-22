import 'package:flutter/widgets.dart';

enum MorrisGameId { three, nine, twelve }

class MorrisBoardDefinition {
  const MorrisBoardDefinition({
    required this.normalizedPoints,
    required this.adjacency,
    required this.mills,
  });

  final List<Offset> normalizedPoints;
  final Map<int, List<int>> adjacency;
  final List<List<int>> mills;

  int get pointCount => normalizedPoints.length;
}

class MorrisGameDefinition {
  const MorrisGameDefinition({
    required this.id,
    required this.board,
    required this.piecesPerPlayer,
    required this.captureOnMill,
    required this.winOnMill,
    required this.allowFlying,
    this.flyingThreshold = 3,
    this.minimumPiecesToContinue = 3,
    this.fullBoardAfterPlacementIsDraw = false,
  });

  final MorrisGameId id;
  final MorrisBoardDefinition board;
  final int piecesPerPlayer;

  /// Nine/12 stone rules remove an opponent piece after completing a mill.
  final bool captureOnMill;

  /// Three Stone ends immediately when a player completes a line.
  final bool winOnMill;

  final bool allowFlying;
  final int flyingThreshold;
  final int minimumPiecesToContinue;

  /// Twelve Stone can finish placement with all 24 points occupied.
  final bool fullBoardAfterPlacementIsDraw;
}
