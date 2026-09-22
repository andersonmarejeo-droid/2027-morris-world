import 'package:flutter/foundation.dart';

import '../../../core/ai/morris_ai.dart';
import '../../../core/diagnostics/runtime_trace.dart';
import '../../../core/feedback/app_feedback_service.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';
import '../../../core/game/morris_engine.dart';
import '../../../core/game/morris_rules.dart';
import '../../../core/match/match_models.dart';
import '../../../core/storage/match_session_repository.dart';

class MatchSessionController extends ChangeNotifier {
  static const Duration _repositoryLoadTimeout = Duration(seconds: 4);

  MatchSessionController({
    required MatchConfig config,
    required MatchSessionRepository repository,
    required GameFeedback feedback,
    MorrisAiEngine? ai,
    Duration aiThinkDelay = AiTiming.thinkDelay,
    Duration aiMoveReveal = AiTiming.moveReveal,
    Duration humanMoveReveal = AiTiming.humanMoveReveal,
    Duration aiCapturePause = AiTiming.capturePause,
  }) : _config = config,
       _repository = repository,
       _feedback = feedback,
       _backgroundAi = ai == null,
       _aiSeed = _stableSeed(config.sessionId),
       _ai = ai ?? MorrisAiEngine(seed: _stableSeed(config.sessionId)),
       _aiThinkDelay = aiThinkDelay,
       _aiMoveReveal = aiMoveReveal,
       _humanMoveReveal = humanMoveReveal,
       _aiCapturePause = aiCapturePause,
       definition = GameCatalog.byId(config.gameId);

  final MatchConfig _config;
  final MatchSessionRepository _repository;
  final GameFeedback _feedback;
  final MorrisAiEngine _ai;
  final bool _backgroundAi;
  final int _aiSeed;
  final Duration _aiThinkDelay;
  final Duration _aiMoveReveal;
  final Duration _humanMoveReveal;
  final Duration _aiCapturePause;
  final MorrisGameDefinition definition;

  MatchSession? _session;
  MatchSession? get session => _session;
  MorrisGameState? get game => _session?.state;
  MatchVisualTrace? get visualTrace => _session?.visualTrace;

  PlayerSide get humanSide => PlayerSide.light;
  PlayerSide get aiSide => humanSide.opponent;

  int? selectedPoint;
  MoveErrorCode? errorCode;
  Object? loadError;
  Object? saveError;
  bool loading = true;
  bool aiThinking = false;
  bool _actionInProgress = false;
  bool _disposed = false;
  int _aiGeneration = 0;
  Future<void> _persistChain = Future<void>.value();

  bool get humanCanAct {
    final value = _session;
    if (value == null || value.status != MatchSessionStatus.active) {
      return false;
    }
    if (_config.mode != MatchMode.offlineAi) {
      return !aiThinking;
    }
    return !aiThinking && value.state.turn == humanSide;
  }

  Set<int> get legalTargets {
    final value = game;
    if (value == null || !humanCanAct) {
      return const <int>{};
    }
    if (value.pendingCaptureBy != null) {
      return MorrisRules.capturablePoints(definition, value);
    }
    if (value.phase == MatchPhase.placement) {
      return MorrisRules.legalPlacements(definition, value);
    }
    final selected = selectedPoint;
    if (selected == null) {
      return const <int>{};
    }
    return MorrisRules.legalMovesFrom(definition, value, selected);
  }

  Set<int> get capturablePoints {
    final value = game;
    if (value == null) {
      return const <int>{};
    }
    return MorrisRules.capturablePoints(definition, value);
  }

  Set<int> get activeMillPoints =>
      visualTrace?.millPoints.toSet() ?? const <int>{};
  int? get lastMoveFrom => visualTrace?.from;
  int? get lastMoveTo => visualTrace?.to;
  int? get lastCapturedPoint => visualTrace?.capturedPoint;
  PlayerSide? get lastMoveActor => visualTrace?.actor;

  Duration get visualMoveDuration {
    final trace = visualTrace;
    final actor = trace?.actor;
    if (trace?.capturedPoint != null) {
      return actor == aiSide
          ? AiTiming.aiCaptureReveal
          : AiTiming.humanCaptureReveal;
    }
    if (aiThinking && actor == aiSide) {
      return _aiMoveReveal;
    }
    return _humanMoveReveal;
  }

