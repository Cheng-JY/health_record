import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// UI preference only. Never modifies medical records or user-entered text.
class AppLocaleController extends ValueNotifier<String> {
  AppLocaleController() : super('system');
  static const _key = 'healthrecord_ui_language_v1';

  Locale? get locale => value == 'system' ? null : Locale(value);

  Future<void> load() async {
    final saved = await SharedPreferencesAsync().getString(_key);
    if (saved == 'zh' || saved == 'en' || saved == 'de') value = saved!;
  }

  Future<void> setLanguage(String language) async {
    if (!const {'system', 'zh', 'en', 'de'}.contains(language)) return;
    await SharedPreferencesAsync().setString(_key, language);
    value = language;
  }
}

final appLocale = AppLocaleController();
