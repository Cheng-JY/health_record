// HEALTHRECORD_L10N_V6
// Display-only: never alter SQLite data, medication instructions or imported CSV.
import 'package:flutter/material.dart';

import 'ui_i18n.dart';
import 'medical_ui_text.dart';
import 'medication_detail_i18n.dart';
import 'display_i18n_v5.dart';

class V6Display {
  static String t(BuildContext context, String zh, String en, String de) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'en':
        return en;
      case 'de':
        return de;
      default:
        return zh;
    }
  }

  static const Map<String, List<String>> _labels = {
    '快捷操作': ['Quick Actions', 'Schnellzugriff'],
    '当前用药': ['Current Medications', 'Aktuelle Medikamente'],
    '最近一次就诊': ['Latest Visit', 'Letzter Arztbesuch'],
    '症状记录': ['Symptom Records', 'Symptomprotokoll'],
    '暂无就诊记录': ['No visits recorded', 'Noch keine Arztbesuche erfasst'],
    '就诊记录': ['Visit Records', 'Arztbesuche'],
    '点击添加或查看就诊记录': [
      'Add or view visit records',
      'Arztbesuche hinzufügen oder ansehen',
    ],
    '库存详情': ['Inventory Details', 'Bestandsdetails'],
    '尚未登记库存': ['No stock recorded', 'Noch kein Bestand erfasst'],
    '未配置消耗': [
      'Daily usage not configured',
      'Tagesverbrauch nicht konfiguriert',
    ],
    '血液学与凝血': ['Hematology & Coagulation', 'Hämatologie und Gerinnung'],
    '凝血酶原时间': ['Prothrombin Time (PT)', 'Prothrombinzeit (PT)'],
    'Quick凝血酶原时间': [
      'Prothrombin Activity (Quick)',
      'Quick-Wert (Prothrombinaktivität)',
    ],
    'Quick 凝血酶原时间': [
      'Prothrombin Activity (Quick)',
      'Quick-Wert (Prothrombinaktivität)',
    ],
    '国际标准化比值': [
      'International Normalized Ratio (INR)',
      'International Normalized Ratio (INR)',
    ],
    '部分凝血活酶时间': [
      'Activated Partial Thromboplastin Time (aPTT)',
      'Aktivierte partielle Thromboplastinzeit (aPTT)',
    ],
    '活化部分凝血活酶时间': [
      'Activated Partial Thromboplastin Time (aPTT)',
      'Aktivierte partielle Thromboplastinzeit (aPTT)',
    ],
    '纤维蛋白原': ['Fibrinogen', 'Fibrinogen'],
    '凝血酶时间': ['Thrombin Time (TT)', 'Thrombinzeit (TT)'],
    'D-二聚体': ['D-dimer', 'D-Dimer'],
    '血小板压积': ['Plateletcrit (PCT)', 'Thrombozytenhämatokrit (PCT)'],
    '平均血红蛋白浓度': [
      'Mean Corpuscular Hemoglobin Concentration (MCHC)',
      'Mittlere korpuskuläre Hämoglobinkonzentration (MCHC)',
    ],
  };

  static String ui(BuildContext context, String raw) {
    final translated = UiI18n.translate(context, raw);
    if (translated != raw) return translated;
    final language = Localizations.localeOf(context).languageCode;
    final pair = _labels[raw.trim()];
    if (pair == null || language == 'zh') return raw;
    return pair[language == 'de' ? 1 : 0];
  }

  static String medication(BuildContext context, String raw) =>
      MedicationDetailI18n.drugName(context, raw);

  static String frequency(BuildContext context, String raw) {
    final translated = MedicationDetailI18n.frequency(context, raw);
    // More natural English wording for 'once daily'.
    final match = RegExp(r'^每日\s*([1-9][0-9]*)\s*次$').firstMatch(raw.trim());
    if (match != null && Localizations.localeOf(context).languageCode == 'en') {
      final n = int.parse(match.group(1)!);
      return n == 1
          ? 'Once daily'
          : n == 2
          ? 'Twice daily'
          : '$n times daily';
    }
    return translated;
  }

  static String reason(BuildContext context, String raw) =>
      DisplayI18nV5.known(context, raw);

  static String medical(BuildContext context, String raw) {
    final existing = MedicalUiText.name(context, raw);
    return existing != raw ? existing : ui(context, raw);
  }

  static String medicalWithCode(BuildContext context, String raw) {
    // Chart labels frequently contain the stable indicator code in parentheses.
    final match = RegExp(r'^(.+) \(([^()]*)\)$').firstMatch(raw);
    if (match == null) return medical(context, raw);
    return '${medical(context, match.group(1)!)} (${match.group(2)!})';
  }

  static String batchRemaining(
    BuildContext context,
    String quantity,
    String unit,
    int? days,
  ) {
    final suffix = days == null
        ? ui(context, '未配置消耗')
        : '$days ${t(context, '天', 'days', 'Tage')}';
    return t(
      context,
      '剩余：$quantity $unit · 预计 $suffix',
      'Remaining: $quantity $unit · Estimated: $suffix',
      'Restbestand: $quantity $unit · Geschätzt: $suffix',
    );
  }

  static String batchDaily(
    BuildContext context,
    String quantity,
    String unit,
  ) => t(
    context,
    '每日实际消耗：$quantity $unit',
    'Actual daily usage: $quantity $unit',
    'Tatsächlicher Tagesverbrauch: $quantity $unit',
  );
  static String batchExpiry(BuildContext context, String expiry) => t(
    context,
    '有效期：$expiry',
    'Expiry date: $expiry',
    'Verfallsdatum: $expiry',
  );
  static String batchPack(
    BuildContext context,
    String batch,
    int packSize,
    String unit,
  ) => t(
    context,
    '批号：$batch · 每盒 $packSize $unit',
    'Batch: $batch · $packSize $unit per pack',
    'Charge: $batch · $packSize $unit pro Packung',
  );

  static String inventorySummary(
    BuildContext context,
    int days,
    int missing,
    int batches,
  ) {
    if (batches == 0) return ui(context, '尚未登记库存');
    if (missing > 0)
      return t(
        context,
        '已配置批次约 $days 天；另有 $missing 批待设置消耗',
        'About $days days in configured batches; $missing batch(es) need daily usage',
        'Ca. $days Tage in konfigurierten Chargen; bei $missing Charge(n) fehlt der Tagesverbrauch',
      );
    return t(
      context,
      '已登记 $batches 批 · 按已确认的消耗规则估算',
      '$batches batches · estimated from confirmed daily usage',
      '$batches Chargen · Schätzung anhand des bestätigten Tagesverbrauchs',
    );
  }

  static String inventoryDays(
    BuildContext context,
    int days,
    int missing,
    bool empty,
  ) {
    if (empty) return '—';
    final suffix = t(context, '天', 'days', 'Tage');
    return '${missing > 0 ? '≥' : ''}$days $suffix';
  }
}
