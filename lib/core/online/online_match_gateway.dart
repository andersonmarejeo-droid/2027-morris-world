import '../game/game_definition.dart';
import 'quick_message.dart';

class OnlineAvailability {
  const OnlineAvailability({
    required this.enabled,
    this.reason,
  });

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
  const DisabledOnlineMatchGateway();

  @override
  Future<OnlineAvailability> availability() async => const OnlineAvailability(
        enabled: false,
        reason: 'firebase-backend-not-configured',
      );

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
