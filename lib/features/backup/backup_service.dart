import 'dart:convert';

import '../../core/database/app_database.dart';

/// A portable JSON snapshot of the app's complete v7 business database.
/// Import REPLACES local data. It never uploads data over the network.
class HealthRecordBackupService {
  HealthRecordBackupService(this.db);

  final AppDatabase db;

  static const int backupVersion = 1;
  static const int supportedSchemaVersion = 7;

  // Parent tables precede children to preserve foreign-key constraints.
  static const List<String> tables = [
    'lab_categories',
    'lab_tests',
    'hospitals',
    'lab_results',
    'imported_lab_results',
    'visits',
    'visit_reports',
    'report_result_links',
    'medications',
    'medication_plans',
  ];

  Future<String> exportJson() async {
    if (db.schemaVersion != supportedSchemaVersion) {
      throw StateError('暂不支持数据库版本 ${db.schemaVersion} 的备份，请升级备份功能。');
    }

    return db.transaction(() async {
      final contents = <String, Object?>{};
      for (final table in tables) {
        final rows = await db.customSelect('SELECT * FROM "$table"').get();
        contents[table] = rows.map((row) => row.data).toList();
      }
      return const JsonEncoder.withIndent('  ').convert({
        'format': 'health_record_local_backup',
        'backupVersion': backupVersion,
        'schemaVersion': supportedSchemaVersion,
        'exportedAt': DateTime.now().toUtc().toIso8601String(),
        'tables': contents,
      });
    });
  }

  BackupPreview inspect(String jsonText) {
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } catch (_) {
      throw const FormatException('文件不是有效的 JSON 备份。');
    }
    if (decoded is! Map<String, dynamic> ||
        decoded['format'] != 'health_record_local_backup' ||
        decoded['backupVersion'] != backupVersion ||
        decoded['schemaVersion'] != supportedSchemaVersion) {
      throw const FormatException('备份格式或数据库版本不兼容（需要 v7 备份）。');
    }
    final content = decoded['tables'];
    if (content is! Map<String, dynamic> ||
        content.length != tables.length ||
        content.keys.any((name) => !tables.contains(name))) {
      throw const FormatException('备份的数据表不完整或存在未知表。');
    }
    final counts = <String, int>{};
    for (final name in tables) {
      final rows = content[name];
      if (rows is! List || rows.any((e) => e is! Map<String, dynamic>)) {
        throw FormatException('表 $name 的记录格式不正确。');
      }
      counts[name] = rows.length;
    }
    return BackupPreview(
      exportedAt: decoded['exportedAt'] as String? ?? '未知',
      rowCounts: counts,
    );
  }

  Future<void> restoreJson(String jsonText) async {
    // No destructive write happens until complete structural validation.
    inspect(jsonText);
    if (db.schemaVersion != supportedSchemaVersion) {
      throw StateError('当前应用数据库不是 v7，不能恢复此备份。');
    }
    final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
    final data = decoded['tables'] as Map<String, dynamic>;

    // Validate every column name against this installed database schema.
    final allowedColumns = <String, Set<String>>{};
    for (final name in tables) {
      final fields = await db.customSelect('PRAGMA table_info("$name")').get();
      if (fields.isEmpty) throw StateError('数据库缺少表 $name');
      allowedColumns[name] = fields.map((r) => r.read<String>('name')).toSet();
      for (final raw in data[name] as List) {
        final row = raw as Map<String, dynamic>;
        if (row.isEmpty ||
            row.keys.any((k) => !allowedColumns[name]!.contains(k))) {
          throw FormatException('表 $name 的字段与当前数据库不兼容。');
        }
        // The current schema contains only JSON-compatible scalar values.
        if (row.values.any(
          (v) => v != null && v is! String && v is! num && v is! bool,
        )) {
          throw FormatException('表 $name 包含不支持的数据类型。');
        }
      }
    }

    // Atomic replace. On errors SQLite rolls back deletions and insertions.
    await db.transaction(() async {
      for (final name in tables.reversed) {
        await db.customStatement('DELETE FROM "$name"');
      }
      for (final name in tables) {
        for (final raw in data[name] as List) {
          final row = raw as Map<String, dynamic>;
          final columns = row.keys.toList();
          final quotedColumns = columns.map((c) => '"$c"').join(', ');
          final placeholders = List.filled(columns.length, '?').join(', ');
          await db.customStatement(
            'INSERT INTO "$name" ($quotedColumns) VALUES ($placeholders)',
            columns.map((c) => row[c]).toList(),
          );
        }
      }
    });
  }
}

class BackupPreview {
  const BackupPreview({required this.exportedAt, required this.rowCounts});
  final String exportedAt;
  final Map<String, int> rowCounts;
  int get totalRecords => rowCounts.values.fold(0, (sum, n) => sum + n);
}
