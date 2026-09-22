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

      final saved = await repository.getLocalProfile();
      final challenge = await repository.sendChallenge(
        'ahmet',
        MorrisGameId.nine,
      );

      expect(saved.name, 'Mustafa');
      expect(challenge.opponent.id, 'ahmet');
      expect(challenge.status, ChallengeStatus.pending);
      expect(await repository.getChallenges(), hasLength(1));
    },
  );
}
