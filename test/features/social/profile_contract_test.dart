import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('profile sprint keeps phone-number collection out of the product', () {
    final sources =
        <String>[
          File(
            'lib/features/social/domain/friend_player.dart',
          ).readAsStringSync(),
          File(
            'lib/features/social/presentation/profile_screen.dart',
          ).readAsStringSync(),
          File(
            'lib/features/social/data/player_profile_store.dart',
          ).readAsStringSync(),
        ].join('\n').toLowerCase();

    expect(sources.contains('phone'), isFalse);
    expect(sources.contains('telephone'), isFalse);
  });

  test(
    'profile persistence keeps social add-friend and challenge contracts',
    () {
      final domain =
          File(
            'lib/features/social/domain/friend_player.dart',
          ).readAsStringSync();
      final repository =
          File(
            'lib/features/social/data/in_memory_friends_repository.dart',
          ).readAsStringSync();

      expect(domain, contains('Future<bool> addFriend(String name)'));
      expect(
        domain,
        contains('Future<void> saveLocalProfile(PlayerProfile profile)'),
      );
      expect(repository, contains('Future<bool> addFriend(String name)'));
      expect(
        repository,
        contains('Future<void> saveLocalProfile(PlayerProfile profile)'),
      );
      expect(repository, contains('_friendById(friendId)'));
    },
  );
}
