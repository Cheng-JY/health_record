import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';

class CsvLabRow {
  CsvLabRow({
    required this.rowNumber,
    required this.values,
    required this.sampleDate,
    required this.numericValue,
    required this.id,
  });
  final int rowNumber;
  final Map<String, String> values;
  final DateTime sampleDate;
  final double? numericValue;
  final String id;
  String get code => values['indicator_code']!;
  String get name => values['indicator_name_cn']!;
  String get rawValue => values['value']!;
}

class CsvPreview {
  CsvPreview(this.rows, this.errors);
  final List<CsvLabRow> rows;
  final List<String> errors;
}

class CsvImportService {
  CsvImportService(this.db);
  final AppDatabase db;
  static const fields = [
    'report_id',
    'sample_date',
    'report_date',
    'indicator_code',
    'indicator_name_cn',
    'value',
    'unit',
    'reference_range',
    'category',
  ];

  CsvPreview parse(List<int> bytes) {
    final content = utf8.decode(bytes).replaceFirst('\uFEFF', '');
    // Input uses UTF-8, comma-separated RFC style CSV and period decimals.
    final records = csv.decode(content);
    if (records.isEmpty) throw const FormatException('CSV 文件为空');
    final header = records.first.map((e) => e.toString().trim()).toList();
    final absent = fields.where((f) => !header.contains(f)).toList();
    if (absent.isNotEmpty) throw FormatException('缺少字段: ${absent.join(', ')}');
    final valid = <CsvLabRow>[];
    final errors = <String>[];
    // Include a per-file ordinal so repeated identical clinical measurements
    // remain distinct while reimporting an unchanged file is idempotent.
    final fileHash = sha256.convert(bytes).toString();
    for (var i = 1; i < records.length; i++) {
      final cells = records[i];
      if (cells.every((v) => v.toString().trim().isEmpty)) continue;
      if (cells.length != header.length) {
        errors.add('第 ${i + 1} 行：列数 ${cells.length}，应为 ${header.length}');
        continue;
      }
      final values = <String, String>{
        for (var j = 0; j < header.length; j++)
          header[j]: cells[j].toString().trim(),
      };
      final date = DateTime.tryParse(
        values['sample_date']!.replaceFirst(' ', 'T'),
      );
      if (date == null ||
          values['indicator_name_cn']!.isEmpty ||
          values['value']!.isEmpty) {
        errors.add('第 ${i + 1} 行：缺少采样日期、指标名称或检查结果');
        continue;
      }
      final raw = values['value']!;
      final numeric = double.tryParse(raw);
      valid.add(
        CsvLabRow(
          rowNumber: i + 1,
          values: values,
          sampleDate: date,
          numericValue: numeric,
          id: sha256.convert(utf8.encode('$fileHash:$i')).toString(),
        ),
      );
    }
    return CsvPreview(valid, errors);
  }

  /// Transaction: all new records succeed or none are written.
  /// Reimporting the exact same file skips existing row identifiers.
  Future<({int added, int skipped})> importRows(
    List<CsvLabRow> rows,
    String fileName,
  ) async {
    var added = 0;
    var skipped = 0;
    await db.transaction(() async {
      for (final row in rows) {
        final existing = await (db.select(
          db.importedLabResults,
        )..where((t) => t.id.equals(row.id))).getSingleOrNull();
        if (existing != null) {
          skipped++;
          continue;
        }
        final v = row.values;
        await db
            .into(db.importedLabResults)
            .insert(
              ImportedLabResultsCompanion.insert(
          id: row.id,
          fileName: fileName,
          reportId: v['report_id']!,
          sampleDateRaw: v['sample_date']!,
          sampleDate: row.sampleDate,
          reportDateRaw: v['report_date']!,
          indicatorCode: v['indicator_code']!,
          indicatorNameCn: v['indicator_name_cn']!,
          rawValue: v['value']!,
          numericValue: Value(row.numericValue),
          unit: v['unit']!,
          referenceRange: v['reference_range']!,
          category: v['category']!,
          importedAt: DateTime.now(),
              ),
            );
        added++;
      }
    });
    return (added: added, skipped: skipped);
  }
}
