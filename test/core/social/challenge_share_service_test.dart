import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/core/online/online_match_gateway.dart';
import 'package:nine_tas/core/online/spark_room_client.dart';
import 'package:nine_tas/features/social/application/challenge_share_service.dart';

class _UnavailableOnlineGateway extends DisabledOnlineMatchGateway {
  int createRoomCalls = 0;

  @override
  Future<OnlineAvailability> availability() async =>
      const OnlineAvailability(enabled: false, reason: 'test-disabled');

  @override
  Future<OnlineRoom> createPrivateRoom(MorrisGameId gameId) async {
    createRoomCalls++;
    throw StateError('Room creation should not be attempted.');
  }
}

class _FailingOnlineGateway extends DisabledOnlineMatchGateway {
  @override
  Future<OnlineAvailability> availability() async =>
      const OnlineAvailability(enabled: true);

  @override
  Future<OnlineRoom> createPrivateRoom(MorrisGameId gameId) async =>
      throw StateError('Simulated network failure.');
}

void main() {
  test('WhatsApp challenge invite uses the closed-test opt-in link', () {
    expect(
      ChallengeShareService.closedTestingLink,
      'https://play.google.com/apps/testing/com.zpgames.ucdokuzoniki',
    );
  });

  test('room invitation includes a real room code and join instruction', () {
    final message = ChallengeShareService.roomInviteMessage(
      opening: 'Birlikte 9 Taş oynayalım: uygulamayı indir',
      roomCode: 'AbCdEfGh1234567890xy',
      roomCodeLabel: 'Oda kodu',
      joinRoomLabel: 'Oda koduyla katıl',
    );

    expect(message, contains('AbCdEfGh1234567890xy'));
    expect(message, contains('Oda koduyla katıl'));
    expect(message, contains('Birlikte 9 Taş'));
  });

  test(
    'unavailable online rooms do not block sharing an app invitation',
    () async {
      final gateway = _UnavailableOnlineGateway();

      final room = await ChallengeShareService.tryCreatePrivateRoom(
        gateway,
        MorrisGameId.nine,
      );

      expect(room, isNull);
      expect(gateway.createRoomCalls, 0);
    },
  );

  test('room creation errors return no room for link-only fallback', () async {
    final room = await ChallengeShareService.tryCreatePrivateRoom(
      _FailingOnlineGateway(),
      MorrisGameId.nine,
    );

    expect(room, isNull);
  });
}
