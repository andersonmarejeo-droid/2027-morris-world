import '../firebase/firebase_service_exception.dart';
import '../game/game_definition.dart';
import 'firebase_match_client.dart';
import 'quick_message.dart';

class OnlineAvailability {
  const OnlineAvailability({required this.enabled, this.reason});

  final bool enabled;
  final String? reason;
}

abstract interface class OnlineMatchGateway {
  Future<OnlineAvailability> availability();
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
  Future<void> cancelQuickMatch(String ticketId) async {}

  @override
  Future<void> sendQuickMessage({
    required String matchId,
    required QuickMessageId messageId,
  }) => Future.error(StateError('Online backend is not configured.'));
}

/// Firebase transport for protected match operations.
///
/// Quick matchmaking intentionally remains unavailable until a server-side
/// queue, cancellation protocol, fairness policy and load tests exist. The
/// transport is still useful to verified match screens for server-authoritative
/// quick messages and the dedicated [FirebaseMatchClient] APIs.
class FirebaseOnlineMatchGateway implements OnlineMatchGateway {
  FirebaseOnlineMatchGateway(this.matchClient);

  final FirebaseMatchClient matchClient;

  @override
  Future<OnlineAvailability> availability() async => const OnlineAvailability(
    enabled: false,
    reason: 'quick-match-server-not-configured',
  );

  @override
  Future<String> createQuickMatch(MorrisGameId gameId) => Future.error(
    const FirebaseServiceException(
      FirebaseServiceErrorCode.unsupported,
      debugMessage: 'quick-match-server-not-configured',
    ),
  );

  @override
  Future<void> cancelQuickMatch(String ticketId) => Future.error(
    const FirebaseServiceException(
      FirebaseServiceErrorCode.unsupported,
      debugMessage: 'quick-match-server-not-configured',
    ),
  );

  @override
  Future<void> sendQuickMessage({
    required String matchId,
    required QuickMessageId messageId,
  }) => matchClient.sendQuickMessage(matchId: matchId, messageId: messageId);
}
