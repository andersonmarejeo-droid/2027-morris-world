import 'package:flutter/widgets.dart';

import 'game_definition.dart';

abstract final class MorrisBoards {
  static const _classic24Points = [
    Offset(0, 0), Offset(3, 0), Offset(6, 0),
    Offset(1, 1), Offset(3, 1), Offset(5, 1),
    Offset(2, 2), Offset(3, 2), Offset(4, 2),
    Offset(0, 3), Offset(1, 3), Offset(2, 3),
    Offset(4, 3), Offset(5, 3), Offset(6, 3),
    Offset(2, 4), Offset(3, 4), Offset(4, 4),
    Offset(1, 5), Offset(3, 5), Offset(5, 5),
    Offset(0, 6), Offset(3, 6), Offset(6, 6),
  ];

  /// Turkish Three Stone: square + cross, 9 intersections, no diagonal lines.
  static const threeStone = MorrisBoardDefinition(
    normalizedPoints: [
      Offset(0, 0), Offset(3, 0), Offset(6, 0),
      Offset(0, 3), Offset(3, 3), Offset(6, 3),
      Offset(0, 6), Offset(3, 6), Offset(6, 6),
    ],
    adjacency: {
      0: [1, 3],
      1: [0, 2, 4],
      2: [1, 5],
      3: [0, 4, 6],
      4: [1, 3, 5, 7],
      5: [2, 4, 8],
      6: [3, 7],
      7: [4, 6, 8],
      8: [5, 7],
    },
    mills: [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
    ],
  );

  static const nineStone = MorrisBoardDefinition(
    normalizedPoints: _classic24Points,
    adjacency: {
      0: [1, 9],
      1: [0, 2, 4],
      2: [1, 14],
      3: [4, 10],
      4: [1, 3, 5, 7],
      5: [4, 13],
      6: [7, 11],
      7: [4, 6, 8],
      8: [7, 12],
      9: [0, 10, 21],
      10: [3, 9, 11, 18],
      11: [6, 10, 15],
      12: [8, 13, 17],
      13: [5, 12, 14, 20],
      14: [2, 13, 23],
      15: [11, 16],
      16: [15, 17, 19],
      17: [12, 16],
      18: [10, 19],
      19: [16, 18, 20, 22],
      20: [13, 19],
      21: [9, 22],
      22: [19, 21, 23],
      23: [14, 22],
    },
    mills: [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [9, 10, 11], [12, 13, 14],
      [15, 16, 17], [18, 19, 20], [21, 22, 23],
      [0, 9, 21], [3, 10, 18], [6, 11, 15],
      [1, 4, 7], [16, 19, 22],
      [8, 12, 17], [5, 13, 20], [2, 14, 23],
    ],
  );

  /// Twelve Stone uses the same 24 points with four corner diagonals added.
  static const twelveStone = MorrisBoardDefinition(
    normalizedPoints: _classic24Points,
    adjacency: {
      0: [1, 9, 3],
      1: [0, 2, 4],
      2: [1, 14, 5],
      3: [4, 10, 0, 6],
      4: [1, 3, 5, 7],
      5: [4, 13, 2, 8],
      6: [7, 11, 3],
      7: [4, 6, 8],
      8: [7, 12, 5],
      9: [0, 10, 21],
      10: [3, 9, 11, 18],
      11: [6, 10, 15],
      12: [8, 13, 17],
      13: [5, 12, 14, 20],
      14: [2, 13, 23],
      15: [11, 16, 18],
      16: [15, 17, 19],
      17: [12, 16, 20],
      18: [10, 19, 21, 15],
      19: [16, 18, 20, 22],
      20: [13, 19, 23, 17],
      21: [9, 22, 18],
      22: [19, 21, 23],
      23: [14, 22, 20],
    },
    mills: [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [9, 10, 11], [12, 13, 14],
      [15, 16, 17], [18, 19, 20], [21, 22, 23],
      [0, 9, 21], [3, 10, 18], [6, 11, 15],
      [1, 4, 7], [16, 19, 22],
      [8, 12, 17], [5, 13, 20], [2, 14, 23],
      [0, 3, 6], [2, 5, 8], [21, 18, 15], [23, 20, 17],
    ],
  );
}
