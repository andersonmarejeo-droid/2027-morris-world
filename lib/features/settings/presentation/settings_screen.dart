import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_services.dart';
import '../../../app/app_settings_controller.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_models.dart';
import '../../../core/settings/app_settings_models.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final services = AppServicesScope.of(context);
    final controller = services.settings;
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
            scrollable: false,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            bottomNavigationBar: const AppBottomNav(active: AppNavTab.settings),
            body: DefaultTabController(
              length: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SettingsHeader(
                    title: l10n.settings,
                    subtitle: l10n.gameExperience,
                  ),
                  const SizedBox(height: 6),
                  TabBar(
                    isScrollable: false,
                    indicatorColor: AppColors.darkOrange,
                    labelColor: AppColors.darkOrange,
                    unselectedLabelColor: AppColors.inkMuted,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                    tabs: [
                      Tab(
                        height: 48,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.gameExperience,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        height: 48,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.boardView,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        height: 48,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.accountAndLegal,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                child: ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.language_rounded),
                                  title: Text(
                                    options.firstWhere(
                                      (opt) => opt.$1 == selected,
                                      orElse: () => options.first,
                                    ).$2,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(l10n.language),
                                  trailing: const Icon(Icons.chevron_right_rounded),
                                  onTap: () => _showLanguagePicker(
                                    context,
                                    controller,
                                    options,
                                    selected,
                                    l10n,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Card(
                                child: Column(
                                  children: [
                                    SwitchListTile(
                                      dense: true,
                                      title: Text(l10n.sound),
                                      value: controller.state.soundEnabled,
                                      onChanged: controller.setSoundEnabled,
                                    ),
                                    SwitchListTile(
                                      dense: true,
                                      title: Text(l10n.haptic),
                                      value: controller.state.hapticEnabled,
                                      onChanged: controller.setHapticEnabled,
                                    ),
                                    SwitchListTile(
                                      dense: true,
                                      title: Text(l10n.reduceMotion),
                                      subtitle: Text(l10n.reduceMotionSubtitle),
                                      value: controller.state.reduceMotion,
                                      onChanged: controller.setReduceMotion,
                                    ),
                                    SwitchListTile(
                                      dense: true,
                                      title: Text(l10n.showMoveHints),
                                      subtitle: Text(l10n.showMoveHintsSubtitle),
                                      value: controller.state.showMoveHints,
                                      onChanged: controller.setShowMoveHints,
                                    ),
                                    SwitchListTile(
                                      dense: true,
                                      title: Text(l10n.colorAssist),
                                      subtitle: Text(l10n.colorAssistSubtitle),
                                      value: controller.state.colorAssist,
                                      onChanged: controller.setColorAssist,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _BoardStylePreview(
                                boardView: controller.state.boardView,
                                boardSurface: controller.state.boardSurface,
                                pieceTheme: controller.state.pieceTheme,
                              ),
                              const SizedBox(height: 6),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _BoardViewSelector(
                                        value: controller.state.boardView,
                                        onChanged: controller.setBoardView,
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      DropdownButtonFormField<BoardSurface>(
                                        key: ValueKey(controller.state.boardSurface),
                                        initialValue: controller.state.boardSurface,
                                        decoration: InputDecoration(
                                          labelText: l10n.boardSurface,
                                          prefixIcon: const Icon(Icons.texture_rounded),
                                        ),
                                        items: [
                                          DropdownMenuItem(
                                            value: BoardSurface.wood,
                                            child: _SurfaceMenuItem(
                                              surface: BoardSurface.wood,
                                              label: l10n.surfaceWood,
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: BoardSurface.darkStone,
                                            child: _SurfaceMenuItem(
                                              surface: BoardSurface.darkStone,
                                              label: l10n.surfaceDarkStone,
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: BoardSurface.marble,
                                            child: _SurfaceMenuItem(
                                              surface: BoardSurface.marble,
                                              label: l10n.surfaceMarble,
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: BoardSurface.minimal,
                                            child: _SurfaceMenuItem(
                                              surface: BoardSurface.minimal,
                                              label: l10n.surfaceMinimal,
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          if (value != null) {
                                            controller.setBoardSurface(value);
                                          }
                                        },
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
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
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Card(
                            child: Column(
                              children: [
                                ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.menu_book_outlined),
                                  title: Text(l10n.termsOfUse),
                                  trailing: const Icon(Icons.open_in_new_rounded),
                                  onTap: () => _openTermsOfUse(context),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.privacy_tip_outlined),
                                  title: Text(_privacyPolicyLabel(context)),
                                  trailing: const Icon(Icons.open_in_new_rounded),
                                  onTap: _openPrivacyPolicy,
                                ),
                                ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.info_outline_rounded),
                                  title: Text(l10n.legalInformation),
                                  trailing: const Icon(Icons.chevron_right_rounded),
                                  onTap:
                                      () => _showInformationDialog(
                                        context,
                                        title: l10n.legalInformation,
                                        message: l10n.legalInformationBody,
                                      ),
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.logout_rounded),
                                  title: Text(l10n.onlineSignOut),
                                  onTap: () => _signOutOnline(context),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  title: Text(
                                    l10n.deleteLocalData,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                  onTap:
                                      () => _confirmDeleteLocalData(context, services),
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
            ),
          );
        },
      ),
    );
  }
}

String _privacyPolicyLabel(BuildContext context) =>
    switch (Localizations.localeOf(context).languageCode) {
      'tr' => 'Gizlilik politikası',
      'de' => 'Datenschutzerklärung',
      'es' => 'Política de privacidad',
      'fr' => 'Politique de confidentialité',
      'pt' => 'Política de privacidade',
      'ar' => 'سياسة الخصوصية',
      'hi' => 'गोपनीयता नीति',
      _ => 'Privacy policy',
    };

Future<void> _openPrivacyPolicy() async {
  final uri = Uri.parse('https://tas-4e90e.web.app/privacy-policy');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<void> _openTermsOfUse(BuildContext context) async {
  final uri = Uri.parse('https://tas-4e90e.web.app/terms-of-use');
  try {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      showAppNotice(context, AppLocalizations.of(context).genericLoadError);
    }
  } catch (_) {
    if (context.mounted) {
      showAppNotice(context, AppLocalizations.of(context).genericLoadError);
    }
  }
}

Future<void> _showLanguagePicker(
  BuildContext context,
  AppSettingsController controller,
  List<(Locale?, String)> options,
  Locale? selected,
  AppLocalizations l10n,
) async {
  await showAppBottomSheet<void>(
    context: context,
    builder:
        (sheetContext) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.language,
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final option in options)
              ListTile(
                dense: true,
                leading: Icon(
                  option.$1 == selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color:
                      option.$1 == selected
                          ? Theme.of(sheetContext).colorScheme.primary
                          : null,
                ),
                title: Text(option.$2),
                trailing:
                    option.$1 == selected
                        ? Icon(
                          Icons.check_rounded,
                          color: Theme.of(sheetContext).colorScheme.primary,
                        )
                        : null,
                onTap: () {
                  closeAppOverlay(sheetContext);
                  if (option.$1 == null) {
                    controller.useSystemLanguage();
                  } else {
                    controller.setLocale(option.$1!);
                  }
                },
              ),
          ],
        ),
  );
}

Future<void> _showInformationDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final l10n = AppLocalizations.of(context);
  await showAppInformationDialog(
    context: context,
    title: title,
    message: message,
    closeLabel: l10n.cancel,
  );
}

Future<void> _signOutOnline(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  try {
    if (Firebase.apps.isEmpty || FirebaseAuth.instance.currentUser == null) {
      showAppNotice(context, l10n.onlineSessionMissing);
      return;
    }
    await FirebaseAuth.instance.signOut();
    if (context.mounted) showAppNotice(context, l10n.onlineSignOutDone);
  } catch (_) {
    if (context.mounted) showAppNotice(context, l10n.genericLoadError);
  }
}

Future<void> _confirmDeleteLocalData(
  BuildContext context,
  AppServices services,
) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showAppActionDialog<bool>(
    context: context,
    title: l10n.deleteLocalDataTitle,
    message: l10n.deleteLocalDataBody,
    actions: [
      AppDialogAction(label: l10n.cancel, value: false),
      AppDialogAction(label: l10n.deleteAction, value: true, primary: true),
    ],
  );
  if (confirmed != true || !context.mounted) return;
  try {
    await services.social.deleteLocalUserData();
    await services.matchSessions.deleteAll();
    if (context.mounted) showAppNotice(context, l10n.deleteLocalDataDone);
  } catch (_) {
    if (context.mounted) showAppNotice(context, l10n.genericLoadError);
  }
}

class _BoardViewSelector extends StatelessWidget {
  const _BoardViewSelector({required this.value, required this.onChanged});

  final BoardViewStyle value;
  final ValueChanged<BoardViewStyle> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.boardView,
      child: SegmentedButton<BoardViewStyle>(
        // A vertical selector preserves the complete label on narrow phones.
        // The old horizontal control clipped words such as “Gerçekçi”.
        direction: Axis.vertical,
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: BoardViewStyle.flat2d,
            icon: const Icon(Icons.crop_square_rounded),
            label: Text(l10n.viewFlat, maxLines: 1),
          ),
          ButtonSegment(
            value: BoardViewStyle.realistic,
            icon: const Icon(Icons.layers_rounded),
            label: Text(l10n.viewRealistic, maxLines: 1),
          ),
          ButtonSegment(
            value: BoardViewStyle.perspective3d,
            icon: const Icon(Icons.view_in_ar_rounded),
            label: Text(l10n.viewPerspective, maxLines: 1),
          ),
        ],
        selected: {value},
        onSelectionChanged: (values) => onChanged(values.first),
      ),
    );
  }
}

