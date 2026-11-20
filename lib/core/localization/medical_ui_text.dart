// HEALTHRECORD_DYNAMIC_I18N_V3
// Display-only medical labels; never change IDs or stored laboratory values.
import 'package:flutter/material.dart';

class MedicalUiText {
  static const Map<String, Map<String, String>> names = {
    "血常规": {"en": "Complete Blood Count", "de": "Blutbild"},
    "尿液检查": {"en": "Urinalysis", "de": "Urinuntersuchung"},
    "尿液与相关检验": {"en": "Urine Tests", "de": "Urinuntersuchungen"},
    "血液学与临床化学": {
      "en": "Hematology & Clinical Chemistry",
      "de": "Hämatologie und Klinische Chemie",
    },
    "临床化学": {"en": "Clinical Chemistry", "de": "Klinische Chemie"},
    "蛋白、免疫与电解质": {
      "en": "Proteins, Immunology & Electrolytes",
      "de": "Proteine, Immunologie und Elektrolyte",
    },
    "蛋白与免疫": {"en": "Proteins & Immunology", "de": "Proteine und Immunologie"},
    "自身免疫血清学": {"en": "Autoimmune Serology", "de": "Autoimmunserologie"},
    "肝炎血清学": {"en": "Hepatitis Serology", "de": "Hepatitis-Serologie"},
    "床旁血糖自测": {"en": "Point-of-Care Glucose", "de": "Blutzucker-Selbstmessung"},
    "未分类": {"en": "Uncategorized", "de": "Nicht kategorisiert"},
    "其他": {"en": "Other", "de": "Sonstige"},
    "白细胞": {"en": "White Blood Cells (WBC)", "de": "Leukozyten"},
    "白细胞计数": {"en": "White Blood Cell Count", "de": "Leukozytenzahl"},
    "红细胞": {"en": "Red Blood Cells (RBC)", "de": "Erythrozyten"},
    "红细胞计数": {"en": "Red Blood Cell Count", "de": "Erythrozytenzahl"},
    "血红蛋白": {"en": "Hemoglobin", "de": "Hämoglobin"},
    "血小板": {"en": "Platelets", "de": "Thrombozyten"},
    "血小板计数": {"en": "Platelet Count", "de": "Thrombozytenzahl"},
    "血细胞比容": {"en": "Hematocrit", "de": "Hämatokrit"},
    "红细胞压积": {"en": "Hematocrit", "de": "Hämatokrit"},
    "平均红细胞体积": {
      "en": "Mean Corpuscular Volume (MCV)",
      "de": "Mittleres Erythrozytenvolumen (MCV)",
    },
    "平均红细胞血红蛋白含量": {
      "en": "Mean Corpuscular Hemoglobin (MCH)",
      "de": "Mittlerer Hämoglobingehalt (MCH)",
    },
    "平均红细胞血红蛋白浓度": {
      "en": "Mean Corpuscular Hemoglobin Concentration (MCHC)",
      "de": "Mittlere Hämoglobinkonzentration (MCHC)",
    },
    "红细胞分布宽度": {
      "en": "Red Cell Distribution Width (RDW)",
      "de": "Erythrozytenverteilungsbreite (RDW)",
    },
    "中性粒细胞": {"en": "Neutrophils", "de": "Neutrophile"},
    "中性粒细胞绝对值": {
      "en": "Absolute Neutrophil Count",
      "de": "Absolute Neutrophilenzahl",
    },
    "分叶中性粒细胞": {
      "en": "Segmented Neutrophils",
      "de": "Segmentkernige Neutrophile",
    },
    "淋巴细胞": {"en": "Lymphocytes", "de": "Lymphozyten"},
    "淋巴细胞绝对值": {
      "en": "Absolute Lymphocyte Count",
      "de": "Absolute Lymphozytenzahl",
    },
    "单核细胞": {"en": "Monocytes", "de": "Monozyten"},
    "嗜酸性粒细胞": {"en": "Eosinophils", "de": "Eosinophile"},
    "嗜碱性粒细胞": {"en": "Basophils", "de": "Basophile"},
    "网织红细胞": {"en": "Reticulocytes", "de": "Retikulozyten"},
    "平均血小板体积": {
      "en": "Mean Platelet Volume (MPV)",
      "de": "Mittleres Thrombozytenvolumen (MPV)",
    },
    "C反应蛋白": {
      "en": "C-Reactive Protein (CRP)",
      "de": "C-reaktives Protein (CRP)",
    },
    "C 反应蛋白": {
      "en": "C-Reactive Protein (CRP)",
      "de": "C-reaktives Protein (CRP)",
    },
    "超敏C反应蛋白": {"en": "High-Sensitivity CRP", "de": "Hochsensitives CRP"},
    "降钙素原": {"en": "Procalcitonin", "de": "Prokalzitonin"},
    "乳酸脱氢酶": {
      "en": "Lactate Dehydrogenase (LDH)",
      "de": "Laktatdehydrogenase (LDH)",
    },
    "γ-谷氨酰转移酶": {
      "en": "Gamma-Glutamyl Transferase (GGT)",
      "de": "Gamma-Glutamyltransferase (GGT)",
    },
    "谷丙转氨酶": {
      "en": "Alanine Aminotransferase (ALT)",
      "de": "Alanin-Aminotransferase (ALT)",
    },
    "谷草转氨酶": {
      "en": "Aspartate Aminotransferase (AST)",
      "de": "Aspartat-Aminotransferase (AST)",
    },
    "碱性磷酸酶": {
      "en": "Alkaline Phosphatase (ALP)",
      "de": "Alkalische Phosphatase (ALP)",
    },
    "总蛋白": {"en": "Total Protein", "de": "Gesamteiweiß"},
    "白蛋白": {"en": "Albumin", "de": "Albumin"},
    "球蛋白": {"en": "Globulin", "de": "Globulin"},
    "总胆红素": {"en": "Total Bilirubin", "de": "Gesamtbilirubin"},
    "直接胆红素": {"en": "Direct Bilirubin", "de": "Direktes Bilirubin"},
    "间接胆红素": {"en": "Indirect Bilirubin", "de": "Indirektes Bilirubin"},
    "肌酐": {"en": "Creatinine", "de": "Kreatinin"},
    "尿素": {"en": "Urea", "de": "Harnstoff"},
    "尿素氮": {
      "en": "Blood Urea Nitrogen (BUN)",
      "de": "Harnstoff-Stickstoff (BUN)",
    },
    "尿酸": {"en": "Uric Acid", "de": "Harnsäure"},
    "钠": {"en": "Sodium", "de": "Natrium"},
    "钾": {"en": "Potassium", "de": "Kalium"},
    "氯": {"en": "Chloride", "de": "Chlorid"},
    "钙": {"en": "Calcium", "de": "Kalzium"},
    "镁": {"en": "Magnesium", "de": "Magnesium"},
    "磷": {"en": "Phosphate", "de": "Phosphat"},
    "葡萄糖": {"en": "Glucose", "de": "Glukose"},
    "血糖": {"en": "Blood Glucose", "de": "Blutzucker"},
    "补体C3": {"en": "Complement C3", "de": "Komplement C3"},
    "补体C4": {"en": "Complement C4", "de": "Komplement C4"},
    "补体 C3": {"en": "Complement C3", "de": "Komplement C3"},
    "补体 C4": {"en": "Complement C4", "de": "Komplement C4"},
    "补体C3c": {"en": "Complement C3c", "de": "Komplement C3c"},
    "抗核抗体": {
      "en": "Antinuclear Antibodies (ANA)",
      "de": "Antinukleäre Antikörper (ANA)",
    },
    "抗双链DNA抗体": {"en": "Anti-dsDNA Antibodies", "de": "Anti-dsDNA-Antikörper"},
    "抗Sm抗体": {"en": "Anti-Sm Antibodies", "de": "Anti-Sm-Antikörper"},
    "免疫球蛋白G": {"en": "Immunoglobulin G (IgG)", "de": "Immunglobulin G (IgG)"},
    "免疫球蛋白A": {"en": "Immunoglobulin A (IgA)", "de": "Immunglobulin A (IgA)"},
    "免疫球蛋白M": {"en": "Immunoglobulin M (IgM)", "de": "Immunglobulin M (IgM)"},
    "尿pH": {"en": "Urine pH", "de": "Urin-pH"},
    "尿液pH": {"en": "Urine pH", "de": "Urin-pH"},
    "尿液比重": {"en": "Urine Specific Gravity", "de": "Spezifisches Uringewicht"},
    "尿比重": {"en": "Urine Specific Gravity", "de": "Spezifisches Uringewicht"},
    "尿蛋白": {"en": "Urine Protein", "de": "Urinprotein"},
    "尿总蛋白": {"en": "Total Urine Protein", "de": "Gesamtprotein im Urin"},
    "尿糖": {"en": "Urine Glucose", "de": "Uringlukose"},
    "尿酮体": {"en": "Urine Ketones", "de": "Urinketone"},
    "尿红细胞": {"en": "Urine Red Blood Cells", "de": "Erythrozyten im Urin"},
    "尿白细胞": {"en": "Urine White Blood Cells", "de": "Leukozyten im Urin"},
    "尿亚硝酸盐": {"en": "Urine Nitrite", "de": "Nitrit im Urin"},
    "尿胆原": {"en": "Urobilinogen", "de": "Urobilinogen"},
    "尿胆红素": {"en": "Urine Bilirubin", "de": "Bilirubin im Urin"},
    "尿量": {"en": "Urine Volume", "de": "Urinvolumen"},
    "尿液收集时间": {"en": "Urine Collection Duration", "de": "Urinsammelzeit"},
    "尿蛋白/肌酐比值": {
      "en": "Urine Protein/Creatinine Ratio",
      "de": "Protein/Kreatinin-Quotient im Urin",
    },
  };

