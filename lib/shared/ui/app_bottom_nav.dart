import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../app/app_colors.dart';
import '../../app/app_routes.dart';
import '../../app/app_tokens.dart';
import '../../core/feedback/motion_tokens.dart';

enum AppNavTab { home, friends, rankings, profile, settings }

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.active});

  final AppNavTab active;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <(AppNavTab, IconData, String, String)>[
      (AppNavTab.home, Icons.home_rounded, l10n.home, AppRoutes.home),
      (AppNavTab.friends, Icons.people_alt_rounded, l10n.friends, AppRoutes.friends),
      (AppNavTab.rankings, Icons.emoji_events_rounded, l10n.rankings, AppRoutes.rankings),
      (AppNavTab.profile, Icons.person_rounded, l10n.profile, AppRoutes.profile),
      (AppNavTab.settings, Icons.settings_rounded, l10n.settings, AppRoutes.settings),
    ];

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: Colors.white.withValues(alpha: 0.96),
        elevation: 10,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(AppRadii.large),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scaledLabel = MediaQuery.textScalerOf(context).scale(11);
            final showLabels = constraints.maxWidth >= 430 && scaledLabel <= 13.5;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Row(
                children: [
                  for (final item in items)
                    Expanded(
                      child: _NavButton(
                        icon: item.$2,
                        label: item.$3,
                        selected: active == item.$1,
                        showLabel: showLabels,
                        onTap: () {
                          if (active != item.$1) context.go(item.$4);
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.showLabel,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? Colors.white : AppColors.inkMuted;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: MotionTokens.fast,
                  width: showLabel ? 40 : 48,
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.ink : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                  ),
                  child: Icon(icon, color: iconColor, size: 23),
                ),
                if (showLabel) ...[
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: selected ? AppColors.ink : AppColors.inkMuted,
                          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
