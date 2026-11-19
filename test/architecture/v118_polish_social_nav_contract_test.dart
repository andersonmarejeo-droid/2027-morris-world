import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('v118 polish social navigation and rematch contract is present', () {
    final friends =
        File(
          'lib/features/social/presentation/friends_screen.dart',
        ).readAsStringSync();
    final shareService =
        File(
          'lib/features/social/application/challenge_share_service.dart',
        ).readAsStringSync();
    final routes =
        File(
          'lib/app/app_routes.dart',
        ).readAsStringSync();
    final socialDomain =
        File(
          'lib/features/social/domain/friend_player.dart',
        ).readAsStringSync();
    final game =
        File(
          'lib/features/gameplay/presentation/game_screen.dart',
        ).readAsStringSync();
    final board =
        File(
          'lib/features/gameplay/presentation/widgets/morris_board.dart',
        ).readAsStringSync();
    final settings =
        File(
          'lib/features/settings/presentation/settings_screen.dart',
        ).readAsStringSync();

    expect(friends, contains('ChallengeShareService.closedTestingLink'));
    expect(
      friends.contains('ChallengeShareService.roomInviteMessage') ||
          shareService.contains('roomInviteMessage'),
      isTrue,
    );
    expect(
      friends.contains('AppRoutes.onlineRoom') || routes.contains('onlineRoom'),
      isTrue,
    );
    expect(friends, contains('_challengeLink'));
    expect(friends, contains('_addFriend'));
    expect(socialDomain, contains('Future<bool> addFriend(String name)'));
    expect(game, contains('_requestRematch'));
    expect(game, contains('resultVictoryPraise'));
    expect(game, contains('minHeight: 54'));
    expect(
      board,
      isNot(contains('final arc = math.sin(math.pi * motionProgress)')),
    );
    expect(settings, contains('PopScope'));
    expect(settings, contains('context.go(AppRoutes.home)'));
  });
}
