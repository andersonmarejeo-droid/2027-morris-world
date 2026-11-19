import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nine_tas/app/app_services.dart';
import 'package:nine_tas/app/app_services_scope.dart';
import 'package:nine_tas/app/app_settings_controller.dart';
import 'package:nine_tas/app/app_theme.dart';
import 'package:nine_tas/core/feedback/app_feedback_service.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/core/match/match_models.dart';
import 'package:nine_tas/core/online/online_match_gateway.dart';
import 'package:nine_tas/core/settings/app_settings_models.dart';
import 'package:nine_tas/core/settings/app_settings_repository.dart';
import 'package:nine_tas/core/storage/match_session_repository.dart';
import 'package:nine_tas/features/home/presentation/home_screen.dart';
import 'package:nine_tas/features/settings/presentation/settings_screen.dart';
import 'package:nine_tas/features/social/data/in_memory_friends_repository.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

class _FakeSettingsRepo implements AppSettingsRepository {
  @override
  Future<AppSettingsState> load() async => const AppSettingsState();
  @override
  Future<void> save(AppSettingsState state) async {}
}

class _FakeMatchRepo implements MatchSessionRepository {
  final Map<String, MatchSession> _sessions = {};
  @override
  Future<void> delete(String sessionId) async => _sessions.remove(sessionId);
  @override
  Future<void> deleteAll() async => _sessions.clear();
  @override
  Future<MatchSession?> getById(String sessionId) async => _sessions[sessionId];
  @override
  Future<MatchSession?> getMostRecentActive() async => null;
  Future<MatchSession?> getMostRecentActiveForGame(MorrisGameId gameId) async => null;
  @override
  Future<List<MatchSession>> listRecent({int limit = 10}) async => [];
  @override
  Future<void> save(MatchSession session) async => _sessions[session.config.sessionId] = session;
}

Widget _buildHost({
  required Widget child,
  required Locale locale,
  required AppServices services,
  double textScale = 1.0,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: AppServicesScope(services: services, child: child),
    ),
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  final testLocales = <Locale>[
    const Locale('tr'),
    const Locale('en'),
    const Locale('de'),
    const Locale('ar'),
    const Locale('hi'),
    const Locale('es'),
    const Locale('fr'),
    const Locale('pt', 'BR'),
  ];

  for (final locale in testLocales) {
    testWidgets('UI stability and overflow check for locale: ${locale.languageCode}', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final settingsCtrl = AppSettingsController(_FakeSettingsRepo());
      final services = AppServices(
        settings: settingsCtrl,
        matchSessions: _FakeMatchRepo(),
        feedback: AppFeedbackService(settingsCtrl),
        social: InMemoryFriendsRepository(),
        online: const DisabledOnlineMatchGateway(reason: 'test'),
      );

      // 1. HomeScreen
      await tester.pumpWidget(_buildHost(
        child: const HomeScreen(),
        locale: locale,
        services: services,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: 'HomeScreen overflow in ${locale.languageCode}');

      // 2. SettingsScreen
      await tester.pumpWidget(_buildHost(
        child: const SettingsScreen(),
        locale: locale,
        services: services,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: 'SettingsScreen overflow in ${locale.languageCode}');

      // 3. Cleanup pending frames/timers
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    });
  }
}
