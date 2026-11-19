import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_tokens.dart';
import '../../../core/diagnostics/runtime_trace.dart';
import '../../../core/family_ads.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';
import '../../../core/match/match_models.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';

class GameModeScreen extends StatefulWidget {
  const GameModeScreen({super.key, required this.gameId});
  final MorrisGameId gameId;

  @override
  State<GameModeScreen> createState() => _GameModeScreenState();
}

class _GameModeScreenState extends State<GameModeScreen> {
  @override
  void initState() {
    super.initState();
    // If consent is required, let the user handle it before a match begins.
    // With no production ad IDs configured this is a no-op.
    unawaited(FamilyAds.initialize());
  }

  @override
  Widget build(BuildContext context) {
    RuntimeTrace.install();
    final l10n = AppLocalizations.of(context);
    final title = gameName(l10n, widget.gameId);
    final definition = GameCatalog.byId(widget.gameId);
    final emptyBoard = List<PlayerSide?>.filled(
      definition.board.pointCount,
      null,
    );

    return AppScreenShell(
      title: title,
      tone: AppScreenTone.brand,
      scrollable: false,
      maxWidth: AppConstraints.compactMaxWidth,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      actions: [
        IconButton(
          tooltip: l10n.howToPlay,
          onPressed: () => context.push(AppRoutes.tutorial(widget.gameId)),
          icon: const Icon(Icons.school_outlined, color: Colors.white),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ModeCompactHeader(
            title: title,
            subtitle: l10n.offlineSubtitle,
            board: MorrisBoard(
              definition: definition,
              board: emptyBoard,
              onPointTap: (_) {},
              interactive: false,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: _ModeTile(
              icon: Icons.smart_toy_rounded,
              title: l10n.computerModeTitle,
              subtitle: l10n.computerModeSubtitle,
              onTap: () => _chooseComputerDifficulty(context, l10n),
              accent: AppColors.target,
              featured: true,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: _ModeTile(
              icon: Icons.people_alt_rounded,
              title: l10n.sameDevice,
              subtitle: l10n.sameDeviceSubtitle,
              onTap: () => _startSameDevice(context),
              accent: AppColors.selection,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: _ModeTile(
              icon: Icons.public_rounded,
              title: l10n.online,
              subtitle: l10n.onlineSubtitle,
              onTap: () => context.push(AppRoutes.online(widget.gameId)),
              accent: AppColors.brandDeep,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: _ModeTile(
              icon: Icons.sports_esports_rounded,
              title: l10n.challenge,
              subtitle: l10n.challengeSubtitle,
              onTap: () => context.push(AppRoutes.friendsForGame(widget.gameId)),
              accent: AppColors.zpOrange,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseComputerDifficulty(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    RuntimeTrace.startScenario(
      'offline_ai.select_difficulty',
      data: <String, Object?>{'game': widget.gameId.name},
    );
    RuntimeTrace.mark('difficulty.sheet.open.request');

    final difficulty = await RuntimeTrace.measureAsync(
      'difficulty.sheet.open_to_close',
      () => showAppBottomSheet<AiDifficulty>(
        context: context,
        builder:
            (sheetContext) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.offlineDifficultyTitle,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.aiFoundationNotice,
                  style: Theme.of(sheetContext).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final difficulty in AiDifficulty.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: OutlinedButton.icon(
                      onPressed:
                          () => closeAppOverlay(sheetContext, difficulty),
                      icon: const Icon(Icons.smart_toy_outlined),
                      label: Text(_difficultyName(l10n, difficulty)),
                    ),
                  ),
              ],
            ),
      ),
    );

    RuntimeTrace.mark(
      'difficulty.sheet.closed',
      data: <String, Object?>{'difficulty': difficulty?.name},
    );
    if (difficulty == null || !context.mounted) return;

    await Future<void>.delayed(Duration.zero);
    if (!context.mounted) return;

    RuntimeTrace.setPhase('offline_ai.route_push');
    final config = MatchConfig(
      sessionId: MatchIds.create(),
      gameId: widget.gameId,
      mode: MatchMode.offlineAi,
      difficulty: difficulty,
    );
    RuntimeTrace.mark(
      'play.push.before',
      data: <String, Object?>{
        'game': widget.gameId.name,
        'mode': config.mode.name,
        'difficulty': difficulty.name,
      },
    );
    await context.push(AppRoutes.play(config, fresh: true));
    RuntimeTrace.mark('play.push.returned');
  }

  Future<void> _startSameDevice(BuildContext context) async {
    RuntimeTrace.startScenario(
      'local_two_player.start',
      data: <String, Object?>{'game': widget.gameId.name},
    );
    RuntimeTrace.setPhase('local_two_player.route_push');
    final config = MatchConfig(
      sessionId: MatchIds.create(),
      gameId: widget.gameId,
      mode: MatchMode.localTwoPlayer,
    );
    RuntimeTrace.mark(
      'play.push.before',
      data: <String, Object?>{
        'game': widget.gameId.name,
        'mode': config.mode.name,
      },
    );
    await context.push(AppRoutes.play(config, fresh: true));
    RuntimeTrace.mark('play.push.returned');
  }

  String _difficultyName(AppLocalizations l10n, AiDifficulty difficulty) =>
      switch (difficulty) {
        AiDifficulty.beginner => l10n.beginner,
        AiDifficulty.easy => l10n.easy,
        AiDifficulty.medium => l10n.medium,
        AiDifficulty.hard => l10n.hard,
        AiDifficulty.master => l10n.master,
      };
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.accent,
    this.featured = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accent;
  final bool featured;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: featured ? 3 : 1,
    shadowColor: AppColors.ink.withValues(alpha: 0.18),
    borderRadius: BorderRadius.circular(AppRadii.large),
    child: InkWell(
      borderRadius: BorderRadius.circular(AppRadii.large),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.large),
          border: Border.all(
            color: featured ? AppColors.darkOrange : AppColors.darkOrange.withValues(alpha: 0.35),
            width: featured ? 1.8 : 1.1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.inkMuted,
                      fontSize: 11,
                      height: 1.18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: featured ? accent : AppColors.ink,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ModeCompactHeader extends StatelessWidget {
  const _ModeCompactHeader({
    required this.title,
    required this.subtitle,
    required this.board,
  });

  final String title;
  final String subtitle;
  final Widget board;

  @override
  Widget build(BuildContext context) => Container(
    height: 62,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(AppRadii.large),
      border: Border.all(color: AppColors.darkOrange.withValues(alpha: 0.45), width: 1.2),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: board,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.90),
                  fontSize: 11,
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
