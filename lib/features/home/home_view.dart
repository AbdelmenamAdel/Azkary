import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/manager/app_cubit.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/theme/app_theme_enum.dart';
import 'package:azkar/features/home/widgets/auther_media.dart';
import 'package:azkar/features/home/widgets/azkar_names_section.dart';
import 'package:azkar/features/home/widgets/doaa_image_section.dart';
import 'package:azkar/features/home/widgets/e_rosary.dart';
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
                trailing: Icon(Icons.arrow_forward_ios,
                    color: colors.text?.withValues(alpha: 0.5), size: 16),
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
                trailing: Icon(Icons.arrow_forward_ios,
                    color: colors.text?.withValues(alpha: 0.5), size: 16),
                onTap: () {
                  _showThemeDialog(context);
                },
              ),
              Divider(color: colors.text?.withValues(alpha: 0.1)),
            ],
          ),
        ),
      ),
      appBar: AppBar(
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
        backgroundColor: context.colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.translate('choose_language'),
          style:
              TextStyle(color: context.colors.secondary, fontFamily: 'Cairo'),
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
        backgroundColor: context.colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.translate('choose_theme'),
          style:
              TextStyle(color: context.colors.secondary, fontFamily: 'Cairo'),
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
    final colors = context.colors;
    return ListTile(
      leading: CircleAvatar(backgroundColor: color, radius: 10),
      title: Text(label, style: TextStyle(color: colors.text)),
      onTap: () {
        // 1. Pop the dialog
        Navigator.pop(context);
        // 2. Pop the drawer
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.pop(_scaffoldKey.currentContext!);
        }
        // 3. Change theme
        context.read<AppCubit>().changeTheme(theme);
      },
    );
  }

  Widget _languageTile(BuildContext context, String code, String label) {
    final colors = context.colors;
    return ListTile(
      title: Text(label, style: TextStyle(color: colors.text)),
      onTap: () {
        // 1. Pop the dialog immediately
        Navigator.pop(context);

        // 2. Pop the drawer if it's open
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.pop(_scaffoldKey.currentContext!);
        }

        // 3. Change language AFTER UI items are popped to ensure stability
        context.read<AppCubit>().changeLanguage(code);
      },
    );
  }
}
