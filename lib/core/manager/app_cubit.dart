import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme/app_theme_enum.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final FlutterSecureStorage _storage;

  AppCubit(this._storage, {Locale? initialLocale, AppTheme? initialTheme})
    : super(
        AppState(
          locale: initialLocale ?? const Locale('ar'),
          theme: initialTheme ?? AppTheme.emerald,
        ),
      );

  static const String _langKey = 'lang_code';
  static const String _themeKey = 'theme_index';

  Future<void> loadSettings() async {
    try {
      final String? langCode = await _storage.read(key: _langKey);
      final String? themeIndexStr = await _storage.read(key: _themeKey);

      Locale locale = const Locale('ar');
      if (langCode != null) {
        locale = Locale(langCode);
      }

      AppTheme theme = AppTheme.emerald;
      if (themeIndexStr != null) {
        final int index = int.tryParse(themeIndexStr) ?? 0;
        if (index >= 0 && index < AppTheme.values.length) {
          theme = AppTheme.values[index];
        }
      }

      emit(AppState(locale: locale, theme: theme));
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // If storage fails, we already have default state from constructor
    }
  }

  Future<void> changeLanguage(String langCode) async {
    try {
      await _storage.write(key: _langKey, value: langCode);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
    emit(state.copyWith(locale: Locale(langCode)));
  }

  Future<void> changeTheme(AppTheme theme) async {
    try {
      await _storage.write(key: _themeKey, value: theme.index.toString());
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
    emit(state.copyWith(theme: theme));
  }
}
