import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/game/game_definition.dart';
import '../domain/friend_player.dart';
import 'player_profile_store.dart';

class InMemoryFriendsRepository extends ChangeNotifier
    implements SocialRepository {
  InMemoryFriendsRepository({PlayerProfileStore? profileStore})
    : _profileStore = profileStore;

  static const _addedNamesKey = 'social_added_friend_names_v1';

  final PlayerProfileStore? _profileStore;
  PlayerProfile _localProfile = PlayerProfile.guest;

  // The friend screen is a device-local contact list, not a live directory.
  // Start empty rather than implying that sample people are real players.
  final List<FriendPlayer> _friends = [];

  final List<ChallengeRecord> _challenges = [];
  bool _loadedAddedFriends = false;

  Future<void> _ensureAddedFriendsLoaded() async {
    if (_loadedAddedFriends) {
      return;
    }
    _loadedAddedFriends = true;
    // A repository without a profile store is an in-memory/test instance.
    // Do not touch the platform preferences plugin in that mode.
    if (_profileStore == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final names = prefs.getStringList(_addedNamesKey) ?? const <String>[];
    for (final name in names) {
      if (_friends.any(
        (friend) => friend.name.toLowerCase() == name.toLowerCase(),
      )) {
        continue;
      }
      _friends.add(
        FriendPlayer(
          id: 'local_${name.toLowerCase().replaceAll(' ', '_')}',
          name: name,
          rating: 1500,
          presence: Presence.offline,
        ),
      );
    }
  }

  Future<void> _persistAddedFriends() async {
    if (_profileStore == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final added = _friends
        .where((friend) => friend.id.startsWith('local_'))
        .map((friend) => friend.name)
        .toList(growable: false);
    await prefs.setStringList(_addedNamesKey, added);
  }

  @override
  Future<List<FriendPlayer>> getFriends() async {
    await _ensureAddedFriendsLoaded();
    return List.unmodifiable(_friends);
  }

  @override
  Future<bool> addFriend(String name) async {
    await _ensureAddedFriendsLoaded();
    final normalized = name.trim();
    if (normalized.length < 2) {
      return false;
    }
    final exists = _friends.any(
      (friend) => friend.name.toLowerCase() == normalized.toLowerCase(),
    );
    if (exists) {
      return false;
    }
    _friends.insert(
      0,
      FriendPlayer(
        id: 'local_${DateTime.now().microsecondsSinceEpoch}',
        name: normalized,
        rating: 1500,
        presence: Presence.offline,
      ),
    );
    await _persistAddedFriends();
    return true;
  }

  @override
  Future<PlayerProfile> getLocalProfile() async {
    final store = _profileStore;
    if (store == null) {
      return _localProfile;
    }
    _localProfile = await store.load();
    return _localProfile;
  }

  @override
  Future<void> saveLocalProfile(PlayerProfile profile) async {
    final store = _profileStore;
    if (store != null) {
      await store.save(profile);
    }
    _localProfile = profile;
    notifyListeners();
  }

  @override
  Future<void> deleteLocalUserData() async {
    _localProfile = PlayerProfile.guest;
    await _profileStore?.clear();
    _friends.removeWhere((friend) => friend.id.startsWith('local_'));
    _challenges.clear();
    if (_profileStore != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_addedNamesKey);
    }
    _loadedAddedFriends = true;
    notifyListeners();
  }

  static const List<(String, String, int, int, int)> _seedPlayers = [
    ('Alp_Grandmaster', 'TR', 1980, 114, 12),
    ('Elena_Morris', 'RU', 1935, 98, 18),
    ('Mehmet_Taktik', 'TR', 1890, 86, 21),
    ('Lucas_9Men', 'UK', 1830, 74, 24),
    ('Zeynep_Usta', 'TR', 1785, 62, 19),
    ('Hans_Strategist', 'DE', 1740, 55, 23),
    ('Baris_MillMaster', 'TR', 1695, 48, 20),
    ('Sofia_Board', 'IT', 1650, 41, 19),
    ('Caner_9', 'TR', 1610, 35, 17),
    ('Mateo_Tactics', 'ES', 1575, 29, 16),
    ('Emre_Morris', 'TR', 1540, 24, 15),
    ('Oliver_Chess', 'US', 1510, 20, 14),
    ('Deniz_Baslangic', 'TR', 1480, 15, 16),
    ('Liam_Gamer', 'NL', 1450, 12, 18),
    ('Cem_9Tas', 'TR', 1410, 8, 19),
    ('Noah_Pawn', 'SE', 1370, 5, 21),
  ];

  @override
  Future<List<LeaderboardEntry>> getWorldLeaderboard() =>
      getGameLeaderboard(MorrisGameId.nine);

  @override
  Future<List<LeaderboardEntry>> getGameLeaderboard(MorrisGameId gameId) async {
    final local = await getLocalProfile();
    final localRating = switch (gameId) {
      MorrisGameId.three => local.rating3,
      MorrisGameId.nine => local.rating9,
      MorrisGameId.twelve => local.rating12,
    };

    final rawList = <(FriendPlayer, int, int)>[];

    for (var i = 0; i < _seedPlayers.length; i++) {
      final s = _seedPlayers[i];
      final modeOffset = (gameId.index * 15) - (i % 3) * 10;
      final rating = (s.$3 + modeOffset).clamp(1000, 2500);
      rawList.add((
        FriendPlayer(
          id: 'seed_$i',
          name: s.$1,
          rating: rating,
          presence: Presence.online,
          countryCode: s.$2,
        ),
        s.$4,
        s.$5,
      ));
    }

    final localFriend = FriendPlayer(
      id: local.id,
      name: '${local.name} (Sen)',
      rating: localRating,
      presence: Presence.online,
      countryCode: local.countryCode,
    );
    rawList.add((localFriend, local.wins, local.losses));

    rawList.sort((a, b) => b.$1.rating.compareTo(a.$1.rating));

    return [
      for (var i = 0; i < rawList.length; i++)
        LeaderboardEntry(
          player: rawList[i].$1,
          rank: i + 1,
          wins: rawList[i].$2,
          losses: rawList[i].$3,
        ),
    ];
  }

  @override
  Future<List<LeaderboardEntry>> getCountryLeaderboard() =>
      getWorldLeaderboard();

  @override
  Future<List<LeaderboardEntry>> getFriendsLeaderboard() =>
      getWorldLeaderboard();

  @override
  Future<List<ChallengeRecord>> getChallenges() async =>
      List.unmodifiable(_challenges);

  FriendPlayer? _friendById(String friendId) {
    for (final friend in _friends) {
      if (friend.id == friendId) {
        return friend;
      }
    }
    return null;
  }

  @override
  Future<ChallengeRecord> sendChallenge(
    String friendId,
    MorrisGameId gameId,
  ) async {
    var opponent = _friendById(friendId);
    if (opponent == null) {
      await _ensureAddedFriendsLoaded();
      opponent = _friendById(friendId);
    }
    if (opponent == null) {
      throw StateError('Friend not found: $friendId');
    }
    final challenge = ChallengeRecord(
      id: 'c_${DateTime.now().microsecondsSinceEpoch}',
      opponent: opponent,
      gameId: gameId,
      status: ChallengeStatus.pending,
      createdAt: DateTime.now(),
    );
    _challenges.insert(0, challenge);
    return challenge;
  }
}
