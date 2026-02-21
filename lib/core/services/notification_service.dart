import 'dart:async';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:azkar/core/services/services_locator.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _foregroundTimer;

  static const String channelId = 'azkar_reminders_v6';
  static const String channelName = 'Azkar Reminders';
  static const String channelDescription = 'Daily Azkar notifications';

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification click
      },
    );

    await _requestPermissions();
    await _checkFirstRun();
    await scheduleDailyAzkar();
    _startForegroundTimer();
  }

  Future<void> testNotification() async {
    await _showImmediateNotification(
      888,
      "تجربة التنبيهات",
      "إذا كنت تسمع الصوت الآن، فهذا يعني أن التنبيهات تعمل بنجاح مع الصوت المخصص",
    );
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
            sound: RawResourceAndroidNotificationSound('azkar_notification'),
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: true,
            sound: 'azkar_notification.mp3',
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
          iOS: DarwinNotificationDetails(presentSound: true),
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    // iOS specific permissions
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
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
            sound: RawResourceAndroidNotificationSound('azkar_notification'),
          ),
        );
  }

  Future<void> scheduleDailyAzkar() async {
    // Cancel all previous notifications to avoid duplicates/mess
    await _notificationsPlugin.cancelAll();

    final allAzkar = _getAllAzkar();
    final random = Random();

    // Check if we can use exact alarms
    final bool canScheduleExact = await Permission.scheduleExactAlarm.isGranted;

    // Schedule 50 notifications for today
    // We'll spread them between 6 AM and 11 PM
    const startHour = 3;
    const endHour = 24;
    const totalHours = endHour - startHour;
    const intervalMinutes = (totalHours * 60) / 50;

    for (int i = 0; i < 50; i++) {
      final zekr = allAzkar[random.nextInt(allAzkar.length)];
      final scheduledTime = DateTime.now().add(
        Duration(minutes: (i + 1) * intervalMinutes.toInt()),
      );

      // If the time is too late today, it will naturally be scheduled for later
      await _scheduleNotification(
        i,
        "اذكر الله",
        zekr,
        scheduledTime,
        canScheduleExact,
      );
    }
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
            sound: RawResourceAndroidNotificationSound('azkar_notification'),
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: true,
            sound: 'azkar_notification.mp3',
          ),
        ),
        androidScheduleMode: canScheduleExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
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
          iOS: DarwinNotificationDetails(presentSound: true),
        ),
        androidScheduleMode: canScheduleExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  void _startForegroundTimer() {
    _foregroundTimer?.cancel();
    // Show a dialog every 30 minutes in foreground (approximate)
    _foregroundTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      _showForegroundDialog();
    });
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
