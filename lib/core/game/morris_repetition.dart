import 'game_models.dart';

/// Tracks repeated movement positions (same stones on the same points and the
/// same side to move). The placement phase and pending captures are excluded.
abstract final class MorrisRepetition {
  static const occurrencesToDraw = 5;

  /// Records [state] and returns true when the same position has appeared for
  /// the fifth time. Call only after a completed movement turn.
  static bool record(MorrisGameState state, Map<String, int> counts) {
    if (state.phase != MatchPhase.movement || state.pendingCaptureBy != null) {
      return false;
    }

    final position = _signature(state);
    final occurrences = (counts[position] ?? 0) + 1;
    counts[position] = occurrences;
    return occurrences >= occurrencesToDraw;
  }

  static String _signature(MorrisGameState state) =>
      '${state.turn.name}|${state.board.map((side) => switch (side) {
        null => '0',
        PlayerSide.light => '1',
        PlayerSide.dark => '2',
      }).join()}';
}
