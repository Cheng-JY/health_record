// HEALTHRECORD_MED_DETAIL_I18N_V4
// Presentation-only; never modify stored medication names, dose or history.
import 'package:flutter/material.dart';

class MedicationDetailI18n {
  static String tr(BuildContext context, String zh, String en, String de) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'en':
        return en;
      case 'de':
        return de;
      default:
        return zh;
    }
  }

  static const _drugNames = <String, List<String>>{
    '泼尼松龙': ['Prednisolone', 'Prednisolon'],
    '吗替麦考酚酯': ['Mycophenolate mofetil', 'Mycophenolatmofetil'],
    '羟氯喹': ['Hydroxychloroquine', 'Hydroxychloroquin'],
    '艾司西酞普兰': ['Escitalopram', 'Escitalopram'],
    '罗拉西泮': ['Lorazepam', 'Lorazepam'],
    '骨化三醇': ['Calcitriol', 'Calcitriol'],
    '阿法骨化醇': ['Alfacalcidol', 'Alfacalcidol'],
  };
  static const _exactValues = <String, List<String>>{
    '激素': ['Corticosteroid', 'Glukokortikoid'],
    '免疫抑制剂': ['Immunosuppressant', 'Immunsuppressivum'],
    '激素减量': ['Steroid dose reduction', 'Kortison-Dosisreduktion'],
    '未填写': ['Not specified', 'Nicht angegeben'],
    '持续中': ['Ongoing', 'Laufend'],
    '每日': ['Daily', 'Täglich'],
    '每周一次': ['Once weekly', 'Einmal wöchentlich'],
    '按需': ['As needed', 'Bei Bedarf'],
  };

  static String _lookup(
    BuildContext context,
    String raw,
    Map<String, List<String>> terms,
  ) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'zh') return raw;
    final found = terms[raw.trim()];
    if (found == null) return raw;
    return found[code == 'de' ? 1 : 0];
  }

  static String drugName(BuildContext context, String name) =>
      _lookup(context, name, _drugNames);
  static String dataValue(BuildContext context, String value) =>
      _lookup(context, value, _exactValues);

  static String frequency(BuildContext context, String value) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'zh') return value;
    final trimmed = value.trim();
    final match = RegExp(r'^每日\s*([1-9][0-9]*)\s*次$').firstMatch(trimmed);
    if (match != null) {
      final n = match.group(1)!;
      return lang == 'de' ? '$n-mal täglich' : '$n times daily';
    }
    return dataValue(context, value);
  }

  static String date(BuildContext context, DateTime? value) {
    if (value == null) return dataValue(context, '持续中');
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }
}
