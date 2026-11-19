import '../core/game/game_definition.dart';
import '../core/match/match_models.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const friends = '/friends';
  static const rankings = '/rankings';
  static const profile = '/profile';
  static const settings = '/settings';
  static const puzzles = '/puzzles';

  static String puzzle(String puzzleId) => '/puzzles/$puzzleId';
  static String mode(MorrisGameId gameId) => '/game/${gameId.name}';
  static String friendsForGame(MorrisGameId gameId) => '/friends?game=${gameId.name}';
  static String tutorial(MorrisGameId gameId) => '/learn/${gameId.name}';
  static String online(MorrisGameId gameId) => '/online/${gameId.name}';
  static String onlineRoom(String roomCode) => '/online-room/$roomCode';

  static String play(MatchConfig config, {bool fresh = false}) {
    final parameters = <String, String>{
      'session': config.sessionId,
      if (config.difficulty != null) 'difficulty': config.difficulty!.name,
      if (fresh) 'fresh': '1',
    };
    final query = Uri(queryParameters: parameters).query;
    return '/play/${config.gameId.name}/${config.mode.name}?$query';
  }
}
