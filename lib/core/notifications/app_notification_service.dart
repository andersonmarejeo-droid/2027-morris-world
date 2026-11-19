import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// İki günde bir saat 17:00'de (öğleden sonra 5) kullanıcıya
/// oyuna davet hatırlatıcıları gönderen bildirim servisi.
class AppNotificationService {
  static final AppNotificationService _instance =
      AppNotificationService._internal();
  factory AppNotificationService() => _instance;
  AppNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const String _channelId = 'morris_game_reminders';
  static const String _channelName = 'Oyun Hatırlatıcıları';
  static const String _channelDesc =
      'İki günde bir saat 17:00 oyuna davet ve maç hatırlatıcıları';

  // Farklı ve sıkıcı olmayan davet mesajları
  static const List<Map<String, String>> _reminderMessages = [
    {
      'title': 'Morris Dünyası seni bekliyor! 🎯',
      'body': 'Hamle sırası sende! Seni oynamaya bekleriz.',
    },
    {
      'title': '9 Taş Tahtası Seni Çağırıyor! 🏆',
      'body': 'Bugün değirmen kurmaya ne dersin? Yeni bir maç seni bekliyor!',
    },
    {
      'title': 'Usta bir hamleye hazır mısın? ⚔️',
      'body': 'Rakipler hazır! Seni keyifli bir maç oynamaya bekleriz.',
    },
    {
      'title': 'Taktik Arenasında Zekanı Göster! 🧠',
      'body': 'Stratejini konuşturma vakti! Tahta seni bekliyor.',
    },
    {
      'title': 'Morris Ustası, maç zamanı! 👑',
      'body': 'Günün stresini atmak için bir el 9 Taş oynamaya ne dersin?',
    },
  ];

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 1. Timezone veritabanını başlat
      tz.initializeTimeZones();
      _configureLocalTimeZone();

      // 2. Android & iOS başlatma ayarları
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(initSettings);

      // 3. Android 13+ (API 33+) bildirim izni talep et
      final androidPlatform = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlatform != null) {
        await androidPlatform.requestNotificationsPermission();
      }

      _initialized = true;

      // 4. İki günde bir saat 17:00 bildirimlerini planla
      await scheduleBiDailyReminders();
    } catch (e, stack) {
      debugPrint('AppNotificationService başlatılırken hata: $e\n$stack');
    }
  }

  void _configureLocalTimeZone() {
    try {
      final now = DateTime.now();
      final offset = now.timeZoneOffset.inMilliseconds;
      final locationName = now.timeZoneName;
      try {
        tz.setLocalLocation(tz.getLocation(locationName));
      } catch (_) {
        final locations = tz.timeZoneDatabase.locations;
        tz.Location? matchedLocation;
        for (final loc in locations.values) {
          if (loc.currentTimeZone.offset == offset) {
            matchedLocation = loc;
            break;
          }
        }
        if (matchedLocation != null) {
          tz.setLocalLocation(matchedLocation);
        } else {
          tz.setLocalLocation(tz.UTC);
        }
      }
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  /// Önümüzdeki 30 gün boyunca 2 günde bir saat 17:00 için bildirimleri zamanlar.
  Future<void> scheduleBiDailyReminders() async {
    try {
      // Eski hatırlatıcı bildirimlerini temizle (ID aralığı 100 - 120)
      for (int i = 0; i < 20; i++) {
        await _notificationsPlugin.cancel(100 + i);
      }

      final now = tz.TZDateTime.now(tz.local);

      // 15 döngü = 30 gün boyunca iki günde bir
      for (int i = 0; i < 15; i++) {
        final daysToAdd = (i + 1) * 2; // 2, 4, 6, 8, ... gün sonra
        var scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day + daysToAdd,
          17, // Saat 17:00 (Öğleden sonra 5)
          0,
          0,
        );

        if (scheduledDate.isBefore(now)) {
          continue;
        }

        final messageData = _reminderMessages[i % _reminderMessages.length];
        final notificationId = 100 + i;

        await _notificationsPlugin.zonedSchedule(
          notificationId,
          messageData['title'],
          messageData['body'],
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDesc,
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
              styleInformation: BigTextStyleInformation(
                messageData['body']!,
                contentTitle: messageData['title'],
              ),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }

      debugPrint('İki günde bir saat 17:00 bildirimleri başarıyla zamanlandı.');
    } catch (e, stack) {
      debugPrint('scheduleBiDailyReminders hatası: $e\n$stack');
    }
  }
}
