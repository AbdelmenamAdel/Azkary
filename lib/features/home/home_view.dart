import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/manager/app_cubit.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/theme/app_theme_enum.dart';
import 'package:azkar/core/remote-config/auther_media.dart';
import 'package:azkar/features/home/widgets/azkar_names_section.dart';
import 'package:azkar/features/home/widgets/doaa_image_section.dart';
import 'package:azkar/features/home/widgets/e_rosary.dart';
import 'package:azkar/features/home/widgets/prayer_times_section.dart';
import 'package:azkar/features/home/widgets/permissions_bottom_sheet.dart';
import 'package:azkar/features/home/widgets/bug_report_sheet.dart';
import 'package:azkar/features/home/widgets/suggestions_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/core/services/services_locator.dart';
import 'package:azkar/core/services/version_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionOnFirstLaunch();
  }

  Future<void> _checkLocationPermissionOnFirstLaunch() async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final hasShownLocationDialog = await storage.read(
        key: 'location_permission_shown',
      );

      if (hasShownLocationDialog == null) {
        // First launch, show location dialog
        await storage.write(key: 'location_permission_shown', value: 'true');
        final status = await Geolocator.checkPermission();
        if (mounted && status == LocationPermission.denied) {
          _showLocationPermissionDialog();
        }
      } else {
        // Not first launch, but still check if permission is disabled
        final status = await Geolocator.checkPermission();
        if (mounted && status == LocationPermission.denied) {
          // Location is not enabled, show dialog if user hasn't used app yet today
          final lastCheck = await storage.read(key: 'last_location_check');
          final today = DateTime.now().toString().split(' ')[0];

          if (lastCheck != today) {
            await storage.write(key: 'last_location_check', value: today);
            _showLocationPermissionDialog();
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking location permission: $e');
    }
  }

  void _showLocationPermissionDialog() {
    final colors = context.colors;
    final textColor = colors.text ?? Colors.black87;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.translate('perm_location'),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نحتاج إلى الوصول إلى موقعك لحساب أوقات الصلاة بدقة.',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: textColor.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'هذا سيساعدنا في تقديم أوقات صلاة دقيقة لموقعك.',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: Colors.blue.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'ليس الآن',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: textColor.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _requestLocationPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text(
                'السماح',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestLocationPermission() async {
    try {
      final status = await Geolocator.requestPermission();
      if (mounted) {
        if (status == LocationPermission.denied) {
          // User denied permission
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'لم تسمح بالوصول إلى الموقع. سيتم استخدام القاهرة كموقع افتراضي.',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (status == LocationPermission.deniedForever) {
          // User denied permanently, open app settings
          _showOpenSettingsDialog();
        } else if (status == LocationPermission.whileInUse ||
            status == LocationPermission.always) {
          // Permission granted
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'شكراً! سيتم استخدام موقعك لحساب أوقات الصلاة.',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
    }
  }

  void _showOpenSettingsDialog() {
    final colors = context.colors;
    final textColor = colors.text ?? Colors.black87;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_outlined,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'السماح بالموقع',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'قمت برفض إذن الموقع نهائياً. يرجى فتح إعدادات التطبيق والسماح بالوصول إلى الموقع.',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: textColor.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: textColor.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Geolocator.openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'فتح الإعدادات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: colors.background,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colors.primary?.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings, color: colors.secondary, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        context.translate('settings'),
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 24,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.language, color: colors.secondary),
                        title: Text(
                          context.translate('language'),
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 12,

                            fontFamily: 'Cairo',
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: colors.text?.withValues(alpha: 0.5),
                          size: 16,
                        ),
                        onTap: () {
                          _showLanguageDialog(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.palette, color: colors.secondary),
                        title: Text(
                          context.translate('themes'),
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.text,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: colors.text?.withValues(alpha: 0.5),
                          size: 16,
                        ),
                        onTap: () {
                          _showThemeDialog(context);
                        },
                      ),
                      // if (false)
                      ListTile(
                        leading: Icon(
                          Icons.notifications_active,
                          color: colors.secondary,
                        ),
                        title: Text(
                          "تجربة التنبيهات",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cairo',
                            color: context.colors.text,
                          ),
                        ),
                        trailing: Icon(
                          Icons.play_arrow,
                          color: colors.text?.withValues(alpha: 0.5),
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          sl<NotificationService>().testNotification();
                        },
                      ),
                      Divider(color: colors.text?.withValues(alpha: 0.1)),
                      ListTile(
                        leading: Icon(
                          Icons.security_rounded,
                          color: colors.secondary,
                        ),
                        title: Text(
                          context.translate('permissions'),
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.text,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: colors.text?.withValues(alpha: 0.5),
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const PermissionsBottomSheet(),
                          );
                        },
                      ),
                      Divider(color: colors.text?.withValues(alpha: 0.1)),
                      // Feedback Expansion Tile with Animated Trailing
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          trailing: Icon(
                            Icons.expand_more_rounded,
                            color: colors.primary?.withValues(alpha: 0.5),
                            size: 24,
                          ),
                          leading: Icon(
                            Icons.feedback_rounded,
                            color: colors.secondary,
                          ),
                          title: Text(
                            context.translate('feedback_title'),
                            style: TextStyle(
                              color: colors.text,
                              fontFamily: 'Cairo',
                              fontSize: 12,
                            ),
                          ),
                          children: [
                            Container(
                              color: colors.primary?.withValues(alpha: 0.05),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.bug_report_rounded,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  context.translate('feedback_bugs'),
                                  style: TextStyle(
                                    fontSize: 12,

                                    color: colors.text,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => const BugReportSheet(),
                                  );
                                },
                              ),
                            ),
                            Divider(
                              color: colors.text?.withValues(alpha: 0.1),
                              height: 1,
                            ),
                            Container(
                              color: colors.primary?.withValues(alpha: 0.025),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.lightbulb_rounded,
                                  color: Colors.amber,
                                ),
                                title: Text(
                                  context.translate('feedback_suggestions'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.text,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => const SuggestionsSheet(),
                                  );
                                },
                              ),
                            ),
                            Divider(
                              color: colors.text?.withValues(alpha: 0.1),
                              height: 1,
                            ),
                            Container(
                              color: colors.primary?.withValues(alpha: 0.05),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.teal,
                                ),
                                title: Text(
                                  context.translate('contact_developer'),
                                  style: TextStyle(
                                    fontSize: 12,

                                    color: colors.text,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => const AutherMedia(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // app current version
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 24,
                ),
                child: FutureBuilder<String>(
                  future: VersionService.getFullVersionString(),
                  builder: (context, snapshot) {
                    final version = snapshot.data ?? 'v0.0.0+0';
                    return Column(
                      children: [
                        Divider(color: colors.text?.withValues(alpha: 0.1)),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Version: $version',
                            style: TextStyle(
                              color: colors.text?.withValues(alpha: 0.5),
                              fontSize: 11,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colors.primary,
        elevation: 5,
        shadowColor: colors.primary?.withValues(alpha: 0.5),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          context.translate('app_title'),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(3.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PrayerTimesSection(),
              ERosarySection(),
              AzkarNamesSection(),
              DoaaImageSection(),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.translate('choose_language'),
                style: TextStyle(
                  color: context.colors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  fontFamily: 'Cairo',
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),
              _languageTile(context, 'ar', 'العربية', '🇸🇦'),
              _languageTile(context, 'en', 'English', '🇬🇧'),
              _languageTile(context, 'fr', 'Français', '🇫🇷'),
              _languageTile(context, 'de', 'Deutsch', '🇩🇪'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.translate('choose_theme'),
                style: TextStyle(
                  color: context.colors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  fontFamily: 'Cairo',
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),
              _themeTile(
                context,
                AppTheme.emerald,
                context.translate('theme_emerald'),
                const Color(0xFF4EADAD),
              ),
              _themeTile(
                context,
                AppTheme.midnight,
                context.translate('theme_midnight'),
                const Color(0xFF1E293B),
              ),
              _themeTile(
                context,
                AppTheme.rose,
                context.translate('theme_rose'),
                const Color(0xFF881337),
              ),
              _themeTile(
                context,
                AppTheme.forest,
                context.translate('theme_forest'),
                const Color(0xFF064E3B),
              ),
              _themeTile(
                context,
                AppTheme.sunset,
                context.translate('theme_sunset'),
                const Color(0xFF7C2D12),
              ),
              _themeTile(
                context,
                AppTheme.sepia,
                context.translate('theme_sepia'),
                const Color(0xFF704214),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeTile(
    BuildContext context,
    AppTheme theme,
    String label,
    Color color,
  ) {
    final colors = context.colors;
    final cubit = context.read<AppCubit>();
    final isSelected = cubit.state.theme == theme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? colors.primary!.withValues(alpha: 0.1) : null,
        border: Border.all(
          color: isSelected
              ? colors.secondary!.withValues(alpha: 0.5)
              : colors.text!.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: isSelected
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : null,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: colors.text,
            fontFamily: 'Cairo',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: colors.secondary, size: 24)
            : Icon(
                Icons.arrow_forward_ios,
                color: colors.text?.withValues(alpha: 0.5),
                size: 16,
              ),
        onTap: () {
          Navigator.pop(context);
          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            Navigator.pop(_scaffoldKey.currentContext!);
          }
          context.read<AppCubit>().changeTheme(theme);
        },
      ),
    );
  }

  Widget _languageTile(
    BuildContext context,
    String code,
    String label,
    String flag,
  ) {
    final colors = context.colors;
    final cubit = context.read<AppCubit>();
    final isSelected = cubit.state.locale.languageCode == code;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? colors.primary!.withValues(alpha: 0.1) : null,
        border: Border.all(
          color: isSelected
              ? colors.secondary!.withValues(alpha: 0.5)
              : colors.text!.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 32)),
        title: Text(
          label,
          style: TextStyle(
            color: colors.text,
            fontFamily: 'Cairo',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: colors.secondary, size: 24)
            : Icon(
                Icons.arrow_forward_ios,
                color: colors.text?.withValues(alpha: 0.5),
                size: 16,
              ),
        onTap: () {
          Navigator.pop(context);
          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            Navigator.pop(_scaffoldKey.currentContext!);
          }
          context.read<AppCubit>().changeLanguage(code);
        },
      ),
    );
  }
}
