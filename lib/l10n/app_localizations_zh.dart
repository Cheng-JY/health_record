// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'HealthRecord';

  @override
  String get home => '首页';

  @override
  String get labResults => '检查结果';

  @override
  String get hospitals => '医院';

  @override
  String get settings => '设置';

  @override
  String get language => '应用语言';

  @override
  String get systemLanguage => '跟随系统';

  @override
  String get chinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get medicationManagement => '用药管理';

  @override
  String get medicationInventory => '药品库存';

  @override
  String get addStock => '新增库存';

  @override
  String get backup => '本地备份与恢复';

  @override
  String get sync => 'Mac 与 iPhone 同步';
}
