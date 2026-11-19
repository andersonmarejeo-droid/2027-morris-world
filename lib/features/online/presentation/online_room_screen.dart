import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/family_ads.dart';
import '../../../core/feedback/app_feedback_service.dart';
import '../../../core/feedback/motion_tokens.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_models.dart';
import '../../../core/game/morris_engine.dart';
import '../../../core/game/morris_rules.dart';
import '../../../core/match/match_models.dart';
import '../../../core/online/firebase_match_client.dart';
import '../../../core/online/online_match_gateway.dart';
import '../../../core/online/spark_room_client.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../../shared/ui/match_confetti.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../../gameplay/presentation/widgets/match_player_bar.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';
import '../../social/application/challenge_share_service.dart';

class OnlineRoomScreen extends StatefulWidget {
  const OnlineRoomScreen({super.key, required this.roomCode});
  final String roomCode;

  @override
  State<OnlineRoomScreen> createState() => _OnlineRoomScreenState();
}

class _OnlineRoomScreenState extends State<OnlineRoomScreen> {
  OnlineMatchGateway? _gateway;
  String? _observedRoomCode;
  Stream<OnlineRoom?>? _roomStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateRoomStream(AppServicesScope.of(context).online);
  }

  @override
  void didUpdateWidget(covariant OnlineRoomScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomCode != widget.roomCode) {
      _updateRoomStream(AppServicesScope.of(context).online);
    }
  }

  void _updateRoomStream(OnlineMatchGateway gateway) {
    if (_gateway == gateway && _observedRoomCode == widget.roomCode) return;
    _gateway = gateway;
    _observedRoomCode = widget.roomCode;
    _roomStream = gateway.watchPrivateRoom(widget.roomCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<OnlineRoom?>(
      stream: _roomStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _RoomProblem(
            title: l10n.onlineArena,
            message: l10n.genericLoadError,
          );
        }
        if (!snapshot.hasData) {
          return AppScreenShell(
            title: l10n.onlineArena,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final room = snapshot.data;
        if (room == null) {
          return _RoomProblem(
            title: l10n.onlineArena,
            message: l10n.genericLoadError,
          );
        }
        if (room.status == OnlineRoomStatus.waiting) {
          return _WaitingRoom(room: room);
        }
        if (room.localSide == null) {
          return _RoomProblem(
            title: l10n.onlineArena,
            message: l10n.genericLoadError,
          );
        }
        if (!room.hostReady) {
          return _MatchReadyGate(room: room);
        }
        return _OnlineRoomGame(room: room);
      },
    );
  }
}

class _WaitingRoom extends StatefulWidget {
  const _WaitingRoom({required this.room});
  final OnlineRoom room;

  @override
  State<_WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<_WaitingRoom> {
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    _startFallbackTimer();
  }

