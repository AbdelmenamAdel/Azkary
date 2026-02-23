// import 'package:azkar/core/services/services_locator.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:azkar/core/manager/app_cubit.dart';
// import 'package:azkar/core/manager/app_state.dart';
// import 'package:azkar/core/theme/app_theme_enum.dart';
// import 'package:flutter/material.dart';

// void main() {
//   group('AppCubit Tests', () {
//     late AppCubit appCubit;

//     setUp(() {
//       appCubit = sl<AppCubit>();
//     });

//     tearDown(() {
//       appCubit.close();
//     });

//     test('Initial state is correct', () {
//       expect(appCubit.state.theme, isNotNull);
//       expect(appCubit.state.locale, isNotNull);
//     });

//     blocTest<AppCubit, AppState>(
//       'emits AppState with new theme when changeTheme is called',
//       build: () => appCubit,
//       act: (cubit) => cubit.changeTheme(AppThemeEnum.light),
//       expect: () => [
//         isA<AppState>().having(
//           (state) => state.theme,
//           'theme',
//           AppThemeEnum.light,
//         ),
//       ],
//     );

//     blocTest<AppCubit, AppState>(
//       'emits AppState with new locale when changeLocale is called',
//       build: () => appCubit,
//       act: (cubit) => cubit.changeLocale(const Locale('en')),
//       expect: () => [
//         isA<AppState>().having(
//           (state) => state.locale.languageCode,
//           'locale',
//           'en',
//         ),
//       ],
//     );

//     blocTest<AppCubit, AppState>(
//       'correctly saves theme preference',
//       build: () => appCubit,
//       act: (cubit) async {
//         await cubit.changeTheme(AppThemeEnum.dark);
//       },
//       expect: () => [
//         isA<AppState>().having(
//           (state) => state.theme,
//           'theme',
//           AppThemeEnum.dark,
//         ),
//       ],
//     );

//     blocTest<AppCubit, AppState>(
//       'correctly saves locale preference',
//       build: () => appCubit,
//       act: (cubit) async {
//         await cubit.changeLocale(const Locale('ar'));
//       },
//       expect: () => [
//         isA<AppState>().having(
//           (state) => state.locale.languageCode,
//           'locale',
//           'ar',
//         ),
//       ],
//     );

//     test('Theme values are valid', () {
//       expect(AppThemeEnum.values.length, greaterThan(0));
//       for (var theme in AppThemeEnum.values) {
//         expect(theme, isNotNull);
//       }
//     });

//     test('Locale values are valid', () {
//       final locales = [
//         const Locale('ar'),
//         const Locale('en'),
//         const Locale('fr'),
//         const Locale('de'),
//       ];

//       for (var locale in locales) {
//         expect(locale.languageCode, isNotEmpty);
//         expect(locale.languageCode.length, equals(2));
//       }
//     });
//   });

//   group('AppCubit Theme Switching', () {
//     late AppCubit appCubit;

//     setUp(() {
//       appCubit = AppCubit();
//     });

//     tearDown(() {
//       appCubit.close();
//     });

//     blocTest<AppCubit, AppState>(
//       'can switch between multiple themes',
//       build: () => appCubit,
//       act: (cubit) async {
//         await cubit.changeTheme(AppThemeEnum.light);
//         await cubit.changeTheme(AppThemeEnum.dark);
//       },
//       expect: () => [
//         isA<AppState>().having(
//           (state) => state.theme,
//           'theme',
//           AppThemeEnum.light,
//         ),
//         isA<AppState>().having(
//           (state) => state.theme,
//           'theme',
//           AppThemeEnum.dark,
//         ),
//       ],
//     );
//   });

//   group('AppCubit Locale Switching', () {
//     late AppCubit appCubit;

//     setUp(() {
//       appCubit = AppCubit();
//     });

//     tearDown(() {
//       appCubit.close();
//     });

//     blocTest<AppCubit, AppState>(
//       'can switch between multiple locales',
//       build: () => appCubit,
//       act: (cubit) async {
//         await cubit.changeLocale(const Locale('ar'));
//         await cubit.changeLocale(const Locale('en'));
//         await cubit.changeLocale(const Locale('fr'));
//       },
//       expect: () => [
//         isA<AppState>().having(
//           (state) => state.locale.languageCode,
//           'locale',
//           'ar',
//         ),
//         isA<AppState>().having(
//           (state) => state.locale.languageCode,
//           'locale',
//           'en',
//         ),
//         isA<AppState>().having(
//           (state) => state.locale.languageCode,
//           'locale',
//           'fr',
//         ),
//       ],
//     );
//   });
// }