  Future<void> initialize({bool createNew = false}) async {
    RuntimeTrace.setPhase('controller.initialize');
    RuntimeTrace.mark(
      'controller.initialize.enter',
      data: <String, Object?>{
        'game': _config.gameId.name,
        'mode': _config.mode.name,
        'difficulty': _config.difficulty?.name,
        'fresh': createNew,
      },
    );
    loading = true;
    loadError = null;
    if (!_disposed) {
      notifyListeners();
    }

    if (createNew) {
      RuntimeTrace.setPhase('controller.initial_state');
      final initialState = RuntimeTrace.measureSync(
        'MorrisEngine.initial',
        () => MorrisEngine.initial(definition),
      );
      _session = RuntimeTrace.measureSync(
        'MatchSession.construct',
        () => MatchSession(
          config: _config,
          state: initialState,
          status: MatchSessionStatus.active,
          updatedAt: DateTime.now(),
        ),
      );
      saveError = null;
      loading = false;
      RuntimeTrace.mark('controller.session.ready');
      if (!_disposed) {
        notifyListeners();
      }
      RuntimeTrace.setPhase('controller.ai_gate');
      await _runAiIfNeeded();
      RuntimeTrace.mark('controller.initialize.done');
      return;
    }

    try {
      RuntimeTrace.setPhase('controller.repository_load');
      final existing = await RuntimeTrace.measureAsync(
        'repository.getById',
        () => _repository
            .getById(_config.sessionId)
            .timeout(_repositoryLoadTimeout),
      );
      final fallback =
          existing == null
              ? RuntimeTrace.measureSync(
                'MorrisEngine.initial.resume_fallback',
                () => MorrisEngine.initial(definition),
              )
              : null;
      _session =
          existing ??
          MatchSession(
            config: _config,
            state: fallback!,
            status: MatchSessionStatus.active,
            updatedAt: DateTime.now(),
          );
      if (existing == null) {
        await RuntimeTrace.measureAsync(
          'repository.save.initial',
          () => _repository.save(_session!),
        );
      }
      saveError = null;
    } catch (error) {
      loadError = error;
      RuntimeTrace.mark(
        'controller.initialize.error',
        data: <String, Object?>{'error': error.toString()},
      );
    } finally {
      loading = false;
      if (!_disposed) {
        notifyListeners();
      }
    }
    if (loadError == null) {
      await _runAiIfNeeded();
    }
    RuntimeTrace.mark('controller.initialize.done');
  }

  Future<void> restart() async {
    if (_actionInProgress || aiThinking) {
      return;
    }
    _cancelAi();
    _actionInProgress = true;
    try {
      _session = MatchSession(
        config: _config,
        state: MorrisEngine.initial(definition),
        status: MatchSessionStatus.active,
        updatedAt: DateTime.now(),
      );
      selectedPoint = null;
      errorCode = null;
      if (!_disposed) {
        notifyListeners();
      }
      await flush();
    } finally {
      _actionInProgress = false;
    }
    await _runAiIfNeeded();
  }

  Future<void> dragMove({required int from, required int to}) async {
    if (!humanCanAct || _actionInProgress) {
      return;
    }
    final value = game;
    if (value == null || value.phase != MatchPhase.movement) {
      return;
    }
    if (value.board[from] != value.turn) {
      return;
    }
    selectedPoint = from;
    errorCode = null;
    if (!_disposed) {
      notifyListeners();
    }
    await tapPoint(to);
  }

