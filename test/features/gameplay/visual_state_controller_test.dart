import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/feedback/app_feedback_service.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/core/match/match_models.dart';
import 'package:nine_tas/core/storage/match_session_repository.dart';
import 'package:nine_tas/features/gameplay/application/match_session_controller.dart';

void main() {
  test('placement exposes every legal empty target and stores last move trace', () async {
    final repo = _MemoryRepo();
    final controller = MatchSessionController(
      config: const MatchConfig(
        sessionId: 'visual-placement',
        gameId: MorrisGameId.nine,
        mode: MatchMode.localTwoPlayer,
      ),
      repository: repo,
      feedback: _NoopFeedback(),
    );
    await controller.initialize();
    expect(controller.legalTargets.length, 24);
    await controller.tapPoint(0);
    expect(controller.lastMoveTo, 0);
    expect(controller.session?.moveCount, 1);
    controller.dispose();
  });
}

class _MemoryRepo implements MatchSessionRepository {
  final data = <String, MatchSession>{};
  @override
  Future<void> delete(String sessionId) async {
    data.remove(sessionId);
  }
  @override
  Future<MatchSession?> getById(String sessionId) async => data[sessionId];
  @override
  Future<MatchSession?> getMostRecentActive() async => null;
  @override
  Future<MatchSession?> getMostRecentActiveForGame(MorrisGameId gameId) async => null;
  @override
  Future<void> save(MatchSession session) async => data[session.config.sessionId] = session;
}

class _NoopFeedback implements GameFeedback {
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
