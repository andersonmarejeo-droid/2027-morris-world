import 'package:shared_preferences/shared_preferences.dart';

import '../domain/friend_player.dart';

abstract interface class PlayerProfileStore {
  Future<PlayerProfile> load();
  Future<void> save(PlayerProfile profile);
}

class SharedPreferencesPlayerProfileStore implements PlayerProfileStore {
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

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  @override
  Future<PlayerProfile> load() async {
    const fallback = PlayerProfile.guest;
    final storedEmail = await _prefs.getString(_emailKey);
    return PlayerProfile(
      id: await _prefs.getString(_idKey) ?? fallback.id,
      name: await _prefs.getString(_nameKey) ?? fallback.name,
      countryCode: await _prefs.getString(_countryKey) ?? fallback.countryCode,
      rating3: await _prefs.getInt(_rating3Key) ?? fallback.rating3,
      rating9: await _prefs.getInt(_rating9Key) ?? fallback.rating9,
      rating12: await _prefs.getInt(_rating12Key) ?? fallback.rating12,
      wins: await _prefs.getInt(_winsKey) ?? fallback.wins,
      losses: await _prefs.getInt(_lossesKey) ?? fallback.losses,
      bestStreak: await _prefs.getInt(_bestStreakKey) ?? fallback.bestStreak,
      level: await _prefs.getInt(_levelKey) ?? fallback.level,
      xp: await _prefs.getInt(_xpKey) ?? fallback.xp,
      xpForNextLevel:
          await _prefs.getInt(_xpForNextLevelKey) ?? fallback.xpForNextLevel,
      avatarId: await _prefs.getString(_avatarIdKey) ?? fallback.avatarId,
      email: storedEmail == null || storedEmail.isEmpty ? null : storedEmail,
    );
  }

  @override
  Future<void> save(PlayerProfile profile) async {
    await _prefs.setString(_idKey, profile.id);
    await _prefs.setString(_nameKey, profile.name);
    await _prefs.setString(_countryKey, profile.countryCode);
    await _prefs.setInt(_rating3Key, profile.rating3);
    await _prefs.setInt(_rating9Key, profile.rating9);
    await _prefs.setInt(_rating12Key, profile.rating12);
    await _prefs.setInt(_winsKey, profile.wins);
    await _prefs.setInt(_lossesKey, profile.losses);
    await _prefs.setInt(_bestStreakKey, profile.bestStreak);
    await _prefs.setInt(_levelKey, profile.level);
    await _prefs.setInt(_xpKey, profile.xp);
    await _prefs.setInt(_xpForNextLevelKey, profile.xpForNextLevel);
    await _prefs.setString(_avatarIdKey, profile.avatarId);
    final email = profile.email;
    if (email == null || email.isEmpty) {
      await _prefs.remove(_emailKey);
    } else {
      await _prefs.setString(_emailKey, email);
    }
  }
}
