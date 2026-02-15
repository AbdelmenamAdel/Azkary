import 'package:flutter/material.dart';
import '../theme/app_theme_enum.dart';

class AppState {
  final Locale locale;
  final AppTheme theme;

  AppState({
    required this.locale,
    required this.theme,
  });

  AppState copyWith({
    Locale? locale,
    AppTheme? theme,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
    );
  }
}
