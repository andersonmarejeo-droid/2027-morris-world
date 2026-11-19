import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'app/app_services.dart';
import 'app/app_feature_flags.dart';
import 'app/app_settings_controller.dart';
import 'app/nine_tas_app.dart';
import 'core/ads/family_audience.dart';
import 'core/feedback/app_feedback_service.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/firebase/firebase_observability.dart';
import 'core/notifications/app_notification_service.dart';
import 'core/online/lazy_online_match_gateway.dart';
import 'core/online/online_service_factory.dart';
import 'core/online/online_match_gateway.dart';
import 'core/settings/app_settings_repository.dart';
import 'core/storage/sqflite_match_session_repository.dart';
import 'features/social/data/in_memory_friends_repository.dart';
import 'features/social/data/player_profile_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ekranı tüm sayfalarda dikey (portrait) moduna sabitle
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FamilyAudiencePreference.load();

  final settings = AppSettingsController(
    SharedPreferencesAppSettingsRepository(),
  );
  await settings.initialize();

  // İki günde bir saat 17:00 bildirim servisi
  AppNotificationService().initialize();

  runApp(
    NineTasApp(
      settings: settings,
      createServices: () => _createServices(settings),
    ),
  );
}

Future<AppServices> _createServices(AppSettingsController settings) async =>
    AppServices(
      settings: settings,
      matchSessions: SqfliteMatchSessionRepository(),
      feedback: AppFeedbackService(settings),
      social: InMemoryFriendsRepository(
        profileStore: SharedPreferencesPlayerProfileStore(),
      ),
      // The local game starts immediately. Firebase (including anonymous Auth)
      // is not initialized until the player opens the online lobby.
      online: LazyOnlineMatchGateway(_createOnlineService),
    );

Future<OnlineMatchGateway> _createOnlineService() async {
  if (!AppFeatureFlags.onlineBackendCandidate) {
    return const DisabledOnlineMatchGateway(
      reason: 'binary-candidate-disabled',
    );
  }
  final firebase = await FirebaseBootstrap.initialize();
  await FirebaseObservability.initialize(firebase);
  return OnlineServiceFactory.create(firebase);
}
