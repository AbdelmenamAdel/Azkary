import 'package:azkar/core/manager/app_cubit.dart';
import 'package:azkar/core/manager/app_state.dart';
import 'package:azkar/core/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/home/home_view.dart';
import 'package:azkar/core/services/services_locator.dart';
import 'package:azkar/features/rosary/manager/rosary_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ZekrCounterCubit>()),
        BlocProvider(create: (context) => sl<AppCubit>()),
        BlocProvider(create: (context) => sl<RosaryCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(630, 1280),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: state.locale,
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
                Locale('fr'),
                Locale('de'),
              ],
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: AppThemes.getTheme(state.theme, state.locale.languageCode),
              home: const HomeView(),
            );
          },
        );
      },
    );
  }
}
