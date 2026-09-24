import 'package:flutter/widgets.dart';

import 'app/app_services.dart';
import 'app/app_settings_controller.dart';
import 'app/nine_tas_app.dart';
import 'core/feedback/app_feedback_service.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/firebase/firebase_observability.dart';
import 'core/online/online_service_factory.dart';
import 'core/settings/app_settings_repository.dart';
import 'core/storage/sqflite_match_session_repository.dart';
import 'features/social/data/in_memory_friends_repository.dart';
import 'features/social/data/player_profile_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = AppSettingsController(
    SharedPreferencesAppSettingsRepository(),
  );
  await settings.initialize();
  final firebase = await FirebaseBootstrap.initialize();
  await FirebaseObservability.initialize(firebase);
  final online = await OnlineServiceFactory.create(firebase);

  final services = AppServices(
    settings: settings,
    matchSessions: SqfliteMatchSessionRepository(),
    feedback: AppFeedbackService(settings),
    social: InMemoryFriendsRepository(
      profileStore: SharedPreferencesPlayerProfileStore(),
    ),
    online: online,
  );

  runApp(NineTasApp(services: services));
}
