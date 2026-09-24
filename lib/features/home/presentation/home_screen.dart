import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';
import '../../../core/match/match_models.dart';
import '../../../shared/ui/app_async_view.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';
import '../../social/application/challenge_share_service.dart';
import '../../social/domain/friend_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _challengeFriends(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final selected = await showAppBottomSheet<MorrisGameId>(
      context: context,
      builder:
          (sheetContext) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.challengeFriends,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.challengeSubtitle),
              const SizedBox(height: AppSpacing.lg),
              for (final id in MorrisGameId.values) ...[
                FilledButton.tonalIcon(
                  onPressed: () => closeAppOverlay(sheetContext, id),
                  icon: const Icon(Icons.sports_esports_rounded),
                  label: Text(gameName(l10n, id)),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              TextButton(
                onPressed: () => closeAppOverlay<MorrisGameId>(sheetContext),
                child: Text(l10n.cancel),
              ),
            ],
          ),
    );

    if (selected == null || !context.mounted) {
      return;
    }

    final game = gameName(l10n, selected);
    final link = ChallengeShareService.storeLink(selected);
    final message = l10n.whatsappChallengeInvite(game, link);
    final opened = await ChallengeShareService.shareOnWhatsApp(message);
    if (!opened && context.mounted) {
      showAppNotice(context, l10n.genericLoadError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final services = AppServicesScope.of(context);
    return AppScreenShell(
      tone: AppScreenTone.brand,
      scrollable: true,
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.home),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 122),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppAsyncView<PlayerProfile>(
            future: services.social.getLocalProfile(),
            errorBuilder:
                (context) => _ProfileStrip(
                  l10n: l10n,
                  name: l10n.guestPlayer,
                  subtitle: l10n.localProfile,
                ),
            dataBuilder:
                (context, profile) => _ProfileStrip(
                  l10n: l10n,
                  name: profile.name,
                  subtitle: l10n.countryProfile(profile.countryCode),
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppAsyncView<MatchSession?>(
            future: services.matchSessions.getMostRecentActive(),
            errorBuilder:
                (context) => AppErrorView(message: l10n.matchLoadError),
            dataBuilder:
                (context, session) =>
                    session == null
                        ? const SizedBox.shrink()
                        : Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _ContinueCard(session: session, l10n: l10n),
                        ),
          ),
          _HomeSectionHeader(
            title: l10n.selectGameTitle,
            subtitle: l10n.selectGameSubtitle,
          ),
          const SizedBox(height: AppSpacing.lg),
          _GameCard(
            id: MorrisGameId.three,
            title: l10n.game3Name,
            subtitle: l10n.game3Description,
          ),
          const SizedBox(height: AppSpacing.sm),
          _GameCard(
            id: MorrisGameId.nine,
            title: l10n.game9Name,
            subtitle: l10n.game9Description,
            emphasized: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _GameCard(
            id: MorrisGameId.twelve,
            title: l10n.game12Name,
            subtitle: l10n.game12Description,
          ),
          const SizedBox(height: AppSpacing.md),
          _ChallengeCard(
            title: l10n.challengeFriends,
            subtitle: l10n.challengeSubtitle,
            onTap: () => _challengeFriends(context, l10n),
          ),
        ],
      ),
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  const _HomeSectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.md,
    ),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.white.withValues(alpha: 0.9), width: 3),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    ),
  );
}

class _ProfileStrip extends StatelessWidget {
  const _ProfileStrip({
    required this.l10n,
    required this.name,
    required this.subtitle,
  });

  final AppLocalizations l10n;
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: 0.14),
    borderRadius: BorderRadius.circular(AppRadii.large),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.push(AppRoutes.profile),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: l10n.settings,
            onPressed: () => context.push(AppRoutes.settings),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.92),
              foregroundColor: AppColors.ink,
            ),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
    ),
  );
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.session, required this.l10n});
  final MatchSession session;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.selection.withValues(alpha: 0.94),
    borderRadius: BorderRadius.circular(AppRadii.large),
    child: InkWell(
      borderRadius: BorderRadius.circular(AppRadii.large),
      onTap: () => context.push(AppRoutes.play(session.config)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 19,
              backgroundColor: AppColors.ink,
              foregroundColor: Colors.white,
              child: Icon(Icons.play_arrow_rounded),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.continueMatch,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.continueMatchSubtitle(
                      gameName(l10n, session.config.gameId),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    ),
  );
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.id,
    required this.title,
    required this.subtitle,
    this.emphasized = false,
  });

  final MorrisGameId id;
  final String title;
  final String subtitle;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final definition = GameCatalog.byId(id);
    final emptyBoard = List<PlayerSide?>.filled(
      definition.board.pointCount,
      null,
    );
    return Material(
      color: Colors.white,
      elevation: emphasized ? 4 : 0,
      shadowColor: AppColors.ink.withValues(alpha: 0.28),
      borderRadius: BorderRadius.circular(AppRadii.large),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.large),
        onTap: () => context.push(AppRoutes.mode(id)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(
              color:
                  emphasized
                      ? AppColors.selection.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.35),
              width: emphasized ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: emphasized ? 96 : 88,
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          emphasized
                              ? const [AppColors.brandDeep, AppColors.brandTop]
                              : const [
                                AppColors.surfaceMuted,
                                AppColors.brandSoft,
                              ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      MorrisBoard(
                        definition: definition,
                        board: emptyBoard,
                        onPointTap: (_) {},
                        interactive: false,
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              emphasized
                                  ? Colors.white.withValues(alpha: 0.94)
                                  : AppColors.ink,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _gameCount(id),
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(
                            color: emphasized ? AppColors.ink : Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: emphasized ? AppColors.brandDeep : AppColors.ink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _gameCount(MorrisGameId game) => switch (game) {
    MorrisGameId.three => '3',
    MorrisGameId.nine => '9',
    MorrisGameId.twelve => '12',
  };
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: 0.97),
    borderRadius: BorderRadius.circular(AppRadii.large),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.large),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.large),
          border: Border.all(color: AppColors.brandSoft, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.brandSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group_add_rounded,
                  color: AppColors.brandDeep,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
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
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
