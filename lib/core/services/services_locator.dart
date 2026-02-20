import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get_it/get_it.dart';
import '../theme/app_theme_enum.dart';
import '../../features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import '../../features/rosary/manager/rosary_cubit.dart';
import '../manager/app_cubit.dart';
import '../services/sound_service.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  const storage = FlutterSecureStorage();
  sl.registerLazySingleton<FlutterSecureStorage>(() => storage);
  sl.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
  sl.registerLazySingleton<SoundService>(() => SoundService(sl()));

  // Pre-load Settings
  final String? langCode = await storage.read(key: 'lang_code');
  final String? themeIndexStr = await storage.read(key: 'theme_index');

  Locale initialLocale = const Locale('ar');
  if (langCode != null) initialLocale = Locale(langCode);

  AppTheme initialTheme = AppTheme.emerald;
  if (themeIndexStr != null) {
    final int index = int.tryParse(themeIndexStr) ?? 0;
    if (index >= 0 && index < AppTheme.values.length) {
      initialTheme = AppTheme.values[index];
    }
  }

  // Cubits
  sl.registerFactory<AppCubit>(
    () => AppCubit(
      sl(),
      initialLocale: initialLocale,
      initialTheme: initialTheme,
    ),
  );
  sl.registerFactory<RosaryCubit>(() => RosaryCubit(sl()));
  sl.registerFactory<ZekrCounterCubit>(() => ZekrCounterCubit());
}
