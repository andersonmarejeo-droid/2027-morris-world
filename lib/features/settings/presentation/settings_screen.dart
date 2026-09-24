import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_models.dart';
import '../../../core/settings/app_settings_models.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = AppServicesScope.of(context).settings;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutes.home);
        }
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final selected = controller.state.locale;
          final options = <(Locale?, String)>[
            (null, l10n.systemLanguage),
            (const Locale('tr'), l10n.languageTurkish),
            (const Locale('en'), l10n.languageEnglish),
            (const Locale('de'), l10n.languageGerman),
            (const Locale('es'), l10n.languageSpanish),
            (const Locale('fr'), l10n.languageFrench),
            (const Locale('pt', 'BR'), l10n.languagePortugueseBrazil),
            (const Locale('ar'), l10n.languageArabic),
            (const Locale('hi'), l10n.languageHindi),
          ];
          return AppScreenShell(
            title: l10n.settings,
            scrollable: true,
            bottomNavigationBar: const AppBottomNav(active: AppNavTab.settings),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SettingsHeader(
                  title: l10n.settings,
                  subtitle: l10n.gameExperience,
                ),
                const SizedBox(height: AppSpacing.xl),
                _SettingsSection(
                  icon: Icons.translate_rounded,
                  title: l10n.language,
                  child: Card(
                    child: Column(
                      children:
                          options.map((option) {
                            final locale = option.$1;
                            final isSelected = locale == selected;
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              leading: Icon(
                                isSelected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                              ),
                              title: Text(option.$2),
                              trailing:
                                  isSelected
                                      ? Icon(
                                        Icons.check_rounded,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      )
                                      : null,
                              onTap:
                                  () =>
                                      locale == null
                                          ? controller.useSystemLanguage()
                                          : controller.setLocale(locale),
                            );
                          }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _SettingsSection(
                  icon: Icons.tune_rounded,
                  title: l10n.gameExperience,
                  child: Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          title: Text(l10n.sound),
                          value: controller.state.soundEnabled,
                          onChanged: controller.setSoundEnabled,
                        ),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          title: Text(l10n.haptic),
                          value: controller.state.hapticEnabled,
                          onChanged: controller.setHapticEnabled,
                        ),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          title: Text(l10n.reduceMotion),
                          subtitle: Text(l10n.reduceMotionSubtitle),
                          value: controller.state.reduceMotion,
                          onChanged: controller.setReduceMotion,
                        ),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          title: Text(l10n.showMoveHints),
                          subtitle: Text(l10n.showMoveHintsSubtitle),
                          value: controller.state.showMoveHints,
                          onChanged: controller.setShowMoveHints,
                        ),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          title: Text(l10n.colorAssist),
                          subtitle: Text(l10n.colorAssistSubtitle),
                          value: controller.state.colorAssist,
                          onChanged: controller.setColorAssist,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _SettingsSection(
                  icon: Icons.dashboard_customize_rounded,
                  title: l10n.boardView,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _BoardStylePreview(
                        boardView: controller.state.boardView,
                        boardSurface: controller.state.boardSurface,
                        pieceTheme: controller.state.pieceTheme,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SegmentedButton<BoardViewStyle>(
                                showSelectedIcon: false,
                                segments: [
                                  ButtonSegment(
                                    value: BoardViewStyle.flat2d,
                                    icon: const Icon(Icons.crop_square_rounded),
                                    label: Text(l10n.viewFlat),
                                  ),
                                  ButtonSegment(
                                    value: BoardViewStyle.realistic,
                                    icon: const Icon(Icons.layers_rounded),
                                    label: Text(l10n.viewRealistic),
                                  ),
                                  ButtonSegment(
                                    value: BoardViewStyle.perspective3d,
                                    icon: const Icon(Icons.view_in_ar_rounded),
                                    label: Text(l10n.viewPerspective),
                                  ),
                                ],
                                selected: {controller.state.boardView},
                                onSelectionChanged:
                                    (values) =>
                                        controller.setBoardView(values.first),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              DropdownButtonFormField<BoardSurface>(
                                initialValue: controller.state.boardSurface,
                                decoration: InputDecoration(
                                  labelText: l10n.boardSurface,
                                  prefixIcon: const Icon(Icons.texture_rounded),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: BoardSurface.wood,
                                    child: Text(l10n.surfaceWood),
                                  ),
                                  DropdownMenuItem(
                                    value: BoardSurface.darkStone,
                                    child: Text(l10n.surfaceDarkStone),
                                  ),
                                  DropdownMenuItem(
                                    value: BoardSurface.marble,
                                    child: Text(l10n.surfaceMarble),
                                  ),
                                  DropdownMenuItem(
                                    value: BoardSurface.minimal,
                                    child: Text(l10n.surfaceMinimal),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.setBoardSurface(value);
                                  }
                                },
                              ),
                              const SizedBox(height: AppSpacing.md),
                              DropdownButtonFormField<PieceTheme>(
                                initialValue: controller.state.pieceTheme,
                                decoration: InputDecoration(
                                  labelText: l10n.pieceTheme,
                                  prefixIcon: const Icon(Icons.circle_rounded),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: PieceTheme.classic,
                                    child: Text(l10n.pieceClassic),
                                  ),
                                  DropdownMenuItem(
                                    value: PieceTheme.marble,
                                    child: Text(l10n.pieceMarble),
                                  ),
                                  DropdownMenuItem(
                                    value: PieceTheme.obsidian,
                                    child: Text(l10n.pieceObsidian),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.setPieceTheme(value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(AppRadii.medium),
            ),
            child: Icon(Icons.tune_rounded, color: scheme.onPrimary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
      const SizedBox(height: AppSpacing.sm),
      child,
    ],
  );
}

class _BoardStylePreview extends StatelessWidget {
  const _BoardStylePreview({
    required this.boardView,
    required this.boardSurface,
    required this.pieceTheme,
  });

  final BoardViewStyle boardView;
  final BoardSurface boardSurface;
  final PieceTheme pieceTheme;

  static final Board _previewBoard = List<PlayerSide?>.generate(
    GameCatalog.nine.board.pointCount,
    (index) => switch (index) {
      0 || 7 || 15 || 22 => PlayerSide.light,
      2 || 9 || 16 || 20 => PlayerSide.dark,
      _ => null,
    },
    growable: false,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: '${l10n.boardView}: ${boardView.name}',
      child: Card(
        color: scheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.boardView,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.boardSurface,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 132,
                child: IgnorePointer(
                  child: MorrisBoard(
                    definition: GameCatalog.nine,
                    board: _previewBoard,
                    onPointTap: (_) {},
                    interactive: false,
                    showHints: false,
                    colorAssist: true,
                    surface: boardSurface,
                    viewStyle: boardView,
                    pieceTheme: pieceTheme,
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
