// HEALTHRECORD_DISPLAY_I18N_V5
// Display-only UI translations; original medical records remain unchanged.
import 'package:flutter/material.dart';

class DisplayI18nV5 {
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

  static String known(BuildContext context, String? original) {
    final text = original ?? '';
    const names = <String, List<String>>{
      '泼尼松龙': ['Prednisolone', 'Prednisolon'],
      '吗替麦考酚酯': ['Mycophenolate mofetil', 'Mycophenolatmofetil'],
      '羟氯喹': ['Hydroxychloroquine', 'Hydroxychloroquin'],
      '免疫抑制剂': ['Immunosuppressant', 'Immunsuppressivum'],
      '激素': ['Corticosteroid', 'Glukokortikoid'],
      '皮疹复查': ['Rash follow-up', 'Kontrolle eines Hautausschlags'],
      '激素减量': [
        'Corticosteroid dose reduction',
        'Reduktion der Glukokortikoiddosis',
      ],
      '未标记停用': ['Not marked as discontinued', 'Nicht als abgesetzt markiert'],
      '已停用（保留历史）': [
        'Discontinued (history preserved)',
        'Abgesetzt (Verlauf erhalten)',
      ],
      '门诊': ['Outpatient', 'Ambulant'],
      '住院': ['Inpatient', 'Stationär'],
      '急诊': ['Emergency', 'Notfall'],
      '其他': ['Other', 'Sonstige'],
      '未填写': ['Not specified', 'Nicht angegeben'],
      'CSV 导入': ['CSV import', 'CSV-Import'],
      '手动录入': ['Manual entry', 'Manueller Eintrag'],
    };
    final match = names[text];
    if (match == null) return text;
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'en'
        ? match[0]
        : lang == 'de'
        ? match[1]
        : text;
  }

  static String visitType(BuildContext context, String code, String fallback) {
    final names = {
      'outpatient': ['Outpatient', 'Ambulant'],
      'inpatient': ['Inpatient', 'Stationär'],
      'emergency': ['Emergency', 'Notfall'],
      'other': ['Other', 'Sonstige'],
    };
    final translations = names[code];
    if (translations == null) return known(context, fallback);
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'en'
        ? translations[0]
        : lang == 'de'
        ? translations[1]
        : fallback;
  }

  static String chartCounts(
    BuildContext context,
    int numeric,
    int limits,
    int other,
  ) => tr(
    context,
    '数值点：$numeric（含 $limits 个界限值） · 非数值结果：$other',
    'Numeric points: $numeric ($limits limit values) · Non-numeric results: $other',
    'Numerische Punkte: $numeric ($limits Grenzwerte) · Nichtnumerische Ergebnisse: $other',
  );

  static String reference(BuildContext context, String range, String unit) =>
      '${tr(context, '图中参考范围', 'Reference range in chart', 'Referenzbereich im Diagramm')}: $range $unit';

  static String visitLabel(
    BuildContext context,
    String zh,
    String en,
    String de,
    String? value,
  ) => '${tr(context, zh, en, de)}: ${known(context, value)}';
}
