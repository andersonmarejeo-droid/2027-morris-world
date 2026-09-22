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
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            child: Text(
              entry.rank.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: entry.rank <= 3 ? AppColors.brandDeep : AppColors.ink,
              ),
            ),
          ),
          CircleAvatar(
            radius: 19,
            child: Text(entry.player.name.characters.first),
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
          Text(
            entry.player.rating.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    ),
  );
}
