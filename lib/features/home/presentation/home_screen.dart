import 'dart:async';

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
import '../../../core/settings/app_settings_models.dart';
import '../../../shared/ui/app_async_view.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';
import '../../social/application/challenge_share_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _challengeFriends(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final selectedGame = await showAppBottomSheet<MorrisGameId>(
      context: context,
      builder:
          (sheetContext) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.challenge,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.challengeSubtitle),
              const SizedBox(height: AppSpacing.md),
              for (final gameId in MorrisGameId.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: OutlinedButton(
                    onPressed: () => closeAppOverlay(sheetContext, gameId),
                    child: Text(gameName(l10n, gameId)),
                  ),
                ),
            ],
          ),
    );

    if (selectedGame == null || !context.mounted) return;

    final message = l10n.whatsappChallengeInvite(
      gameName(l10n, selectedGame),
      ChallengeShareService.closedTestingLink,
    );
    final opened = await ChallengeShareService.shareOnWhatsApp(message);
    if (!opened) {
      if (context.mounted) showAppNotice(context, l10n.genericLoadError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final services = AppServicesScope.of(context);
    return AppScreenShell(
      title: l10n.appTitle,
      tone: AppScreenTone.surface,
      scrollable: false,
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.home),
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
      actions: [
        IconButton(
          tooltip: l10n.profile,
          onPressed: () => context.push(AppRoutes.profile),
          icon: const Icon(Icons.person_rounded),
        ),
        IconButton(
          tooltip: l10n.settings,
          onPressed: () => context.push(AppRoutes.settings),
          icon: const Icon(Icons.settings_rounded),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    final lang = l10n.localeName.toLowerCase();
                    final challengeTitle = lang.startsWith('tr')
                        ? 'Meydan Oku'
                        : l10n.challengeFriends;
                    final challengeSub = lang.startsWith('tr')
                        ? 'Arkadaşınla oyna'
                        : l10n.challengeSubtitle;
                    return _ChallengeCard(
                      icon: Icons.chat_rounded,
                      iconBgColor: const Color(0xFF25D366),
                      borderColor: const Color(0xFF25D366).withValues(alpha: 0.6),
                      bgColor: const Color(0xFFE8F7EE).withValues(alpha: 0.45),
                      title: challengeTitle,
                      subtitle: challengeSub,
                      onTap: () => _challengeFriends(context, l10n),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final lang = l10n.localeName.toLowerCase();
                    final puzzleTitle = lang.startsWith('tr')
                        ? 'Taktik Arenası'
                        : lang.startsWith('de')
                        ? 'Taktik-Arena'
                        : lang.startsWith('es')
                        ? 'Arena Táctica'
                        : lang.startsWith('fr')
                        ? 'Arène Tactique'
                        : lang.startsWith('pt')
                        ? 'Arena Tática'
                        : lang.startsWith('ar')
                        ? 'ساحة التكتيك'
                        : lang.startsWith('hi')
                        ? 'रणनीति क्षेत्र'
                        : 'Tactics Arena';
                    final puzzleSubtitle = lang.startsWith('tr')
                        ? 'Taktik bulmaca'
                        : lang.startsWith('de')
                        ? 'Taktik-Rätsel'
                        : lang.startsWith('es')
                        ? 'Rompecabezas'
                        : lang.startsWith('fr')
                        ? 'Puzzle tactique'
                        : lang.startsWith('pt')
                        ? 'Enigma tático'
                        : lang.startsWith('ar')
                        ? 'ألغاز تكتيكية'
                        : lang.startsWith('hi')
                        ? 'रणनीतिक पहेली'
                        : 'Tactical puzzle';
                    return _ChallengeCard(
                      icon: Icons.psychology_rounded,
                      iconBgColor: AppColors.darkOrange,
                      borderColor: AppColors.darkOrange.withValues(alpha: 0.6),
                      bgColor: AppColors.darkOrange.withValues(alpha: 0.12),
                      title: puzzleTitle,
                      subtitle: puzzleSubtitle,
                      onTap: () => context.push(AppRoutes.puzzles),
                    );
                  },
                ),
              ),
            ],
          ),
          AppAsyncView<MatchSession?>(
            future: services.matchSessions.getMostRecentActive(),
            errorBuilder:
                (context) => AppErrorView(message: l10n.matchLoadError),
            dataBuilder:
                (context, session) =>
                    session == null
                        ? const SizedBox.shrink()
                        : Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: _ContinueCard(session: session, l10n: l10n),
                        ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _GameCard(
                      id: MorrisGameId.nine,
                      title: l10n.game9Name,
                      subtitle: l10n.game9Description,
                      emphasized: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _GameCard(
                      id: MorrisGameId.twelve,
                      title: l10n.game12Name,
                      subtitle: l10n.game12Description,
                    ),
                  ),
                ),
                Expanded(
                  child: _GameCard(
                    id: MorrisGameId.three,
                    title: l10n.game3Name,
                    subtitle: l10n.game3Description,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.session, required this.l10n});
  final MatchSession session;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final continueText =
        '${l10n.continueMatch}: ${gameName(l10n, session.config.gameId)}';
    return Material(
      color: AppColors.brandSoft.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(AppRadii.medium),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        onTap: () => context.push(AppRoutes.play(session.config)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.medium),
            border: Border.all(
              color: AppColors.darkOrange.withValues(alpha: 0.35),
              width: 1.1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.darkOrange,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.play_arrow_rounded, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    continueText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      height: 1.15,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.darkOrange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
      color: emphasized ? const Color(0xFFF5F8F2) : Colors.white,
      elevation: emphasized ? 1.5 : 0,
      shadowColor: AppColors.brandDeep.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadii.medium),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        onTap: () => context.push(AppRoutes.mode(id)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.medium),
            border: Border.all(
              color:
                  emphasized
                      ? AppColors.darkOrange
                      : AppColors.darkOrange.withValues(alpha: 0.38),
              width: emphasized ? 1.8 : 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: emphasized ? 96 : 88,
                  height: emphasized ? 96 : 88,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                    border: Border.all(
                      color:
                          emphasized
                              ? AppColors.darkOrange
                              : AppColors.darkOrange.withValues(alpha: 0.50),
                      width: emphasized ? 1.5 : 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Positioned.fill(
                        child: MorrisBoard(
                          definition: definition,
                          board: emptyBoard,
                          onPointTap: (_) {},
                          interactive: false,
                          showHints: false,
                          surface: BoardSurface.minimal,
                          viewStyle: BoardViewStyle.flat2d,
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              emphasized
                                  ? AppColors.darkOrange
                                  : AppColors.brandDeep,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _gameCount(id),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.inkMuted,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:
                        emphasized ? AppColors.darkOrange : AppColors.darkOrange.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: emphasized ? Colors.white : AppColors.darkOrange,
                    size: 22,
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
    required this.icon,
    required this.iconBgColor,
    required this.borderColor,
    required this.bgColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final Color borderColor;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppRadii.medium),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(color: borderColor, width: 1.5),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          fontSize: 12,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.inkMuted,
                          fontSize: 10,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
