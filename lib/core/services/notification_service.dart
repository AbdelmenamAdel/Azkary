import 'dart:async';
import 'dart:math';
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

  static const String channelId = 'azkar_reminders';
  static const String channelName = 'Azkar Reminders';
  static const String channelDescription = 'Daily Azkar notifications';

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mip-map/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
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
    await scheduleDailyAzkar();
    _startForegroundTimer();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

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
          ),
        );
  }

  Future<void> scheduleDailyAzkar() async {
    // Cancel all previous notifications to avoid duplicates/mess
    await _notificationsPlugin.cancelAll();

    final allAzkar = _getAllAzkar();
    final random = Random();

    // Schedule 50 notifications for today
    // We'll spread them between 6 AM and 11 PM
    const startHour = 3;
    const endHour = 24;
    const totalHours = endHour - startHour;
    final intervalMinutes = (totalHours * 60) / 50;

    for (int i = 0; i < 50; i++) {
      final zekr = allAzkar[random.nextInt(allAzkar.length)];
      final scheduledTime = DateTime.now().add(
        Duration(minutes: (i + 1) * intervalMinutes.toInt()),
      );

      // If the time is too late today, it will naturally be scheduled for later
      await _scheduleNotification(i, "اذكر الله", zekr, scheduledTime);
    }
  }

  Future<void> _scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
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
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
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
