import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/diagnostics/runtime_trace.dart';
import '../../../core/feedback/motion_tokens.dart';
import '../../../core/game/game_models.dart';
import '../../../core/match/match_models.dart';
import '../../../core/online/quick_message.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
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
  bool _initializeScheduled = false;
  int _traceBuildCount = 0;
  bool _matchFrameMarked = false;

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
    if (_initializeScheduled) return;
    _initializeScheduled = true;
    RuntimeTrace.setPhase('game_screen.waiting_first_frame');
    RuntimeTrace.mark('game_screen.initialize_scheduled');

    // Preserve the V107 ANR root fix: Android gets a frame before session work.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      RuntimeTrace.setPhase('game_screen.post_frame_initialize');
      RuntimeTrace.mark('game_screen.post_frame_initialize.begin');
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
    _controller?.dispose();
    super.dispose();
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
        context.go(AppRoutes.home);
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
        await controller.restart();
        if (mounted && controller.saveError != null) {
          showAppNotice(context, l10n.saveFailedStayInMatch);
        }
      }
    } finally {
      _restartPromptOpen = false;
    }
  }

  Future<void> _requestRematch() async {
    controller.pauseAi();
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
                    onPressed: () => context.go(AppRoutes.home),
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
    final services = AppServicesScope.of(context);
    final settings = services.settings.state;
    final session = controller.session!;
    final isAi = widget.config.mode == MatchMode.offlineAi;
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

    return AppScreenShell(
      title: gameName(l10n, widget.config.gameId),
      scrollable: true,
      maxWidth: AppConstraints.boardMaxWidth,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      actions: [
        IconButton(
          tooltip: l10n.restart,
          onPressed: _requestRestart,
          icon: const Icon(Icons.refresh_rounded),
        ),
        IconButton(
          tooltip: l10n.saveAndExit,
          onPressed: _requestExit,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
      body: MatchLifecycleGuard(
        onPersist: controller.flush,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MatchPlayerBar(
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
            const SizedBox(height: AppSpacing.md),
            _TurnBanner(
              status: status,
              moveCountLabel: l10n.moveCountLabel(session.moveCount),
              captureRequired: game.pendingCaptureBy != null,
            ),
            const SizedBox(height: AppSpacing.md),
            _BoardStage(
              child: MorrisBoard(
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
                // Tap -> tap is the stable canonical interaction. Drag can be
                // re-enabled later after device profiling; it is not required
                // for any Morris rule or accessibility flow.
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
                      PlayerSide.light => l10n.boardPointLight(point + 1),
                      PlayerSide.dark => l10n.boardPointDark(point + 1),
                      null => l10n.boardPointEmpty(point + 1),
                    },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MatchPlayerBar(
              name: bottomName,
              side: PlayerSide.light,
              active:
                  visualTurn == PlayerSide.light &&
                  game.phase != MatchPhase.finished,
              stonesOnBoard: game.stonesOnBoard(PlayerSide.light),
              stonesToPlace: game.lightToPlace,
              reduceMotion: settings.reduceMotion,
            ),
            if (controller.errorCode != null) ...[
              const SizedBox(height: AppSpacing.md),
              _InlineNotice(
                icon: Icons.info_outline_rounded,
                text: moveErrorText(l10n, controller.errorCode!),
                danger: true,
              ),
            ],
            if (controller.saveError != null) ...[
              const SizedBox(height: AppSpacing.md),
              _InlineNotice(
                icon: Icons.cloud_off_rounded,
                text: l10n.saveFailedStayInMatch,
                danger: true,
              ),
            ],
            if (game.phase == MatchPhase.finished) ...[
              const SizedBox(height: AppSpacing.md),
              _ResultCard(
                title: instructionText(l10n, game),
                message: _resultMessage(l10n, game, isAi),
                rematchLabel: l10n.rematch,
                homeLabel: l10n.home,
                onRematch: _requestRematch,
                onHome: () => context.go(AppRoutes.home),
              ),
            ],
            if (widget.config.mode == MatchMode.onlineRanked ||
                widget.config.mode == MatchMode.challenge) ...[
              const SizedBox(height: AppSpacing.lg),
              _QuickMessages(
                l10n: l10n,
                onSend: (messageId) async {
                  try {
                    await services.online.sendQuickMessage(
                      matchId: session.config.sessionId,
                      messageId: messageId,
                    );
                  } catch (_) {
                    if (context.mounted) {
                      showAppNotice(context, l10n.onlineBackendRequired);
                    }
                  }
                },
              ),
            ],
          ],
        ),
      ),
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
  });

  final String status;
  final String moveCountLabel;
  final bool captureRequired;

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
        duration: MotionTokens.fast,
        constraints: const BoxConstraints(minHeight: 54),
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              child: Icon(
                captureRequired
                    ? Icons.gps_fixed_rounded
                    : Icons.touch_app_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                status,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: onBackground),
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

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({
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
    final background = danger ? scheme.errorContainer : scheme.primaryContainer;
    final foreground =
        danger ? scheme.onErrorContainer : scheme.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.message,
    required this.rematchLabel,
    required this.homeLabel,
    required this.onRematch,
    required this.onHome,
  });

  final String title;
  final String message;
  final String rematchLabel;
  final String homeLabel;
  final VoidCallback onRematch;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.62),
            AppColors.selection.withValues(alpha: 0.72),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
      child: Card(
        color: scheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  size: 34,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onHome,
                      icon: const Icon(Icons.home_rounded),
                      label: Text(homeLabel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onRematch,
                      icon: const Icon(Icons.replay_rounded),
                      label: Text(rematchLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickMessages extends StatelessWidget {
  const _QuickMessages({required this.l10n, required this.onSend});

  final AppLocalizations l10n;
  final Future<void> Function(QuickMessageId messageId) onSend;

  @override
  Widget build(BuildContext context) {
    final items = <(QuickMessageId, String)>[
      (QuickMessageId.goodMove, l10n.quickGoodMove),
      (QuickMessageId.congrats, l10n.quickCongrats),
      (QuickMessageId.goodGame, l10n.quickGoodGame),
      (QuickMessageId.more, l10n.quickMore),
    ];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder:
            (context, index) => ActionChip(
              label: Text(items[index].$2),
              onPressed: () => unawaited(onSend(items[index].$1)),
            ),
      ),
    );
  }
}
