import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nine_tas/features/social/data/in_memory_friends_repository.dart';
import 'package:nine_tas/features/social/data/player_profile_store.dart';
import 'package:nine_tas/features/social/domain/friend_player.dart';

class _FakePlayerProfileStore implements PlayerProfileStore {
  PlayerProfile value = PlayerProfile.guest;
  int saveCount = 0;

  @override
  Future<PlayerProfile> load() async => value;

  @override
  Future<void> save(PlayerProfile profile) async {
    value = profile;
    saveCount += 1;
  }

  @override
  Future<void> clear() async {
    value = PlayerProfile.guest;
  }
}

void main() {
  test('local profile can be edited without platform storage', () async {
    final repository = InMemoryFriendsRepository();
    final before = await repository.getLocalProfile();
    final edited = before.copyWith(name: 'Mustafa', countryCode: 'TR');

    await repository.saveLocalProfile(edited);
    final after = await repository.getLocalProfile();

    expect(after.name, 'Mustafa');
    expect(after.countryCode, 'TR');
    expect(after.rating9, before.rating9);
  });

  test('injected profile store persists the complete profile', () async {
    final store = _FakePlayerProfileStore();
    final repository = InMemoryFriendsRepository(profileStore: store);
    final edited = PlayerProfile.guest.copyWith(
      name: 'Ada',
      countryCode: 'DE',
      avatarId: 'avatar_07',
      email: 'ada@example.com',
    );

    await repository.saveLocalProfile(edited);
    final loaded = await repository.getLocalProfile();

    expect(store.saveCount, 1);
    expect(loaded.name, 'Ada');
    expect(loaded.countryCode, 'DE');
    expect(loaded.avatarId, 'avatar_07');
    expect(loaded.email, 'ada@example.com');
  });

  test(
    'shared preferences profile record survives a fresh store instance',
    () async {
      SharedPreferences.setMockInitialValues({});
      final firstStore = SharedPreferencesPlayerProfileStore();
      final edited = PlayerProfile.guest.copyWith(
        name: 'Mustafa',
        countryCode: 'TR',
        rating3: 1701,
        rating9: 1802,
        rating12: 1903,
      );

      await firstStore.save(edited);
      final loaded = await SharedPreferencesPlayerProfileStore().load();

      expect(loaded.name, 'Mustafa');
      expect(loaded.countryCode, 'TR');
      expect(loaded.overallRating, 1802);
    },
  );

  test('legacy profile fields are loaded and migrated as one record', () async {
    SharedPreferences.setMockInitialValues({
      'profile.name': 'Eski Profil',
      'profile.country': 'DE',
      'profile.rating3': 1700,
    });
    final store = SharedPreferencesPlayerProfileStore();

    final loaded = await store.load();
    final restored = await SharedPreferencesPlayerProfileStore().load();

    expect(loaded.name, 'Eski Profil');
    expect(loaded.countryCode, 'DE');
    expect(loaded.rating3, 1700);
    expect(restored.name, 'Eski Profil');
    expect(restored.countryCode, 'DE');
  });

  test('deleting local user data clears profile and added friends', () async {
    SharedPreferences.setMockInitialValues({});
    final store = _FakePlayerProfileStore();
    final repository = InMemoryFriendsRepository(profileStore: store);
    await repository.saveLocalProfile(
      PlayerProfile.guest.copyWith(name: 'Mustafa'),
    );
    await repository.addFriend('Bora');

    await repository.deleteLocalUserData();

    expect((await repository.getLocalProfile()).name, PlayerProfile.guest.name);
    expect(store.value.name, PlayerProfile.guest.name);
    expect(
      (await repository.getFriends()).any((friend) => friend.name == 'Bora'),
      isFalse,
    );
  });
}
