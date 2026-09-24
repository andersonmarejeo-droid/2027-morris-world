import '../../app/app_feature_flags.dart';
import '../firebase/firebase_bootstrap.dart';
import '../firebase/firebase_remote_feature_gate.dart';
import 'firebase_match_client.dart';
import 'online_match_gateway.dart';

/// Builds the only online service exposed to the widget tree.
///
/// The default result is deliberately disabled. A release must satisfy both a
/// binary candidate flag and the remote kill switch before a Firebase-backed
/// transport is even constructed.
abstract final class OnlineServiceFactory {
  static Future<OnlineMatchGateway> create(
    FirebaseBootstrapStatus bootstrap,
  ) async {
    if (!AppFeatureFlags.onlineBackendCandidate) {
      return const DisabledOnlineMatchGateway(
        reason: 'binary-candidate-disabled',
      );
    }
    if (!bootstrap.canUseProtectedServices) {
      return DisabledOnlineMatchGateway(reason: bootstrap.availabilityCode);
    }
    final decision = await FirebaseRemoteFeatureGate().evaluate(bootstrap);
    if (!decision.enabled) {
      return DisabledOnlineMatchGateway(reason: decision.reason);
    }
    return FirebaseOnlineMatchGateway(FirebaseMatchClient());
  }
}
