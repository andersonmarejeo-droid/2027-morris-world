import 'package:flutter/material.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/feedback/motion_tokens.dart';
import '../../../shared/ui/app_async_view.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../domain/friend_player.dart';

enum _RankingTab { world, country, friends }

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  _RankingTab tab = _RankingTab.world;

  Future<List<LeaderboardEntry>> _load() {
    final social = AppServicesScope.of(context).social;
    return switch (tab) {
      _RankingTab.world => social.getWorldLeaderboard(),
      _RankingTab.country => social.getCountryLeaderboard(),
      _RankingTab.friends => social.getFriendsLeaderboard(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreenShell(
      title: l10n.rankings,
      scrollable: true,
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.rankings),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RankingsHero(
            title: l10n.rankings,
            scope: switch (tab) {
              _RankingTab.world => l10n.world,
              _RankingTab.country => l10n.country,
              _RankingTab.friends => l10n.friends,
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _RankingTabs(
            selected: tab,
            worldLabel: l10n.world,
            countryLabel: l10n.country,
            friendsLabel: l10n.friends,
            onChanged: (value) {
              if (value == tab) {
                return;
              }
              setState(() {
                tab = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          AppAsyncView<List<LeaderboardEntry>>(
            key: ValueKey(tab),
            future: _load(),
            errorBuilder:
                (context) => AppErrorView(message: l10n.genericLoadError),
            dataBuilder:
                (context, entries) => Column(
                  children: [
                    for (final entry in entries) ...[
                      _RankingRow(entry: entry, l10n: l10n),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
          ),
        ],
      ),
    );
  }
}

class _RankingTabs extends StatelessWidget {
  const _RankingTabs({
    required this.selected,
    required this.worldLabel,
    required this.countryLabel,
    required this.friendsLabel,
    required this.onChanged,
  });

  final _RankingTab selected;
  final String worldLabel;
  final String countryLabel;
  final String friendsLabel;
  final ValueChanged<_RankingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <(_RankingTab, String, IconData)>[
      (_RankingTab.world, worldLabel, Icons.public_rounded),
      (_RankingTab.country, countryLabel, Icons.flag_rounded),
      (_RankingTab.friends, friendsLabel, Icons.people_alt_rounded),
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: _RankingTabButton(
                label: item.$2,
                icon: item.$3,
                selected: selected == item.$1,
                onTap: () => onChanged(item.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _RankingsHero extends StatelessWidget {
  const _RankingsHero({required this.title, required this.scope});

  final String title;
  final String scope;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.ink, AppColors.brandDeep],
      ),
      borderRadius: BorderRadius.circular(AppRadii.large),
    ),
    child: Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: AppColors.selection,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: AppColors.ink,
            size: 30,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Text(
                  scope,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RankingTabButton extends StatelessWidget {
  const _RankingTabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : AppColors.ink;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        onTap: onTap,
        child: AnimatedContainer(
          duration: MotionTokens.fast,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: foreground),
              const SizedBox(width: 4),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: foreground,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({required this.entry, required this.l10n});
  final LeaderboardEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final podiumColor = _podiumColor(entry.rank);
    final initial =
        entry.player.name.trim().isEmpty
            ? '?'
            : entry.player.name.trim().characters.first.toUpperCase();
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.large),
          border:
              entry.rank <= 3
                  ? Border.all(
                    color: podiumColor.withValues(alpha: 0.7),
                    width: 1.5,
                  )
                  : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      entry.rank <= 3
                          ? podiumColor.withValues(alpha: 0.18)
                          : AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child:
                    entry.rank <= 3
                        ? Icon(
                          Icons.emoji_events_rounded,
                          color: podiumColor,
                          size: 21,
                        )
                        : Text(
                          entry.rank.toString(),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
              ),
              const SizedBox(width: AppSpacing.sm),
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.brandSoft,
                foregroundColor: AppColors.brandDeep,
                child: Text(initial),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.recordValue(entry.wins, entry.losses),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.bolt_rounded, color: podiumColor, size: 17),
                  Text(
                    entry.player.rating.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
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

  Color _podiumColor(int rank) => switch (rank) {
    1 => AppColors.selection,
    2 => AppColors.inkMuted,
    3 => AppColors.zpOrange,
    _ => AppColors.brandDeep,
  };
}
