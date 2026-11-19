import 'package:firebase_database/firebase_database.dart';

import '../firebase/firebase_auth_session.dart';
import '../firebase/firebase_service_exception.dart';
import '../game/game_catalog.dart';
import '../game/game_definition.dart';
import '../game/game_models.dart';
import '../game/morris_engine.dart';
import 'firebase_match_client.dart';

enum OnlineRoomStatus { waiting, active, completed }

/// A private, room-code match designed to run on Firebase's no-cost Spark
/// plan. It deliberately has no public queue, global discovery, chat, or rank.
class OnlineRoom {
  const OnlineRoom({
    required this.id,
    required this.gameId,
    required this.status,
    required this.hostUid,
    required this.guestUid,
    required this.localUid,
    required this.state,
    required this.revision,
    required this.updatedAt,
    this.hostReady = true,
    this.lastMoveBy,
    this.lastFrom,
    this.lastTo,
    this.resignedBy,
    this.forfeitReason,
  });

  final String id;
  final MorrisGameId gameId;
  final OnlineRoomStatus status;
  final String hostUid;
  final String? guestUid;
  final String localUid;
  final MorrisGameState state;
  final int revision;
  final int updatedAt;
  final bool hostReady;
  final String? lastMoveBy;
  final int? lastFrom;
  final int? lastTo;
  final String? resignedBy;
  final String? forfeitReason;

  PlayerSide? get localSide =>
      localUid == hostUid
          ? PlayerSide.light
          : localUid == guestUid
          ? PlayerSide.dark
          : null;

  String? uidFor(PlayerSide side) =>
      side == PlayerSide.light ? hostUid : guestUid;

  factory OnlineRoom.fromMap(
    String id,
    Map<Object?, Object?> source,
    String localUid,
  ) {
    final gameId = _gameId(source['gameId']);
    final definition = GameCatalog.byId(gameId);
    final rawState = source['state'];
    if (rawState is! Map) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
        debugMessage: 'spark-room-state-missing',
      );
    }
    final decodedState = _decodeState(Map<Object?, Object?>.from(rawState));
    final hostUid = _requiredString(source['hostUid']);
    final guestUid = _nullableString(source['guestUid']);
    final resignedBy = _nullableString(source['resignedBy']);
    final forfeitReason = _nullableString(source['forfeitReason']);
    if (resignedBy != null && resignedBy != hostUid && resignedBy != guestUid) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
        debugMessage: 'spark-room-resigner-invalid',
      );
    }
    if (forfeitReason != null &&
        forfeitReason != 'resign' &&
        forfeitReason != 'timeout') {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
        debugMessage: 'spark-room-forfeit-reason-invalid',
      );
    }
    final state =
        resignedBy == null
            ? decodedState
            : decodedState.copyWith(
              winner: resignedBy == hostUid ? PlayerSide.dark : PlayerSide.light,
              clearPendingCapture: true,
              isDraw: false,
            );
    if (state.board.length != definition.board.pointCount ||
        state.lightToPlace < 0 ||
        state.darkToPlace < 0 ||
        state.lightToPlace > definition.piecesPerPlayer ||
        state.darkToPlace > definition.piecesPerPlayer) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
        debugMessage: 'spark-room-state-invalid',
      );
    }

    return OnlineRoom(
      id: id,
      gameId: gameId,
      status:
          resignedBy == null
              ? _roomStatus(source['status'])
              : OnlineRoomStatus.completed,
      hostUid: hostUid,
      guestUid: guestUid,
      localUid: localUid,
      state: state,
      revision: _nonNegativeInt(source['revision']),
      updatedAt: _nonNegativeInt(source['updatedAt']),
      hostReady: source['hostReady'] != false,
      lastMoveBy: _nullableString(source['lastMoveBy']),
      lastFrom: _nullableInt(source['lastFrom']),
      lastTo: _nullableInt(source['lastTo']),
      resignedBy: resignedBy,
      forfeitReason: forfeitReason,
    );
  }
}

