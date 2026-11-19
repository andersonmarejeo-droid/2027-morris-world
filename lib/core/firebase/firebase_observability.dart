import 'firebase_bootstrap.dart';

/// Remote analytics and crash collection stay disabled for the child-inclusive
/// audience. Keep this seam so diagnostics can be added later after privacy
/// disclosures and consent flows are reviewed.
abstract final class FirebaseObservability {
  static Future<void> initialize(FirebaseBootstrapStatus status) async {
    // Deliberately no remote collection for children or unknown-age users.
    if (!status.firebaseReady) return;
  }
}
