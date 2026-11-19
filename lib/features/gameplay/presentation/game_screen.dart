import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/family_ads.dart';
import '../../../core/diagnostics/runtime_trace.dart';
import '../../../core/feedback/app_feedback_service.dart';
import '../../../core/feedback/motion_tokens.dart';
import '../../../core/game/game_models.dart';
import '../../../core/match/match_models.dart';
import '../../../core/online/quick_message.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../../shared/ui/match_confetti.dart';
import '../application/match_session_controller.dart';
import 'game_ui_labels.dart';
import 'widgets/match_lifecycle_guard.dart';
import 'widgets/match_player_bar.dart';
import 'widgets/morris_board.dart';

enum _ExitChoice { continueGame, saveAndExit, abandon }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.config, this.createNew = false});

  final MatchConfig config;
  final bool createNew;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  MatchSessionController? _controller;
  MatchSessionController get controller => _controller!;
  bool _exitPromptOpen = false;
  bool _restartPromptOpen = false;
  bool _drawOfferOpen = false;
  bool _gameOptionsOpen = false;
  bool _initializeScheduled = false;
  int _traceBuildCount = 0;
  bool _matchFrameMarked = false;
  MatchLifecycleFeedback? _matchLifecycleFeedback;
  Future<void>? _matchIntroFuture;
  bool _matchIntroStopped = false;
  bool _introStopScheduled = false;
  bool _didSeeActiveMatch = false;
  bool _completionEffectsQueued = false;
  bool _completionDialogOpen = false;
  int _completionPromptEpoch = 0;
  Future<void>? _recordCompletionFuture;
  String? _activeReaction;
  Timer? _reactionTimer;

  @override
  void initState() {
    super.initState();
    RuntimeTrace.setPhase('game_screen.init_state');
    RuntimeTrace.mark(
      'game_screen.init_state',
      data: <String, Object?>{
        'game': widget.config.gameId.name,
        'mode': widget.config.mode.name,
        'difficulty': widget.config.difficulty?.name,
        'fresh': widget.createNew,
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RuntimeTrace.mark('game_screen.dependencies.enter');
    if (_controller == null) {
      final services = RuntimeTrace.measureSync(
        'game_screen.services_scope',
        () => AppServicesScope.of(context),
      );
      final feedback = services.feedback;
      if (feedback is MatchLifecycleFeedback) {
        _matchLifecycleFeedback = feedback as MatchLifecycleFeedback;
      }
      _controller = RuntimeTrace.measureSync(
        'game_screen.controller_construct',
        () => MatchSessionController(
          config: widget.config,
          repository: services.matchSessions,
          feedback: services.feedback,
        ),
      );
      RuntimeTrace.mark('game_screen.controller_ready');
    }
    if (widget.createNew && _matchIntroFuture == null) {
      _matchIntroFuture = _matchLifecycleFeedback?.matchStarting();
    }
    if (_initializeScheduled) return;
    _initializeScheduled = true;
    RuntimeTrace.setPhase('game_screen.waiting_first_frame');
    RuntimeTrace.mark('game_screen.initialize_scheduled');

    // Preserve the V107 ANR root fix: Android gets a frame before session work.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      RuntimeTrace.setPhase('game_screen.post_frame_initialize');
      RuntimeTrace.mark('game_screen.post_frame_initialize.begin');
      unawaited(FamilyAds.preloadInterstitial());
      unawaited(
        RuntimeTrace.measureAsync(
          'game_screen.controller_initialize',
          () => controller.initialize(createNew: widget.createNew),
        ),
      );
    });
  }

  @override
  void dispose() {
    _reactionTimer?.cancel();
    unawaited(_stopMatchIntro(closing: true));
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _stopMatchIntro({bool closing = false}) async {
    if (_matchIntroStopped) {
      if (closing) await _matchLifecycleFeedback?.matchClosed();
      return;
    }
    _matchIntroStopped = true;
    final starting = _matchIntroFuture;
    if (starting == null) {
      if (closing) await _matchLifecycleFeedback?.matchClosed();
      return;
    }
    try {
      await starting;
      if (closing) {
        await _matchLifecycleFeedback?.matchClosed();
      } else {
        await _matchLifecycleFeedback?.matchReady();
      }
    } catch (_) {
      // Optional match audio must not affect match flow.
    }
  }

  void _scheduleCompletionEffects(MorrisGameState game) {
    if (game.phase != MatchPhase.finished) {
      _didSeeActiveMatch = true;
      return;
    }
    if (!_didSeeActiveMatch || _completionEffectsQueued) return;
    _completionEffectsQueued = true;
    _recordCompletionFuture = FamilyAds.recordCompletedMatch();
    unawaited(FamilyAds.preloadInterstitial());
    final promptEpoch = _completionPromptEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final matchAudio = _matchLifecycleFeedback;
      final localPlayerWon =
          !game.isDraw &&
          game.winner != null &&
          (widget.config.mode != MatchMode.offlineAi ||
              game.winner == controller.humanSide);
      if (localPlayerWon && matchAudio is MatchWinFeedback) {
        unawaited((matchAudio as MatchWinFeedback).matchWon());
      } else {
        unawaited(matchAudio?.matchFinished());
      }
      unawaited(_updateProfileStats(game, localPlayerWon));
      unawaited(
        _showCompletionPrompt(
          game,
          widget.config.mode == MatchMode.offlineAi,
          promptEpoch,
        ),
      );
    });
  }

  Future<void> _updateProfileStats(
    MorrisGameState game,
    bool localPlayerWon,
  ) async {
    try {
      if (!mounted) return;
      final social = AppServicesScope.of(context).social;
      final currentProfile = await social.getLocalProfile();
      final updated = currentProfile.recordMatchResult(
        gameId: widget.config.gameId,
        isWin: localPlayerWon,
        isDraw: game.isDraw,
      );
      await social.saveLocalProfile(updated);
    } catch (_) {
      // Sessizce yutulur
    }
  }

  Future<void> _showCompletionPrompt(
    MorrisGameState game,
    bool isAi,
    int promptEpoch,
  ) async {
    if (_completionDialogOpen) return;
    _completionDialogOpen = true;
    // Let the first confetti burst be visible before the result prompt opens.
    await Future<void>.delayed(AppTimeouts.completionReveal);
    if (!mounted || promptEpoch != _completionPromptEpoch) {
      _completionDialogOpen = false;
      return;
    }
    final l10n = AppLocalizations.of(context);
    final choice = await showAppActionDialog<bool>(
      context: context,
      title: instructionText(l10n, game),
      message: '${_resultMessage(l10n, game, isAi)}\n\n${l10n.rematch}?',
      actions: [
        AppDialogAction(label: l10n.home, value: false),
        AppDialogAction(label: l10n.rematch, value: true, primary: true),
      ],
    );
    _completionDialogOpen = false;
    if (!mounted) return;
    if (choice == true) {
      await _recordCompletionFuture;
      await FamilyAds.showAtMatchEnd();
      if (!mounted) return;
      await _requestRematch();
    } else if (choice == false) {
      await _leaveCompletedMatch();
    }
  }

  Future<void> _leaveCompletedMatch() async {
    await _recordCompletionFuture;
    await FamilyAds.showAtMatchEnd();
    if (mounted) context.go(AppRoutes.home);
  }

  Future<void> _requestExit() async {
    if (_exitPromptOpen) return;
    _exitPromptOpen = true;
    try {
      final session = controller.session;
      final l10n = AppLocalizations.of(context);
      if (session?.status == MatchSessionStatus.completed) {
        await controller.flush();
        if (!mounted) return;
        if (controller.saveError != null) {
          showAppNotice(context, l10n.saveFailedStayInMatch);
          return;
        }
        await _leaveCompletedMatch();
        return;
      }

      final choice = await showAppActionDialog<_ExitChoice>(
        context: context,
        title: l10n.matchInProgressTitle,
        message: l10n.matchInProgressBody,
        actions: [
          AppDialogAction(label: l10n.resume, value: _ExitChoice.continueGame),
          AppDialogAction(label: l10n.abandonMatch, value: _ExitChoice.abandon),
          AppDialogAction(
            label: l10n.saveAndExit,
            value: _ExitChoice.saveAndExit,
            primary: true,
          ),
        ],
      );
      if (!mounted || choice == null || choice == _ExitChoice.continueGame) {
        return;
      }

      controller.pauseAi();
      if (choice == _ExitChoice.abandon) {
        await controller.abandon();
      } else {
        await controller.flush();
      }
      if (!mounted) return;
      if (controller.saveError != null) {
        showAppNotice(context, l10n.saveFailedStayInMatch);
        return;
      }
      context.go(AppRoutes.home);
    } finally {
      _exitPromptOpen = false;
    }
  }

  void _showReactionSheet() {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.localeName.toLowerCase();
    final thinkingText = lang.startsWith('tr')
        ? 'Düşünüyorum'
        : lang.startsWith('de')
        ? 'Überlege...'
        : lang.startsWith('es')
        ? 'Pensando...'
        : lang.startsWith('fr')
        ? 'Réflexion...'
        : lang.startsWith('pt')
        ? 'Pensando...'
        : lang.startsWith('ar')
        ? 'أفكر...'
        : lang.startsWith('hi')
        ? 'सोच रहा हूँ...'
        : 'Thinking...';
    final brilliantText = lang.startsWith('tr')
        ? 'Harika!'
        : lang.startsWith('de')
        ? 'Klasse!'
        : lang.startsWith('es')
        ? '¡Genial!'
        : lang.startsWith('fr')
        ? 'Génial !'
        : lang.startsWith('pt')
        ? 'Brilhante!'
        : lang.startsWith('ar')
        ? 'رائع!'
        : lang.startsWith('hi')
        ? 'शानदार!'
        : 'Brilliant!';

    final reactions = [
      (emoji: '👏', text: l10n.quickGoodMove, id: QuickMessageId.goodMove),
      (emoji: '🏆', text: l10n.quickCongrats, id: QuickMessageId.congrats),
      (emoji: '🤝', text: l10n.quickGoodGame, id: QuickMessageId.goodGame),
      (emoji: '🤔', text: thinkingText, id: QuickMessageId.more),
      (emoji: '⚡', text: brilliantText, id: QuickMessageId.more),
    ];
    showAppBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final r in reactions)
                InkWell(
                  onTap: () {
                    closeAppOverlay(sheetContext);
                    _sendReaction('${r.emoji} ${r.text}', r.id);
                  },
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          r.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.text,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  void _sendReaction(String reactionText, QuickMessageId quickId) {
    final feedback = AppServicesScope.of(context).feedback;
    unawaited(feedback.buttonPressed());
    _reactionTimer?.cancel();
    setState(() {
      _activeReaction = reactionText;
    });
    final isOnline = widget.config.mode == MatchMode.onlineRanked ||
        widget.config.mode == MatchMode.challenge;
    if (isOnline) {
      unawaited(
        AppServicesScope.of(context).online.sendQuickMessage(
          matchId: widget.config.sessionId,
          messageId: quickId,
        ),
      );
    }
    _reactionTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _activeReaction = null;
        });
      }
    });
  }

  Future<void> _requestRestart() async {
    if (_restartPromptOpen) return;
    _restartPromptOpen = true;
    try {
      final l10n = AppLocalizations.of(context);
      final confirmed = await showAppActionDialog<bool>(
        context: context,
        title: l10n.restartMatchTitle,
        message: l10n.restartMatchBody,
        actions: [
          AppDialogAction(label: l10n.cancel, value: false),
          AppDialogAction(label: l10n.restart, value: true, primary: true),
        ],
      );
      if (confirmed == true) {
        _completionPromptEpoch++;
        _completionEffectsQueued = false;
        _didSeeActiveMatch = true;
        _matchIntroStopped = false;
        _introStopScheduled = false;
        _matchIntroFuture = _matchLifecycleFeedback?.matchStarting();
        await controller.restart();
        if (mounted && controller.saveError != null) {
          showAppNotice(context, l10n.saveFailedStayInMatch);
        }
      }
    } finally {
      _restartPromptOpen = false;
    }
  }

  Future<void> _offerDraw() async {
    if (_drawOfferOpen) return;
    final session = controller.session;
    if (session == null || session.status != MatchSessionStatus.active) return;

    _drawOfferOpen = true;
    try {
      final l10n = AppLocalizations.of(context);
      final confirmed = await showAppActionDialog<bool>(
        context: context,
        title: l10n.offerDraw,
        message: l10n.drawOfferPrompt,
        actions: [
          AppDialogAction(label: l10n.cancel, value: false),
          AppDialogAction(label: l10n.offerDraw, value: true, primary: true),
        ],
      );
      if (!mounted || confirmed != true) return;

      if (widget.config.mode == MatchMode.offlineAi) {
        final current = controller.session;
        if (current == null || current.status != MatchSessionStatus.active) {
          return;
        }
        final mostRepeated = current.repetitionCounts.values.fold<int>(
          0,
          (highest, count) => count > highest ? count : highest,
        );
        final accepted =
            current.state.movesWithoutCapture >= 80 || mostRepeated >= 3;
        showAppNotice(
          context,
          accepted
              ? l10n.computerDrawOfferAccepted
              : l10n.computerDrawOfferDeclined,
        );
        if (accepted) await controller.agreeToDraw();
        return;
      }

      final accepted = await showAppActionDialog<bool>(
        context: context,
        title: l10n.drawOfferReceived,
        message: l10n.drawOfferReceivedBody,
        actions: [
          AppDialogAction(label: l10n.declineDraw, value: false),
          AppDialogAction(label: l10n.acceptDraw, value: true, primary: true),
        ],
      );
      if (!mounted || accepted == null) return;
      if (accepted) {
        await controller.agreeToDraw();
      } else {
        showAppNotice(context, l10n.drawOfferDeclined);
      }
    } finally {
      _drawOfferOpen = false;
    }
  }

  Future<void> _openGameOptions() async {
    if (_gameOptionsOpen ||
        controller.session?.status != MatchSessionStatus.active) {
      return;
    }
    _gameOptionsOpen = true;
    try {
      final l10n = AppLocalizations.of(context);
      final resign = await showAppBottomSheet<bool>(
        context: context,
        builder:
            (sheetContext) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.gameOptions,
                      style: Theme.of(sheetContext).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.drawRuleNotice),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.flag_outlined),
                      title: Text(l10n.resignMatch),
                      onTap: () => Navigator.of(sheetContext).pop(true),
                    ),
                  ],
                ),
              ),
            ),
      );
      if (!mounted || resign != true) return;
      final confirmed = await showAppActionDialog<bool>(
        context: context,
        title: l10n.resignMatch,
        message: l10n.resignConfirm,
        actions: [
          AppDialogAction(label: l10n.cancel, value: false),
          AppDialogAction(label: l10n.resignMatch, value: true, primary: true),
        ],
      );
      if (confirmed != true || !mounted) return;
      await controller.resign();
      if (mounted && controller.saveError != null) {
        showAppNotice(context, l10n.saveFailedStayInMatch);
      }
    } finally {
      _gameOptionsOpen = false;
    }
  }

  Future<void> _requestRematch() async {
    _completionPromptEpoch++;
    controller.pauseAi();
    _completionEffectsQueued = false;
    _didSeeActiveMatch = true;
    _matchIntroStopped = false;
    _introStopScheduled = false;
    _matchIntroFuture = _matchLifecycleFeedback?.matchStarting();
    await controller.restart();
    if (!mounted) {
      return;
    }
    if (controller.saveError != null) {
      showAppNotice(
        context,
        AppLocalizations.of(context).saveFailedStayInMatch,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _traceBuildCount++;
    if (_traceBuildCount <= 6) {
      RuntimeTrace.mark(
        'game_screen.build',
        data: <String, Object?>{
          'count': _traceBuildCount,
          'loading': _controller?.loading,
          'has_game': _controller?.game != null,
        },
      );
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        if (controller.loading) {
          return AppScreenShell(
            title: gameName(l10n, widget.config.gameId),
            body: const Center(child: _MatchLoadingState()),
          );
        }
        if (controller.loadError != null || controller.game == null) {
          return AppScreenShell(
            title: gameName(l10n, widget.config.gameId),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.matchLoadError, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: _leaveCompletedMatch,
                    child: Text(l10n.backHome),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildMatch(context, l10n, controller.game!);
      },
    );
  }

  Widget _buildMatch(
    BuildContext context,
    AppLocalizations l10n,
    MorrisGameState game,
  ) {
    RuntimeTrace.setPhase('game_screen.build_match');
    RuntimeTrace.mark(
      'game_screen.build_match.enter',
      data: <String, Object?>{
        'phase': game.phase.name,
        'turn': game.turn.name,
        'points': game.board.length,
      },
    );
    if (!_matchFrameMarked) {
      _matchFrameMarked = true;
      RuntimeTrace.firstFrame('game_screen.match_first_frame');
    }
    if (_matchIntroFuture != null &&
        !_matchIntroStopped &&
        !_introStopScheduled) {
      _introStopScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_stopMatchIntro());
      });
    }
    final services = AppServicesScope.of(context);
    final settings = services.settings.state;
    final session = controller.session!;
    final isAi = widget.config.mode == MatchMode.offlineAi;
    _scheduleCompletionEffects(game);
    final topName = isAi ? l10n.computerPlayer : l10n.darkPlayer;
    final bottomName = isAi ? l10n.you : l10n.lightPlayer;
    final status =
        controller.aiThinking ? l10n.aiThinking : instructionText(l10n, game);
    final visualTurn =
        isAi && controller.aiThinking ? controller.aiSide : game.turn;
    final lightCapturedRaw =
        controller.definition.piecesPerPlayer -
        game.lightToPlace -
        game.stonesOnBoard(PlayerSide.light);
    final darkCapturedRaw =
        controller.definition.piecesPerPlayer -
        game.darkToPlace -
        game.stonesOnBoard(PlayerSide.dark);
    final lightCaptured = lightCapturedRaw < 0 ? 0 : lightCapturedRaw;
    final darkCaptured = darkCapturedRaw < 0 ? 0 : darkCapturedRaw;

    return Stack(
      fit: StackFit.expand,
      children: [
        AppScreenShell(
          title: gameName(l10n, widget.config.gameId),
          scrollable: false,
          maxWidth: AppConstraints.boardMaxWidth,
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          actions: [
            if (widget.config.mode == MatchMode.offlineAi ||
                widget.config.mode == MatchMode.localTwoPlayer)
              IconButton(
                tooltip: l10n.offerDraw,
                onPressed:
                    session.status == MatchSessionStatus.active
                        ? _offerDraw
                        : null,
                icon: const Icon(Icons.handshake_outlined),
              ),
            IconButton(
              tooltip: l10n.restart,
              onPressed: _requestRestart,
              icon: const Icon(Icons.refresh_rounded),
            ),
            IconButton(
              tooltip: l10n.localeName.startsWith('tr')
                  ? 'Tepki'
                  : l10n.localeName.startsWith('de')
                  ? 'Reaktion'
                  : l10n.localeName.startsWith('es')
                  ? 'Reacción'
                  : l10n.localeName.startsWith('fr')
                  ? 'Réaction'
                  : l10n.localeName.startsWith('pt')
                  ? 'Reação'
                  : l10n.localeName.startsWith('ar')
                  ? 'تفاعل'
                  : l10n.localeName.startsWith('hi')
                  ? 'प्रतिक्रिया'
                  : 'Reaction',
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: _showReactionSheet,
            ),
            IconButton(
              tooltip: l10n.saveAndExit,
              onPressed: _requestExit,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
          bottomNavigationBar: const FamilyBannerAd(reserveSpace: true),
          body: MatchLifecycleGuard(
            onPersist: controller.flush,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MatchPlayerBar(
                  compact: true,
                  name: topName,
                  side: PlayerSide.dark,
                  active:
                      visualTurn == PlayerSide.dark &&
                      game.phase != MatchPhase.finished,
                  stonesOnBoard: game.stonesOnBoard(PlayerSide.dark),
                  stonesToPlace: game.darkToPlace,
                  thinking: controller.aiThinking,
                  thinkingLabel: l10n.aiThinking,
                  reduceMotion: settings.reduceMotion,
                ),
                const SizedBox(height: 6),
                _TurnBanner(
                  status: status,
                  moveCountLabel: l10n.moveCountLabel(session.moveCount),
                  captureRequired: game.pendingCaptureBy != null,
                  compact: true,
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: _BoardStage(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            MorrisBoard(
                              definition: controller.definition,
                              board: game.board,
                              selectedPoint: controller.selectedPoint,
                              legalTargets: controller.legalTargets,
                              capturablePoints: controller.capturablePoints,
                              activeMillPoints: controller.activeMillPoints,
                              lastMoveFrom: controller.lastMoveFrom,
                              lastMoveTo: controller.lastMoveTo,
                              lastMoveActor: controller.lastMoveActor,
                              lastCapturedPoint: controller.lastCapturedPoint,
                              capturedLight: lightCaptured,
                              capturedDark: darkCaptured,
                              moveSequence: session.moveCount,
                              moveDuration: controller.visualMoveDuration,
                              onPointTap: controller.tapPoint,
                              onMoveDrop: null,
                              interactive: controller.humanCanAct,
                              reduceMotion: settings.reduceMotion,
                              showHints: settings.showMoveHints,
                              colorAssist: settings.colorAssist,
                              surface: settings.boardSurface,
                              viewStyle: settings.boardView,
                              pieceTheme: settings.pieceTheme,
                              semanticLabelBuilder:
                                  (point, piece) => switch (piece) {
                                    PlayerSide.light => l10n.boardPointLight(
                                      point + 1,
                                    ),
                                    PlayerSide.dark => l10n.boardPointDark(
                                      point + 1,
                                    ),
                                    null => l10n.boardPointEmpty(point + 1),
                                  },
                            ),
                            if (_activeReaction != null)
                              Positioned(
                                top: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceDarkRaised,
                                    borderRadius: BorderRadius.circular(AppRadii.pill),
                                    border: Border.all(
                                      color: AppColors.darkOrange,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.35),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    _activeReaction!,
                                    style: const TextStyle(
                                      color: AppColors.inkOnDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                MatchPlayerBar(
                  compact: true,
                  name: bottomName,
                  side: PlayerSide.light,
                  active:
                      visualTurn == PlayerSide.light &&
                      game.phase != MatchPhase.finished,
                  stonesOnBoard: game.stonesOnBoard(PlayerSide.light),
                  stonesToPlace: game.lightToPlace,
                  reduceMotion: settings.reduceMotion,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 40,
                  child:
                      controller.errorCode != null
                          ? _CompactMatchNotice(
                            icon: Icons.info_outline_rounded,
                            text: moveErrorText(l10n, controller.errorCode!),
                            danger: true,
                          )
                          : controller.saveError != null
                          ? _CompactMatchNotice(
                            icon: Icons.cloud_off_rounded,
                            text: l10n.saveFailedStayInMatch,
                            danger: true,
                          )
                          : game.phase == MatchPhase.finished
                          ? Row(
                            children: [
                              Expanded(
                                child: Text(
                                  instructionText(l10n, game),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              TextButton(
                                onPressed: _leaveCompletedMatch,
                                child: Text(l10n.home),
                              ),
                              const SizedBox(width: 4),
                              FilledButton(
                                onPressed: _requestRematch,
                                child: Text(l10n.rematch),
                              ),
                            ],
                          )
                          : Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton.icon(
                              onPressed: _openGameOptions,
                              icon: const Icon(Icons.more_horiz_rounded),
                              label: Text(l10n.gameOptions),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
        if (!game.isDraw &&
            game.winner != null &&
            (!isAi || game.winner == controller.humanSide) &&
            !settings.reduceMotion)
          const Positioned.fill(child: MatchConfetti()),
      ],
    );
  }

  String _resultMessage(
    AppLocalizations l10n,
    MorrisGameState game,
    bool isAi,
  ) {
    if (game.isDraw) {
      return l10n.resultDrawPraise;
    }
    if (!isAi) {
      return l10n.resultLocalPraise;
    }
    return game.winner == controller.humanSide
        ? l10n.resultVictoryPraise
        : l10n.resultDefeatPraise;
  }
}

class _TurnBanner extends StatelessWidget {
  const _TurnBanner({
    required this.status,
    required this.moveCountLabel,
    required this.captureRequired,
    this.compact = false,
  });

  final String status;
  final String moveCountLabel;
  final bool captureRequired;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = captureRequired ? scheme.error : scheme.primary;
    final background =
        captureRequired ? scheme.errorContainer : scheme.primaryContainer;
    final onBackground =
        captureRequired ? scheme.onErrorContainer : scheme.onPrimaryContainer;
    return Semantics(
      liveRegion: true,
      child: AnimatedContainer(
        duration: compact ? Duration.zero : MotionTokens.fast,
        height: compact ? 42 : null,
        constraints: compact ? null : const BoxConstraints(minHeight: 54),
        padding: EdgeInsets.fromLTRB(
          compact ? 8 : 10,
          compact ? 4 : 8,
          compact ? 8 : 10,
          compact ? 4 : 8,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(color: accent.withValues(alpha: 0.24)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 30 : 38,
              height: compact ? 30 : 38,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              child: Icon(
                captureRequired
                    ? Icons.gps_fixed_rounded
                    : Icons.touch_app_rounded,
                color: Colors.white,
                size: compact ? 17 : 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                status,
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: onBackground,
                  fontSize: compact ? 14 : null,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Text(
                moveCountLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: onBackground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardStage extends StatelessWidget {
  const _BoardStage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.surfaceContainerHighest, scheme.surfaceContainerLow],
        ),
        borderRadius: BorderRadius.circular(AppRadii.extraLarge),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: child,
    );
  }
}

class _MatchLoadingState extends StatelessWidget {
  const _MatchLoadingState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 3, color: scheme.primary),
      ),
    );
  }
}

class _CompactMatchNotice extends StatelessWidget {
  const _CompactMatchNotice({
    required this.icon,
    required this.text,
    required this.danger,
  });

  final IconData icon;
  final String text;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = danger ? scheme.error : scheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: danger ? scheme.errorContainer : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadii.small),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color:
                    danger
                        ? scheme.onErrorContainer
                        : scheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
