import 'package:flutter/material.dart';
import 'app_colors_extension.dart';
import 'app_theme_enum.dart';

class AppThemes {
  static ThemeData getTheme(AppTheme theme, String languageCode) {
    final bool isArabic = languageCode == 'ar';
    final String? fontFamily = isArabic ? 'Cairo' : null;

    switch (theme) {
      case AppTheme.midnight:
        return _createTheme(
          primary: const Color(0xFF1E293B),
          secondary: const Color(0xFF818CF8),
          background: const Color(0xFF0F172A),
          surface: const Color(0xFF1E293B),
          text: Colors.white,
          subtext: const Color(0xFF94A3B8),
          fontFamily: fontFamily,
        );
      case AppTheme.rose:
        return _createTheme(
          primary: const Color(0xFF880E4F),
          secondary: const Color(0xFFF06292),
          background: const Color(0xFFFCE4EC),
          surface: Colors.white,
          text: const Color(0xFF880E4F),
          subtext: const Color(0xFFAD1457),
          fontFamily: fontFamily,
        );
      case AppTheme.forest:
        return _createTheme(
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFF81C784),
          background: const Color(0xFFE8F5E9),
          surface: Colors.white,
          text: const Color(0xFF1B5E20),
          subtext: const Color(0xFF388E3C),
          fontFamily: fontFamily,
        );
      case AppTheme.sunset:
        return _createTheme(
          primary: const Color(0xFFE65100),
          secondary: const Color(0xFFFFB74D),
          background: const Color(0xFFFFF3E0),
          surface: Colors.white,
          text: const Color(0xFFE65100),
          subtext: const Color(0xFFF57C00),
          fontFamily: fontFamily,
        );
      case AppTheme.sepia:
        return _createTheme(
          primary: const Color(0xFF704214),
          secondary: const Color(0xFFD4A574),
          background: const Color(0xFFF5E6D3),
          surface: const Color(0xFFFAF3E8),
          text: const Color(0xFF5D3A1A),
          subtext: const Color(0xFF8B6F47),
          fontFamily: fontFamily,
        );
      case AppTheme.emerald:
        return _createTheme(
          primary: const Color(0xFF00695C),
          secondary: const Color(0xFF4DB6AC),
          background: const Color(0xFFE0F2F1),
          surface: Colors.white,
          text: const Color(0xFF004D40),
          subtext: const Color(0xFF00796B),
          fontFamily: fontFamily,
        );
    }
  }

  static ThemeData _createTheme({
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color text,
    required Color subtext,
    String? fontFamily,
  }) {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor:
          background, // Slightly different from header for better depth
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily ?? 'Cairo',
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extensions: [
        MyColors(
          primary: primary,
          secondary: secondary,
          background: background,
          surface: surface,
          text: text,
          subtext: subtext,
        ),
      ],
      fontFamily: fontFamily,
      useMaterial3: true,
    );
  }
}
