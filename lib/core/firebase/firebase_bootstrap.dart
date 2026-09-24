import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../app/app_feature_flags.dart';
import 'firebase_service_exception.dart';

/// The result of bringing the Firebase runtime online.
///
/// Core Firebase and App Check are deliberately reported separately. A
/// configured project can still be unsafe for ranked play if attestation has
/// not been activated, so callers must use [canUseProtectedServices] rather
/// than only checking [firebaseReady].
class FirebaseBootstrapStatus {
  const FirebaseBootstrapStatus({
    required this.firebaseReady,
    required this.appCheckReady,
    this.failure,
  });

  const FirebaseBootstrapStatus.unavailable(this.failure)
    : firebaseReady = false,
      appCheckReady = false;

  final bool firebaseReady;
  final bool appCheckReady;
  final FirebaseServiceException? failure;

  bool get canUseProtectedServices => firebaseReady && appCheckReady;
  bool get isOfflineFallback => !firebaseReady;

  /// A stable diagnostic code that is safe to log without exposing credentials
  /// or platform-specific error text.
  String get availabilityCode => failure?.code.name ?? 'ready';
}

/// Initializes Firebase before any Firebase-backed service is constructed.
///
/// The app intentionally falls back to its fully playable local mode if the
/// platform configuration is absent. In production, passing
/// `--dart-define=STRICT_FIREBASE=true` turns an accidental missing
/// configuration into a release-blocking startup error instead of silently
/// advertising online functionality.
abstract final class FirebaseBootstrap {
  static const _strict = bool.fromEnvironment(
    'STRICT_FIREBASE',
    defaultValue: false,
  );

  static Future<FirebaseBootstrapStatus> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      await _connectEmulatorsIfRequested();
    } catch (error) {
      final failure = FirebaseServiceException(
        FirebaseServiceErrorCode.configuration,
        cause: error,
        debugMessage: 'firebase-core-initialization-failed',
      );
      _report(failure);
      if (kReleaseMode && _strict) rethrow;
      return FirebaseBootstrapStatus.unavailable(failure);
    }

    try {
      await FirebaseAppCheck.instance.activate(
        providerAndroid:
            (kDebugMode || AppFeatureFlags.useFirebaseEmulators)
                ? const AndroidDebugProvider()
                : const AndroidPlayIntegrityProvider(),
        providerApple:
            (kDebugMode || AppFeatureFlags.useFirebaseEmulators)
                ? const AppleDebugProvider()
                : const AppleAppAttestProvider(),
      );
      return const FirebaseBootstrapStatus(
        firebaseReady: true,
        appCheckReady: true,
      );
    } catch (error) {
      final failure = FirebaseServiceException(
        FirebaseServiceErrorCode.appCheck,
        cause: error,
        debugMessage: 'firebase-app-check-activation-failed',
      );
      _report(failure);
      if (kReleaseMode && _strict) rethrow;
      return FirebaseBootstrapStatus(
        firebaseReady: true,
        appCheckReady: false,
        failure: failure,
      );
    }
  }

  static void _report(FirebaseServiceException exception) {
    if (kDebugMode) {
      debugPrint('Firebase runtime unavailable: ${exception.debugMessage}');
    }
  }

  static Future<void> _connectEmulatorsIfRequested() async {
    if (!AppFeatureFlags.useFirebaseEmulators) return;

    // Android emulators reach the development machine through 10.0.2.2 by
    // default. Override it for desktop Flutter or a physical test device.
    const host = String.fromEnvironment(
      'FIREBASE_EMULATOR_HOST',
      defaultValue: '10.0.2.2',
    );
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    FirebaseDatabase.instance.useDatabaseEmulator(host, 9000);
    FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
  }
}
