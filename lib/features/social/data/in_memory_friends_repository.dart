import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/game/game_definition.dart';
import '../domain/friend_player.dart';
import 'player_profile_store.dart';

class InMemoryFriendsRepository implements SocialRepository {
  InMemoryFriendsRepository({PlayerProfileStore? profileStore})
    : _profileStore = profileStore;

  static const _addedNamesKey = 'social_added_friend_names_v1';

  final PlayerProfileStore? _profileStore;
  PlayerProfile _localProfile = PlayerProfile.guest;

  final List<FriendPlayer> _friends = [
    const FriendPlayer(
      id: 'ahmet',
      name: 'Ahmet',
      rating: 1932,
      presence: Presence.online,
    ),
    const FriendPlayer(
      id: 'elif',
      name: 'Elif',
      rating: 1845,
      presence: Presence.online,
    ),
    const FriendPlayer(
      id: 'zeynep',
      name: 'Zeynep',
      rating: 1772,
      presence: Presence.online,
    ),
    const FriendPlayer(
      id: 'murat',
      name: 'Murat',
      rating: 1698,
      presence: Presence.inMatch,
    ),
    const FriendPlayer(
      id: 'can',
      name: 'Can',
      rating: 1645,
      presence: Presence.offline,
    ),
  ];

  final List<ChallengeRecord> _challenges = [];
  bool _loadedAddedFriends = false;

  Future<void> _ensureAddedFriendsLoaded() async {
    if (_loadedAddedFriends) {
      return;
    }
    _loadedAddedFriends = true;
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
    _localProfile = profile;
    final store = _profileStore;
    if (store != null) {
      await store.save(profile);
    }
  }

  @override
  Future<List<LeaderboardEntry>> getWorldLeaderboard() async {
    await _ensureAddedFriendsLoaded();
    return _leaderboard();
  }

  @override
  Future<List<LeaderboardEntry>> getCountryLeaderboard() async {
    await _ensureAddedFriendsLoaded();
    return _leaderboard();
  }

  @override
  Future<List<LeaderboardEntry>> getFriendsLeaderboard() async {
    await _ensureAddedFriendsLoaded();
    return _leaderboard().take(5).toList();
  }

  List<LeaderboardEntry> _leaderboard() {
    final sorted = [..._friends]..sort((a, b) => b.rating.compareTo(a.rating));
    return [
      for (var i = 0; i < sorted.length; i++)
        LeaderboardEntry(
          player: sorted[i],
          rank: i + 1,
          wins: 18 + (sorted.length - i) * 3,
          losses: 6 + i * 2,
        ),
    ];
  }

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
