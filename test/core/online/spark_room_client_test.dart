import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/firebase/firebase_service_exception.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/online/spark_room_client.dart';

Map<String, Object?> roomData({int boardSize = 24}) => <String, Object?>{
  'schemaVersion': 1,
  'gameId': 'nine',
  'status': 'active',
  'hostUid': 'host-user',
  'guestUid': 'guest-user',
  'revision': 3,
  'turnUid': 'guest-user',
  'lastMoveBy': 'host-user',
  'lastFrom': -1,
  'lastTo': 2,
  'createdAt': 1700000000000,
  'updatedAt': 1700000003000,
  'state': <String, Object?>{
    'board': <int>[1, 2, ...List<int>.filled(boardSize - 2, 0)],
    'turn': 'dark',
    'lightToPlace': 8,
    'darkToPlace': 8,
    'pendingCaptureBy': '',
    'winner': '',
    'isDraw': false,
    'movesWithoutCapture': 0,
  },
};

void main() {
  test('decodes private room state and assigns each device its side', () {
    final hostView = OnlineRoom.fromMap(
      'abcdefghijklmnopqrst',
      roomData(),
      'host-user',
    );
    final guestView = OnlineRoom.fromMap(
      'abcdefghijklmnopqrst',
      roomData(),
      'guest-user',
    );

    expect(hostView.gameId, MorrisGameId.nine);
    expect(hostView.localSide, PlayerSide.light);
    expect(guestView.localSide, PlayerSide.dark);
    expect(hostView.revision, 3);
    expect(hostView.state.board.first, PlayerSide.light);
    expect(hostView.state.board[1], PlayerSide.dark);
    expect(hostView.state.board.skip(2).every((cell) => cell == null), isTrue);
  });

  test('rejects a room whose board does not match its selected game', () {
    expect(
      () => OnlineRoom.fromMap(
        'abcdefghijklmnopqrst',
        roomData(boardSize: 9),
        'host-user',
      ),
      throwsA(isA<FirebaseServiceException>()),
    );
  });
}
