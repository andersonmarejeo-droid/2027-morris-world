import 'package:flutter/material.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import 'app_router.dart';
import 'app_services.dart';
import 'app_settings_controller.dart';
import 'app_services_scope.dart';
import 'app_theme.dart';
import 'brand_intro_gate.dart';

class NineTasApp extends StatefulWidget {
  const NineTasApp({
    super.key,
    required this.settings,
    required this.createServices,
  });

  final AppSettingsController settings;
  final Future<AppServices> Function() createServices;

  @override
  State<NineTasApp> createState() => _NineTasAppState();
}

class _NineTasAppState extends State<NineTasApp> {
  late final router = AppRouter.create();
  late final Future<AppServices> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = widget.createServices();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.settings,
      builder:
          (context, _) => MaterialApp.router(
            builder:
                (context, child) => FutureBuilder<AppServices>(
                  future: _servicesFuture,
                  builder: (context, snapshot) {
                    final services = snapshot.data;
                    if (services == null) return const _StartingAppView();
                    return AppServicesScope(
                      services: services,
                      child: BrandIntroGate(
                        child: child ?? const SizedBox.shrink(),
                      ),
                    );
                  },
                ),
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            theme: AppTheme.light(),
            locale: widget.settings.state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            restorationScopeId: 'morris_world',
            routerConfig: router,
          ),
    );
  }
}

class _StartingAppView extends StatelessWidget {
  const _StartingAppView();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: Color(0xFFF7F8F6),
    child: Center(child: CircularProgressIndicator()),
  );
}