  Future<void> tapPoint(int point) async {
    if (_actionInProgress || !humanCanAct) {
      return;
    }
    final current = _session;
    if (current == null || current.status != MatchSessionStatus.active) {
      return;
    }
    _actionInProgress = true;
    var shouldRunAi = false;
    final game = current.state;
    try {
      MorrisGameState next;
      var millFormed = false;
      MatchVisualTrace? trace = current.visualTrace;
      if (game.pendingCaptureBy != null) {
        next = MorrisEngine.capture(definition, game, point);
        selectedPoint = null;
        trace = (trace ?? MatchVisualTrace(actor: game.turn, to: point))
            .copyWith(capturedPoint: point);
      } else if (game.phase == MatchPhase.placement) {
        next = MorrisEngine.place(definition, game, point);
        final mills = MorrisRules.millPointsAt(
          definition,
          next.board,
          point,
          game.turn,
        );
        trace = MatchVisualTrace(
          actor: game.turn,
          to: point,
          millPoints: mills.toList(growable: false),
        );
        // Pick sound starts as the reserve stone leaves the hand. The board
        // state is committed below so the single-painter travel animation can
        // begin immediately. Settle/drop feedback is emitted after the short
        // reveal window.
        await _feedback.pieceSelected();
        millFormed = mills.isNotEmpty;
      } else if (game.phase == MatchPhase.finished) {
        return;
      } else if (selectedPoint == null) {
        if (game.board[point] == game.turn) {
          selectedPoint = point;
          errorCode = null;
          if (!_disposed) {
            notifyListeners();
          }
          await _feedback.pieceSelected();
        }
        return;
      } else if (game.board[point] == game.turn) {
        selectedPoint = point;
        errorCode = null;
        if (!_disposed) {
          notifyListeners();
        }
        await _feedback.pieceSelected();
        return;
      } else {
        final from = selectedPoint!;
        next = MorrisEngine.move(definition, game, from: from, to: point);
        final mills = MorrisRules.millPointsAt(
          definition,
          next.board,
          point,
          game.turn,
        );
        trace = MatchVisualTrace(
          actor: game.turn,
          from: from,
          to: point,
          millPoints: mills.toList(growable: false),
        );
        selectedPoint = null;
        // Start the surface-specific slide sound before the visual travel.
        await _feedback.pieceMoved();
        millFormed = mills.isNotEmpty;
      }

      final finished = next.phase == MatchPhase.finished;
      _session = current.copyWith(
        state: next,
        status:
            finished ? MatchSessionStatus.completed : MatchSessionStatus.active,
        updatedAt: DateTime.now(),
        visualTrace: trace,
        moveCount: current.moveCount + (game.pendingCaptureBy == null ? 1 : 0),
      );
      errorCode = null;
      if (!_disposed) {
        notifyListeners();
      }

      // Keep the board responsive while making every physical action readable.
      if (game.pendingCaptureBy != null) {
        if (AiTiming.humanCaptureReveal > Duration.zero) {
          await Future<void>.delayed(AiTiming.humanCaptureReveal);
        }
        await _feedback.pieceCaptured();
      } else {
        if (_humanMoveReveal > Duration.zero) {
          await Future<void>.delayed(_humanMoveReveal);
        }
        await _feedback.piecePlaced();
      }
      if (millFormed) {
        await _feedback.millFormed();
      }

      await flush();
      if (finished &&
          (_config.mode != MatchMode.offlineAi ||
              next.winner == humanSide ||
              next.isDraw)) {
        await _feedback.success();
      }
      shouldRunAi = !finished && _config.mode == MatchMode.offlineAi;
    } on InvalidMove catch (error) {
      errorCode = error.code;
      if (!_disposed) {
        notifyListeners();
      }
    } finally {
      _actionInProgress = false;
    }
    if (shouldRunAi) {
      await _runAiIfNeeded();
    }
  }

