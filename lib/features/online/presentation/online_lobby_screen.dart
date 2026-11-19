import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/match/match_models.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';

class OnlineLobbyScreen extends StatefulWidget {
  const OnlineLobbyScreen({super.key, required this.gameId});
  final MorrisGameId gameId;

  @override
  State<OnlineLobbyScreen> createState() => _OnlineLobbyScreenState();
}

class _OnlineLobbyScreenState extends State<OnlineLobbyScreen> {
  bool _searching = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_started) unawaited(_startSearch());
    });
  }

  void _playAgainstComputer() {
    if (!mounted) return;
    final config = MatchConfig(
      sessionId: MatchIds.create(),
      gameId: widget.gameId,
      mode: MatchMode.offlineAi,
      difficulty: AiDifficulty.medium,
    );
    // Replace the failed online route so the back button cannot return to a
    // lobby that has already reported that no opponent is available.
    context.go(AppRoutes.play(config, fresh: true));
  }

  Future<void> _fallbackToComputer(String message) async {
    if (!mounted) return;
    showAppNotice(context, message);
    await Future<void>.delayed(AppTimeouts.lobbyFallback);
    if (mounted) _playAgainstComputer();
  }

  Future<void> _startSearch() async {
    if (_started || !mounted) return;
    _started = true;
    setState(() => _searching = true);
    try {
      final gateway = AppServicesScope.of(context).online;
      final availability = await gateway.availability();
      if (!availability.enabled) {
        throw StateError(availability.reason ?? 'online-unavailable');
      }
      final roomCode = await gateway.createQuickMatch(widget.gameId);
      if (mounted) context.go(AppRoutes.onlineRoom(roomCode));
    } catch (_) {
      if (mounted) {
        await _fallbackToComputer(
          AppLocalizations.of(context).genericLoadError,
        );
      }
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreenShell(
      title: l10n.onlineArena,
      scrollable: false,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ArenaHero(gameName: gameName(l10n, widget.gameId), l10n: l10n),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(strokeWidth: 3.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.quickMatch,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.onlineSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      OutlinedButton.icon(
                        onPressed: _searching ? _playAgainstComputer : null,
                        icon: const Icon(Icons.smart_toy_rounded),
                        label: Text(l10n.computerModeTitle),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArenaHero extends StatelessWidget {
  const _ArenaHero({required this.gameName, required this.l10n});
  final String gameName;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF174B48), Color(0xFF0D302F)],
      ),
      borderRadius: BorderRadius.circular(AppRadii.large),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.public_rounded, size: 26, color: Colors.white),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                gameName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.onlineSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
