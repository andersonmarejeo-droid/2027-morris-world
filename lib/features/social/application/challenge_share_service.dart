import 'package:url_launcher/url_launcher.dart';

import '../../../core/game/game_definition.dart';

class ChallengeShareService {
  const ChallengeShareService._();

  static const String packageId = 'com.morrisworld.nine_tas';

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
    var opened = await launchUrl(direct, mode: LaunchMode.externalApplication);
    if (opened) {
      return true;
    }

    final fallback = Uri.https('wa.me', '/', <String, String>{'text': message});
    opened = await launchUrl(fallback, mode: LaunchMode.externalApplication);
    return opened;
  }
}
