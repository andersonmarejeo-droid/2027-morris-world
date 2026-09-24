import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';
import '../../../core/game/morris_engine.dart';

String gameName(AppLocalizations l10n, MorrisGameId id) => switch (id) {
  MorrisGameId.three => l10n.game3Name,
  MorrisGameId.nine => l10n.game9Name,
  MorrisGameId.twelve => l10n.game12Name,
};

String sideName(AppLocalizations l10n, PlayerSide side) =>
    side == PlayerSide.light ? l10n.lightPlayer : l10n.darkPlayer;

String instructionText(AppLocalizations l10n, MorrisGameState game) {
  if (game.isDraw) return l10n.draw;
  if (game.winner != null) return l10n.playerWon(sideName(l10n, game.winner!));
  if (game.pendingCaptureBy != null) {
    return l10n.capturePrompt(sideName(l10n, game.turn));
  }
  if (game.phase == MatchPhase.placement) {
    return l10n.placePrompt(sideName(l10n, game.turn));
  }
  return l10n.movePrompt(sideName(l10n, game.turn));
}

String moveErrorText(AppLocalizations l10n, MoveErrorCode code) =>
    switch (code) {
      MoveErrorCode.matchFinished => l10n.errorMatchFinished,
      MoveErrorCode.captureRequired => l10n.errorCaptureRequired,
      MoveErrorCode.placementFinished => l10n.errorPlacementFinished,
      MoveErrorCode.pointOccupied => l10n.errorPointOccupied,
      MoveErrorCode.notMovementPhase => l10n.errorNotMovementPhase,
      MoveErrorCode.notYourPiece => l10n.errorNotYourPiece,
      MoveErrorCode.targetOccupied => l10n.errorTargetOccupied,
      MoveErrorCode.notAdjacent => l10n.errorNotAdjacent,
      MoveErrorCode.noCaptureRight => l10n.errorNoCaptureRight,
      MoveErrorCode.opponentPieceRequired => l10n.errorOpponentPieceRequired,
      MoveErrorCode.protectedMillPiece => l10n.errorProtectedMillPiece,
      MoveErrorCode.invalidPoint => l10n.errorInvalidPoint,
      MoveErrorCode.boardMismatch => l10n.errorBoardMismatch,
    };
