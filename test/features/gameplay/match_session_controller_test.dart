import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/ai/morris_ai.dart';
import 'package:nine_tas/core/feedback/app_feedback_service.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/match/match_models.dart';
import 'package:nine_tas/core/storage/match_session_repository.dart';
import 'package:nine_tas/features/gameplay/application/match_session_controller.dart';

void main() {
  test('fresh match becomes playable without waiting for storage', () async {
    final repository = _MemoryMatchSessionRepository()..failReads = true;
    final controller = MatchSessionController(
      config: const MatchConfig(
        sessionId: 'fresh-fast-start',
        gameId: MorrisGameId.nine,
        mode: MatchMode.offlineAi,
        difficulty: AiDifficulty.easy,
      ),
      repository: repository,
      feedback: _NoopGameFeedback(),
      ai: MorrisAiEngine(seed: 2),
      aiThinkDelay: Duration.zero,
      aiCapturePause: Duration.zero,
    );

    await controller.initialize(createNew: true);

    expect(repository.readCount, 0);
    expect(controller.loading, isFalse);
    expect(controller.loadError, isNull);
    expect(controller.game, isNotNull);
    expect(controller.humanCanAct, isTrue);
    controller.dispose();
  });

  test('a failed save does not poison later match saves', () async {
    final repository = _MemoryMatchSessionRepository();
    final controller = MatchSessionController(
      config: const MatchConfig(
        sessionId: 'queue-test',
        gameId: MorrisGameId.three,
        mode: MatchMode.localTwoPlayer,
      ),
      repository: repository,
      feedback: _NoopGameFeedback(),
    );

    await controller.initialize();
    expect(controller.loadError, isNull);

    repository.failNextSave = true;
    await controller.tapPoint(0);
    expect(controller.saveError, isNotNull);

    await controller.tapPoint(3);
    expect(controller.saveError, isNull);
    expect(repository.stored['queue-test']?.state.board[0], isNotNull);
    expect(repository.stored['queue-test']?.state.board[3], isNotNull);

    controller.dispose();
  });

  test(
    'offline AI answers the human move using the shared Morris engine',
    () async {
      final repository = _MemoryMatchSessionRepository();
      final feedback = _NoopGameFeedback();
      final controller = MatchSessionController(
        config: const MatchConfig(
          sessionId: 'ai-response-test',
          gameId: MorrisGameId.nine,
          mode: MatchMode.offlineAi,
          difficulty: AiDifficulty.medium,
        ),
        repository: repository,
        feedback: feedback,
        ai: MorrisAiEngine(seed: 3),
        aiThinkDelay: Duration.zero,
        aiCapturePause: Duration.zero,
      );

      await controller.initialize();
      await controller.tapPoint(0);

      final state = controller.game!;
      expect(state.stonesOnBoard(PlayerSide.light), 1);
      expect(state.stonesOnBoard(PlayerSide.dark), 1);
      expect(state.turn, PlayerSide.light);
      expect(controller.aiThinking, isFalse);
      controller.dispose();
    },
  );

  test('abandon is persisted as the last queued snapshot', () async {
    final repository = _MemoryMatchSessionRepository();
    final controller = MatchSessionController(
      config: const MatchConfig(
        sessionId: 'abandon-test',
        gameId: MorrisGameId.nine,
        mode: MatchMode.localTwoPlayer,
      ),
      repository: repository,
      feedback: _NoopGameFeedback(),
    );

    await controller.initialize();
    await controller.tapPoint(0);
    await controller.abandon();

    expect(
      repository.stored['abandon-test']?.status,
      MatchSessionStatus.abandoned,
    );
    controller.dispose();
  });

  test('accepted draw offer is completed and persisted as a draw', () async {
    final repository = _MemoryMatchSessionRepository();
    final controller = MatchSessionController(
      config: const MatchConfig(
        sessionId: 'accepted-draw-test',
        gameId: MorrisGameId.nine,
        mode: MatchMode.localTwoPlayer,
      ),
      repository: repository,
      feedback: _NoopGameFeedback(),
    );

    await controller.initialize(createNew: true);
    await controller.agreeToDraw();

    expect(controller.session?.status, MatchSessionStatus.completed);
    expect(controller.game?.isDraw, isTrue);
    expect(controller.game?.phase, MatchPhase.finished);
    expect(repository.stored['accepted-draw-test']?.state.isDraw, isTrue);
    controller.dispose();
  });

  test(
    'resigning an AI match awards the win to the computer and persists it',
    () async {
      final repository = _MemoryMatchSessionRepository();
      final controller = MatchSessionController(
        config: const MatchConfig(
          sessionId: 'resign-ai-test',
          gameId: MorrisGameId.nine,
          mode: MatchMode.offlineAi,
          difficulty: AiDifficulty.easy,
        ),
        repository: repository,
        feedback: _NoopGameFeedback(),
        ai: MorrisAiEngine(seed: 5),
        aiThinkDelay: const Duration(seconds: 1),
      );

      await controller.initialize(createNew: true);
      await controller.resign();

      expect(controller.session?.status, MatchSessionStatus.completed);
      expect(controller.game?.winner, PlayerSide.dark);
      expect(controller.game?.phase, MatchPhase.finished);
      expect(
        repository.stored['resign-ai-test']?.state.winner,
        PlayerSide.dark,
      );
      controller.dispose();
    },
  );

  test('resigning a local game forfeits the side whose turn it is', () async {
    final repository = _MemoryMatchSessionRepository();
    final controller = MatchSessionController(
      config: const MatchConfig(
        sessionId: 'resign-local-test',
        gameId: MorrisGameId.three,
        mode: MatchMode.localTwoPlayer,
      ),
      repository: repository,
      feedback: _NoopGameFeedback(),
    );

    await controller.initialize(createNew: true);
    await controller.tapPoint(0);
    expect(controller.game?.turn, PlayerSide.dark);
    await controller.resign();

    expect(controller.game?.winner, PlayerSide.light);
    controller.dispose();
  });
}

class _MemoryMatchSessionRepository implements MatchSessionRepository {
  final Map<String, MatchSession> stored = {};
  bool failNextSave = false;
  bool failReads = false;
  int readCount = 0;

  @override
  Future<void> delete(String sessionId) async {
    stored.remove(sessionId);
  }

  @override
  Future<void> deleteAll() async => stored.clear();

  @override
  Future<MatchSession?> getById(String sessionId) async {
    readCount++;
    if (failReads) throw StateError('simulated read failure');
    return stored[sessionId];
  }

  @override
  Future<MatchSession?> getMostRecentActive() async {
    final active = _active();
    return active.isEmpty ? null : active.first;
  }

  @override
  Future<MatchSession?> getMostRecentActiveForGame(MorrisGameId gameId) async {
    final active =
        _active().where((session) => session.config.gameId == gameId).toList();
    return active.isEmpty ? null : active.first;
  }

  List<MatchSession> _active() {
    final result =
        stored.values
            .where((session) => session.status == MatchSessionStatus.active)
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return result;
  }

  @override
  Future<void> save(MatchSession session) async {
    if (failNextSave) {
      failNextSave = false;
      throw StateError('simulated save failure');
    }
    stored[session.config.sessionId] = session;
  }
}

class _NoopGameFeedback implements GameFeedback {
  @override
  Future<void> buttonPressed() async {}

  @override
  Future<void> millFormed() async {}

  @override
  Future<void> pieceCaptured() async {}

  @override
  Future<void> pieceMoved() async {}

  @override
  Future<void> piecePlaced() async {}

  @override
  Future<void> pieceSelected() async {}

  @override
  Future<void> success() async {}
}
