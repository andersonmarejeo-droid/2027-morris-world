import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_service_exception.dart';

/// The minimum identity information that the feature layer needs from Auth.
/// Keeping Firebase's [User] at this boundary prevents it leaking through game
/// and social domain models.
class FirebaseUserIdentity {
  const FirebaseUserIdentity({
    required this.uid,
    required this.isAnonymous,
    this.displayName,
    this.email,
  });

  final String uid;
  final bool isAnonymous;
  final String? displayName;
  final String? email;

  factory FirebaseUserIdentity.fromUser(User user) => FirebaseUserIdentity(
    uid: user.uid,
    isAnonymous: user.isAnonymous,
    displayName: user.displayName,
    email: user.email,
  );
}

/// Owns the lightweight Auth session needed by protected Firebase calls.
///
/// Anonymous sign-in lets a new player safely use an online trial before a
/// product-specific account-linking screen is introduced. It can be disabled
/// for a release with `--dart-define=ALLOW_ANONYMOUS_AUTH=false`; in that case
/// the online area stays unavailable until a supported identity provider signs
/// the player in.
class FirebaseAuthSession {
  FirebaseAuthSession({FirebaseAuth? auth, bool? allowAnonymousSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _allowAnonymousSignIn =
          allowAnonymousSignIn ??
          const bool.fromEnvironment(
            'ALLOW_ANONYMOUS_AUTH',
            defaultValue: true,
          );

  final FirebaseAuth _auth;
  final bool _allowAnonymousSignIn;

  Stream<FirebaseUserIdentity?> get identityChanges => _auth
      .authStateChanges()
      .map((user) => user == null ? null : FirebaseUserIdentity.fromUser(user));

  FirebaseUserIdentity? get currentIdentity {
    final user = _auth.currentUser;
    return user == null ? null : FirebaseUserIdentity.fromUser(user);
  }

  Future<FirebaseUserIdentity> ensureSignedIn() async {
    final current = _auth.currentUser;
    if (current != null) return FirebaseUserIdentity.fromUser(current);

    if (!_allowAnonymousSignIn) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.authentication,
        debugMessage: 'no-authenticated-user',
      );
    }

    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        throw const FirebaseServiceException(
          FirebaseServiceErrorCode.authentication,
          debugMessage: 'anonymous-auth-returned-no-user',
        );
      }
      return FirebaseUserIdentity.fromUser(user);
    } on FirebaseAuthException catch (error) {
      throw FirebaseServiceException(
        _mapAuthCode(error.code),
        cause: error,
        debugMessage: 'firebase-auth-${error.code}',
      );
    }
  }

  Future<void> signOut() => _auth.signOut();

  FirebaseServiceErrorCode _mapAuthCode(String code) => switch (code) {
    'network-request-failed' => FirebaseServiceErrorCode.unavailable,
    'operation-not-allowed' => FirebaseServiceErrorCode.authentication,
    'user-disabled' => FirebaseServiceErrorCode.authentication,
    'too-many-requests' => FirebaseServiceErrorCode.unavailable,
    _ => FirebaseServiceErrorCode.authentication,
  };
}