  Future<void> _runAiIfNeeded() async {
    RuntimeTrace.mark(
      'ai.gate.enter',
      data: <String, Object?>{
        'mode': _config.mode.name,
        'disposed': _disposed,
        'thinking': aiThinking,
        'action': _actionInProgress,
        'turn': _session?.state.turn.name,
      },
    );
    if (_disposed ||
        _config.mode != MatchMode.offlineAi ||
        aiThinking ||
        _actionInProgress) {
      RuntimeTrace.mark('ai.gate.skip.precondition');
      return;
    }
    final current = _session;
    if (current == null ||
        current.status != MatchSessionStatus.active ||
        current.state.turn != aiSide) {
      RuntimeTrace.mark('ai.gate.skip.turn_or_state');
      return;
    }

    RuntimeTrace.setPhase('ai.thinking');
    final difficulty = _config.difficulty ?? AiDifficulty.medium;
    final generation = ++_aiGeneration;
    aiThinking = true;
    selectedPoint = null;
    errorCode = null;
    if (!_disposed) {
      notifyListeners();
    }

    try {
      if (_aiThinkDelay > Duration.zero) {
        await Future<void>.delayed(_aiThinkDelay);
      }
      while (!_disposed && generation == _aiGeneration) {
        final active = _session;
        if (active == null ||
            active.status != MatchSessionStatus.active ||
            active.state.turn != aiSide) {
          break;
        }

        final before = active.state;
        final command = await _chooseAiCommand(
          state: before,
          difficulty: difficulty,
        );
        final next = _ai.applyCommand(definition, before, command);
        if (generation != _aiGeneration || _disposed) {
          break;
        }

        // Start audible motion before committing the state. Placement uses
        // the pick sound; movement uses the current board surface slide sound.
        switch (command.kind) {
          case AiCommandKind.place:
            await _feedback.pieceSelected();
            break;
          case AiCommandKind.move:
            await _feedback.pieceMoved();
            break;
          case AiCommandKind.capture:
            break;
        }

        MatchVisualTrace? trace;
        var millFormed = false;
        switch (command.kind) {
          case AiCommandKind.place:
            final to = command.to;
            final mills = MorrisRules.millPointsAt(
              definition,
              next.board,
              to,
              before.turn,
            );
            trace = MatchVisualTrace(
              actor: before.turn,
              to: to,
              millPoints: mills.toList(growable: false),
            );
            millFormed = mills.isNotEmpty;
            break;
          case AiCommandKind.move:
            final to = command.to;
            final mills = MorrisRules.millPointsAt(
              definition,
              next.board,
              to,
              before.turn,
            );
            trace = MatchVisualTrace(
              actor: before.turn,
              from: command.from,
              to: to,
              millPoints: mills.toList(growable: false),
            );
            millFormed = mills.isNotEmpty;
            break;
          case AiCommandKind.capture:
            trace = (active.visualTrace ??
                    MatchVisualTrace(actor: before.turn, to: command.to))
                .copyWith(capturedPoint: command.to);
            break;
        }
        final finished = next.phase == MatchPhase.finished;
        _session = active.copyWith(
          state: next,
          status:
              finished
                  ? MatchSessionStatus.completed
                  : MatchSessionStatus.active,
          updatedAt: DateTime.now(),
          visualTrace: trace,
          moveCount:
              active.moveCount +
              (command.kind == AiCommandKind.capture ? 0 : 1),
        );
        if (!_disposed) {
          notifyListeners();
        }

        if (command.kind == AiCommandKind.place ||
            command.kind == AiCommandKind.move) {
          if (_aiMoveReveal > Duration.zero) {
            await Future<void>.delayed(_aiMoveReveal);
          }
          await _feedback.piecePlaced();
        } else {
          if (AiTiming.aiCaptureReveal > Duration.zero) {
            await Future<void>.delayed(AiTiming.aiCaptureReveal);
          }
          await _feedback.pieceCaptured();
        }
        if (millFormed) {
          await _feedback.millFormed();
        }

        await flush();
        if (finished) {
          break;
        }

        if (next.pendingCaptureBy == aiSide &&
            _aiCapturePause > Duration.zero) {
          await Future<void>.delayed(_aiCapturePause);
        }
      }
    } finally {
      if (generation == _aiGeneration) {
        aiThinking = false;
      }
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  Future<AiCommand> _chooseAiCommand({
    required MorrisGameState state,
    required AiDifficulty difficulty,
  }) {
    if (!_backgroundAi) {
      return Future<AiCommand>.value(
        _ai.chooseCommand(
          definition: definition,
          state: state,
          difficulty: difficulty,
          aiSide: aiSide,
        ),
      );
    }

    // Medium/Hard/Master searches can be expensive on slower phones. Running
    // the production AI in a background isolate keeps Flutter's UI isolate
    // responsive and prevents Android ANR ("wait or close") dialogs.
    RuntimeTrace.mark(
      'ai.compute.start',
      data: <String, Object?>{'difficulty': difficulty.name},
    );
    return RuntimeTrace.measureAsync(
      'ai.compute',
      () => compute<_AiComputeRequest, AiCommand>(
        _chooseAiCommandInBackground,
        _AiComputeRequest(
          gameId: definition.id,
          state: state,
          difficulty: difficulty,
          aiSide: aiSide,
          seed: _aiSeed,
        ),
      ),
    );
  }

  void pauseAi() {
    _cancelAi();
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _cancelAi() {
    _aiGeneration++;
    aiThinking = false;
  }

  Future<void> flush() {
    final value = _session;
    if (value == null) {
      return Future<void>.value();
    }

    final saved = value.copyWith(updatedAt: DateTime.now());
    _session = saved;

    _persistChain = _persistChain.then(
      (_) => _saveSnapshot(saved),
      onError: (_) => _saveSnapshot(saved),
    );
    return _persistChain;
  }

  Future<void> _saveSnapshot(MatchSession snapshot) async {
    try {
      await _repository.save(snapshot);
      saveError = null;
    } catch (error) {
      saveError = error;
    }
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> abandon() async {
    _cancelAi();
    final value = _session;
    if (value == null) {
      return;
    }
    _session = value.copyWith(
      status: MatchSessionStatus.abandoned,
      updatedAt: DateTime.now(),
    );
    if (!_disposed) {
      notifyListeners();
    }
    await flush();
  }

  @override
  void dispose() {
    _cancelAi();
    _disposed = true;
    super.dispose();
  }

  static int _stableSeed(String value) {
    var hash = 17;
    for (final unit in value.codeUnits) {
      hash = ((hash * 31) + unit) & 0x7fffffff;
    }
    return hash;
  }
}

class _AiComputeRequest {
  const _AiComputeRequest({
    required this.gameId,
    required this.state,
    required this.difficulty,
    required this.aiSide,
    required this.seed,
  });

  final MorrisGameId gameId;
  final MorrisGameState state;
  final AiDifficulty difficulty;
  final PlayerSide aiSide;
  final int seed;
}

AiCommand _chooseAiCommandInBackground(_AiComputeRequest request) {
  final definition = GameCatalog.byId(request.gameId);
  return MorrisAiEngine(seed: request.seed).chooseCommand(
    definition: definition,
    state: request.state,
    difficulty: request.difficulty,
    aiSide: request.aiSide,
  );
}
