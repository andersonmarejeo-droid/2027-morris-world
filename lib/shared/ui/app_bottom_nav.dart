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
    final items = <(AppNavTab, IconData, IconData, String, String)>[
      (
        AppNavTab.home,
        Icons.home_rounded,
        Icons.home_outlined,
        l10n.home,
        AppRoutes.home,
      ),
      (
        AppNavTab.friends,
        Icons.people_alt_rounded,
        Icons.people_alt_outlined,
        l10n.friends,
        AppRoutes.friends,
      ),
      (
        AppNavTab.rankings,
        Icons.emoji_events_rounded,
        Icons.emoji_events_outlined,
        l10n.rankings,
        AppRoutes.rankings,
      ),
      (
        AppNavTab.profile,
        Icons.person_rounded,
        Icons.person_outline_rounded,
        l10n.profile,
        AppRoutes.profile,
      ),
      (
        AppNavTab.settings,
        Icons.settings_rounded,
        Icons.settings_outlined,
        l10n.settings,
        AppRoutes.settings,
      ),
    ];

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Center(
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
                  color: AppColors.darkOrange.withValues(alpha: 0.40),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkOrange.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.scrim.withValues(
                      alpha: AppElevation.floatingShadow,
                    ),
                    blurRadius: AppElevation.blurLarge,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    for (final item in items)
                      Expanded(
                        child: _NavButton(
                          tab: item.$1,
                          filledIcon: item.$2,
                          outlinedIcon: item.$3,
                          label: item.$4,
                          selected: active == item.$1,
                          onTap: () {
                            if (active != item.$1) context.go(item.$5);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.tab,
    required this.filledIcon,
    required this.outlinedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final AppNavTab tab;
  final IconData filledIcon;
  final IconData outlinedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations == true;
    final duration = reduceMotion ? Duration.zero : MotionTokens.fast;

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
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedContainer(
              duration: duration,
              curve: MotionTokens.curve,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              decoration: BoxDecoration(
                color:
                    selected
                        ? AppColors.darkOrange.withValues(alpha: 0.10)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadii.medium),
                border: Border.all(
                  color:
                      selected
                          ? AppColors.darkOrange.withValues(alpha: 0.55)
                          : Colors.transparent,
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? filledIcon : outlinedIcon,
                    color: selected ? AppColors.darkOrange : AppColors.inkMuted,
                    size: 21,
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:
                            selected ? AppColors.darkOrange : AppColors.inkMuted,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedContainer(
                    duration: duration,
                    width: selected ? 14 : 0,
                    height: 2,
                    decoration: BoxDecoration(
                      color:
                          selected ? AppColors.darkOrange : Colors.transparent,
                      borderRadius: BorderRadius.circular(1),
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
}
