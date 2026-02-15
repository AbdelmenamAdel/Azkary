import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTheme {
  emerald,
  midnight,
  rose,
  forest,
  sunset,
}

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.emerald);

  void changeTheme(AppTheme theme) => emit(theme);

  ThemeData getThemeData(AppTheme theme, String languageCode) {
    final bool isArabic = languageCode == 'ar';
    final String? fontFamily = isArabic ? 'Cairo' : null;

    switch (theme) {
      case AppTheme.midnight:
        return _buildTheme(
          primary: const Color(0xFF1E293B),
          secondary: const Color(0xFF818CF8),
          fontFamily: fontFamily,
        );
      case AppTheme.rose:
        return _buildTheme(
          primary: const Color(0xFF881337),
          secondary: const Color(0xFFF472B6),
          fontFamily: fontFamily,
        );
      case AppTheme.forest:
        return _buildTheme(
          primary: const Color(0xFF064E3B),
          secondary: const Color(0xFF34D399),
          fontFamily: fontFamily,
        );
      case AppTheme.sunset:
        return _buildTheme(
          primary: const Color(0xFF7C2D12),
          secondary: const Color(0xFFFBBF24),
          fontFamily: fontFamily,
        );
      case AppTheme.emerald:
        return _buildTheme(
          primary: const Color(0xFF4EADAD),
          secondary: const Color(0xFFC29B0C),
          fontFamily: fontFamily,
        );
    }
  }

  ThemeData _buildTheme({
    required Color primary,
    required Color secondary,
    String? fontFamily,
  }) {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: primary,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        elevation: 5,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily ?? 'Cairo',
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
      ),
      fontFamily: fontFamily,
      useMaterial3: false,
    );
  }
}
