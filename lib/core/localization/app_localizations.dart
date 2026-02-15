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
      'themes': 'الألوان والسمات',
      'choose_theme': 'اختر اللون',
      'theme_emerald': 'الزمردي (الأصلي)',
      'theme_midnight': 'الأزرق الملكي',
      'theme_rose': 'الوردي الدافئ',
      'theme_forest': 'الغابة الهادئة',
      'theme_sunset': 'الغروب الذهبي',
      'theme_sepia': 'السيبيا الكلاسيكي',
      'comprehensive_dua': 'جوامع الدعاء',
      'contact_developer': 'تواصل مع المطور',
      'meet_developer': 'تواصل مع المطور',
      'developer_name': 'عبدالمنعم عادل',
      'developer_title': 'مهندس برمجيات تطبيقات الهاتف المحمول',
      'electronic_rosary': 'السبحة الإلكترونية',
      'total_count': 'العدد الكلي',
      'reset': 'إعادة ضبط',
      'tap_to_open_rosary': 'اضغط هنا لفتح السبحة الإلكترونية',
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
      'themes': 'Themes',
      'choose_theme': 'Choose Theme',
      'theme_emerald': 'Emerald (Default)',
      'theme_midnight': 'Midnight Royal',
      'theme_rose': 'Desert Rose',
      'theme_forest': 'Forest Serenity',
      'theme_sunset': 'Sunset Harmony',
      'theme_sepia': 'Classic Sepia',
      'comprehensive_dua': 'Comprehensive Supplications',
      'contact_developer': 'Contact Developer',
      'meet_developer': 'Meet the Developer',
      'developer_name': 'Abdelmoneim Adel',
      'developer_title': 'Software Mobile Application Engineer',
      'electronic_rosary': 'Electronic Rosary',
      'total_count': 'Total Count',
      'reset': 'Reset',
      'tap_to_open_rosary': 'Tap here to open the electronic rosary',
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
      'themes': 'Thèmes',
      'choose_theme': 'Choisir le thème',
      'theme_emerald': 'Émeraude (Par défaut)',
      'theme_midnight': 'Bleu Royal',
      'theme_rose': 'Rose du Désert',
      'theme_forest': 'Forêt Sérénité',
      'theme_sunset': 'Harmonie du Coucher de Soleil',
      'theme_sepia': 'Sépia Classique',
      'comprehensive_dua': 'Invocations Complètes',
      'contact_developer': 'Contacter le Développeur',
      'meet_developer': 'Rencontrer le Développeur',
      'developer_name': 'Abdelmoneim Adel',
      'developer_title': 'Ingénieur Logiciel d\'Applications Mobiles',
      'electronic_rosary': 'Chapelet Électronique',
      'total_count': 'Compte Total',
      'reset': 'Réinitialiser',
      'tap_to_open_rosary': 'Appuyez ici pour ouvrir le chapelet électronique',
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
      'themes': 'Themes',
      'choose_theme': 'Thema wählen',
      'theme_emerald': 'Smaragd (Standard)',
      'theme_midnight': 'Königliches Blau',
      'theme_rose': 'Wüstenrose',
      'theme_forest': 'Waldstille',
      'theme_sunset': 'Sonnenuntergang Harmonie',
      'theme_sepia': 'Klassisches Sepia',
      'comprehensive_dua': 'Umfassende Bittgebete',
      'contact_developer': 'Entwickler Kontaktieren',
      'meet_developer': 'Den Entwickler Treffen',
      'developer_name': 'Abdelmoneim Adel',
      'developer_title': 'Software-Ingenieur für Mobile Anwendungen',
      'electronic_rosary': 'Elektronischer Rosenkranz',
      'total_count': 'Gesamtzählung',
      'reset': 'Zurücksetzen',
      'tap_to_open_rosary':
          'Tippen Sie hier, um den elektronischen Rosenkranz zu öffnen',
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
