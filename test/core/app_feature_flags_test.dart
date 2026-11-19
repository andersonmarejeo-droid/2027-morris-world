import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/app/app_feature_flags.dart';

void main() {
  test(
    'debug builds stay offline and use the current release build number',
    () {
      expect(AppFeatureFlags.onlineBackendCandidate, isFalse);
      expect(AppFeatureFlags.buildNumber, 43);
    },
  );
}
