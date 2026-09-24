import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/firebase/firebase_service_exception.dart';

void main() {
  test('only retry-safe Firebase failures are marked recoverable', () {
    expect(
      const FirebaseServiceException(
        FirebaseServiceErrorCode.unavailable,
      ).isRecoverable,
      isTrue,
    );
    expect(
      const FirebaseServiceException(
        FirebaseServiceErrorCode.conflict,
      ).isRecoverable,
      isTrue,
    );
    expect(
      const FirebaseServiceException(
        FirebaseServiceErrorCode.authentication,
      ).isRecoverable,
      isFalse,
    );
    expect(
      const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
      ).isRecoverable,
      isFalse,
    );
  });
}
