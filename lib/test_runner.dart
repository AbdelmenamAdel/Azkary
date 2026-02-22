import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:azkar/core/services/services_locator.dart';
import 'package:azkar/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  await sl<NotificationService>().init();
  try {
    await sl<NotificationService>().testNotification();
    print("TEST NOTIFICATION SUCCESS");
  } catch (e) {
    print("TEST NOTIFICATION FAILED: \$e");
  }
}
