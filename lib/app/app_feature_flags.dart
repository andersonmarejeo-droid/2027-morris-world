abstract final class AppFeatureFlags {
  /// Client-side social/online screens are available. Real ranked matchmaking
  /// stays locked until Firebase Auth/RTDB/Cloud Functions are configured.
  static const socialFoundation = true;
  static const onlineBackendConfigured = false;
  static const morabarabaPreview = false;
}
