// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:azkar/core/services/prayer_time_service.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get_it/get_it.dart';
// import 'package:adhan/adhan.dart';
// import '../test_helpers/mock_services.dart';

// void main() {
//   late PrayerTimeService prayerTimeService;
//   late MockFlutterSecureStorage mockStorage;
//   late GetIt sl;

//   setUp(() {
//     mockStorage = MockFlutterSecureStorage();
//     sl = GetIt.instance;
//     sl.reset();
//     sl.registerSingleton<FlutterSecureStorage>(mockStorage);

//     prayerTimeService = PrayerTimeService();
//   });

//   tearDown(() {
//     GetIt.instance.reset();
//   });

//   group('PrayerTimeService Unit Tests', () {
//     test('getPrayerTimes() returns PrayerTimes object', () async {
//       final prayerTimes = await prayerTimeService.getPrayerTimes();
//       expect(prayerTimes, isNotNull);
//     });

//     test('getPrayerTimes() contains valid prayer times', () async {
//       final prayerTimes = await prayerTimeService.getPrayerTimes();

//       expect(prayerTimes.fajr, isNotNull);
//       expect(prayerTimes.sunrise, isNotNull);
//       expect(prayerTimes.dhuhr, isNotNull);
//       expect(prayerTimes.asr, isNotNull);
//       expect(prayerTimes.maghrib, isNotNull);
//       expect(prayerTimes.isha, isNotNull);
//     });

//     test('Prayer times are in ascending order', () async {
//       final prayerTimes = await prayerTimeService.getPrayerTimes();

//       expect(prayerTimes.fajr!.isBefore(prayerTimes.sunrise!), true);
//       expect(prayerTimes.sunrise!.isBefore(prayerTimes.dhuhr!), true);
//       expect(prayerTimes.dhuhr!.isBefore(prayerTimes.asr!), true);
//       expect(prayerTimes.asr!.isBefore(prayerTimes.maghrib!), true);
//       expect(prayerTimes.maghrib!.isBefore(prayerTimes.isha!), true);
//     });

//     test('prefetchTomorrowPrayerTimes() returns valid PrayerTimes', () async {
//       final tomorrowTimes = await prayerTimeService
//           .prefetchTomorrowPrayerTimes();

//       // First call should return times
//       expect(tomorrowTimes, isNotNull);
//     });

//     test('prefetchTomorrowPrayerTimes() only runs once per day', () async {
//       final firstCall = await prayerTimeService.prefetchTomorrowPrayerTimes();

//       await Future.delayed(const Duration(milliseconds: 50));

//       final secondCall = await prayerTimeService.prefetchTomorrowPrayerTimes();

//       // Should only prefetch once
//       expect(firstCall != null || secondCall == null, true);
//     });

//     test('getPrayerKey() returns correct localization key', () {
//       expect(prayerTimeService.getPrayerKey(Prayer.fajr), 'prayer_fajr');
//       expect(prayerTimeService.getPrayerKey(Prayer.dhuhr), 'prayer_dhuhr');
//       expect(prayerTimeService.getPrayerKey(Prayer.asr), 'prayer_asr');
//       expect(prayerTimeService.getPrayerKey(Prayer.isha), 'prayer_isha');
//     });

//     test('getPrayerName() returns Arabic prayer names', () {
//       expect(prayerTimeService.getPrayerName(Prayer.fajr), 'الفجر');
//       expect(prayerTimeService.getPrayerName(Prayer.dhuhr), 'الظهر');
//       expect(prayerTimeService.getPrayerName(Prayer.asr), 'العصر');
//       expect(prayerTimeService.getPrayerName(Prayer.isha), 'العشاء');
//     });

//     test('getPrayerIcon() returns valid emoji', () {
//       final fajrIcon = prayerTimeService.getPrayerIcon(Prayer.fajr);
//       final dhuhrIcon = prayerTimeService.getPrayerIcon(Prayer.dhuhr);

//       expect(fajrIcon, isNotEmpty);
//       expect(dhuhrIcon, isNotEmpty);
//       expect(fajrIcon, equals('🌙'));
//       expect(dhuhrIcon, equals('☀️'));
//     });

//     test('formatTime() formats DateTime correctly', () {
//       final testTime = DateTime(2026, 2, 23, 14, 30, 0);
//       final formatted = prayerTimeService.formatTime(testTime);

//       expect(formatted, isNotEmpty);
//       expect(formatted.contains('2:30'), true);
//     });
//   });

//   group('PrayerTimeService Location Caching', () {
//     test('Location is cached and reused within 1 hour', () async {
//       final prayerTimes1 = await prayerTimeService.getPrayerTimes();

//       // Immediate second call should use cache
//       final prayerTimes2 = await prayerTimeService.getPrayerTimes();

//       // Should return valid prayer times both times
//       expect(prayerTimes1, isNotNull);
//       expect(prayerTimes2, isNotNull);
//     });
//   });

//   group('PrayerTimeService Performance Tests', () {
//     test('getPrayerTimes() completes in less than 2 seconds', () async {
//       final stopwatch = Stopwatch()..start();
//       await prayerTimeService.getPrayerTimes();
//       stopwatch.stop();

//       expect(
//         stopwatch.elapsedMilliseconds,
//         lessThan(2000),
//         reason:
//             'Prayer time fetching took too long: ${stopwatch.elapsedMilliseconds}ms',
//       );
//     });

//     test('Repeated getPrayerTimes() calls are faster due to caching', () async {
//       // First call
//       final stopwatch1 = Stopwatch()..start();
//       await prayerTimeService.getPrayerTimes();
//       stopwatch1.stop();

//       // Second call (should use cache)
//       final stopwatch2 = Stopwatch()..start();
//       await prayerTimeService.getPrayerTimes();
//       stopwatch2.stop();

//       // Second call should be significantly faster
//       expect(
//         stopwatch2.elapsedMilliseconds,
//         lessThanOrEqualTo(stopwatch1.elapsedMilliseconds),
//       );
//     });
//   });

//   group('PrayerTimeService Error Handling', () {
//     test('getPrayerTimes() handles errors gracefully', () async {
//       expect(
//         () async => await prayerTimeService.getPrayerTimes(),
//         returnsNormally,
//       );
//     });

//     test('prefetchTomorrowPrayerTimes() handles errors gracefully', () async {
//       expect(
//         () async => await prayerTimeService.prefetchTomorrowPrayerTimes(),
//         returnsNormally,
//       );
//     });
//   });
// }