  static String name(BuildContext context, String raw) {
    final language = Localizations.localeOf(context).languageCode;
    if (language == 'zh') return raw;
    // Only known exact terms are translated. Unknown terms remain original.
    return names[raw.trim()]?[language] ?? raw;
  }

  static String text(BuildContext context, String zh, String en, String de) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'en':
        return en;
      case 'de':
        return de;
      default:
        return zh;
    }
  }

  static String hospitalCounts(
    BuildContext context,
    String? city,
    int active,
    int linked,
  ) {
    final place = city == null || city.trim().isEmpty
        ? text(context, '未填写城市', 'City not specified', 'Stadt nicht angegeben')
        : city;
    return text(
      context,
      '$place · 有效检查 $active 条 · 全部关联 $linked 条',
      '$place · $active active results · $linked linked results',
      '$place · $active aktive Befunde · $linked verknüpfte Befunde',
    );
  }

  static String labsOverview(
    BuildContext context,
    int total,
    int manual,
    int csv,
  ) => text(
    context,
    '共 $total 条 · 手动 $manual 条 · CSV $csv 条',
    '$total results · $manual manual · $csv imported',
    '$total Ergebnisse · $manual manuell · $csv importiert',
  );

  static String countIndicators(BuildContext context, int count) =>
      text(context, '$count 个指标', '$count indicators', '$count Parameter');

  static String countRecords(BuildContext context, int count) =>
      text(context, '$count 条', '$count records', '$count Einträge');

  static String latest(BuildContext context, String date) =>
      text(context, '最新：$date', 'Latest: $date', 'Zuletzt: $date');
}
