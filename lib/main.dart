import 'package:azkar/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/localization/language_cubit.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/home/home_view.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ZekrCounterCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
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
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<ThemeCubit, AppTheme>(
              builder: (context, themeState) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  locale: locale,
                  supportedLocales: const [
                    Locale('ar'),
                    Locale('en'),
                    Locale('fr'),
                    Locale('de'),
                  ],
                  localizationsDelegates: [
                    const AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: context.read<ThemeCubit>().getThemeData(
                        themeState,
                        locale.languageCode,
                      ),
                  home: HomeView(),
                );
              },
            );
          },
        );
      },
    );
  }
}
