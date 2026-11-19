import '../game/game_definition.dart';
import 'firebase_match_client.dart';
import 'online_match_gateway.dart';
import 'quick_message.dart';
import 'spark_room_client.dart';

/// Defers Firebase work until an online screen asks for the service.
///
/// This keeps app launch and offline games local-only. A candidate build must
/// still pass the Firebase App Check and Remote Config gates before it can
/// return an enabled gateway.
class LazyOnlineMatchGateway implements OnlineMatchGateway {
  LazyOnlineMatchGateway(this._createGateway);

  final Future<OnlineMatchGateway> Function() _createGateway;
  Future<OnlineMatchGateway>? _gatewayFuture;

  Future<OnlineMatchGateway> _resolve() async {
    final pending = _gatewayFuture ??= _createGateway();
    try {
      return await pending;
    } catch (_) {
      if (identical(_gatewayFuture, pending)) _gatewayFuture = null;
      rethrow;
    }
  }

  @override
  Future<OnlineAvailability> availability() async {
    try {
      return await (await _resolve()).availability();
    } catch (_) {
      return const OnlineAvailability(
        enabled: false,
        reason: 'online-service-unavailable',
      );
    }
  }

  @override
  Future<OnlineRoom> createPrivateRoom(MorrisGameId gameId) async =>
      (await _resolve()).createPrivateRoom(gameId);

  @override
  Future<OnlineRoom> joinPrivateRoom(String roomCode) async =>
      (await _resolve()).joinPrivateRoom(roomCode);

  @override
  Stream<OnlineRoom?> watchPrivateRoom(String roomCode) async* {
    yield* (await _resolve()).watchPrivateRoom(roomCode);
  }

  @override
  Future<OnlineRoom> submitRoomMove({
    required String roomCode,
    required int expectedRevision,
    required OnlineMoveCommand command,
  }) async => (await _resolve()).submitRoomMove(
    roomCode: roomCode,
    expectedRevision: expectedRevision,
    command: command,
  );

  @override
  Future<void> closePrivateRoom(String roomCode) async =>
      (await _resolve()).closePrivateRoom(roomCode);

  @override
  Future<void> confirmMatch(String roomCode) async =>
      (await _resolve()).confirmMatch(roomCode);

  @override
  Future<void> resignPrivateRoom({
    required String roomCode,
    required int expectedRevision,
  }) async => (await _resolve()).resignPrivateRoom(
    roomCode: roomCode,
    expectedRevision: expectedRevision,
  );

  @override
  Future<void> claimPrivateRoomTimeout({
    required String roomCode,
    required int expectedRevision,
  }) async => (await _resolve()).claimPrivateRoomTimeout(
    roomCode: roomCode,
    expectedRevision: expectedRevision,
  );

  @override
  Future<String> createQuickMatch(MorrisGameId gameId) async =>
      (await _resolve()).createQuickMatch(gameId);

  @override
  Future<void> cancelQuickMatch(String ticketId) async =>
      (await _resolve()).cancelQuickMatch(ticketId);

  @override
  Future<void> sendQuickMessage({
    required String matchId,
    required QuickMessageId messageId,
  }) async => (await _resolve()).sendQuickMessage(
    matchId: matchId,
    messageId: messageId,
  );
}
