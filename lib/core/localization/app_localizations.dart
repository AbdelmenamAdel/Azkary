import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'app_title': 'أذكاري',
      'morning_azkar': 'أذكار الصباح',
      'evening_azkar': 'أذكار المساء',
      'after_pray_azkar': 'أذكار بعد الصلاة',
      'sleep_azkar': 'أذكار النوم',
      'friday_sunan': 'سنن الجمعة',
      'allah_names': 'أسماء الله الحسنى',
      'daily_werd': 'وردك اليومي',
      'various_azkar': 'أذكار متفرقة',
      'roqiah': 'الرقية الشرعية',
      'dhikr_virtue': 'فضل الذكر',
      'dua_virtue': 'فضل الدعاء',
      'allah_verse':
          'هُوَ اللَّهُ الَّذِي لَا إِلَهَ إِلَّا هُوَ الرَّحْمَنُ الرَّحِيمُ المَلِكُ القُدُّوسُ السَّلَامُ المُؤْمِنُ المُهَيْمِنُ العَزِيزُ الجَبَّارُ المُتَكَبِّرُ',
      'subhan_allah': 'سُبْحَانَ اللَّهِ عَمَّا يُشْرِكُونَ',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'choose_language': 'اختر اللغة',
    },
    'en': {
      'app_title': 'Azkary',
      'morning_azkar': 'Morning Azkar',
      'evening_azkar': 'Evening Azkar',
      'after_pray_azkar': 'After Prayer Azkar',
      'sleep_azkar': 'Sleep Azkar',
      'friday_sunan': 'Friday Sunan',
      'allah_names': 'Names of Allah',
      'daily_werd': 'Daily Werd',
      'various_azkar': 'Various Azkar',
      'roqiah': 'Ruqyah',
      'dhikr_virtue': 'Virtue of Dhikr',
      'dua_virtue': 'Virtue of Dua',
      'allah_verse':
          'He is Allah, other than whom there is no deity, the Beneficent, the Merciful, the King, the Holy, the Peace, the Giver of Security, the Guardian...',
      'subhan_allah':
          'Exalted is Allah above whatever they associate with Him.',
      'settings': 'Settings',
      'language': 'Language',
      'choose_language': 'Choose Language',
    },
    'fr': {
      'app_title': 'Azkary',
      'morning_azkar': 'Azkar du Matin',
      'evening_azkar': 'Azkar du Soir',
      'after_pray_azkar': 'Azkar après la Prière',
      'sleep_azkar': 'Azkar du Sommeil',
      'friday_sunan': 'Sunan du Vendredi',
      'allah_names': 'Noms d\'Allah',
      'daily_werd': 'Werd Quotidien',
      'various_azkar': 'Azkar Divers',
      'roqiah': 'Roqya',
      'dhikr_virtue': 'Vertu du Dhikr',
      'dua_virtue': 'Vertu de l\'Invocation',
      'allah_verse':
          'C\'est Lui Allah. Nulle divinité sauf Lui; Le Souverain, Le Pur, L\'Apaisant, Le Rassurant, Le Prédominant, Le Puissant, Le Contraignant, Le Superbe.',
      'subhan_allah':
          'Gloire à Allah! Il est bien au-dessus de ce qu\'ils Lui associent.',
      'settings': 'Paramètres',
      'language': 'Langue',
      'choose_language': 'Choisir la langue',
    },
    'de': {
      'app_title': 'Azkary',
      'morning_azkar': 'Morgendliche Azkar',
      'evening_azkar': 'Abendliche Azkar',
      'after_pray_azkar': 'Azkar nach dem Gebet',
      'sleep_azkar': 'Schlaf-Azkar',
      'friday_sunan': 'Freitags-Sunan',
      'allah_names': 'Namen Allahs',
      'daily_werd': 'Tägliches Werd',
      'various_azkar': 'Verschiedene Azkar',
      'roqiah': 'Ruqyah',
      'dhikr_virtue': 'Tugend des Dhikr',
      'dua_virtue': 'Tugend des Dua',
      'allah_verse':
          'Er ist Allah, außer dem es keinen Gott gibt, der König, der Heilige, der Friede, der Gewährer der Sicherheit, der Wächter...',
      'subhan_allah': 'Gepriesen sei Allah über das, was sie Ihm beigesellen.',
      'settings': 'Einstellungen',
      'language': 'Sprache',
      'choose_language': 'Sprache wählen',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en', 'fr', 'de'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String translate(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