/// Client-only private-room transport. RTDB rules restrict room reads to its
/// two participants and each move to the player whose turn it is. Since the
/// Spark plan has no trusted callable server, this remains casual play only:
/// it must not be used for ranked results or prizes.
class SparkRoomClient {
  SparkRoomClient({
    FirebaseDatabase? database,
    FirebaseAuthSession? auth,
  }) : _database = database ?? FirebaseDatabase.instance,
       _auth = auth ?? FirebaseAuthSession();

  final FirebaseDatabase _database;
  final FirebaseAuthSession _auth;

  static const _quickMatchTimeout = Duration(seconds: 20);
  static const turnTimeout = Duration(minutes: 2);

  /// Finds another player for the same game without exposing a room-code
  /// screen. The room remains an internal transport detail: once two queue
  /// tickets pair, both clients enter the active room automatically.
  ///
  /// This uses only Realtime Database transactions so it stays compatible
  /// with the Firebase Spark plan. It deliberately has no chat, ranking, or
  /// public player profile data in the queue.
  Future<String> createQuickMatch(MorrisGameId gameId) async {
    final uid = await _readyUid();
    final room = await createPrivateRoom(gameId);
    final queue = _database.ref('sparkMatchmaking/${gameId.name}');
    final ticket = queue.push();
    final ticketId = ticket.key;
    if (ticketId == null || !_isRoomCode(ticketId)) {
      await closeRoom(room.id);
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.unknown,
        debugMessage: 'spark-quick-match-ticket-generation-failed',
      );
    }

