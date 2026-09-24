/// A stable, presentation-safe description of a Firebase service failure.
///
/// Firebase plugins expose detailed platform errors.  Those details can be
/// useful in diagnostics, but should never become part of gameplay flow or be
/// presented raw to players.  The app uses these codes to decide whether an
/// online capability can be offered and lets the UI choose a localized message.
enum FirebaseServiceErrorCode {
  configuration,
  appCheck,
  authentication,
  permissionDenied,
  unavailable,
  cancelled,
  conflict,
  invalidRequest,
  notFound,
  failedPrecondition,
  dataIntegrity,
  unsupported,
  unknown,
}

class FirebaseServiceException implements Exception {
  const FirebaseServiceException(this.code, {this.cause, this.debugMessage});

  final FirebaseServiceErrorCode code;
  final Object? cause;
  final String? debugMessage;

  bool get isRecoverable =>
      code == FirebaseServiceErrorCode.unavailable ||
      code == FirebaseServiceErrorCode.conflict ||
      code == FirebaseServiceErrorCode.cancelled;

  @override
  String toString() => 'FirebaseServiceException(${code.name})';
}
