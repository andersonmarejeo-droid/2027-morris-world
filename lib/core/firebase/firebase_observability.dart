import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'firebase_bootstrap.dart';
import 'firebase_service_exception.dart';

/// Installs privacy-conscious production diagnostics after Firebase starts.
///
/// No token, raw Firebase exception or player payload is sent. The client only
/// records stable error categories and lets the operations runbook define who
/// may access the resulting logs.
abstract final class FirebaseObservability {
  static bool _installed = false;

  static Future<void> initialize(FirebaseBootstrapStatus status) async {
    if (_installed || !status.firebaseReady) return;
    _installed = true;

    try {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );
      if (kReleaseMode) {
        await FirebaseAnalytics.instance.logAppOpen();
      }
    } catch (_) {
      // Diagnostics never block the playable offline application.
    }

    final previousFlutterHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      previousFlutterHandler?.call(details);
      if (kReleaseMode) {
        unawaited(
          FirebaseCrashlytics.instance.recordFlutterFatalError(details),
        );
      }
    };

    final previousPlatformHandler = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      if (kReleaseMode) {
        unawaited(
          FirebaseCrashlytics.instance.recordError(
            error,
            stackTrace,
            fatal: true,
            reason: 'uncaught-platform-error',
          ),
        );
      }
      return previousPlatformHandler?.call(error, stackTrace) ?? true;
    };
  }

  static void recordServiceFailure(FirebaseServiceException exception) {
    if (!_installed || !kReleaseMode) return;
    unawaited(
      FirebaseCrashlytics.instance.recordError(
        exception.cause ?? exception,
        null,
        fatal: false,
        reason: 'firebase-service-${exception.code.name}',
      ),
    );
  }
}
