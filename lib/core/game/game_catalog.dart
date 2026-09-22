import 'board_definitions.dart';
import 'game_definition.dart';

abstract final class GameCatalog {
  static const three = MorrisGameDefinition(
    id: MorrisGameId.three,
    board: MorrisBoards.threeStone,
    piecesPerPlayer: 3,
    captureOnMill: false,
    winOnMill: true,
    allowFlying: false,
  );

  static const nine = MorrisGameDefinition(
    id: MorrisGameId.nine,
    board: MorrisBoards.nineStone,
    piecesPerPlayer: 9,
    captureOnMill: true,
    winOnMill: false,
    allowFlying: true,
  );

  static const twelve = MorrisGameDefinition(
    id: MorrisGameId.twelve,
    board: MorrisBoards.twelveStone,
    piecesPerPlayer: 12,
    captureOnMill: true,
    winOnMill: false,
    allowFlying: true,
    fullBoardAfterPlacementIsDraw: true,
  );

  static const all = [three, nine, twelve];

  static MorrisGameDefinition byId(MorrisGameId id) => switch (id) {
        MorrisGameId.three => three,
        MorrisGameId.nine => nine,
        MorrisGameId.twelve => twelve,
      };
}
