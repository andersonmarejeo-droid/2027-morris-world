import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../../app/app_feature_flags.dart';
import 'firebase_bootstrap.dart';

/// Result of the two-key online rollout check.
///
/// A signed binary must opt in through a build-time value and Remote Config
/// must independently allow the backend. This gives operations a remote kill
/// switch without letting a Console typo activate an unreviewed app build.
class OnlineFeatureDecision {
  const OnlineFeatureDecision({required this.enabled, required this.reason});

  final bool enabled;
  final String reason;
}

class FirebaseRemoteFeatureGate {
  FirebaseRemoteFeatureGate({FirebaseRemoteConfig? remoteConfig})
    : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;

  Future<OnlineFeatureDecision> evaluate(FirebaseBootstrapStatus status) async {
    if (!AppFeatureFlags.onlineBackendCandidate) {
      return const OnlineFeatureDecision(
        enabled: false,
        reason: 'binary-candidate-disabled',
      );
    }
    if (!status.canUseProtectedServices) {
      return OnlineFeatureDecision(
        enabled: false,
        reason: status.availabilityCode,
      );
    }
    if (AppFeatureFlags.useFirebaseEmulators) {
      // A real Remote Config project must never decide an emulator build's
      // rollout. Emulator matchmaking gets a separately explicit test path.
      return const OnlineFeatureDecision(
        enabled: false,
        reason: 'emulator-rollout-disabled',
      );
    }

    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval:
              kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );
      await _remoteConfig.setDefaults(<String, dynamic>{
        'online_backend_enabled': false,
        'online_backend_minimum_build': 2147483647,
      });
      await _remoteConfig.fetchAndActivate();

      final remotelyEnabled = _remoteConfig.getBool('online_backend_enabled');
      final minimumBuild = _remoteConfig.getInt('online_backend_minimum_build');
      if (!remotelyEnabled) {
        return const OnlineFeatureDecision(
          enabled: false,
          reason: 'remote-kill-switch-disabled',
        );
      }
      if (AppFeatureFlags.buildNumber < minimumBuild) {
        return const OnlineFeatureDecision(
          enabled: false,
          reason: 'minimum-build-not-met',
        );
      }
      return const OnlineFeatureDecision(enabled: true, reason: 'enabled');
    } catch (_) {
      // Remote Config errors must fail closed. The raw provider exception can
      // carry platform details, so only the stable reason leaves this layer.
      return const OnlineFeatureDecision(
        enabled: false,
        reason: 'remote-config-unavailable',
      );
    }
  }
}
