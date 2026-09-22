import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/online/online_match_gateway.dart';
import '../../../shared/ui/app_async_view.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';

class OnlineLobbyScreen extends StatelessWidget {
  const OnlineLobbyScreen({super.key, required this.gameId});
  final MorrisGameId gameId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final services = AppServicesScope.of(context);
    return AppScreenShell(
      title: l10n.onlineArena,
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ArenaHero(gameName: gameName(l10n, gameId), l10n: l10n),
          const SizedBox(height: AppSpacing.lg),
          AppAsyncView<OnlineAvailability>(
            future: services.online.availability(),
            errorBuilder: (context) => AppErrorView(message: l10n.genericLoadError),
            dataBuilder: (context, availability) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: availability.enabled
                      ? () async {
                          try {
                            await services.online.createQuickMatch(gameId);
                          } catch (_) {
                            if (context.mounted) {
                              showAppNotice(context, l10n.onlineBackendRequired);
                            }
                          }
                        }
                      : null,
                  icon: const Icon(Icons.flash_on_rounded),
                  label: Text(l10n.quickMatch),
                ),
                if (!availability.enabled) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _BackendNotice(text: l10n.onlineBackendRequired),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.friends),
            icon: const Icon(Icons.group_rounded),
            label: Text(l10n.challengeFriends),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.rankings),
            icon: const Icon(Icons.emoji_events_rounded),
            label: Text(l10n.viewRankings),
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
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brandTop, AppColors.brandDeep],
          ),
          borderRadius: BorderRadius.circular(AppRadii.large),
        ),
        child: Column(
          children: [
            const Icon(Icons.public_rounded, size: 48, color: Colors.white),
            const SizedBox(height: AppSpacing.md),
            Text(
              gameName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.onlineArenaSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
            ),
          ],
        ),
      );
}

class _BackendNotice extends StatelessWidget {
  const _BackendNotice({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.brandDeep),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
          ],
        ),
      );
}
