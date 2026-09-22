import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrapStatus {
  const FirebaseBootstrapStatus({required this.ready, this.error});
  final bool ready;
  final Object? error;
}

abstract final class FirebaseBootstrap {
  static const _strict = bool.fromEnvironment('STRICT_FIREBASE', defaultValue: false);

  static Future<FirebaseBootstrapStatus> initialize() async {
    try {
      await Firebase.initializeApp();
      return const FirebaseBootstrapStatus(ready: true);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Firebase is not configured yet: $error');
      }
      if (kReleaseMode && _strict) rethrow;
      return FirebaseBootstrapStatus(ready: false, error: error);
    }
  }
}
