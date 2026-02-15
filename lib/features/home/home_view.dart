import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/localization/language_cubit.dart';
import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/features/home/widgets/auther_media.dart';
import 'package:azkar/features/home/widgets/azkar_names_section.dart';
import 'package:azkar/features/home/widgets/doaa_image_section.dart';
import 'package:azkar/features/home/widgets/e_rosary.dart';
import 'package:azkar/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primary,
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF0F172A),
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.settings,
                          color: AppColors.secondary, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        context.translate('settings'),
                        style: const TextStyle(
                          color: Colors.white,
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
                leading: const Icon(Icons.language, color: AppColors.secondary),
                title: Text(
                  context.translate('language'),
                  style:
                      const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                ),
                trailing: RotatedBox(
                  quarterTurns:
                      Directionality.of(context) == TextDirection.rtl ? 2 : 0,
                  child: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white54, size: 16),
                ),
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette, color: AppColors.secondary),
                title: Text(
                  context.translate('themes'),
                  style:
                      const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white54, size: 16),
                onTap: () {
                  _showThemeDialog(context);
                },
              ),
              const Divider(color: Colors.white24),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 5,
        shadowColor: AppColors.blueGrey.withValues(alpha: 0.5),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          context.translate('app_title'),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.language, color: Colors.white),
        //     onPressed: () => _showLanguageDialog(context),
        //   ),
        // ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(3.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DoaaImageSection(),
              AzkarNamesSection(),
              ERosarySection(),
              AuthorMedia(),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.translate('choose_language'),
          style:
              const TextStyle(color: AppColors.secondary, fontFamily: 'Cairo'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageTile(context, 'ar', 'العربية'),
            _languageTile(context, 'en', 'English'),
            _languageTile(context, 'fr', 'Français'),
            _languageTile(context, 'de', 'Deutsch'),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.translate('choose_theme'),
          style:
              const TextStyle(color: AppColors.secondary, fontFamily: 'Cairo'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _themeTile(context, AppTheme.emerald,
                context.translate('theme_emerald'), const Color(0xFF4EADAD)),
            _themeTile(context, AppTheme.midnight,
                context.translate('theme_midnight'), const Color(0xFF1E293B)),
            _themeTile(context, AppTheme.rose, context.translate('theme_rose'),
                const Color(0xFF881337)),
            _themeTile(context, AppTheme.forest,
                context.translate('theme_forest'), const Color(0xFF064E3B)),
            _themeTile(context, AppTheme.sunset,
                context.translate('theme_sunset'), const Color(0xFF7C2D12)),
          ],
        ),
      ),
    );
  }

  Widget _themeTile(
      BuildContext context, AppTheme theme, String label, Color color) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color, radius: 10),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        // 1. Pop the dialog
        Navigator.pop(context);
        // 2. Pop the drawer
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.pop(_scaffoldKey.currentContext!);
        }
        // 3. Change theme
        context.read<ThemeCubit>().changeTheme(theme);
      },
    );
  }

  Widget _languageTile(BuildContext context, String code, String label) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        // 1. Pop the dialog immediately
        Navigator.pop(context);

        // 2. Pop the drawer if it's open
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.pop(_scaffoldKey.currentContext!);
        }

        // 3. Change language AFTER UI items are popped to ensure stability
        context.read<LanguageCubit>().changeLanguage(code);
      },
    );
  }
}
