// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:adhan/adhan.dart';

// // Mock Services
// class MockFlutterLocalNotificationsPlugin extends Mock
//     implements FlutterLocalNotificationsPlugin {
//   @override
//   Future<bool?> initialize(
//     InitializationSettings settings, {
//     bool onDidReceiveBackgroundNotificationResponse = false,
//   }) async {
//     return true;
//   }

//   @override
//   Future<void> zonedSchedule(
//     int id,
//     String? title,
//     String? body,
//     TZDateTime scheduledDate,
//     NotificationDetails notificationDetails, {
//     required UILocalNotificationDateInterpretation
//     uiLocalNotificationDateInterpretation,
//     required bool matchDateTimeComponents,
//   }) async {}

//   @override
//   Future<void> cancelAll() async {}

//   @override
//   Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
//     return [];
//   }
// }

// class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
//   final _store = <String, String>{};

//   @override
//   Future<String?> read({
//     required String key,
//     required iOS? iOptions,
//     required MacOsOptions? mOptions,
//     required WebOptions? webOptions,
//   }) async {
//     return _store[key];
//   }

//   @override
//   Future<void> write({
//     required String key,
//     required String value,
//     required iOS? iOptions,
//     required MacOsOptions? mOptions,
//     required WebOptions? webOptions,
//   }) async {
//     _store[key] = value;
//   }

//   @override
//   Future<void> delete({
//     required String key,
//     required iOS? iOptions,
//     required MacOsOptions? mOptions,
//     required WebOptions? webOptions,
//   }) async {
//     _store.remove(key);
//   }

//   @override
//   Future<void> deleteAll({
//     required iOS? iOptions,
//     required MacOsOptions? mOptions,
//     required WebOptions? webOptions,
//   }) async {
//     _store.clear();
//   }

//   void clear() => _store.clear();
//   String? getValue(String key) => _store[key];
// }

// class MockGeolocator extends Mock {
//   static Future<bool> isLocationServiceEnabled() async => true;

//   static Future<LocationPermission> checkPermission() async =>
//       LocationPermission.whileInUse;

//   static Future<Position> getCurrentPosition({
//     LocationAccuracy desiredAccuracy = LocationAccuracy.best,
//   }) async {
//     return Position(
//       latitude: 30.0444,
//       longitude: 31.2357,
//       timestamp: DateTime.now(),
//       accuracy: 10,
//       altitude: 0,
//       heading: 0,
//       speed: 0,
//       speedAccuracy: 0,
//       altitudeAccuracy: 0,
//       headingAccuracy: 0,
//     );
//   }
// }

// class MockPrayerTimes extends Mock implements PrayerTimes {
//   late final DateTime _fajr;
//   late final DateTime _sunrise;
//   late final DateTime _dhuhr;
//   late final DateTime _asr;
//   late final DateTime _maghrib;
//   late final DateTime _isha;

//   MockPrayerTimes() {
//     final now = DateTime.now();
//     _fajr = now.add(const Duration(hours: 1));
//     _sunrise = now.add(const Duration(hours: 2));
//     _dhuhr = now.add(const Duration(hours: 5));
//     _asr = now.add(const Duration(hours: 8));
//     _maghrib = now.add(const Duration(hours: 10));
//     _isha = now.add(const Duration(hours: 12));
//   }

//   @override
//   DateTime? get fajr => _fajr;

//   @override
//   DateTime? get sunrise => _sunrise;

//   @override
//   DateTime? get dhuhr => _dhuhr;

//   @override
//   DateTime? get asr => _asr;

//   @override
//   DateTime? get maghrib => _maghrib;

//   @override
//   DateTime? get isha => _isha;

//   @override
//   Prayer nextPrayer() {
//     final now = DateTime.now();
//     if (now.isBefore(_fajr)) return Prayer.fajr;
//     if (now.isBefore(_sunrise)) return Prayer.sunrise;
//     if (now.isBefore(_dhuhr)) return Prayer.dhuhr;
//     if (now.isBefore(_asr)) return Prayer.asr;
//     if (now.isBefore(_maghrib)) return Prayer.maghrib;
//     if (now.isBefore(_isha)) return Prayer.isha;
//     return Prayer.fajr;
//   }

//   @override
//   DateTime? timeForPrayer(Prayer prayer) {
//     switch (prayer) {
//       case Prayer.fajr:
//         return _fajr;
//       case Prayer.sunrise:
//         return _sunrise;
//       case Prayer.dhuhr:
//         return _dhuhr;
//       case Prayer.asr:
//         return _asr;
//       case Prayer.maghrib:
//         return _maghrib;
//       case Prayer.isha:
//         return _isha;
//       default:
//         return null;
//     }
//   }
// }
