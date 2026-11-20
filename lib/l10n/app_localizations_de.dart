// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'HealthRecord';

  @override
  String get home => 'Startseite';

  @override
  String get labResults => 'Laborergebnisse';

  @override
  String get hospitals => 'Krankenhäuser';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'App-Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get chinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get medicationManagement => 'Medikamentenverwaltung';

  @override
  String get medicationInventory => 'Medikamentenvorrat';

  @override
  String get addStock => 'Bestand hinzufügen';

  @override
  String get backup => 'Lokale Sicherung und Wiederherstellung';

  @override
  String get sync => 'Mac-iPhone-Synchronisierung';
}
