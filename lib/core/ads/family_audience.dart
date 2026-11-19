import 'package:shared_preferences/shared_preferences.dart';

enum FamilyAudience { under18OrUnknown, adult18Plus }

/// Stores only a broad audience choice on this device. No birth date or exact
/// age is collected, and no audience choice is sent to the game backend.
abstract final class FamilyAudiencePreference {
  static const _key = 'family_audience.v1';

  /// Audience selection is intentionally not shown in the app. The game is
  /// family-friendly for every player, so ads always use the child-safe,
  /// non-personalised configuration.
  static bool get needsChoice => false;

  static FamilyAudience get current => FamilyAudience.under18OrUnknown;

  static bool get isAdult => false;

  static Future<void> load() async {
    // Remove a previous version's adult choice so an upgrade cannot enable
    // personalised ads or change the family-safe policy unexpectedly.
    try {
      await (await SharedPreferences.getInstance()).remove(_key);
    } catch (_) {}
  }

  static Future<void> choose(FamilyAudience audience) async {
    try {
      await (await SharedPreferences.getInstance()).remove(_key);
    } catch (_) {
      // The app remains usable with the in-memory child-safe value.
    }
  }
}
