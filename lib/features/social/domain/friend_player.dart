import '../../../core/game/game_definition.dart';

enum Presence { online, inMatch, offline }

enum PlayerTitle {
  apprentice,
  tactician,
  millMaster,
  grandmaster;

  String label(String locale) {
    final lang = locale.toLowerCase();
    if (lang.startsWith('tr')) {
      return switch (this) {
        PlayerTitle.apprentice => 'Çırak',
        PlayerTitle.tactician => 'Taktisyen',
        PlayerTitle.millMaster => 'Değirmen Ustası',
        PlayerTitle.grandmaster => 'Büyükusta',
      };
    }
    if (lang.startsWith('de')) {
      return switch (this) {
        PlayerTitle.apprentice => 'Lehrling',
        PlayerTitle.tactician => 'Taktiker',
        PlayerTitle.millMaster => 'Mühlenmeister',
        PlayerTitle.grandmaster => 'Großmeister',
      };
    }
    if (lang.startsWith('es')) {
      return switch (this) {
        PlayerTitle.apprentice => 'Aprendiz',
        PlayerTitle.tactician => 'Táctico',
        PlayerTitle.millMaster => 'Maestro del Molino',
        PlayerTitle.grandmaster => 'Gran Maestro',
      };
    }
    if (lang.startsWith('fr')) {
      return switch (this) {
        PlayerTitle.apprentice => 'Apprenti',
        PlayerTitle.tactician => 'Tacticien',
        PlayerTitle.millMaster => 'Maître du Moulin',
        PlayerTitle.grandmaster => 'Grand Maître',
      };
    }
    if (lang.startsWith('pt')) {
      return switch (this) {
        PlayerTitle.apprentice => 'Aprendiz',
        PlayerTitle.tactician => 'Tático',
        PlayerTitle.millMaster => 'Mestre do Moinho',
        PlayerTitle.grandmaster => 'Grande Mestre',
      };
    }
    if (lang.startsWith('ar')) {
      return switch (this) {
        PlayerTitle.apprentice => 'مبتدئ',
        PlayerTitle.tactician => 'خبير تكتيكي',
        PlayerTitle.millMaster => 'سيد الطاحونة',
        PlayerTitle.grandmaster => 'أستاذ كبير',
      };
    }
    if (lang.startsWith('hi')) {
      return switch (this) {
        PlayerTitle.apprentice => 'प्रशिक्षु',
        PlayerTitle.tactician => 'रणनीतिकार',
        PlayerTitle.millMaster => 'मिल मास्टर',
        PlayerTitle.grandmaster => 'ग्रैंडमास्टर',
      };
    }
    return switch (this) {
      PlayerTitle.apprentice => 'Apprentice',
      PlayerTitle.tactician => 'Tactician',
      PlayerTitle.millMaster => 'Mill Master',
      PlayerTitle.grandmaster => 'Grandmaster',
    };
  }

  int get requiredWins => switch (this) {
    PlayerTitle.apprentice => 0,
    PlayerTitle.tactician => 6,
    PlayerTitle.millMaster => 26,
    PlayerTitle.grandmaster => 76,
  };
}

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

  PlayerTitle get title {
    if (rating >= 1800) return PlayerTitle.grandmaster;
    if (rating >= 1650) return PlayerTitle.millMaster;
    if (rating >= 1550) return PlayerTitle.tactician;
    return PlayerTitle.apprentice;
  }
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
    rating3: 1500,
    rating9: 1500,
    rating12: 1500,
    wins: 0,
    losses: 0,
    bestStreak: 0,
    level: 1,
    xp: 0,
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
  int get overallRating => ((rating3 + rating9 + rating12) / 3).round();
  int get totalGames => wins + losses;
  double get winRate => totalGames == 0 ? 0 : wins / totalGames;

  PlayerTitle get title {
    if (wins >= 76) return PlayerTitle.grandmaster;
    if (wins >= 26) return PlayerTitle.millMaster;
    if (wins >= 6) return PlayerTitle.tactician;
    return PlayerTitle.apprentice;
  }

  PlayerTitle? get nextTitle {
    switch (title) {
      case PlayerTitle.apprentice:
        return PlayerTitle.tactician;
      case PlayerTitle.tactician:
        return PlayerTitle.millMaster;
      case PlayerTitle.millMaster:
        return PlayerTitle.grandmaster;
      case PlayerTitle.grandmaster:
        return null;
    }
  }

  int get winsToNextTitle {
    final next = nextTitle;
    if (next == null) return 0;
    final diff = next.requiredWins - wins;
    return diff > 0 ? diff : 0;
  }

  PlayerProfile recordMatchResult({
    required MorrisGameId gameId,
    required bool isWin,
    required bool isDraw,
  }) {
    final earnedXp = isWin ? 120 : (isDraw ? 50 : 30);
    var newXp = xp + earnedXp;
    var newLevel = level;
    var nextXp = xpForNextLevel;
    while (newXp >= nextXp && nextXp > 0) {
      newXp -= nextXp;
      newLevel += 1;
      nextXp = (nextXp * 1.25).round();
    }

    final newWins = isWin ? wins + 1 : wins;
    final newLosses = (!isWin && !isDraw) ? losses + 1 : losses;
    final newStreak = isWin ? (bestStreak + 1) : bestStreak;

    final deltaRating = isWin ? 15 : (isDraw ? 2 : -10);
    var r3 = rating3;
    var r9 = rating9;
    var r12 = rating12;
    switch (gameId) {
      case MorrisGameId.three:
        r3 = (r3 + deltaRating).clamp(100, 3000);
      case MorrisGameId.nine:
        r9 = (r9 + deltaRating).clamp(100, 3000);
      case MorrisGameId.twelve:
        r12 = (r12 + deltaRating).clamp(100, 3000);
    }

    return copyWith(
      wins: newWins,
      losses: newLosses,
      bestStreak: newStreak,
      xp: newXp,
      level: newLevel,
      xpForNextLevel: nextXp,
      rating3: r3,
      rating9: r9,
      rating12: r12,
    );
  }
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
  Future<void> deleteLocalUserData();
  Future<List<LeaderboardEntry>> getWorldLeaderboard();
  Future<List<LeaderboardEntry>> getGameLeaderboard(MorrisGameId gameId);
  Future<List<LeaderboardEntry>> getCountryLeaderboard();
  Future<List<LeaderboardEntry>> getFriendsLeaderboard();
  Future<List<ChallengeRecord>> getChallenges();
  Future<ChallengeRecord> sendChallenge(String friendId, MorrisGameId gameId);
}
