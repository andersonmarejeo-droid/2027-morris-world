import 'package:firebase_app_check/firebase_app_check.dart';

import 'firebase_service_exception.dart';

/// Verifies that App Check has produced a usable token before a protected
/// client operation is offered.
///
/// Callable Functions automatically attach the token after activation. The
/// explicit read below is a fast readiness check that keeps the UI locked when
/// a debug token was not registered or the production attestation provider has
/// not been configured yet.
class FirebaseAppCheckService {
  FirebaseAppCheckService({FirebaseAppCheck? appCheck})
    : _appCheck = appCheck ?? FirebaseAppCheck.instance;

  final FirebaseAppCheck _appCheck;

  Future<void> ensureUsableToken() async {
    try {
      final token = await _appCheck.getToken();
      if (token == null || token.isEmpty) {
        throw const FirebaseServiceException(
          FirebaseServiceErrorCode.appCheck,
          debugMessage: 'app-check-token-empty',
        );
      }
    } catch (error) {
      if (error is FirebaseServiceException) rethrow;
      throw FirebaseServiceException(
        FirebaseServiceErrorCode.appCheck,
        cause: error,
        debugMessage: 'app-check-token-unavailable',
      );
    }
  }
}
