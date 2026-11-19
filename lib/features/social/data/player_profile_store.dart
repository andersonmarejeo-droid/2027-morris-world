import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/friend_player.dart';

abstract interface class PlayerProfileStore {
  Future<PlayerProfile> load();
  Future<void> save(PlayerProfile profile);
  Future<void> clear();
}

class SharedPreferencesPlayerProfileStore implements PlayerProfileStore {
  static const _profileRecordKey = 'profile.record.v2';
  static const _idKey = 'profile.id';
  static const _nameKey = 'profile.name';
  static const _countryKey = 'profile.country';
  static const _rating3Key = 'profile.rating3';
  static const _rating9Key = 'profile.rating9';
  static const _rating12Key = 'profile.rating12';
  static const _winsKey = 'profile.wins';
  static const _lossesKey = 'profile.losses';
  static const _bestStreakKey = 'profile.bestStreak';
  static const _levelKey = 'profile.level';
  static const _xpKey = 'profile.xp';
  static const _xpForNextLevelKey = 'profile.xpForNextLevel';
  static const _avatarIdKey = 'profile.avatarId';
  static const _emailKey = 'profile.email';

  @override
  Future<PlayerProfile> load() async {
    const fallback = PlayerProfile.guest;
    final prefs = await SharedPreferences.getInstance();
    final record = prefs.getString(_profileRecordKey);
    if (record != null && record.isNotEmpty) {
      try {
        final json = jsonDecode(record) as Map<String, dynamic>;
        final profile = PlayerProfile(
          id: json['id'] as String? ?? fallback.id,
          name: json['name'] as String? ?? fallback.name,
          countryCode: json['countryCode'] as String? ?? fallback.countryCode,
          rating3: (json['rating3'] as num?)?.toInt() ?? fallback.rating3,
          rating9: (json['rating9'] as num?)?.toInt() ?? fallback.rating9,
          rating12: (json['rating12'] as num?)?.toInt() ?? fallback.rating12,
          wins: (json['wins'] as num?)?.toInt() ?? fallback.wins,
          losses: (json['losses'] as num?)?.toInt() ?? fallback.losses,
          bestStreak:
              (json['bestStreak'] as num?)?.toInt() ?? fallback.bestStreak,
          level: (json['level'] as num?)?.toInt() ?? fallback.level,
          xp: (json['xp'] as num?)?.toInt() ?? fallback.xp,
          xpForNextLevel:
              (json['xpForNextLevel'] as num?)?.toInt() ??
              fallback.xpForNextLevel,
          avatarId: json['avatarId'] as String? ?? fallback.avatarId,
          email: json['email'] as String?,
        );
        final migrated = _removeSampleProgress(profile);
        if (!identical(profile, migrated)) await save(migrated);
        return migrated;
      } on FormatException {
        // Fall back to the older per-field record if a partial/corrupt record
        // is encountered; the next save will replace it atomically.
      } on TypeError {
        // Treat malformed values like an unavailable record and migrate below.
      }
    }

    final storedEmail = prefs.getString(_emailKey);
    final loadedProfile = PlayerProfile(
      id: prefs.getString(_idKey) ?? fallback.id,
      name: prefs.getString(_nameKey) ?? fallback.name,
      countryCode: prefs.getString(_countryKey) ?? fallback.countryCode,
      rating3: prefs.getInt(_rating3Key) ?? fallback.rating3,
      rating9: prefs.getInt(_rating9Key) ?? fallback.rating9,
      rating12: prefs.getInt(_rating12Key) ?? fallback.rating12,
      wins: prefs.getInt(_winsKey) ?? fallback.wins,
      losses: prefs.getInt(_lossesKey) ?? fallback.losses,
      bestStreak: prefs.getInt(_bestStreakKey) ?? fallback.bestStreak,
      level: prefs.getInt(_levelKey) ?? fallback.level,
      xp: prefs.getInt(_xpKey) ?? fallback.xp,
      xpForNextLevel:
          prefs.getInt(_xpForNextLevelKey) ?? fallback.xpForNextLevel,
      avatarId: prefs.getString(_avatarIdKey) ?? fallback.avatarId,
      email: storedEmail == null || storedEmail.isEmpty ? null : storedEmail,
    );
    final profile = _removeSampleProgress(loadedProfile);
    final hasLegacyRecord =
        prefs.getString(_idKey) != null ||
        prefs.getString(_nameKey) != null ||
        prefs.getString(_countryKey) != null;
    if (hasLegacyRecord || !identical(profile, loadedProfile)) {
      await save(profile);
    }
    return profile;
  }

  @override
  Future<void> save(PlayerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(
      _profileRecordKey,
      jsonEncode(<String, Object?>{
        'id': profile.id,
        'name': profile.name,
        'countryCode': profile.countryCode,
        'rating3': profile.rating3,
        'rating9': profile.rating9,
        'rating12': profile.rating12,
        'wins': profile.wins,
        'losses': profile.losses,
        'bestStreak': profile.bestStreak,
        'level': profile.level,
        'xp': profile.xp,
        'xpForNextLevel': profile.xpForNextLevel,
        'avatarId': profile.avatarId,
        'email': profile.email,
      }),
    );
    if (!saved) {
      throw StateError('The profile could not be saved to device storage.');
    }
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileRecordKey);
    for (final key in const <String>[
      _idKey,
      _nameKey,
      _countryKey,
      _rating3Key,
      _rating9Key,
      _rating12Key,
      _winsKey,
      _lossesKey,
      _bestStreakKey,
      _levelKey,
      _xpKey,
      _xpForNextLevelKey,
      _avatarIdKey,
      _emailKey,
    ]) {
      await prefs.remove(key);
    }
  }
}

PlayerProfile _removeSampleProgress(PlayerProfile profile) {
  // These values were bundled as demo statistics before real match statistics
  // were recorded. Clear only that exact seeded combination, keeping the
  // player's name, country, avatar and email intact.
  final isSeededDemo =
      profile.rating3 == 1518 &&
      profile.rating9 == 1674 &&
      profile.rating12 == 1589 &&
      profile.wins == 42 &&
      profile.losses == 26 &&
      profile.bestStreak == 7 &&
      profile.level == 12 &&
      profile.xp == 740;
  if (!isSeededDemo) return profile;
  return profile.copyWith(
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
}
