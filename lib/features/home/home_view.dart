import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/manager/app_cubit.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/theme/app_theme_enum.dart';
import 'package:azkar/core/remote-config/auther_media.dart';
import 'package:azkar/features/home/widgets/azkar_names_section.dart';
import 'package:azkar/features/home/widgets/doaa_image_section.dart';
import 'package:azkar/features/home/widgets/e_rosary.dart';
import 'package:azkar/features/home/widgets/prayer_times_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/core/services/services_locator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              ListTile(
                leading: Icon(Icons.language, color: colors.secondary),
                title: Text(
                  context.translate('language'),
                  style: TextStyle(color: colors.text, fontFamily: 'Cairo'),
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
                  style: TextStyle(color: colors.text, fontFamily: 'Cairo'),
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
                title: const Text(
                  "تجربة التنبيهات",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                trailing: Icon(
                  Icons.play_arrow,
                  color: colors.text?.withValues(alpha: 0.5),
                  size: 16,
                ),
                onTap: () {
                  sl<NotificationService>().testNotification();
                },
              ),
              Divider(color: colors.text?.withValues(alpha: 0.1)),
              ListTile(
                leading: Icon(Icons.person, color: colors.secondary),
                title: Text(
                  context.translate('contact_developer'),
                  style: TextStyle(color: colors.text, fontFamily: 'Cairo'),
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
                    builder: (context) => const AutherMedia(),
                  );
                },
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
              AzkarNamesSection(),
              ERosarySection(),
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
