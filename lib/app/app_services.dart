import '../core/feedback/app_feedback_service.dart';
import '../core/online/online_match_gateway.dart';
import '../core/storage/match_session_repository.dart';
import '../features/social/domain/friend_player.dart';
import 'app_settings_controller.dart';

class AppServices {
  const AppServices({
    required this.settings,
    required this.matchSessions,
    required this.feedback,
    required this.social,
    required this.online,
  });

  final AppSettingsController settings;
  final MatchSessionRepository matchSessions;
  final GameFeedback feedback;
  final SocialRepository social;
  final OnlineMatchGateway online;
}
