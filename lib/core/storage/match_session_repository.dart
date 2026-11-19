import '../game/game_definition.dart';
import '../match/match_models.dart';

abstract interface class MatchSessionRepository {
  Future<MatchSession?> getById(String sessionId);
  Future<MatchSession?> getMostRecentActive();
  Future<MatchSession?> getMostRecentActiveForGame(MorrisGameId gameId);
  Future<void> save(MatchSession session);
  Future<void> delete(String sessionId);
  Future<void> deleteAll();
}
