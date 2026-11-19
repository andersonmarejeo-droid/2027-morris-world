import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/features/social/data/in_memory_friends_repository.dart';
import 'package:nine_tas/features/social/domain/friend_player.dart';

void main() {
  test(
    'profile persistence does not break seeded friend challenge flow',
    () async {
      final repository = InMemoryFriendsRepository();
      final before = await repository.getLocalProfile();
      await repository.saveLocalProfile(before.copyWith(name: 'Mustafa'));
      expect(await repository.addFriend('Ahmet'), isTrue);

      final saved = await repository.getLocalProfile();
      final friend = (await repository.getFriends()).single;
      final challenge = await repository.sendChallenge(
        friend.id,
        MorrisGameId.nine,
      );

      expect(saved.name, 'Mustafa');
      expect(challenge.opponent.name, 'Ahmet');
      expect(challenge.status, ChallengeStatus.pending);
      expect(await repository.getChallenges(), hasLength(1));
    },
  );
}
