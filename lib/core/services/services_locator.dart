import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get_it/get_it.dart';
import '../../features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import '../../features/rosary/manager/rosary_cubit.dart';
import '../manager/app_cubit.dart';
import '../services/sound_service.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
  sl.registerLazySingleton<SoundService>(() => SoundService(sl()));

  // Cubits
  sl.registerFactory<AppCubit>(() => AppCubit(sl()));
  sl.registerFactory<RosaryCubit>(() => RosaryCubit(sl()));
  sl.registerFactory<ZekrCounterCubit>(() => ZekrCounterCubit());
}
