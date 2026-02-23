import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:azkar/core/services/services_locator.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

/// NotificationService manages scheduled azkar notifications for background and terminated states.
///
/// **Key Features for Background/Terminated Notifications:**
///
/// 1. **Android Background Support:**
///    - Uses `AndroidScheduleMode.exactAllowWhileIdle` / `inexactAllowWhileIdle`
///    - Automatically reschedules notifications after device restart via BootReceiver
///    - Respects battery optimization while ensuring notifications are delivered
///    - AndroidManifest.xml has RECEIVE_BOOT_COMPLETED permission for boot handling
///
/// 2. **iOS Background Support:**
///    - Scheduled notifications work automatically in background and after termination
///    - iOS handles suspension properly without additional configuration
///    - Notifications continue to fire even when app is backgrounded or terminated
///
/// 3. **Foreground Mode:**
///    - When app is active, shows dialog notifications every 30 minutes
///    - Pauses when app goes to background, resumes when app comes to foreground
///    - Managed via AppLifecycleObserver in main.dart
///
/// 4. **Persistence Strategy:**
///    - Notifications are stored by the OS scheduler (Android AlarmManager, iOS UNUserNotificationCenter)
///    - On app launch, verifies pending notifications are still scheduled
///    - Reschedules if necessary (e.g., after force stop or cache clear)
///    - Persists scheduling timestamp for debugging
///
/// **Setup Requirements:**
/// ✅ flutter_local_notifications plugin configured
/// ✅ AndroidManifest.xml has RECEIVE_BOOT_COMPLETED permission
/// ✅ BootReceiver properly exported in manifest (android:exported="true")
/// ✅ iOS Info.plist has location permissions configured
/// ✅ AppLifecycleObserver integrated in main.dart
///
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _foregroundTimer;

  static const String channelId = 'azkar_reminders_v9';
  static const String channelName = 'Azkar Reminders v9';
  static const String channelDescription = 'Daily Azkar notifications';

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsIOS,
          );

      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          // Handle notification click
        },
      );

      // Initialize background notification handler for terminated state
      await _initializeBackgroundHandler();

      // Do these in background to not block app launch if they take time
      unawaited(_initTasks());
    } catch (e) {
      debugPrint("Notification Service init error: $e");
    }
  }

  /// Initialize handler for notifications received in background/terminated state
  Future<void> _initializeBackgroundHandler() async {
    try {
      // For Android: ensure notifications are rescheduled after device restart
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      // Verify that scheduled notifications are properly configured
      final pendingNotifications = await _notificationsPlugin
          .pendingNotificationRequests();
      debugPrint(
        'Pending notifications on init: ${pendingNotifications.length}',
      );
    } catch (e) {
      debugPrint("Background handler initialization error: $e");
    }
  }

  Future<void> _initTasks() async {
    try {
      await _requestPermissions();
      await _checkFirstRun();
      // IMPORTANT: Reschedule notifications after app launch
      // This ensures notifications persist even if app was terminated
      await rescheduleMissedNotifications();
      _startForegroundTimer();
    } catch (e) {
      debugPrint("Notification Service tasks error: $e");
    }
  }

  Future<void> testNotification() async {
    try {
      await _showImmediateNotification(
        888,
        "تجربة التنبيهات",
        "إذا كنت تسمع الصوت الآن، فهذا يعني أن التنبيهات تعمل بنجاح مع الصوت المخصص",
      );
      final context = sl<GlobalKey<NavigatorState>>().currentState?.context;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم إرسال التنبيه. تحقق من الإشعارات!'),
            backgroundColor: context.colors.primary,
          ),
        );
      }
    } catch (e) {
      debugPrint("Test Notification error: $e");
      final context = sl<GlobalKey<NavigatorState>>().currentState?.context;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الإشعار: $e'),
            backgroundColor: context.colors.secondary,
          ),
        );
      }
    }
  }

  Future<void> _checkFirstRun() async {
    const String firstRunKey = 'is_first_run';
    final storage = sl<FlutterSecureStorage>();
    final isFirstRun = await storage.read(key: firstRunKey);

    if (isFirstRun == null) {
      // First time opening the app
      await _showImmediateNotification(
        999,
        "مرحباً بك في تطبيق أذكاري",
        "نسأل الله أن يجعل هذا التطبيق سبباً في ذكرك لله دائماً",
      );
      await storage.write(key: firstRunKey, value: 'false');
    }
  }

  Future<void> _showImmediateNotification(
    int id,
    String title,
    String body,
  ) async {
    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('notification_sound'),
            playSound: true,
            enableVibration: true,
            ticker: 'أذكاري',
            showWhen: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            presentList: true,
            sound: 'notification_sound.mp3',
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            presentList: true,
          ),
        ),
      );
    } catch (e) {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            presentList: true,

            sound: 'notification_sound.mp3',
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            presentList: true,
          ),
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    if (!Platform.isMacOS && !Platform.isWindows && !Platform.isLinux) {
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
      if (await Permission.locationWhenInUse.isDenied) {
        await Permission.locationWhenInUse.request();
      }
    }

    if (Platform.isAndroid) {
      if (await Permission.scheduleExactAlarm.isDenied) {
        try {
          await Permission.scheduleExactAlarm.request();
        } catch (e) {
          debugPrint("ScheduleExactAlarm permission request failed: $e");
        }
      }
    }

    // iOS specific permissions
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // macOS specific permissions
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Android specific channel creation
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            channelName,
            description: channelDescription,
            importance: Importance.max,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('notification_sound'),
          ),
        );
  }

  Future<void> scheduleDailyAzkar() async {
    // Cancel all previous notifications to avoid duplicates/mess
    await _notificationsPlugin.cancelAll();

    final allAzkar = _getAllAzkar();
    final random = Random();

    // Check if we can use exact alarms
    bool canScheduleExact = false;
    if (Platform.isAndroid) {
      canScheduleExact = await Permission.scheduleExactAlarm.isGranted;
    }

    // OPTIMIZATION: Schedule only 6 notifications per day instead of 50
    // Timing: Early morning, mid-morning, midday, afternoon, evening, night
    final notificationTimes = [
      (hour: 3, minute: 0), // Early morning
      (hour: 3, minute: 30), // Early morning
      (hour: 4, minute: 0), // Early morning
      (hour: 4, minute: 30), // Early morning
      (hour: 5, minute: 0), // Early morning
      (hour: 5, minute: 30), // Early morning
      (hour: 6, minute: 0), // Early morning
      (hour: 6, minute: 30), // Early morning
      (hour: 7, minute: 0), // Early morning
      (hour: 7, minute: 30), // Early morning
      (hour: 8, minute: 0), // Early morning
      (hour: 8, minute: 30), // Early morning
      (hour: 9, minute: 0), // Mid-morning
      (hour: 9, minute: 30), // Mid-morning
      (hour: 10, minute: 0), // Mid-morning
      (hour: 10, minute: 30), // Mid-morning
      (hour: 11, minute: 0), // Mid-morning
      (hour: 11, minute: 30), // Mid-morning
      (hour: 12, minute: 0), // Midday
      (hour: 12, minute: 30), // Midday
      (hour: 13, minute: 0), // Afternoon
      (hour: 13, minute: 30), // Afternoon
      (hour: 14, minute: 0), // Afternoon
      (hour: 14, minute: 30), // Afternoon
      (hour: 15, minute: 0), // Afternoon
      (hour: 15, minute: 30), // Afternoon
      (hour: 16, minute: 0), // Evening
      (hour: 16, minute: 30), // Evening
      (hour: 17, minute: 0), // Evening
      (hour: 17, minute: 30), // Evening
      (hour: 18, minute: 0), // Evening
      (hour: 18, minute: 30), // Evening
      (hour: 19, minute: 0), // Night
      (hour: 19, minute: 30), // Night
      (hour: 20, minute: 0), // Night
      (hour: 20, minute: 30), // Night
      (hour: 21, minute: 0), // Night
      (hour: 21, minute: 30), // Night
      (hour: 22, minute: 0), // Night
      (hour: 22, minute: 30), // Night
      (hour: 23, minute: 0), // Night
    ];

    for (int i = 0; i < notificationTimes.length; i++) {
      final zekr = allAzkar[random.nextInt(allAzkar.length)];
      final now = DateTime.now();
      var scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        notificationTimes[i].hour,
        notificationTimes[i].minute,
      );

      // If time already passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await _scheduleNotification(
        i,
        "اذكر الله",
        zekr,
        scheduledTime,
        canScheduleExact,
      );
    }

    // Save scheduling timestamp to track when notifications were scheduled
    await _saveNotificationScheduleTime();
  }

  /// Reschedule notifications for background/terminated states
  /// This is called after app launch to ensure notifications persist
  Future<void> rescheduleMissedNotifications() async {
    try {
      final pendingNotifications = await _notificationsPlugin
          .pendingNotificationRequests();

      debugPrint(
        'Rescheduling: Found ${pendingNotifications.length} pending notifications',
      );

      // If no pending notifications exist, reschedule all
      if (pendingNotifications.isEmpty) {
        debugPrint('No pending notifications. Scheduling new ones...');
        await scheduleDailyAzkar();
      } else {
        // Notifications already exist, just verify they're still scheduled
        debugPrint(
          'Notifications still active. Skipping reschedule to avoid duplicates.',
        );
      }
    } catch (e) {
      debugPrint("Error rescheduling notifications: $e");
      // Fallback: reschedule anyway
      await scheduleDailyAzkar();
    }
  }

  /// Save the time when notifications were scheduled (for debugging/persistence)
  Future<void> _saveNotificationScheduleTime() async {
    try {
      final storage = sl<FlutterSecureStorage>();
      await storage.write(
        key: 'notification_schedule_time',
        value: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      debugPrint("Error saving notification schedule time: $e");
    }
  }

  /// Get the last time notifications were scheduled
  Future<DateTime?> getLastNotificationScheduleTime() async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final timeStr = await storage.read(key: 'notification_schedule_time');
      if (timeStr != null) {
        return DateTime.parse(timeStr);
      }
    } catch (e) {
      debugPrint("Error reading notification schedule time: $e");
    }
    return null;
  }

  Future<void> _scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
    bool canScheduleExact,
  ) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('notification_sound'),
            playSound: true,
            // Critical: Allow notifications while idle (background/terminated)
            fullScreenIntent: true,
            autoCancel: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            presentList: true,
            sound: 'notification_sound.mp3',
            // iOS: notifications work in background/terminated automatically
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            presentList: true,
          ),
        ),
        // Critical settings for background/terminated notification delivery
        androidScheduleMode: canScheduleExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint("Error scheduling notification (primary): $e");
      // Fallback with reduced settings
      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              channelId,
              channelName,
              channelDescription: channelDescription,
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              presentBanner: true,
              presentList: true,
            ),
            macOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              presentBanner: true,
              presentList: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e2) {
        debugPrint("Error scheduling notification (fallback): $e2");
      }
    }
  }

  void _startForegroundTimer() {
    _foregroundTimer?.cancel();
    // OPTIMIZATION: Extended interval from 30 minutes to 60 minutes to reduce CPU/memory
    // This balance between user engagement and resource efficiency
    _foregroundTimer = Timer.periodic(const Duration(minutes: 60), (timer) {
      _showForegroundDialog();
    });
  }

  /// Call this method when app returns to foreground to ensure notifications are active
  Future<void> resumeNotifications() async {
    try {
      // Verify notifications are still pending
      final pendingNotifications = await _notificationsPlugin
          .pendingNotificationRequests();
      debugPrint(
        'App resumed. Pending notifications: ${pendingNotifications.length}',
      );

      // If notifications were cleared while in background, reschedule them
      if (pendingNotifications.isEmpty) {
        debugPrint('Notifications cleared in background. Rescheduling...');
        await scheduleDailyAzkar();
      }

      // Restart foreground timer if needed
      if (_foregroundTimer == null || !_foregroundTimer!.isActive) {
        _startForegroundTimer();
      }
    } catch (e) {
      debugPrint("Error resuming notifications: $e");
    }
  }

  /// Call this method when app goes to background to pause foreground timer
  void pauseNotifications() {
    _foregroundTimer?.cancel();
    debugPrint('App paused. Foreground notifications paused.');
  }

  void _showForegroundDialog() {
    final context = sl<GlobalKey<NavigatorState>>().currentState?.context;
    if (context == null) return;

    final allAzkar = _getAllAzkar();
    final zekr = allAzkar[Random().nextInt(allAzkar.length)];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.teal),
            SizedBox(width: 10),
            Text("اذكر الله", style: TextStyle(fontFamily: 'Cairo')),
          ],
        ),
        content: Text(
          zekr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("تم", style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  List<String> _getAllAzkar() {
    final azkarService = sl<Azkar>();
    final List<String> texts = [];

    for (var item in azkarService.morning) {
      texts.add(item.zekr);
    }
    for (var item in azkarService.night) {
      texts.add(item.zekr);
    }
    for (var item in azkarService.afterPray) {
      texts.add(item.zekr);
    }

    // Return unique non-empty ones
    return texts.where((t) => t.isNotEmpty).toSet().toList();
  }
}
