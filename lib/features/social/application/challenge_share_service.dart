import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_tokens.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/online/online_match_gateway.dart';
import '../../../core/online/spark_room_client.dart';

class ChallengeShareService {
  const ChallengeShareService._();

  // WhatsApp must not be held behind Firebase startup/Remote Config. A room
  // code is an optional enhancement to the invite; the Play test link is the
  // reliable fallback and should be shared promptly even on a slow network.
  static const Duration _roomCreationBudget = AppTimeouts.roomCreation;
  static const Duration _whatsappLaunchBudget = Duration(seconds: 2);

  static const String packageId = 'com.zpgames.ucdokuzoniki';
  static const String closedTestingLink =
      'https://play.google.com/apps/testing/com.zpgames.ucdokuzoniki';

  static String roomInviteMessage({
    required String opening,
    required String roomCode,
    required String roomCodeLabel,
    required String joinRoomLabel,
  }) => '$opening\n\n$roomCodeLabel: $roomCode\n$joinRoomLabel';

  /// Creating a live room enriches the WhatsApp invite with a join code, but
  /// must not prevent sharing the install/challenge link when online play is
  /// temporarily disabled or unavailable.
  static Future<OnlineRoom?> tryCreatePrivateRoom(
    OnlineMatchGateway online,
    MorrisGameId gameId,
  ) async {
    final pending = _createRoomIfAvailable(online, gameId);
    try {
      return await pending.timeout(_roomCreationBudget);
    } on TimeoutException {
      // The request is still allowed to finish so a late-created room does
      // not remain in Firebase as an orphaned invite.
      unawaited(_closeLateRoom(pending, online));
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<OnlineRoom?> _createRoomIfAvailable(
    OnlineMatchGateway online,
    MorrisGameId gameId,
  ) async {
    if (!(await online.availability()).enabled) return null;
    return online.createPrivateRoom(gameId);
  }

  static Future<void> _closeLateRoom(
    Future<OnlineRoom?> pending,
    OnlineMatchGateway online,
  ) async {
    try {
      final room = await pending;
      if (room != null) await online.closePrivateRoom(room.id);
    } catch (_) {
      // Sharing has already fallen back to the install link. A late cleanup
      // failure must never surface as a WhatsApp sharing error.
    }
  }

  static String storeLink(MorrisGameId gameId) {
    final referrer =
        'utm_source=whatsapp&utm_medium=challenge&utm_campaign=${gameId.name}';
    return Uri.https('play.google.com', '/store/apps/details', <String, String>{
      'id': packageId,
      'referrer': referrer,
    }).toString();
  }

  static Future<bool> shareOnWhatsApp(String message) async {
    final direct = Uri.parse(
      'whatsapp://send?text=${Uri.encodeComponent(message)}',
    );
    var opened = false;
    try {
      opened = await launchUrl(
        direct,
        mode: LaunchMode.externalApplication,
      ).timeout(_whatsappLaunchBudget, onTimeout: () => false);
    } catch (_) {
      // WhatsApp might not be installed, or Android may reject its scheme.
    }
    if (opened) {
      return true;
    }

    final fallback = Uri.https('wa.me', '/', <String, String>{'text': message});
    try {
      return await launchUrl(
        fallback,
        mode: LaunchMode.externalApplication,
      ).timeout(_whatsappLaunchBudget, onTimeout: () => false);
    } catch (_) {
      return false;
    }
  }
}
