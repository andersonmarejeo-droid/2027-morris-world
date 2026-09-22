import 'package:flutter/material.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import 'app_router.dart';
import 'app_services.dart';
import 'app_services_scope.dart';
import 'app_theme.dart';
import 'brand_intro_gate.dart';

class NineTasApp extends StatefulWidget {
  const NineTasApp({super.key, required this.services});
  final AppServices services;

  @override
  State<NineTasApp> createState() => _NineTasAppState();
}

class _NineTasAppState extends State<NineTasApp> {
  late final router = AppRouter.create();

  @override
  Widget build(BuildContext context) {
    return AppServicesScope(
      services: widget.services,
      child: AnimatedBuilder(
        animation: widget.services.settings,
        builder: (context, _) => MaterialApp.router(
          builder: (context, child) => BrandIntroGate(
            child: child ?? const SizedBox.shrink(),
          ),
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.light(),
          locale: widget.services.settings.state.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          restorationScopeId: 'morris_world',
          routerConfig: router,
        ),
      ),
    );
  }
}
