import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/features/social/data/in_memory_friends_repository.dart';
import 'package:nine_tas/features/social/domain/friend_player.dart';

void main() {
  test('challenge creation is single-record and starts pending', () async {
    final repository = InMemoryFriendsRepository();
    final challenge = await repository.sendChallenge('ahmet', MorrisGameId.nine);
    expect(challenge.status, ChallengeStatus.pending);
    expect(challenge.gameId, MorrisGameId.nine);
    expect((await repository.getChallenges()).length, 1);
  });

  test('profile exposes per-variant ratings', () async {
    final profile = await InMemoryFriendsRepository().getLocalProfile();
    expect(profile.rating3, greaterThan(0));
    expect(profile.rating9, greaterThan(0));
    expect(profile.rating12, greaterThan(0));
  });
}