    var paired = false;
    String? pairedRoomId;
    try {
      await ticket.set(<String, Object?>{
        'schemaVersion': 1,
        'gameId': gameId.name,
        'uid': uid,
        'roomId': room.id,
        'status': 'waiting',
        'createdAt': ServerValue.timestamp,
      });

      final deadline = DateTime.now().add(_quickMatchTimeout);
      while (DateTime.now().isBefore(deadline)) {
        final ownSnapshot = await ticket.get();
        final ownValue = ownSnapshot.value;
        if (ownValue is Map) {
          final own = Map<Object?, Object?>.from(ownValue);
          if (own['status'] == 'matched' && own['roomId'] is String) {
            // The queue claim is written just before the other client joins
            // the room. Do not navigate to the room while it is still in its
            // waiting state; that race left one player on a frozen "waiting
            // for opponent" board. Wait until the room has two participants.
            final candidateRoom = (own['roomId'] as String).trim();
            if (await _waitForActiveRoom(candidateRoom)) {
              paired = true;
              pairedRoomId = candidateRoom;
              return pairedRoomId;
            }
          }
        }

        final waiting = await queue
            .orderByChild('status')
            .equalTo('waiting')
            .get();
        final rawWaiting = waiting.value;
        if (rawWaiting is Map) {
          for (final entry in rawWaiting.entries) {
            final candidateId = entry.key.toString();
            if (candidateId == ticketId || entry.value is! Map) continue;
            final candidate = Map<Object?, Object?>.from(entry.value as Map);
            final candidateRoom = _nullableString(candidate['roomId']);
            if (candidateRoom == null || !_isRoomCode(candidateRoom)) continue;

            final claimed = await queue.child(candidateId).runTransaction(
              (value) {
                if (value is! Map) return Transaction.abort();
                final current = Map<String, Object?>.from(value);
                if (current['status'] != 'waiting' ||
                    current['roomId'] != candidateRoom ||
                    current['uid'] == uid) {
                  return Transaction.abort();
                }
                current
                  ..['status'] = 'matched'
                  ..['matchedUid'] = uid
                  ..['matchedAt'] = ServerValue.timestamp;
                return Transaction.success(current);
              },
              applyLocally: false,
            );
            if (!claimed.committed) continue;

            try {
              await joinPrivateRoom(candidateRoom);
              paired = true;
              pairedRoomId = candidateRoom;
              return candidateRoom;
            } catch (_) {
              // The candidate may have disappeared between the claim and
              // join. Remove this ticket and retry another candidate.
              await queue.child(candidateId).remove();
            }
          }
        }
        await Future<void>.delayed(const Duration(milliseconds: 700));
      }

      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.notFound,
        debugMessage: 'spark-quick-match-timeout',
      );
    } finally {
      try {
        await ticket.remove();
      } catch (_) {
        // Queue cleanup is best effort; stale entries are ignored after the
        // short timeout and do not affect local fallback.
      }
      if (!paired || pairedRoomId != room.id) {
        try {
          await closeRoom(room.id);
        } catch (_) {
          // The room may already have been claimed by the other player.
        }
      }
    }
  }

  Future<bool> _waitForActiveRoom(String roomId) async {
    final reference = _database.ref('sparkRooms/$roomId');
    final deadline = DateTime.now().add(const Duration(seconds: 8));
    while (DateTime.now().isBefore(deadline)) {
      try {
        final snapshot = await reference.get();
        final value = snapshot.value;
        if (value is Map) {
          final room = Map<Object?, Object?>.from(value);
          if (room['status'] == 'active' &&
              _nullableString(room['guestUid']) != null) {
            return true;
          }
        }
      } catch (_) {
        // A short transient read failure is retried until the pairing budget
        // expires; the lobby will then fall back to the computer opponent.
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    return false;
  }

  Future<OnlineRoom> createPrivateRoom(MorrisGameId gameId) async {
    final uid = await _readyUid();
    final reference = _database.ref('sparkRooms').push();
    final id = reference.key;
    if (id == null || !_isRoomCode(id)) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.unknown,
        debugMessage: 'spark-room-id-generation-failed',
      );
    }
    final initialState = MorrisEngine.initial(GameCatalog.byId(gameId));
    await reference.set(<String, Object?>{
      'schemaVersion': 1,
      'gameId': gameId.name,
      'status': 'waiting',
      'hostUid': uid,
      'guestUid': '',
      'hostReady': false,
      'revision': 0,
      'turnUid': uid,
      'lastMoveBy': '',
      'lastFrom': -1,
      'lastTo': -1,
      'createdAt': ServerValue.timestamp,
      'updatedAt': ServerValue.timestamp,
      'state': _encodeState(initialState),
    });
    return OnlineRoom.fromMap(
      id,
      Map<Object?, Object?>.from((await reference.get()).value as Map),
      uid,
    );
  }

  Future<OnlineRoom> joinPrivateRoom(String roomCode) async {
    final id = roomCode.trim();
    if (!_isRoomCode(id)) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.invalidRequest,
        debugMessage: 'spark-room-code-invalid',
      );
    }
    final uid = await _readyUid();
    final reference = _database.ref('sparkRooms/$id');
    final result = await reference.runTransaction((value) {
      // Realtime Database may first invoke the handler with the local cache,
      // before the server value has arrived. Returning abort for that initial
      // null prevents the SDK from fetching the actual invite room, so the
      // joining player always sees a false "not found/full" result. A
      // successful null proposal makes the SDK reconcile against the server;
      // an existing room is retried with its authoritative map, while a truly
      // missing room still resolves to the not-found path below.
      if (value == null) return Transaction.success(null);
      if (value is! Map) return Transaction.abort();
      final current = Map<String, Object?>.from(value);
      final status = current['status'];
      final hostUid = current['hostUid'];
      final guestUid = _nullableString(current['guestUid']);
      if (hostUid == uid && guestUid == null && status == 'waiting') {
        return Transaction.success(current);
      }
      if (status != 'waiting' || guestUid != null || hostUid == uid) {
        return Transaction.abort();
      }
      current['guestUid'] = uid;
      current['status'] = 'active';
      current['updatedAt'] = ServerValue.timestamp;
      return Transaction.success(current);
    }, applyLocally: false);
    if (!result.committed || result.snapshot.value is! Map) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.notFound,
        debugMessage: 'spark-room-unavailable-or-full',
      );
    }
    return OnlineRoom.fromMap(
      id,
      Map<Object?, Object?>.from(result.snapshot.value as Map),
      uid,
    );
  }

  Stream<OnlineRoom?> watchRoom(String roomId) async* {
    final id = roomId.trim();
    if (!_isRoomCode(id)) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.invalidRequest,
        debugMessage: 'spark-room-code-invalid',
      );
    }
    final uid = await _readyUid();
    yield* _database.ref('sparkRooms/$id').onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null) return null;
      if (value is! Map) {
        throw const FirebaseServiceException(
          FirebaseServiceErrorCode.dataIntegrity,
          debugMessage: 'spark-room-payload-invalid',
        );
      }
      return OnlineRoom.fromMap(id, Map<Object?, Object?>.from(value), uid);
    });
  }

  Future<OnlineRoom> submitMove({
    required String roomId,
    required int expectedRevision,
    required OnlineMoveCommand command,
  }) async {
    final id = roomId.trim();
    if (!_isRoomCode(id) || expectedRevision < 0) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.invalidRequest,
        debugMessage: 'spark-room-move-request-invalid',
      );
    }
    final uid = await _readyUid();
    final reference = _database.ref('sparkRooms/$id');
    Object? rejection;
    final result = await reference.runTransaction((value) {
      rejection = null;
      if (value is! Map) {
        rejection = FirebaseServiceErrorCode.notFound;
        return Transaction.abort();
      }
      try {
        final current = Map<String, Object?>.from(value);
        final room = OnlineRoom.fromMap(
          id,
          Map<Object?, Object?>.from(value),
          uid,
        );
        if (room.status != OnlineRoomStatus.active) {
          rejection = FirebaseServiceErrorCode.failedPrecondition;
          return Transaction.abort();
        }
        if (room.localSide == null) {
          rejection = FirebaseServiceErrorCode.permissionDenied;
          return Transaction.abort();
        }
        if (current['turnUid'] != uid) {
          rejection = FirebaseServiceErrorCode.failedPrecondition;
          return Transaction.abort();
        }
        if (room.revision != expectedRevision) {
          rejection = FirebaseServiceErrorCode.conflict;
          return Transaction.abort();
        }

        final definition = GameCatalog.byId(room.gameId);
        final nextState = _applyCommand(definition, room.state, command);
        final nextTurnUid = room.uidFor(nextState.turn);
        if (nextTurnUid == null) {
          rejection = FirebaseServiceErrorCode.failedPrecondition;
          return Transaction.abort();
        }
        current
          ..['state'] = _encodeState(nextState)
          ..['revision'] = room.revision + 1
          ..['turnUid'] = nextTurnUid
          ..['lastMoveBy'] = uid
          ..['lastFrom'] = command.from ?? -1
          ..['lastTo'] = command.to
          ..['status'] =
              nextState.phase == MatchPhase.finished ? 'completed' : 'active'
          ..['updatedAt'] = ServerValue.timestamp;
        return Transaction.success(current);
      } on InvalidMove {
        rejection = FirebaseServiceErrorCode.invalidRequest;
        return Transaction.abort();
      } on FirebaseServiceException catch (error) {
        rejection = error.code;
        return Transaction.abort();
      } catch (_) {
        rejection = FirebaseServiceErrorCode.dataIntegrity;
        return Transaction.abort();
      }
    }, applyLocally: false);

    if (!result.committed || result.snapshot.value is! Map) {
      final code =
          rejection is FirebaseServiceErrorCode
              ? rejection as FirebaseServiceErrorCode
              : FirebaseServiceErrorCode.conflict;
      throw FirebaseServiceException(
        code,
        debugMessage: 'spark-room-move-rejected',
      );
    }
    return OnlineRoom.fromMap(
      id,
      Map<Object?, Object?>.from(result.snapshot.value as Map),
      uid,
    );
  }

  Future<void> resignRoom({
    required String roomId,
    required int expectedRevision,
  }) async {
    final id = roomId.trim();
    if (!_isRoomCode(id)) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.invalidRequest,
        debugMessage: 'spark-room-code-invalid',
      );
    }
    final uid = await _readyUid();
    final reference = _database.ref('sparkRooms/$id');
    final snapshot = await reference.get();
    final value = snapshot.value;
    if (value is! Map) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.notFound,
        debugMessage: 'spark-room-not-found',
      );
    }
    final room = OnlineRoom.fromMap(id, Map<Object?, Object?>.from(value), uid);
    if (room.status != OnlineRoomStatus.active || room.localSide == null) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.failedPrecondition,
        debugMessage: 'spark-room-cannot-resign',
      );
    }
    if (room.revision != expectedRevision) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.conflict,
        debugMessage: 'spark-room-revision-changed',
      );
    }
    await reference.child('resignedBy').set(uid);
    await reference.child('forfeitReason').set('resign');
    await reference.child('status').set('completed');
  }

  /// Claims the opponent's turn after the inactivity window has elapsed.
  /// The child writes are guarded by RTDB rules against the current turn and
  /// server timestamp, so a move that arrives first makes the claim fail.
  Future<void> claimTimeout({
    required String roomId,
    required int expectedRevision,
  }) async {
    final id = roomId.trim();
    if (!_isRoomCode(id)) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.invalidRequest,
        debugMessage: 'spark-room-code-invalid',
      );
    }
    final uid = await _readyUid();
    final reference = _database.ref('sparkRooms/$id');
    final snapshot = await reference.get();
    final value = snapshot.value;
    if (value is! Map) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.notFound,
        debugMessage: 'spark-room-not-found',
      );
    }
    final room = OnlineRoom.fromMap(id, Map<Object?, Object?>.from(value), uid);
    final localSide = room.localSide;
    if (room.status != OnlineRoomStatus.active ||
        localSide == null ||
        room.state.turn == localSide ||
        room.revision != expectedRevision ||
        DateTime.now().millisecondsSinceEpoch - room.updatedAt <
            turnTimeout.inMilliseconds) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.failedPrecondition,
        debugMessage: 'spark-room-timeout-not-ready',
      );
    }
    final timedOutUid = room.uidFor(room.state.turn);
    if (timedOutUid == null) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
        debugMessage: 'spark-room-turn-owner-missing',
      );
    }
    await reference.child('resignedBy').set(timedOutUid);
    await reference.child('forfeitReason').set('timeout');
    await reference.child('status').set('completed');
  }

  Future<void> confirmMatch(String roomId) async {
    final id = roomId.trim();
    if (!_isRoomCode(id)) return;
    final uid = await _readyUid();
    final reference = _database.ref('sparkRooms/$id');
    await reference.runTransaction((value) {
      if (value is! Map) return Transaction.abort();
      final current = Map<String, Object?>.from(value);
      if (current['hostUid'] != uid) return Transaction.abort();
      current['hostReady'] = true;
      current['status'] = 'active';
      current['updatedAt'] = ServerValue.timestamp;
      return Transaction.success(current);
    }, applyLocally: false);
  }

  Future<void> closeRoom(String roomId) async {
    final id = roomId.trim();
    if (!_isRoomCode(id)) return;
    final uid = await _readyUid();
    final reference = _database.ref('sparkRooms/$id');
    final result = await reference.runTransaction((value) {
      if (value is! Map) return Transaction.abort();
      final current = Map<String, Object?>.from(value);
      if (current['hostUid'] != uid) {
        return Transaction.abort();
      }
      return Transaction.success(null);
    }, applyLocally: false);
    if (!result.committed) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.failedPrecondition,
        debugMessage: 'spark-room-cannot-close',
      );
    }
  }

  Future<String> _readyUid() async {
    final identity = await _auth.ensureSignedIn();
    // Firebase App Check is activated during bootstrap and the SDK attaches a
    // token to database requests when available. RTDB enforcement is currently
    // off until Play Integrity is verified, so a local token-readiness check
    // must not block Spark rooms on devices where attestation cannot complete.
    return identity.uid;
  }

  static bool _isRoomCode(String value) =>
      RegExp(r'^[A-Za-z0-9_-]{20}$').hasMatch(value);
}

