import '../../../core/game/game_definition.dart';

enum Presence { online, inMatch, offline }

class FriendPlayer {
  const FriendPlayer({
    required this.id,
    required this.name,
    required this.rating,
    required this.presence,
    this.countryCode = 'TR',
  });

  final String id;
  final String name;
  final int rating;
  final Presence presence;
  final String countryCode;
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.player,
    required this.rank,
    required this.wins,
    required this.losses,
  });

  final FriendPlayer player;
  final int rank;
  final int wins;
  final int losses;
}

class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.rating3,
    required this.rating9,
    required this.rating12,
    required this.wins,
    required this.losses,
    required this.bestStreak,
    required this.level,
    required this.xp,
    required this.xpForNextLevel,
    this.avatarId = 'avatar_01',
    this.email,
  });

  static const guest = PlayerProfile(
    id: 'local',
    name: 'Misafir',
    countryCode: 'TR',
    rating3: 1518,
    rating9: 1674,
    rating12: 1589,
    wins: 42,
    losses: 26,
    bestStreak: 7,
    level: 12,
    xp: 740,
    xpForNextLevel: 1000,
  );

  final String id;
  final String name;
  final String countryCode;
  final int rating3;
  final int rating9;
  final int rating12;
  final int wins;
  final int losses;
  final int bestStreak;
  final int level;
  final int xp;
  final int xpForNextLevel;
  final String avatarId;
  final String? email;

  PlayerProfile copyWith({
    String? id,
    String? name,
    String? countryCode,
    int? rating3,
    int? rating9,
    int? rating12,
    int? wins,
    int? losses,
    int? bestStreak,
    int? level,
    int? xp,
    int? xpForNextLevel,
    String? avatarId,
    String? email,
    bool clearEmail = false,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      rating3: rating3 ?? this.rating3,
      rating9: rating9 ?? this.rating9,
      rating12: rating12 ?? this.rating12,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      bestStreak: bestStreak ?? this.bestStreak,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpForNextLevel: xpForNextLevel ?? this.xpForNextLevel,
      avatarId: avatarId ?? this.avatarId,
      email: clearEmail ? null : email ?? this.email,
    );
  }

  double get levelProgress =>
      xpForNextLevel <= 0
          ? 0.0
          : (xp / xpForNextLevel).clamp(0.0, 1.0).toDouble();
  int get totalGames => wins + losses;
  double get winRate => totalGames == 0 ? 0 : wins / totalGames;
}

enum ChallengeStatus {
  pending,
  accepted,
  inProgress,
  completed,
  declined,
  expired,
  cancelled,
}

class ChallengeRecord {
  const ChallengeRecord({
    required this.id,
    required this.opponent,
    required this.gameId,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final FriendPlayer opponent;
  final MorrisGameId gameId;
  final ChallengeStatus status;
  final DateTime createdAt;
}

abstract interface class SocialRepository {
  Future<List<FriendPlayer>> getFriends();
  Future<bool> addFriend(String name);
  Future<PlayerProfile> getLocalProfile();
  Future<void> saveLocalProfile(PlayerProfile profile);
  Future<List<LeaderboardEntry>> getWorldLeaderboard();
  Future<List<LeaderboardEntry>> getCountryLeaderboard();
  Future<List<LeaderboardEntry>> getFriendsLeaderboard();
  Future<List<ChallengeRecord>> getChallenges();
  Future<ChallengeRecord> sendChallenge(String friendId, MorrisGameId gameId);
}
