import '../firebase/firebase_service_exception.dart';
import '../game/game_definition.dart';
import 'firebase_match_client.dart';
import 'quick_message.dart';
import 'spark_room_client.dart';

class OnlineAvailability {
  const OnlineAvailability({required this.enabled, this.reason});

  final bool enabled;
  final String? reason;
}

abstract interface class OnlineMatchGateway {
  Future<OnlineAvailability> availability();
  Future<OnlineRoom> createPrivateRoom(MorrisGameId gameId);
  Future<OnlineRoom> joinPrivateRoom(String roomCode);
  Stream<OnlineRoom?> watchPrivateRoom(String roomCode);
  Future<OnlineRoom> submitRoomMove({
    required String roomCode,
    required int expectedRevision,
    required OnlineMoveCommand command,
  });
  Future<void> closePrivateRoom(String roomCode);
  Future<void> confirmMatch(String roomCode);
  Future<void> resignPrivateRoom({
    required String roomCode,
    required int expectedRevision,
  });
  Future<void> claimPrivateRoomTimeout({
    required String roomCode,
    required int expectedRevision,
  });
  Future<String> createQuickMatch(MorrisGameId gameId);
  Future<void> cancelQuickMatch(String ticketId);
  Future<void> sendQuickMessage({
    required String matchId,
    required QuickMessageId messageId,
  });
}

class DisabledOnlineMatchGateway implements OnlineMatchGateway {
  const DisabledOnlineMatchGateway({
    this.reason = 'firebase-backend-not-configured',
  });

  final String reason;

  @override
  Future<OnlineAvailability> availability() async =>
      OnlineAvailability(enabled: false, reason: reason);

  @override
  Future<String> createQuickMatch(MorrisGameId gameId) =>
      Future.error(StateError('Online backend is not configured.'));

  @override
  Future<OnlineRoom> createPrivateRoom(MorrisGameId gameId) =>
      Future.error(StateError('Online backend is not configured.'));

  @override
  Future<OnlineRoom> joinPrivateRoom(String roomCode) =>
      Future.error(StateError('Online backend is not configured.'));

  @override
  Stream<OnlineRoom?> watchPrivateRoom(String roomCode) =>
      Stream.error(StateError('Online backend is not configured.'));

  @override
  Future<OnlineRoom> submitRoomMove({
    required String roomCode,
    required int expectedRevision,
    required OnlineMoveCommand command,
  }) => Future.error(StateError('Online backend is not configured.'));

  @override
  Future<void> closePrivateRoom(String roomCode) async {}

  @override
  Future<void> confirmMatch(String roomCode) async {}

  @override
  Future<void> resignPrivateRoom({
    required String roomCode,
    required int expectedRevision,
  }) => Future.error(StateError('Online backend is not configured.'));

  @override
  Future<void> claimPrivateRoomTimeout({
    required String roomCode,
    required int expectedRevision,
  }) => Future.error(StateError('Online backend is not configured.'));

  @override
  Future<void> cancelQuickMatch(String ticketId) async {}

  @override
  Future<void> sendQuickMessage({
    required String matchId,
    required QuickMessageId messageId,
  }) => Future.error(StateError('Online backend is not configured.'));
}

/// Firebase transport for Spark-plan private matches.
class FirebaseOnlineMatchGateway implements OnlineMatchGateway {
  FirebaseOnlineMatchGateway(this.roomClient);

  final SparkRoomClient roomClient;

  @override
  Future<OnlineAvailability> availability() async =>
      const OnlineAvailability(enabled: true);

  @override
  Future<OnlineRoom> createPrivateRoom(MorrisGameId gameId) =>
      roomClient.createPrivateRoom(gameId);

  @override
  Future<OnlineRoom> joinPrivateRoom(String roomCode) =>
      roomClient.joinPrivateRoom(roomCode);

  @override
  Stream<OnlineRoom?> watchPrivateRoom(String roomCode) =>
      roomClient.watchRoom(roomCode);

  @override
  Future<OnlineRoom> submitRoomMove({
    required String roomCode,
    required int expectedRevision,
    required OnlineMoveCommand command,
  }) => roomClient.submitMove(
    roomId: roomCode,
    expectedRevision: expectedRevision,
    command: command,
  );

  @override
  Future<void> closePrivateRoom(String roomCode) =>
      roomClient.closeRoom(roomCode);

  @override
  Future<void> confirmMatch(String roomCode) =>
      roomClient.confirmMatch(roomCode);

  @override
  Future<void> resignPrivateRoom({
    required String roomCode,
    required int expectedRevision,
  }) => roomClient.resignRoom(
    roomId: roomCode,
    expectedRevision: expectedRevision,
  );

  @override
  Future<void> claimPrivateRoomTimeout({
    required String roomCode,
    required int expectedRevision,
  }) => roomClient.claimTimeout(
    roomId: roomCode,
    expectedRevision: expectedRevision,
  );

  @override
  Future<String> createQuickMatch(MorrisGameId gameId) =>
      roomClient.createQuickMatch(gameId);

  @override
  Future<void> cancelQuickMatch(String ticketId) => roomClient.closeRoom(ticketId);

  @override
  Future<void> sendQuickMessage({
    required String matchId,
    required QuickMessageId messageId,
  }) => Future.error(
    const FirebaseServiceException(
      FirebaseServiceErrorCode.unsupported,
      debugMessage: 'quick-messages-require-trusted-backend',
    ),
  );
}