  @override
  void didUpdateWidget(covariant _WaitingRoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room.id != widget.room.id) _startFallbackTimer();
  }

  void _startFallbackTimer() {
    _fallbackTimer?.cancel();
    // WhatsApp meydan okumalarında arkadaşın gelmesi için 5 dakika beklenir.
    _fallbackTimer = Timer(const Duration(minutes: 5), _fallbackToComputer);
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  Future<void> _fallbackToComputer() async {
    if (!mounted) return;
    try {
      await AppServicesScope.of(
        context,
      ).online.closePrivateRoom(widget.room.id);
    } catch (_) {
      // The local fallback remains safe even if cleanup is temporarily offline.
    }
    if (!mounted) return;
    final config = MatchConfig(
      sessionId: MatchIds.create(),
      gameId: widget.room.gameId,
      mode: MatchMode.offlineAi,
      difficulty: AiDifficulty.medium,
    );
    context.go(AppRoutes.play(config, fresh: true));
  }

  Future<void> _close(BuildContext context) async {
    try {
      await AppServicesScope.of(
        context,
      ).online.closePrivateRoom(widget.room.id);
      if (context.mounted) context.go(AppRoutes.home);
    } catch (_) {
      if (context.mounted) {
        showAppNotice(context, AppLocalizations.of(context).onlineMoveFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreenShell(
      title: l10n.onlineArena,
      bottomNavigationBar: const FamilyBannerAd(reserveSpace: true),
      actions: [
        IconButton(
          tooltip: l10n.closeOnlineRoom,
          onPressed: () => _close(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    width: 46,
                    height: 46,
                    child: CircularProgressIndicator(strokeWidth: 4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '⚔️ Rakip Bekleniyor',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.onlineSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Büyük Oda Kodu Kutusu
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadii.medium),
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.room.id,
                          style: const TextStyle(
                            letterSpacing: 4,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: l10n.copyRoomCode,
                          icon: const Icon(Icons.copy_rounded),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.room.id));
                            showAppNotice(context, l10n.roomCodeCopied);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final invite = '${l10n.whatsappChallengeInvite(gameName(l10n, widget.room.gameId), ChallengeShareService.closedTestingLink)}\n\n'
                          '🔑 ${l10n.roomCode}: ${widget.room.id}\n'
                          '👉 ${l10n.joinPrivateRoom}';
                      await ChallengeShareService.shareOnWhatsApp(invite);
                    },
                    icon: const Icon(Icons.share_rounded),
                    label: Text(l10n.shareInvite),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: _fallbackToComputer,
                    icon: const Icon(Icons.smart_toy_rounded),
                    label: Text(l10n.computerModeTitle),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MatchReadyGate extends StatefulWidget {
  const _MatchReadyGate({required this.room});
  final OnlineRoom room;

  @override
  State<_MatchReadyGate> createState() => _MatchReadyGateState();
}

class _MatchReadyGateState extends State<_MatchReadyGate> {
  bool _confirming = false;
  bool _soundPlayed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_soundPlayed) {
      _soundPlayed = true;
      final feedback = AppServicesScope.of(context).feedback;
      if (feedback is MatchLifecycleFeedback) {
        unawaited((feedback as MatchLifecycleFeedback).matchStarting());
      }
      unawaited(HapticFeedback.heavyImpact());
    }
  }

  Future<void> _startMatch() async {
    if (_confirming) return;
    setState(() => _confirming = true);
    try {
      await AppServicesScope.of(context).online.confirmMatch(widget.room.id);
    } catch (_) {
      if (mounted) {
        showAppNotice(context, AppLocalizations.of(context).onlineMoveFailed);
      }
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  Future<void> _leave() async {
    try {
      await AppServicesScope.of(context).online.closePrivateRoom(widget.room.id);
    } catch (_) {}
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isHost = widget.room.localSide == PlayerSide.light;

    return AppScreenShell(
      title: l10n.onlineArena,
      bottomNavigationBar: const FamilyBannerAd(reserveSpace: true),
      actions: [
        IconButton(
          tooltip: l10n.exitMatch,
          onPressed: _leave,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.large),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    isHost ? Icons.sports_esports_rounded : Icons.hourglass_top_rounded,
                    size: 64,
                    color: isHost ? Colors.green : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    isHost ? '⚔️ Rakip Meydan Okumayı Kabul Etti!' : 'Odaya Katıldın!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    isHost
                        ? 'Rakibin odaya katıldı ve hazır! Maçı başlatmak için butona dokun.'
                        : 'Ev sahibinin maçı onaylayıp başlatması bekleniyor...',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (isHost) ...[
                    FilledButton.icon(
                      onPressed: _confirming ? null : _startMatch,
                      icon: _confirming
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        _confirming ? 'Başlatılıyor...' : 'Maçı Başlat',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: _confirming ? null : _leave,
                      child: Text(l10n.cancel),
                    ),
                  ] else ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton(
                      onPressed: _leave,
                      child: Text(l10n.exitMatch),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnlineRoomGame extends StatefulWidget {
  const _OnlineRoomGame({required this.room});
  final OnlineRoom room;

  @override
  State<_OnlineRoomGame> createState() => _OnlineRoomGameState();
}

class _OnlineRoomGameState extends State<_OnlineRoomGame> {
  static const Duration _moveRequestTimeout = Duration(seconds: 8);

  int? _selectedPoint;
  bool _submitting = false;
  bool _gameOptionsOpen = false;
  bool _exitDialogOpen = false;
  bool _allowPop = false;
  bool _timeoutClaimInFlight = false;
  Timer? _timeoutTimer;
  MatchLifecycleFeedback? _matchAudio;
  Future<void>? _matchIntroFuture;
  bool _matchIntroStopped = true;
  bool _completionEffectsQueued = false;

  @override
  void initState() {
    super.initState();
    _timeoutTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => unawaited(_claimExpiredTurn()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final feedback = AppServicesScope.of(context).feedback;
    if (feedback is MatchLifecycleFeedback) {
      _matchAudio = feedback as MatchLifecycleFeedback;
    }
    _handleRoomLifecycle(widget.room);
  }

  @override
  void didUpdateWidget(covariant _OnlineRoomGame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room.id != widget.room.id) {
      _selectedPoint = null;
      _submitting = false;
      _matchIntroFuture = null;
      _matchIntroStopped = true;
      _completionEffectsQueued = false;
    }
    // The room stream is authoritative. If the revision/turn changed while
    // a move was being submitted (or while the opponent moved), discard the
    // old selection so a later tap cannot submit a stale move.
    if (oldWidget.room.id == widget.room.id &&
        (oldWidget.room.revision != widget.room.revision ||
            oldWidget.room.state.turn != widget.room.state.turn ||
            oldWidget.room.status != widget.room.status)) {
      _selectedPoint = null;
      _submitting = false;
    }
    _handleRoomLifecycle(widget.room);
  }

  void _handleRoomLifecycle(OnlineRoom room) {
    if (room.status == OnlineRoomStatus.active &&
        room.revision == 0 &&
        room.state.phase != MatchPhase.finished &&
        _matchIntroFuture == null) {
      _matchIntroStopped = false;
      _matchIntroFuture = _matchAudio?.matchStarting();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_stopMatchIntro());
      });
    }

    if (room.state.phase == MatchPhase.finished && !_completionEffectsQueued) {
      _completionEffectsQueued = true;
      unawaited(FamilyAds.recordCompletedMatch());
      unawaited(FamilyAds.preloadInterstitial());
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await _stopMatchIntro();
        final localPlayerWon =
            !room.state.isDraw &&
            room.localSide != null &&
            room.state.winner == room.localSide;
        final matchAudio = _matchAudio;
        if (localPlayerWon && matchAudio is MatchWinFeedback) {
          await (matchAudio as MatchWinFeedback).matchWon();
        } else {
          await matchAudio?.matchFinished();
        }
        if (!mounted || !localPlayerWon) return;
        if (room.forfeitReason == 'timeout') {
          showAppNotice(context, AppLocalizations.of(context).opponentTimedOut);
        } else if (room.forfeitReason == 'resign') {
          showAppNotice(context, AppLocalizations.of(context).opponentLeft);
        }
      });
    }
  }

  Future<void> _claimExpiredTurn() async {
    if (!mounted || _timeoutClaimInFlight) return;
    final room = widget.room;
    final localSide = room.localSide;
    if (localSide == null ||
        room.status != OnlineRoomStatus.active ||
        room.state.phase == MatchPhase.finished ||
        room.state.turn == localSide ||
        room.updatedAt <= 0) {
      return;
    }
    final elapsed = DateTime.now().millisecondsSinceEpoch - room.updatedAt;
    if (elapsed < SparkRoomClient.turnTimeout.inMilliseconds) return;

    _timeoutClaimInFlight = true;
    try {
      await AppServicesScope.of(context).online.claimPrivateRoomTimeout(
        roomCode: room.id,
        expectedRevision: room.revision,
      );
    } catch (_) {
      // Another client may have moved or claimed the timeout first. The room
      // stream will deliver the authoritative state shortly.
    } finally {
      _timeoutClaimInFlight = false;
    }
  }

  Future<void> _stopMatchIntro({bool closing = false}) async {
    if (_matchIntroStopped) {
      if (closing) await _matchAudio?.matchClosed();
      return;
    }
    _matchIntroStopped = true;
    final starting = _matchIntroFuture;
    if (starting == null) {
      if (closing) await _matchAudio?.matchClosed();
      return;
    }
    try {
      await starting;
      if (closing) {
        await _matchAudio?.matchClosed();
      } else {
        await _matchAudio?.matchReady();
      }
    } catch (_) {
      // Optional audio never blocks an online match.
    }
  }

  Future<void> _requestOnlineRematch() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final room = await AppServicesScope.of(
        context,
      ).online.createPrivateRoom(widget.room.gameId);
      if (mounted) context.go(AppRoutes.onlineRoom(room.id));
    } catch (_) {
      if (mounted) {
        showAppNotice(
          context,
          AppLocalizations.of(context).onlineRoomUnavailable,
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _openOnlineGameOptions() async {
    final room = widget.room;
    if (_gameOptionsOpen || room.status != OnlineRoomStatus.active) return;
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
      if (!mounted || confirmed != true) return;
      setState(() => _submitting = true);
      await AppServicesScope.of(context).online.resignPrivateRoom(
        roomCode: room.id,
        expectedRevision: room.revision,
      );
    } catch (_) {
      if (mounted) {
        showAppNotice(context, AppLocalizations.of(context).onlineMoveFailed);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
      _gameOptionsOpen = false;
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    unawaited(_stopMatchIntro(closing: true));
    super.dispose();
  }

  Future<void> _tapPoint(int point) async {
    final room = widget.room;
    final side = room.localSide;
    final l10n = AppLocalizations.of(context);
    if (_submitting || side == null || room.status != OnlineRoomStatus.active) {
      return;
    }
    if (room.state.turn != side) return;

    OnlineMoveCommand? command;
    final state = room.state;
    if (state.pendingCaptureBy != null) {
      if (MorrisRules.capturablePoints(
        GameCatalog.byId(room.gameId),
        state,
      ).contains(point)) {
        command = OnlineMoveCommand.capture(point);
      }
    } else if (state.phase == MatchPhase.placement) {
      if (state.board[point] == null) command = OnlineMoveCommand.place(point);
    } else if (state.phase == MatchPhase.movement) {
      if (state.board[point] == side) {
        setState(() => _selectedPoint = point);
        return;
      }
      final from = _selectedPoint;
      if (from != null) {
        final legalTargets = MorrisRules.legalMovesFrom(
          GameCatalog.byId(room.gameId),
          state,
          from,
        );
        if (state.board[point] != null) {
          showAppNotice(
            context,
            moveErrorText(l10n, MoveErrorCode.targetOccupied),
          );
        } else if (!legalTargets.contains(point)) {
          // Previously this branch returned silently, which looked like a
          // frozen board after the user selected a stone. Explain the rule
          // while preserving the selection so a legal target can be tapped.
          showAppNotice(
            context,
            moveErrorText(l10n, MoveErrorCode.notAdjacent),
          );
        } else {
          command = OnlineMoveCommand.move(from: from, to: point);
        }
      }
    }

    if (command == null) return;
    setState(() => _submitting = true);
    try {
      await AppServicesScope.of(context).online
          .submitRoomMove(
            roomCode: room.id,
            expectedRevision: room.revision,
            command: command,
          )
          .timeout(_moveRequestTimeout);
      if (mounted) setState(() => _selectedPoint = null);
    } catch (_) {
      if (mounted) {
        showAppNotice(context, AppLocalizations.of(context).onlineMoveFailed);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _closeRoom() async {
    final room = widget.room;
    final isFinished = room.state.phase == MatchPhase.finished;
    if (room.status == OnlineRoomStatus.active &&
        !isFinished &&
        room.localSide != null) {
      try {
        await AppServicesScope.of(context).online.resignPrivateRoom(
          roomCode: room.id,
          expectedRevision: room.revision,
        );
      } catch (_) {
        // Returning home remains safe if a brief connection loss prevents the
        // forfeit from reaching Firebase.
      }
    }
    if (isFinished) {
      await FamilyAds.showAtMatchEnd();
    }
    if (mounted) context.go(AppRoutes.home);
  }

  Future<void> _handleExitIntent() async {
    final room = widget.room;
    if (room.state.phase == MatchPhase.finished || _allowPop) {
      await _closeRoom();
      return;
    }
    if (_exitDialogOpen) return;
    _exitDialogOpen = true;
    try {
      final l10n = AppLocalizations.of(context);
      final confirmed = await showAppActionDialog<bool>(
        context: context,
        title: l10n.exitMatch,
        message: l10n.exitMatchConfirm,
        actions: [
          AppDialogAction(label: l10n.cancel, value: false),
          AppDialogAction(label: l10n.exitMatch, value: true, primary: true),
        ],
      );
      if (!mounted || confirmed != true) return;
      _allowPop = true;
      await _closeRoom();
    } finally {
      _exitDialogOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final l10n = AppLocalizations.of(context);
    final services = AppServicesScope.of(context);
    final settings = services.settings.state;
    final definition = GameCatalog.byId(room.gameId);
    final state = room.state;
    final localSide = room.localSide!;
    final isMyTurn =
        room.status == OnlineRoomStatus.active &&
        state.turn == localSide &&
        !_submitting;
    final currentInstruction =
        state.phase == MatchPhase.finished
            ? instructionText(l10n, state)
            : isMyTurn
            ? instructionText(l10n, state)
            : l10n.onlineWaitingTurn;
    final lastActor =
        room.lastMoveBy == room.hostUid
            ? PlayerSide.light
            : room.lastMoveBy == room.guestUid
            ? PlayerSide.dark
            : null;
    final capturesLight =
        definition.piecesPerPlayer -
        state.lightToPlace -
        state.stonesOnBoard(PlayerSide.light);
    final capturesDark =
        definition.piecesPerPlayer -
        state.darkToPlace -
        state.stonesOnBoard(PlayerSide.dark);

    final finished = state.phase == MatchPhase.finished;
    final localWon = !state.isDraw && state.winner == localSide;
    return PopScope(
      canPop: finished || _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !finished) unawaited(_handleExitIntent());
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppScreenShell(
            title: gameName(l10n, room.gameId),
            scrollable: false,
            maxWidth: AppConstraints.boardMaxWidth,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
            actions: [
              IconButton(
                tooltip: l10n.exitMatch,
                onPressed: _handleExitIntent,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
            bottomNavigationBar: const FamilyBannerAd(reserveSpace: true),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MatchPlayerBar(
                  compact: true,
                  name:
                      localSide == PlayerSide.dark
                          ? l10n.you
                          : l10n.onlineOpponent,
                  side: PlayerSide.dark,
                  active:
                      state.turn == PlayerSide.dark &&
                      state.phase != MatchPhase.finished,
                  stonesOnBoard: state.stonesOnBoard(PlayerSide.dark),
                  stonesToPlace: state.darkToPlace,
                  reduceMotion: settings.reduceMotion,
                ),
                const SizedBox(height: 6),
                _TurnBanner(
                  status: currentInstruction,
                  moveCount: room.revision,
                  submitting: _submitting,
                  compact: true,
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: MorrisBoard(
                        definition: definition,
                        board: state.board,
                        selectedPoint: _selectedPoint,
                        legalTargets:
                            _selectedPoint == null
                                ? const <int>{}
                                : MorrisRules.legalMovesFrom(
                                  definition,
                                  state,
                                  _selectedPoint!,
                                ),
                        capturablePoints: MorrisRules.capturablePoints(
                          definition,
                          state,
                        ),
                        activeMillPoints: MorrisRules.allMillPoints(
                          definition,
                          state.board,
                          PlayerSide.light,
                        )..addAll(
                          MorrisRules.allMillPoints(
                            definition,
                            state.board,
                            PlayerSide.dark,
                          ),
                        ),
                        lastMoveFrom:
                            room.lastFrom != null && room.lastFrom! >= 0
                                ? room.lastFrom
                                : null,
                        lastMoveTo:
                            room.lastTo != null && room.lastTo! >= 0
                                ? room.lastTo
                                : null,
                        lastMoveActor: lastActor,
                        capturedLight: capturesLight < 0 ? 0 : capturesLight,
                        capturedDark: capturesDark < 0 ? 0 : capturesDark,
                        moveSequence: room.revision,
                        moveDuration: MotionTokens.board,
                        interactive: isMyTurn,
                        reduceMotion: settings.reduceMotion,
                        showHints: settings.showMoveHints,
                        colorAssist: settings.colorAssist,
                        surface: settings.boardSurface,
                        viewStyle: settings.boardView,
                        pieceTheme: settings.pieceTheme,
                        onPointTap: _tapPoint,
                        semanticLabelBuilder:
                            (point, piece) => switch (piece) {
                              PlayerSide.light => l10n.boardPointLight(
                                point + 1,
                              ),
                              PlayerSide.dark => l10n.boardPointDark(point + 1),
                              null => l10n.boardPointEmpty(point + 1),
                            },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                MatchPlayerBar(
                  compact: true,
                  name:
                      localSide == PlayerSide.light
                          ? l10n.you
                          : l10n.onlineOpponent,
                  side: PlayerSide.light,
                  active:
                      state.turn == PlayerSide.light &&
                      state.phase != MatchPhase.finished,
                  stonesOnBoard: state.stonesOnBoard(PlayerSide.light),
                  stonesToPlace: state.lightToPlace,
                  reduceMotion: settings.reduceMotion,
                ),
                SizedBox(
                  height: 40,
                  child:
                      finished
                          ? Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.isDraw
                                      ? l10n.resultDrawPraise
                                      : localWon
                                      ? l10n.resultVictoryPraise
                                      : l10n.resultDefeatPraise,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              TextButton(
                                onPressed: _handleExitIntent,
                                child: Text(l10n.home),
                              ),
                              FilledButton(
                                onPressed:
                                    _submitting ? null : _requestOnlineRematch,
                                child: Text(l10n.rematch),
                              ),
                            ],
                          )
                          : Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton.icon(
                              onPressed:
                                  _submitting ? null : _openOnlineGameOptions,
                              icon: const Icon(Icons.more_horiz_rounded),
                              label: Text(l10n.gameOptions),
                            ),
                          ),
                ),
              ],
            ),
          ),
          if (finished && localWon && !settings.reduceMotion)
            const Positioned.fill(child: MatchConfetti()),
        ],
      ),
    );
  }
}

class _TurnBanner extends StatelessWidget {
  const _TurnBanner({
    required this.status,
    required this.moveCount,
    required this.submitting,
    this.compact = false,
  });

  final String status;
  final int moveCount;
  final bool submitting;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    height: compact ? 42 : null,
    constraints: compact ? null : const BoxConstraints(minHeight: 52),
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 8 : 12,
      vertical: compact ? 4 : 8,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadii.medium),
    ),
    child: Row(
      children: [
        if (submitting)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          Icon(Icons.sync_rounded, size: compact ? 17 : 24),
        SizedBox(width: compact ? 6 : AppSpacing.sm),
        Expanded(
          child: Text(
            status,
            maxLines: compact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(moveCount.toString()),
      ],
    ),
  );
}

class _RoomProblem extends StatelessWidget {
  const _RoomProblem({required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => AppScreenShell(
    title: title,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 44),
          const SizedBox(height: AppSpacing.md),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(AppLocalizations.of(context).home),
          ),
        ],
      ),
    ),
  );
}
