import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/online/firebase_match_client.dart';

void main() {
  test(
    'decodes persisted RTDB empty board cells without losing their slots',
    () {
      final state = OnlineMorrisState.fromMap(<Object?, Object?>{
        'board': <Object?>['empty', 'light', null, 'dark'],
        'turn': 'light',
        'lightToPlace': 3,
        'darkToPlace': 3,
        'pendingCaptureBy': null,
        'winner': null,
        'isDraw': false,
      });

      expect(state.board, <OnlineSide?>[
        null,
        OnlineSide.light,
        null,
        OnlineSide.dark,
      ]);
    },
  );
}
