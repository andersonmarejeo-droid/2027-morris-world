import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../game/game_definition.dart';
import '../match/match_models.dart';
import 'match_session_repository.dart';

class SqfliteMatchSessionRepository implements MatchSessionRepository {
  Database? _database;
  Future<Database>? _opening;

  Future<Database> get _db async {
    final ready = _database;
    if (ready != null) return ready;

    final opening = _opening;
    if (opening != null) return opening;

    final future = _openDatabase();
    _opening = future;
    try {
      final database = await future;
      _database = database;
      return database;
    } finally {
      _opening = null;
    }
  }

  Future<Database> _openDatabase() async {
    final root = await getDatabasesPath();
    final path = '$root${Platform.pathSeparator}morris_world.db';
    return openDatabase(
      path,
      version: 1,
      singleInstance: true,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE match_sessions(
            session_id TEXT PRIMARY KEY,
            game_id TEXT NOT NULL,
            mode TEXT NOT NULL,
            difficulty TEXT,
            status TEXT NOT NULL,
            updated_at INTEGER NOT NULL,
            state_json TEXT NOT NULL
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_match_sessions_active ON match_sessions(status, updated_at)',
        );
      },
    );
  }

  @override
  Future<MatchSession?> getById(String sessionId) async {
    final rows = await (await _db).query(
      'match_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      limit: 1,
    );
    return rows.isEmpty ? null : MatchSession.fromDatabaseMap(rows.first);
  }

  @override
  Future<MatchSession?> getMostRecentActive() async {
    final rows = await (await _db).query(
      'match_sessions',
      where: 'status = ?',
      whereArgs: [MatchSessionStatus.active.name],
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : MatchSession.fromDatabaseMap(rows.first);
  }

  @override
  Future<MatchSession?> getMostRecentActiveForGame(MorrisGameId gameId) async {
    final rows = await (await _db).query(
      'match_sessions',
      where: 'status = ? AND game_id = ?',
      whereArgs: [MatchSessionStatus.active.name, gameId.name],
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : MatchSession.fromDatabaseMap(rows.first);
  }

  @override
  Future<void> save(MatchSession session) async {
    await (await _db).insert(
      'match_sessions',
      session.toDatabaseMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> delete(String sessionId) async {
    await (await _db).delete(
      'match_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }
}
