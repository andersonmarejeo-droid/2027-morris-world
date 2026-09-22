import 'dart:convert';

import '../game/game_definition.dart';
import '../game/game_models.dart';

enum MatchMode { offlineAi, localTwoPlayer, onlineRanked, challenge }
enum AiDifficulty { beginner, easy, medium, hard, master }
enum MatchSessionStatus { active, completed, abandoned }

class MatchConfig {
  const MatchConfig({
    required this.sessionId,
    required this.gameId,
    required this.mode,
    this.difficulty,
  });

  final String sessionId;
  final MorrisGameId gameId;
  final MatchMode mode;
  final AiDifficulty? difficulty;
}

class MatchVisualTrace {
  const MatchVisualTrace({
    required this.actor,
    required this.to,
    this.from,
    this.capturedPoint,
    this.millPoints = const <int>[],
  });

  final PlayerSide actor;
  final int? from;
  final int to;
  final int? capturedPoint;
  final List<int> millPoints;

  MatchVisualTrace copyWith({
    int? capturedPoint,
    bool clearCapturedPoint = false,
  }) => MatchVisualTrace(
        actor: actor,
        from: from,
        to: to,
        capturedPoint: clearCapturedPoint ? null : (capturedPoint ?? this.capturedPoint),
        millPoints: millPoints,
      );

  Map<String, Object?> toJson() => {
        'actor': actor.name,
        'from': from,
        'to': to,
        'capturedPoint': capturedPoint,
        'millPoints': millPoints,
      };

  factory MatchVisualTrace.fromJson(Map<String, dynamic> json) => MatchVisualTrace(
        actor: _enumByName(PlayerSide.values, json['actor']! as String),
        from: json['from'] as int?,
        to: json['to']! as int,
        capturedPoint: json['capturedPoint'] as int?,
        millPoints: (json['millPoints'] as List<dynamic>? ?? const <dynamic>[])
            .map((value) => value as int)
            .toList(growable: false),
      );
}

class MatchSession {
  const MatchSession({
    required this.config,
    required this.state,
    required this.status,
    required this.updatedAt,
    this.visualTrace,
    this.moveCount = 0,
  });

  final MatchConfig config;
  final MorrisGameState state;
  final MatchSessionStatus status;
  final DateTime updatedAt;
  final MatchVisualTrace? visualTrace;
  final int moveCount;

  MatchSession copyWith({
    MorrisGameState? state,
    MatchSessionStatus? status,
    DateTime? updatedAt,
    MatchVisualTrace? visualTrace,
    bool clearVisualTrace = false,
    int? moveCount,
  }) => MatchSession(
        config: config,
        state: state ?? this.state,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
        visualTrace: clearVisualTrace ? null : (visualTrace ?? this.visualTrace),
        moveCount: moveCount ?? this.moveCount,
      );

  Map<String, Object?> toDatabaseMap() => {
        'session_id': config.sessionId,
        'game_id': config.gameId.name,
        'mode': config.mode.name,
        'difficulty': config.difficulty?.name,
        'status': status.name,
        'updated_at': updatedAt.millisecondsSinceEpoch,
        'state_json': jsonEncode(_snapshotToJson(this)),
      };

  factory MatchSession.fromDatabaseMap(Map<String, Object?> map) {
    final json = jsonDecode(map['state_json']! as String) as Map<String, dynamic>;
    return MatchSession(
      config: MatchConfig(
        sessionId: map['session_id']! as String,
        gameId: _enumByName(MorrisGameId.values, map['game_id']! as String),
        mode: _enumByName(MatchMode.values, map['mode']! as String),
        difficulty: (map['difficulty'] as String?) == null
            ? null
            : _enumByName(AiDifficulty.values, map['difficulty']! as String),
      ),
      state: _stateFromJson(json),
      status: _enumByName(MatchSessionStatus.values, map['status']! as String),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']! as int),
      visualTrace: json['visualTrace'] is Map<String, dynamic>
          ? MatchVisualTrace.fromJson(json['visualTrace'] as Map<String, dynamic>)
          : null,
      moveCount: json['moveCount'] as int? ?? 0,
    );
  }
}

Map<String, Object?> _snapshotToJson(MatchSession session) => {
      ..._stateToJson(session.state),
      'visualTrace': session.visualTrace?.toJson(),
      'moveCount': session.moveCount,
    };

Map<String, Object?> _stateToJson(MorrisGameState state) => {
      'board': state.board.map((value) => switch (value) {
            null => 0,
            PlayerSide.light => 1,
            PlayerSide.dark => 2,
          }).toList(),
      'turn': state.turn.name,
      'lightToPlace': state.lightToPlace,
      'darkToPlace': state.darkToPlace,
      'pendingCaptureBy': state.pendingCaptureBy?.name,
      'winner': state.winner?.name,
      'isDraw': state.isDraw,
    };

MorrisGameState _stateFromJson(Map<String, dynamic> json) => MorrisGameState(
      board: (json['board'] as List<dynamic>).map<PlayerSide?>((value) => switch (value as int) {
            0 => null,
            1 => PlayerSide.light,
            2 => PlayerSide.dark,
            _ => throw FormatException('Invalid board cell: $value'),
          }).toList(),
      turn: _enumByName(PlayerSide.values, json['turn']! as String),
      lightToPlace: json['lightToPlace']! as int,
      darkToPlace: json['darkToPlace']! as int,
      pendingCaptureBy: json['pendingCaptureBy'] == null
          ? null
          : _enumByName(PlayerSide.values, json['pendingCaptureBy']! as String),
      winner: json['winner'] == null
          ? null
          : _enumByName(PlayerSide.values, json['winner']! as String),
      isDraw: json['isDraw']! as bool,
    );

T _enumByName<T extends Enum>(List<T> values, String name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  throw FormatException('Unknown enum value: $name');
}

abstract final class MatchIds {
  static String create() => 'm_${DateTime.now().microsecondsSinceEpoch}';
}