class _SurfaceMenuItem extends StatelessWidget {
  const _SurfaceMenuItem({required this.surface, required this.label});

  final BoardSurface surface;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (background, line) = switch (surface) {
      BoardSurface.wood => (const Color(0xFFC68A55), const Color(0xFF4A2E1F)),
      BoardSurface.darkStone => (
        const Color(0xFF33383B),
        const Color(0xFFF5F7F7),
      ),
      BoardSurface.marble => (const Color(0xFFEAE7DE), const Color(0xFF393733)),
      BoardSurface.minimal => (Colors.white, const Color(0xFF101718)),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 22,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: line.withValues(alpha: 0.72)),
          ),
          alignment: Alignment.center,
          child: Container(width: 18, height: 2.5, color: line),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, overflow: TextOverflow.ellipsis),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadii.large),
        border: Border.all(
          color: AppColors.darkOrange.withValues(alpha: 0.35),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(AppRadii.medium),
            ),
            child: Icon(Icons.tune_rounded, color: scheme.onPrimary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                )),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
                      _boardViewSummary(l10n, boardView),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _boardSurfaceSummary(l10n, boardSurface),
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

String _boardViewLabel(AppLocalizations l10n, BoardViewStyle view) =>
    switch (view) {
      BoardViewStyle.flat2d => l10n.viewFlat,
      BoardViewStyle.realistic => l10n.viewRealistic,
      BoardViewStyle.perspective3d => l10n.viewPerspective,
    };

String _boardViewSummary(AppLocalizations l10n, BoardViewStyle view) =>
    '${l10n.boardView} · ${_boardViewLabel(l10n, view)}';

String _surfaceLabel(AppLocalizations l10n, BoardSurface surface) =>
    switch (surface) {
      BoardSurface.wood => l10n.surfaceWood,
      BoardSurface.darkStone => l10n.surfaceDarkStone,
      BoardSurface.marble => l10n.surfaceMarble,
      BoardSurface.minimal => l10n.surfaceMinimal,
    };

String _boardSurfaceSummary(AppLocalizations l10n, BoardSurface surface) =>
    '${l10n.boardSurface} · ${_surfaceLabel(l10n, surface)}';
