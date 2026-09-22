import 'package:flutter_test/flutter_test.dart';
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
}
