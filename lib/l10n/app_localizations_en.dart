// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HealthRecord';

  @override
  String get home => 'Home';

  @override
  String get labResults => 'Lab Results';

  @override
  String get hospitals => 'Hospitals';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'App Language';

  @override
  String get systemLanguage => 'Follow system';

  @override
  String get chinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get medicationManagement => 'Medications';

  @override
  String get medicationInventory => 'Medication Inventory';

  @override
  String get addStock => 'Add Stock';

  @override
  String get backup => 'Local Backup & Restore';

  @override
  String get sync => 'Mac and iPhone Sync';
}
