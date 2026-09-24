abstract final class AppFeatureFlags {
  /// Client-side social screens are available while their online data source
  /// is still deliberately separated from the offline product.
  static const socialFoundation = true;

  /// First half of the two-key online rollout. This stays false in ordinary
  /// builds; only a reviewed candidate may pass
  /// `--dart-define=ONLINE_BACKEND_CANDIDATE=true`.
  static const onlineBackendCandidate = bool.fromEnvironment(
    'ONLINE_BACKEND_CANDIDATE',
    defaultValue: false,
  );

  /// Compatibility name for presentation code. It must never be treated as a
  /// sufficient signal on its own; Remote Config is the independent second key.
  static const onlineBackendConfigured = onlineBackendCandidate;

  /// Mirrors the pubspec build baseline and prevents an older candidate from
  /// being enabled by a Remote Config value meant for a newer binary.
  static const buildNumber = int.fromEnvironment(
    'APP_BUILD_NUMBER',
    defaultValue: 28,
  );

  /// Local Emulator Suite builds never consult the production rollout switch.
  static const useFirebaseEmulators = bool.fromEnvironment(
    'USE_FIREBASE_EMULATORS',
    defaultValue: false,
  );

  static const morabarabaPreview = false;
}
