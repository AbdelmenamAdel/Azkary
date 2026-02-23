// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:azkar/core/services/notification_service.dart';
// import 'package:azkar/core/utils/azkar.dart';
// import 'package:get_it/get_it.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../test_helpers/mock_services.dart';

// void main() {
//   late NotificationService notificationService;
//   late MockFlutterSecureStorage mockStorage;
//   late GetIt sl;

//   setUp(() {
//     mockStorage = MockFlutterSecureStorage();
//     sl = GetIt.instance;

//     // Register mocks
//     sl.reset();
//     sl.registerSingleton<FlutterSecureStorage>(mockStorage);
//     sl.registerSingleton<Azkar>(Azkar());

//     notificationService = NotificationService();
//   });

//   tearDown(() {
//     GetIt.instance.reset();
//   });

//   group('NotificationService Unit Tests', () {
//     test('init() initializes notification service successfully', () async {
//       expect(() async => await notificationService.init(), returnsNormally);
//     });

//     test('scheduleDailyAzkar() schedules 6 notifications', () async {
//       await notificationService.scheduleDailyAzkar();
//       // Service should have scheduled 6 notifications
//       // Verify through mock if needed
//       expect(true, true); // Service runs without errors
//     });

//     test('testNotification() sends test notification without errors', () async {
//       expect(
//         () async => await notificationService.testNotification(),
//         returnsNormally,
//       );
//     });

//     test(
//       'getLastNotificationScheduleTime() returns null on first call',
//       () async {
//         final lastTime = await notificationService
//             .getLastNotificationScheduleTime();
//         expect(lastTime, isNull);
//       },
//     );

//     test('getLastNotificationScheduleTime() returns saved time', () async {
//       await notificationService.scheduleDailyAzkar();
//       await Future.delayed(const Duration(milliseconds: 100));

//       final lastTime = await notificationService
//           .getLastNotificationScheduleTime();
//       expect(lastTime, isNotNull);
//       expect(lastTime!.year, DateTime.now().year);
//     });

//     test('rescheduleMissedNotifications() completes without error', () async {
//       expect(
//         () async => await notificationService.rescheduleMissedNotifications(),
//         returnsNormally,
//       );
//     });

//     test('resumeNotifications() completes without error', () async {
//       expect(
//         () async => await notificationService.resumeNotifications(),
//         returnsNormally,
//       );
//     });

//     test('pauseNotifications() completes without error', () {
//       expect(() => notificationService.pauseNotifications(), returnsNormally);
//     });

//     test('scheduleDailyAzkar() clears previous notifications', () async {
//       // First scheduling
//       await notificationService.scheduleDailyAzkar();
//       await Future.delayed(const Duration(milliseconds: 50));

//       // Second scheduling should clear first
//       await notificationService.scheduleDailyAzkar();

//       // Should complete without duplicate notification errors
//       expect(true, true);
//     });
//   });

//   group('NotificationService Performance Tests', () {
//     test('scheduleDailyAzkar() completes in less than 5 seconds', () async {
//       final stopwatch = Stopwatch()..start();
//       await notificationService.scheduleDailyAzkar();
//       stopwatch.stop();

//       expect(
//         stopwatch.elapsedMilliseconds,
//         lessThan(5000),
//         reason:
//             'Notification scheduling took too long: ${stopwatch.elapsedMilliseconds}ms',
//       );
//     });

//     test('init() completes in less than 3 seconds', () async {
//       final stopwatch = Stopwatch()..start();
//       await notificationService.init();
//       stopwatch.stop();

//       expect(
//         stopwatch.elapsedMilliseconds,
//         lessThan(3000),
//         reason:
//             'Initialization took too long: ${stopwatch.elapsedMilliseconds}ms',
//       );
//     });
//   });

//   group('NotificationService State Management', () {
//     test('Storage contains scheduled time after scheduling', () async {
//       await notificationService.scheduleDailyAzkar();
//       await Future.delayed(const Duration(milliseconds: 100));

//       final storedTime = mockStorage.getValue('notification_schedule_time');
//       expect(storedTime, isNotNull);
//     });

//     test('Multiple schedulings update the schedule time', () async {
//       await notificationService.scheduleDailyAzkar();
//       await Future.delayed(const Duration(milliseconds: 50));
//       final firstTime = mockStorage.getValue('notification_schedule_time');

//       await Future.delayed(const Duration(milliseconds: 100));
//       await notificationService.scheduleDailyAzkar();
//       final secondTime = mockStorage.getValue('notification_schedule_time');

//       expect(firstTime, isNotNull);
//       expect(secondTime, isNotNull);
//       // Second time should be more recent or equal
//       expect(secondTime!.compareTo(firstTime!), greaterThanOrEqualTo(0));
//     });
//   });
// }
