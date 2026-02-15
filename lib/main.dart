import 'package:azkar/core/utils/app_colors.dart';
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
              theme: ThemeData(
                primaryColor: AppColors.primary,
                appBarTheme: const AppBarTheme(
                  backgroundColor: AppColors.primary,
                  elevation: 5,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                useMaterial3: false,
                fontFamily: locale.languageCode == 'ar' ? 'Cairo' : null,
              ),
              home: HomeView(),
            );
          },
        );
      },
    );
  }
}
