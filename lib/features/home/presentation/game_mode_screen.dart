import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_tokens.dart';
import '../../../core/diagnostics/runtime_trace.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';
import '../../../core/match/match_models.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({super.key, required this.gameId});
  final MorrisGameId gameId;

  @override
  Widget build(BuildContext context) {
    RuntimeTrace.install();
    final l10n = AppLocalizations.of(context);
    final title = gameName(l10n, gameId);
    final definition = GameCatalog.byId(gameId);
    final emptyBoard = List<PlayerSide?>.filled(
      definition.board.pointCount,
      null,
    );

    return AppScreenShell(
      title: title,
      tone: AppScreenTone.brand,
      scrollable: true,
      maxWidth: AppConstraints.compactMaxWidth,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ModeHero(
            title: title,
            child: MorrisBoard(
              definition: definition,
              board: emptyBoard,
              onPointTap: (_) {},
              interactive: false,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.selectModeTitle(title),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.offlineSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _ModeTile(
            icon: Icons.public_rounded,
            title: l10n.online,
            subtitle: l10n.featureComingSoon(l10n.online),
            onTap: () => context.push(AppRoutes.online(gameId)),
            accent: AppColors.brandDeep,
            upcoming: true,
          ),
          _ModeTile(
            icon: Icons.sports_esports_rounded,
            title: l10n.challenge,
            subtitle: l10n.challengeSubtitle,
            onTap: () => context.push(AppRoutes.friendsForGame(gameId)),
            accent: AppColors.zpOrange,
          ),
          _ModeTile(
            icon: Icons.smart_toy_rounded,
            title: l10n.computerModeTitle,
            subtitle: l10n.computerModeSubtitle,
            onTap: () => _chooseComputerDifficulty(context, l10n),
            accent: AppColors.target,
            featured: true,
          ),
          _ModeTile(
            icon: Icons.people_alt_rounded,
            title: l10n.sameDevice,
            subtitle: l10n.sameDeviceSubtitle,
            onTap: () => _startSameDevice(context),
            accent: AppColors.selection,
          ),
          const SizedBox(height: AppSpacing.xs),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () => context.push(AppRoutes.tutorial(gameId)),
            icon: const Icon(Icons.school_outlined),
            label: Text(l10n.howToPlay),
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
      data: <String, Object?>{'game': gameId.name},
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
      gameId: gameId,
      mode: MatchMode.offlineAi,
      difficulty: difficulty,
    );
    RuntimeTrace.mark(
      'play.push.before',
      data: <String, Object?>{
        'game': gameId.name,
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
      data: <String, Object?>{'game': gameId.name},
    );
    RuntimeTrace.setPhase('local_two_player.route_push');
    final config = MatchConfig(
      sessionId: MatchIds.create(),
      gameId: gameId,
      mode: MatchMode.localTwoPlayer,
    );
    RuntimeTrace.mark(
      'play.push.before',
      data: <String, Object?>{'game': gameId.name, 'mode': config.mode.name},
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
    this.upcoming = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accent;
  final bool featured;
  final bool upcoming;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Material(
      color: Colors.white,
      elevation: featured ? 4 : 0,
      shadowColor: AppColors.ink.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(AppRadii.large),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.large),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(
              color: featured ? accent.withValues(alpha: 0.7) : AppColors.line,
              width: featured ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (upcoming) ...[
                            const SizedBox(width: AppSpacing.xs),
                            const Icon(
                              Icons.schedule_rounded,
                              color: AppColors.inkMuted,
                              size: 17,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: featured ? accent : AppColors.ink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ModeHero extends StatelessWidget {
  const _ModeHero({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    height: 206,
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadii.extraLarge),
      border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          left: AppSpacing.xs,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(width: 174, child: child),
      ],
    ),
  );
}