MorrisGameState _applyCommand(
  MorrisGameDefinition definition,
  MorrisGameState state,
  OnlineMoveCommand command,
) => switch (command.kind) {
  'place' when command.from == null => MorrisEngine.place(
    definition,
    state,
    command.to,
  ),
  'move' when command.from != null => MorrisEngine.move(
    definition,
    state,
    from: command.from!,
    to: command.to,
  ),
  'capture' when command.from == null => MorrisEngine.capture(
    definition,
    state,
    command.to,
  ),
  _ => throw const InvalidMove(MoveErrorCode.invalidPoint),
};

Map<String, Object?> _encodeState(MorrisGameState state) => <String, Object?>{
  'board': state.board
      .map(
        (side) => switch (side) {
          null => 0,
          PlayerSide.light => 1,
          PlayerSide.dark => 2,
        },
      )
      .toList(growable: false),
  'turn': state.turn.name,
  'lightToPlace': state.lightToPlace,
  'darkToPlace': state.darkToPlace,
  'pendingCaptureBy': state.pendingCaptureBy?.name ?? '',
  'winner': state.winner?.name ?? '',
  'isDraw': state.isDraw,
  'movesWithoutCapture': state.movesWithoutCapture,
};

MorrisGameState _decodeState(Map<Object?, Object?> source) {
  final rawBoard = source['board'];
  if (rawBoard is! List) {
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'spark-room-board-missing',
    );
  }
  return MorrisGameState(
    board: rawBoard
        .map<PlayerSide?>(
          (value) => switch (value) {
            0 || null => null,
            1 => PlayerSide.light,
            2 => PlayerSide.dark,
            _ =>
              throw const FirebaseServiceException(
                FirebaseServiceErrorCode.dataIntegrity,
                debugMessage: 'spark-room-board-cell-invalid',
              ),
          },
        )
        .toList(growable: false),
    turn: _side(source['turn']),
    lightToPlace: _nonNegativeInt(source['lightToPlace']),
    darkToPlace: _nonNegativeInt(source['darkToPlace']),
    pendingCaptureBy: _nullableSide(source['pendingCaptureBy']),
    winner: _nullableSide(source['winner']),
    isDraw: source['isDraw'] == true,
    movesWithoutCapture: _nonNegativeInt(source['movesWithoutCapture']),
  );
}

