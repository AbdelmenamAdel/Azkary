import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class PermissionsService {
  static Future<void> requestAllPermissions(BuildContext context) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdk = androidInfo.version.sdkInt;

    // 1. طلب إذن POST_NOTIFICATIONS لأندرويد 13+
    if (sdk >= 33) {
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        status = await Permission.notification.request();
      }

      if (!status.isGranted) {
        _showMessage(context, "يجب السماح للإشعارات للعمل.");
      }
    }

    // 2. فتح صفحة exact alarm - Android 12+
    if (sdk >= 31) {
      final canSchedule = await Permission.scheduleExactAlarm.isGranted;
      if (!canSchedule) {
        await openAppSettings(); // يفتح صفحة exact alarms
        _showMessage(context, "رجاءً: فعّل 'Allow exact alarms' من الإعدادات.");
      }
    }

    // 3. تعطيل battery optimization
    if (Platform.isAndroid) {
      final isIgnored = await Permission.ignoreBatteryOptimizations.isGranted;
      if (!isIgnored) {
        await Permission.ignoreBatteryOptimizations.request();
        _showMessage(
          context,
          "يفضل تعطيل Battery Optimization لضمان وصول الإشعارات.",
        );
      }
    }
  }

  static void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
