import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/features/social/data/in_memory_friends_repository.dart';
import 'package:nine_tas/features/social/domain/friend_player.dart';

void main() {
  test(
    'seeded friend challenge does not depend on preferences plugin I/O',
    () async {
      final repository = InMemoryFriendsRepository();
      expect(await repository.addFriend('Ahmet'), isTrue);
      final friend = (await repository.getFriends()).single;

      final challenge = await repository.sendChallenge(
        friend.id,
        MorrisGameId.nine,
      );

      expect(challenge.opponent.name, 'Ahmet');
      expect(challenge.status, ChallengeStatus.pending);
      expect(await repository.getChallenges(), hasLength(1));
    },
  );
}