MorrisGameId _gameId(Object? value) => switch (value) {
  'three' => MorrisGameId.three,
  'nine' => MorrisGameId.nine,
  'twelve' => MorrisGameId.twelve,
  _ =>
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'spark-room-game-invalid',
    ),
};

OnlineRoomStatus _roomStatus(Object? value) => switch (value) {
  'waiting' => OnlineRoomStatus.waiting,
  'active' => OnlineRoomStatus.active,
  'completed' => OnlineRoomStatus.completed,
  _ =>
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'spark-room-status-invalid',
    ),
};

PlayerSide _side(Object? value) => switch (value) {
  'light' => PlayerSide.light,
  'dark' => PlayerSide.dark,
  _ =>
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'spark-room-turn-invalid',
    ),
};

PlayerSide? _nullableSide(Object? value) => switch (value) {
  null || '' => null,
  'light' => PlayerSide.light,
  'dark' => PlayerSide.dark,
  _ =>
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'spark-room-side-invalid',
    ),
};

String _requiredString(Object? value) {
  final result = _nullableString(value);
  if (result == null) {
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'spark-room-required-id-missing',
    );
  }
  return result;
}

String? _nullableString(Object? value) {
  final result = value is String ? value.trim() : '';
  return result.isEmpty ? null : result;
}

int _nonNegativeInt(Object? value) {
  final result = _nullableInt(value);
  if (result == null || result < 0) {
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'spark-room-integer-invalid',
    );
  }
  return result;
}

int? _nullableInt(Object? value) {
  if (value is int) return value;
  if (value is num && value.isFinite && value == value.roundToDouble()) {
    return value.toInt();
  }
  return null;
}
