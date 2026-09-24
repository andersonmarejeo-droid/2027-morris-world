import 'package:firebase_database/firebase_database.dart';

import '../firebase/firebase_app_check_service.dart';
import '../firebase/firebase_auth_session.dart';
import '../firebase/firebase_callable_client.dart';
import '../firebase/firebase_service_exception.dart';
import '../game/game_definition.dart';
import 'quick_message.dart';

enum OnlineSide { light, dark }

enum OnlineMatchStatus { inProgress, completed }

class OnlineMoveCommand {
  const OnlineMoveCommand.place(this.to) : kind = 'place', from = null;

  const OnlineMoveCommand.move({required this.from, required this.to})
    : kind = 'move';

  const OnlineMoveCommand.capture(this.to) : kind = 'capture', from = null;

  final String kind;
  final int? from;
  final int to;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'kind': kind,
    if (from != null) 'from': from,
    'to': to,
  };
}

class OnlineMorrisState {
  const OnlineMorrisState({
    required this.board,
    required this.turn,
    required this.lightToPlace,
    required this.darkToPlace,
    required this.pendingCaptureBy,
    required this.winner,
    required this.isDraw,
  });

  final List<OnlineSide?> board;
  final OnlineSide turn;
  final int lightToPlace;
  final int darkToPlace;
  final OnlineSide? pendingCaptureBy;
  final OnlineSide? winner;
  final bool isDraw;

  factory OnlineMorrisState.fromMap(Map<Object?, Object?> source) {
    final boardRaw = source['board'];
    if (boardRaw is! List) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
        debugMessage: 'live-match-state-board-missing',
      );
    }
    return OnlineMorrisState(
      board: boardRaw.map(_boardCell).toList(growable: false),
      turn: _requiredSide(source['turn']),
      lightToPlace: _requiredInt(source['lightToPlace']),
      darkToPlace: _requiredInt(source['darkToPlace']),
      pendingCaptureBy: _nullableSide(source['pendingCaptureBy']),
      winner: _nullableSide(source['winner']),
      isDraw: source['isDraw'] == true,
    );
  }
}

class OnlineLiveMatch {
  const OnlineLiveMatch({
    required this.id,
    required this.gameId,
    required this.status,
    required this.players,
    required this.sides,
    required this.state,
    required this.revision,
    this.challengeId,
  });

  final String id;
  final MorrisGameId gameId;
  final OnlineMatchStatus status;
  final Set<String> players;
  final Map<OnlineSide, String> sides;
  final OnlineMorrisState state;
  final int revision;
  final String? challengeId;

  factory OnlineLiveMatch.fromMap(String id, Map<Object?, Object?> source) {
    final rawPlayers = source['players'];
    final rawSides = source['sides'];
    final rawState = source['state'];
    if (rawPlayers is! Map || rawSides is! Map || rawState is! Map) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
        debugMessage: 'live-match-required-fields-missing',
      );
    }
    final players = <String>{
      for (final entry in rawPlayers.entries)
        if (entry.key is String && entry.value == true) entry.key as String,
    };
    final sides = <OnlineSide, String>{
      OnlineSide.light: _requiredString(rawSides['light']),
      OnlineSide.dark: _requiredString(rawSides['dark']),
    };
    return OnlineLiveMatch(
      id: id,
      gameId: _gameId(source['gameId']),
      status: _status(source['status']),
      players: Set.unmodifiable(players),
      sides: Map.unmodifiable(sides),
      state: OnlineMorrisState.fromMap(Map<Object?, Object?>.from(rawState)),
      revision: _requiredInt(source['revision']),
      challengeId: _nullableString(source['challengeId']),
    );
  }
}

class OnlineChallengeStart {
  const OnlineChallengeStart({required this.challengeId, this.matchId});

  final String challengeId;
  final String? matchId;
}

class OnlineMoveResult {
  const OnlineMoveResult({
    required this.revision,
    required this.status,
    required this.state,
    required this.finalization,
  });

  final int revision;
  final OnlineMatchStatus status;
  final OnlineMorrisState state;
  final String finalization;
}

/// Firebase-backed, server-authoritative online match client.
///
/// The client never writes `liveMatches` directly. It subscribes to the RTDB
/// state and sends changes through callable Functions, which enforce player,
/// side, turn, revision and Morris-rule validation on the server.
class FirebaseMatchClient {
  factory FirebaseMatchClient({
    FirebaseDatabase? database,
    FirebaseCallableClient? callables,
    FirebaseAuthSession? auth,
    FirebaseAppCheckService? appCheck,
  }) {
    final resolvedAuth = auth ?? FirebaseAuthSession();
    final resolvedAppCheck = appCheck ?? FirebaseAppCheckService();
    return FirebaseMatchClient._(
      database: database ?? FirebaseDatabase.instance,
      auth: resolvedAuth,
      appCheck: resolvedAppCheck,
      callables:
          callables ??
          FirebaseCallableClient(
            auth: resolvedAuth,
            appCheck: resolvedAppCheck,
          ),
    );
  }

  FirebaseMatchClient._({
    required FirebaseDatabase database,
    required FirebaseCallableClient callables,
    required FirebaseAuthSession auth,
    required FirebaseAppCheckService appCheck,
  }) : _database = database,
       _callables = callables,
       _auth = auth,
       _appCheck = appCheck;

