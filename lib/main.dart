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
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/features/rosary/manager/rosary_cubit.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await initServiceLocator();
    sl<NotificationService>()
        .init(); // Don't await here to avoid blocking startup
  } catch (e) {
    debugPrint("Initialization error: $e");
  }

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

/// App lifecycle observer to manage notifications in background/terminated states
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notificationService = sl<NotificationService>();

    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('App resumed - resuming notifications');
        notificationService.resumeNotifications();
        break;
      case AppLifecycleState.paused:
        debugPrint('App paused - pausing foreground notifications');
        notificationService.pauseNotifications();
        break;
      case AppLifecycleState.detached:
        debugPrint('App detached - notifications will continue in background');
        break;
      case AppLifecycleState.hidden:
        debugPrint('App hidden');
        break;
      case AppLifecycleState.inactive:
        debugPrint('App inactive');
        break;
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _lifecycleObserver = AppLifecycleObserver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

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
              navigatorKey: sl<GlobalKey<NavigatorState>>(),
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
