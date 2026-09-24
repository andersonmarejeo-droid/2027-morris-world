import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Firebase release configuration remains source-controlled and safe by default',
    () {
      final firebaseJson = File('firebase.json').readAsStringSync();
      final firebaseProjectTemplate =
          File('.firebaserc.example').readAsStringSync();
      final flags = File('lib/app/app_feature_flags.dart').readAsStringSync();
      final factory =
          File(
            'lib/core/online/online_service_factory.dart',
          ).readAsStringSync();
      final router = File('lib/app/app_router.dart').readAsStringSync();
      final manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();

      expect(
        firebaseProjectTemplate,
        contains('replace-with-your-production-project-id'),
      );
      expect(firebaseJson, isNot(contains('projectId')));
      expect(firebaseJson, contains('"firestore"'));
      expect(firebaseJson, contains('"database"'));
      expect(firebaseJson, contains('"storage"'));
      expect(flags, contains('ONLINE_BACKEND_CANDIDATE'));
      expect(factory, contains('binary-candidate-disabled'));
      expect(router, contains('mode == MatchMode.onlineRanked'));
      expect(manifest, contains('android.permission.INTERNET'));
    },
  );

  test(
    'online writes and profile data have explicit server-side safeguards',
    () {
      final firestoreRules = File('firestore.rules').readAsStringSync();
      final databaseRules = File('database.rules.json').readAsStringSync();
      final functions = File('functions/src/index.ts').readAsStringSync();

      expect(firestoreRules, contains('validProfile'));
      expect(firestoreRules, contains('match /blocks/{blockedUid}'));
      expect(databaseRules, contains(r'auth.uid === $uid'));
      expect(functions, contains('enforceRateLimit'));
      expect(functions, contains('reconcileCompletedMatch'));
      expect(functions, contains('finalizeCompletedMatchSafely'));
    },
  );
}