  final FirebaseDatabase _database;
  final FirebaseCallableClient _callables;
  final FirebaseAuthSession _auth;
  final FirebaseAppCheckService _appCheck;

  Future<OnlineChallengeStart> createChallenge({
    required String receiverId,
    required MorrisGameId gameId,
  }) async {
    final response = await _callables.call(
      'createChallenge',
      data: <String, dynamic>{'receiverId': receiverId, 'gameId': gameId.name},
    );
    return OnlineChallengeStart(
      challengeId: _requiredString(response['challengeId']),
    );
  }

  Future<OnlineChallengeStart> respondToChallenge({
    required String challengeId,
    required bool accept,
  }) async {
    final response = await _callables.call(
      'respondToChallenge',
      data: <String, dynamic>{
        'challengeId': challengeId,
        'action': accept ? 'accepted' : 'declined',
      },
    );
    return OnlineChallengeStart(
      challengeId: challengeId,
      matchId: _nullableString(response['matchId']),
    );
  }

  Future<OnlineChallengeStart> createRematch(String challengeId) async {
    final response = await _callables.call(
      'createRematch',
      data: <String, dynamic>{'challengeId': challengeId},
    );
    return OnlineChallengeStart(
      challengeId: _requiredString(response['challengeId']),
    );
  }

  Future<OnlineMoveResult> submitMove({
    required String matchId,
    required int expectedRevision,
    required OnlineMoveCommand command,
  }) async {
    final response = await _callables.call(
      'submitMove',
      data: <String, dynamic>{
        'matchId': matchId,
        'expectedRevision': expectedRevision,
        'command': command.toJson(),
      },
    );
    final rawState = response['state'];
    if (rawState is! Map) {
      throw const FirebaseServiceException(
        FirebaseServiceErrorCode.dataIntegrity,
        debugMessage: 'submit-move-state-missing',
      );
    }
    return OnlineMoveResult(
      revision: _requiredInt(response['revision']),
      status: _status(response['status']),
      state: OnlineMorrisState.fromMap(Map<Object?, Object?>.from(rawState)),
      finalization: _nullableString(response['finalization']) ?? 'not-required',
    );
  }

  Future<void> sendQuickMessage({
    required String matchId,
    required QuickMessageId messageId,
  }) async {
    await _callables.call(
      'sendQuickMessage',
      data: <String, dynamic>{
        'matchId': matchId,
        'messageId': messageId.wireId,
      },
    );
  }

  /// Retries the idempotent server-side Firestore finalization for a completed
  /// match. This is intentionally separate from normal move submission so a
  /// player never has to replay a move after a transient cross-database error.
  Future<bool> reconcileCompletedMatch(String matchId) async {
    final response = await _callables.call(
      'reconcileCompletedMatch',
      data: <String, dynamic>{'matchId': matchId},
    );
    return response['finalization'] == 'completed';
  }

  Stream<OnlineLiveMatch?> watchMatch(String matchId) async* {
    await _auth.ensureSignedIn();
    await _appCheck.ensureUsableToken();
    final reference = _database.ref('liveMatches/$matchId');
    yield* reference.onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw == null) return null;
      if (raw is! Map) {
        throw const FirebaseServiceException(
          FirebaseServiceErrorCode.dataIntegrity,
          debugMessage: 'live-match-payload-is-not-a-map',
        );
      }
      return OnlineLiveMatch.fromMap(matchId, Map<Object?, Object?>.from(raw));
    });
  }
}

OnlineSide _requiredSide(Object? raw) {
  final side = _nullableSide(raw);
  if (side == null) {
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'live-match-side-missing',
    );
  }
  return side;
}

OnlineSide? _nullableSide(Object? raw) => switch (raw) {
  'light' => OnlineSide.light,
  'dark' => OnlineSide.dark,
  null => null,
  _ =>
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'live-match-side-invalid',
    ),
};

// Realtime Database does not retain null array entries, so the backend stores
// empty board cells with this explicit value. Callable responses may still
// contain null, which is accepted here as well.
OnlineSide? _boardCell(Object? raw) => switch (raw) {
  'empty' => null,
  _ => _nullableSide(raw),
};

MorrisGameId _gameId(Object? raw) => switch (raw) {
  'three' => MorrisGameId.three,
  'nine' => MorrisGameId.nine,
  'twelve' => MorrisGameId.twelve,
  _ =>
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'live-match-game-invalid',
    ),
};

OnlineMatchStatus _status(Object? raw) => switch (raw) {
  'inProgress' => OnlineMatchStatus.inProgress,
  'completed' => OnlineMatchStatus.completed,
  _ =>
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'live-match-status-invalid',
    ),
};

String _requiredString(Object? raw) {
  final result = _nullableString(raw);
  if (result == null) {
    throw const FirebaseServiceException(
      FirebaseServiceErrorCode.dataIntegrity,
      debugMessage: 'required-string-missing',
    );
  }
  return result;
}

String? _nullableString(Object? raw) {
  final result = raw is String ? raw.trim() : '';
  return result.isEmpty ? null : result;
}

int _requiredInt(Object? raw) {
  if (raw is int) return raw;
  if (raw is num && raw.isFinite && raw == raw.roundToDouble()) {
    return raw.toInt();
  }
  throw const FirebaseServiceException(
    FirebaseServiceErrorCode.dataIntegrity,
    debugMessage: 'required-int-missing',
  );
}
