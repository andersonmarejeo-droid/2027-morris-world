import 'package:cloud_functions/cloud_functions.dart';

import 'firebase_app_check_service.dart';
import 'firebase_auth_session.dart';
import 'firebase_service_exception.dart';

/// Single protected route to the app's callable Cloud Functions.
///
/// Authentication and App Check are checked immediately before every callable
/// request. This makes an accidentally configured but unattested project fail
/// closed instead of issuing a partially trusted move or challenge request.
class FirebaseCallableClient {
  FirebaseCallableClient({
    FirebaseFunctions? functions,
    required FirebaseAuthSession auth,
    required FirebaseAppCheckService appCheck,
  }) : _functions = functions ?? FirebaseFunctions.instance,
       _auth = auth,
       _appCheck = appCheck;

  final FirebaseFunctions _functions;
  final FirebaseAuthSession _auth;
  final FirebaseAppCheckService _appCheck;

  Future<Map<String, dynamic>> call(
    String name, {
    Map<String, dynamic> data = const <String, dynamic>{},
  }) async {
    try {
      await _auth.ensureSignedIn();
      await _appCheck.ensureUsableToken();
      final result = await _functions.httpsCallable(name).call(data);
      final raw = result.data;
      if (raw is! Map) {
        throw const FirebaseServiceException(
          FirebaseServiceErrorCode.dataIntegrity,
          debugMessage: 'callable-response-is-not-a-map',
        );
      }
      return Map<String, dynamic>.from(raw);
    } on FirebaseServiceException {
      rethrow;
    } on FirebaseFunctionsException catch (error) {
      throw FirebaseServiceException(
        _mapFunctionCode(error.code.toString()),
        cause: error,
        debugMessage: 'callable-$name-${error.code}',
      );
    } catch (error) {
      throw FirebaseServiceException(
        FirebaseServiceErrorCode.unknown,
        cause: error,
        debugMessage: 'callable-$name-failed',
      );
    }
  }

  FirebaseServiceErrorCode _mapFunctionCode(String rawCode) {
    final code = rawCode.split('.').last;
    return switch (code) {
      'unauthenticated' => FirebaseServiceErrorCode.authentication,
      'permissionDenied' ||
      'permission-denied' => FirebaseServiceErrorCode.permissionDenied,
      'unavailable' ||
      'deadlineExceeded' ||
      'deadline-exceeded' => FirebaseServiceErrorCode.unavailable,
      'cancelled' => FirebaseServiceErrorCode.cancelled,
      'aborted' => FirebaseServiceErrorCode.conflict,
      'invalidArgument' ||
      'invalid-argument' => FirebaseServiceErrorCode.invalidRequest,
      'notFound' || 'not-found' => FirebaseServiceErrorCode.notFound,
      'failedPrecondition' ||
      'failed-precondition' => FirebaseServiceErrorCode.failedPrecondition,
      'dataLoss' || 'data-loss' => FirebaseServiceErrorCode.dataIntegrity,
      _ => FirebaseServiceErrorCode.unknown,
    };
  }
}
