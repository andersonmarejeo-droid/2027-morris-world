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
    final scheme = Theme.of(context).colorScheme;
    final items = <(AppNavTab, IconData, String, String)>[
      (AppNavTab.home, Icons.home_rounded, l10n.home, AppRoutes.home),
      (
        AppNavTab.friends,
        Icons.people_alt_rounded,
        l10n.friends,
        AppRoutes.friends,
      ),
      (
        AppNavTab.rankings,
        Icons.emoji_events_rounded,
        l10n.rankings,
        AppRoutes.rankings,
      ),
      (
        AppNavTab.profile,
        Icons.person_rounded,
        l10n.profile,
        AppRoutes.profile,
      ),
      (
        AppNavTab.settings,
        Icons.settings_rounded,
        l10n.settings,
        AppRoutes.settings,
      ),
    ];

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scaledLabel = MediaQuery.textScalerOf(context).scale(11);
          final showLabels = constraints.maxWidth >= 440 && scaledLabel <= 13.5;
          return Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppConstraints.navigationMaxWidth,
              ),
              child: Material(
                color: scheme.surface.withValues(alpha: 0.98),
                elevation: 0,
                shadowColor: Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadii.large),
                clipBehavior: Clip.antiAlias,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.large),
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.68),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.scrim.withValues(
                          alpha: AppElevation.floatingShadow,
                        ),
                        blurRadius: AppElevation.blurLarge,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xs,
                    ),
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
                  ),
                ),
              ),
            ),
          );
        },
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
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations == true;
    final duration = reduceMotion ? Duration.zero : MotionTokens.fast;
    final iconColor = selected ? scheme.onPrimary : scheme.onSurfaceVariant;

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
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: AnimatedContainer(
              duration: duration,
              curve: MotionTokens.curve,
              constraints: const BoxConstraints(
                minHeight: AppConstraints.minTapTarget,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: showLabel ? AppSpacing.xs : AppSpacing.sm,
                vertical: showLabel ? AppSpacing.xs : AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: selected ? scheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  if (showLabel) ...[
                    const SizedBox(height: 2),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:
                            selected
                                ? scheme.onPrimary
                                : scheme.onSurfaceVariant,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w700,
                      ),
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
