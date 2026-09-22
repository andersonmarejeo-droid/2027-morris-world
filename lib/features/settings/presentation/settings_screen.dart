import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/settings/app_settings_models.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_screen_shell.dart';

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
                _SectionTitle(text: l10n.language),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  child: Column(
                    children:
                        options.map((option) {
                          final locale = option.$1;
                          final isSelected = locale == selected;
                          return ListTile(
                            leading: Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                            ),
                            title: Text(option.$2),
                            onTap:
                                () =>
                                    locale == null
                                        ? controller.useSystemLanguage()
                                        : controller.setLocale(locale),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _SectionTitle(text: l10n.gameExperience),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(l10n.sound),
                        value: controller.state.soundEnabled,
                        onChanged: controller.setSoundEnabled,
                      ),
                      SwitchListTile(
                        title: Text(l10n.haptic),
                        value: controller.state.hapticEnabled,
                        onChanged: controller.setHapticEnabled,
                      ),
                      SwitchListTile(
                        title: Text(l10n.reduceMotion),
                        subtitle: Text(l10n.reduceMotionSubtitle),
                        value: controller.state.reduceMotion,
                        onChanged: controller.setReduceMotion,
                      ),
                      SwitchListTile(
                        title: Text(l10n.showMoveHints),
                        subtitle: Text(l10n.showMoveHintsSubtitle),
                        value: controller.state.showMoveHints,
                        onChanged: controller.setShowMoveHints,
                      ),
                      SwitchListTile(
                        title: Text(l10n.colorAssist),
                        subtitle: Text(l10n.colorAssistSubtitle),
                        value: controller.state.colorAssist,
                        onChanged: controller.setColorAssist,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _SectionTitle(text: l10n.boardView),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedButton<BoardViewStyle>(
                          segments: [
                            ButtonSegment(
                              value: BoardViewStyle.flat2d,
                              label: Text(l10n.viewFlat),
                            ),
                            ButtonSegment(
                              value: BoardViewStyle.realistic,
                              label: Text(l10n.viewRealistic),
                            ),
                            ButtonSegment(
                              value: BoardViewStyle.perspective3d,
                              label: Text(l10n.viewPerspective),
                            ),
                          ],
                          selected: {controller.state.boardView},
                          onSelectionChanged:
                              (values) => controller.setBoardView(values.first),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        DropdownButtonFormField<BoardSurface>(
                          initialValue: controller.state.boardSurface,
                          decoration: InputDecoration(
                            labelText: l10n.boardSurface,
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
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.titleLarge);
}
