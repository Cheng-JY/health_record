import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class LabCategories extends Table {
  TextColumn get id => text()();
  TextColumn get code => text().unique()();
  TextColumn get nameZh => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {id};
}

class LabTests extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(LabCategories, #id)();
  TextColumn get code => text().unique()();
  TextColumn get nameZh => text()();
  TextColumn get nameDe => text().nullable()();
  TextColumn get canonicalUnit => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class LabResults extends Table {
  TextColumn get id => text()();
  TextColumn get testId => text().references(LabTests, #id)();
  DateTimeColumn get measuredAt => dateTime()();
  RealColumn get valueNumeric => real()();
  TextColumn get unit => text()();
  RealColumn get referenceLow => real().nullable()();
  RealColumn get referenceHigh => real().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// CSV entries are separate from manual records to preserve original text values.
class ImportedLabResults extends Table {
  TextColumn get id => text()();
  TextColumn get fileName => text()();
  TextColumn get reportId => text()();
  TextColumn get sampleDateRaw => text()();
  DateTimeColumn get sampleDate => dateTime()();
  TextColumn get reportDateRaw => text()();
  TextColumn get indicatorCode => text()();
  TextColumn get indicatorNameCn => text()();
  TextColumn get rawValue => text()();
  RealColumn get numericValue => real().nullable()();
  TextColumn get unit => text()();
  TextColumn get referenceRange => text()();
  TextColumn get category => text()();
  DateTimeColumn get importedAt => dateTime()();
  // Added in schema v3. Edits never overwrite the CSV provenance snapshot.
  TextColumn get originalSnapshot => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get editedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get hospitalId => text().nullable().references(Hospitals, #id)();
  @override
  Set<Column> get primaryKey => {id};
}

class Hospitals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get city => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

/// A distinct outpatient, inpatient or emergency encounter at a hospital.
class Visits extends Table {
  TextColumn get id => text()();
  TextColumn get hospitalId => text().references(Hospitals, #id)();
  TextColumn get visitType =>
      text()(); // outpatient / inpatient / emergency / other
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get department => text().nullable()();
  TextColumn get doctor => text().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A report belongs to one visit. This is report metadata, not the PDF itself.
class VisitReports extends Table {
  TextColumn get id => text()();
  TextColumn get visitId => text().references(Visits, #id)();
  TextColumn get title => text()();
  DateTimeColumn get reportDate => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

/// A lab result may belong to at most one report, regardless of source.
/// Existing lab tables remain untouched. The repository validates target IDs.
class ReportResultLinks extends Table {
  TextColumn get reportId => text().references(VisitReports, #id)();
  TextColumn get sourceKind => text()(); // 'csv' or 'manual'
  TextColumn get resultId => text()();
  @override
  Set<Column> get primaryKey => {sourceKind, resultId};
}

/// Drug catalog item. Retain it when a prescription ends for audit/history.
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get strength => text().nullable()(); // e.g. "500 mg/tablet"
  TextColumn get form => text().nullable()(); // tablet / capsule / injection
  TextColumn get purpose => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// A historical, date-bounded medication plan. Never overwrite old doses.
class MedicationPlans extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text().references(Medications, #id)();
  TextColumn get dose => text()(); // "1片", "500 mg", etc.
  TextColumn get frequency => text()(); // "每日", "每周一次", "按需", etc.
  TextColumn get times => text().nullable()(); // "08:00,20:00"
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get changeReason => text().nullable()();
  TextColumn get instructions => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    LabCategories,
    LabTests,
    LabResults,
    ImportedLabResults,
    Hospitals,
    Visits,
    VisitReports,
    ReportResultLinks,
    Medications,
    MedicationPlans,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const _createSymptomsSql = '''
    CREATE TABLE IF NOT EXISTS symptom_entries (
      id TEXT NOT NULL PRIMARY KEY,
      symptom TEXT NOT NULL,
      severity INTEGER NOT NULL CHECK (severity BETWEEN 1 AND 10),
      occurred_at TEXT NOT NULL,
      notes TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  static const _createSymptomPhotosSql = '''
    CREATE TABLE IF NOT EXISTS symptom_photos (
      id TEXT NOT NULL PRIMARY KEY,
      symptom_id TEXT NOT NULL REFERENCES symptom_entries(id) ON DELETE CASCADE,
      mime_type TEXT NOT NULL,
      image_base64 TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  ''';

  AppDatabase()
    : super(
        driftDatabase(
          name: 'health_record',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.dart.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(_createSymptomsSql);
      await customStatement(_createSymptomPhotosSql);
    },
    onUpgrade: (m, from, to) async {
      // v1 -> v2 / v3
      if (from < 2) {
        await m.createTable(importedLabResults);
      }

      // v2 -> v3
      // 为已有的 CSV 表增加编辑、备注和软删除字段
      if (from >= 2 && from < 3) {
        await customStatement(
          'ALTER TABLE imported_lab_results '
          'ADD COLUMN original_snapshot TEXT',
        );

        await customStatement(
          'ALTER TABLE imported_lab_results '
          'ADD COLUMN note TEXT',
        );

        await customStatement(
          'ALTER TABLE imported_lab_results '
          'ADD COLUMN edited_at INTEGER',
        );

        await customStatement(
          'ALTER TABLE imported_lab_results '
          'ADD COLUMN deleted_at INTEGER',
        );
      }

      // v3 -> v4
      // 为 CSV 表增加医院字段，并创建医院表
      if (from < 4) {
        await m.createTable(hospitals);

        // 历史结果允许没有医院
        await customStatement(
          'ALTER TABLE imported_lab_results '
          'ADD COLUMN hospital_id TEXT '
          'REFERENCES hospitals(id)',
        );
      }

      // v4 -> v5: visit records. Does not alter existing lab or hospital rows.
      if (from < 5) {
        await m.createTable(visits);
      }
      // v5 -> v6: report metadata and explicit result-to-report links.
      // No existing CSV or manual result is deleted or rewritten.
      if (from < 6) {
        await m.createTable(visitReports);
        await m.createTable(reportResultLinks);
      }
      // v6 -> v7: medication catalog and immutable dose-plan history.
      // Existing labs, hospitals, visits and reports stay unchanged.
      if (from < 7) {
        await m.createTable(medications);
        await m.createTable(medicationPlans);
      }
      // v7 -> v8: symptoms only; existing clinical data remains unchanged.
      if (from < 8) {
        await customStatement(_createSymptomsSql);
      }
      // v8 -> v9: symptom photos; existing entries remain untouched.
      if (from < 9) {
        await customStatement(_createSymptomPhotosSql);
      }
    },

    beforeOpen: (details) async {
      await customStatement(_createSymptomsSql);
      await customStatement(_createSymptomPhotosSql);
      // 检查医院表是否存在
      final tables = await customSelect(
        "SELECT name FROM sqlite_master "
        "WHERE type = 'table' AND name = 'hospitals'",
      ).get();

      if (tables.isEmpty) {
        // 创建缺失的医院表
        await customStatement('''
          CREATE TABLE IF NOT EXISTS hospitals (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            city TEXT,
            created_at INTEGER NOT NULL
          )
        ''');
      }

      // 检查 CSV 记录是否已有 hospital_id 字段
      final columns = await customSelect(
        'PRAGMA table_info(imported_lab_results)',
      ).get();

      final hasHospitalId = columns.any(
        (row) => row.read<String>('name') == 'hospital_id',
      );

      if (!hasHospitalId) {
        await customStatement(
          'ALTER TABLE imported_lab_results '
          'ADD COLUMN hospital_id TEXT '
          'REFERENCES hospitals(id)',
        );
      }

      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Updates an imported result while preserving its original imported values.
  Future<void> editImportedResult({
    required ImportedLabResult original,
    required DateTime sampleDate,
    required String rawValue,
    required String unit,
    required String referenceRange,
    required String note,
  }) async {
    if (rawValue.trim().isEmpty) {
      throw ArgumentError('检查结果不能为空');
    }
    final snapshot =
        original.originalSnapshot ??
        jsonEncode({
          'sampleDateRaw': original.sampleDateRaw,
          'rawValue': original.rawValue,
          'numericValue': original.numericValue,
          'unit': original.unit,
          'referenceRange': original.referenceRange,
          'reportId': original.reportId,
          'indicatorCode': original.indicatorCode,
          'indicatorNameCn': original.indicatorNameCn,
          'category': original.category,
        });
    final cleanValue = rawValue.trim();
    final numeric = double.tryParse(cleanValue);
    await (update(
      importedLabResults,
    )..where((t) => t.id.equals(original.id))).write(
      ImportedLabResultsCompanion(
        sampleDate: Value(sampleDate),
        sampleDateRaw: Value(sampleDate.toIso8601String()),
        rawValue: Value(cleanValue),
        numericValue: Value(numeric),
        unit: Value(unit.trim()),
        referenceRange: Value(referenceRange.trim()),
        note: Value(note.trim()),
        originalSnapshot: Value(snapshot),
        editedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Soft-delete: hides the result but retains the provenance and row id.
  Future<void> deleteImportedResult(String id) async {
    await (update(importedLabResults)..where((t) => t.id.equals(id))).write(
      ImportedLabResultsCompanion(deletedAt: Value(DateTime.now())),
    );
  }

  Stream<List<ImportedLabResult>> watchImportedResults() =>
      (select(importedLabResults)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.sampleDate)]))
          .watch();

  Stream<List<LabCategory>> watchCategories() => (select(
    labCategories,
  )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).watch();

  Stream<List<LabTest>> watchTests() =>
      (select(labTests)..orderBy([(t) => OrderingTerm.asc(t.nameZh)])).watch();

  Stream<List<LabResult>> watchResults() =>
      (select(labResults)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.measuredAt)]))
          .watch();

  Stream<List<LabResult>> watchByTest(String testId) =>
      (select(labResults)
            ..where((t) => t.testId.equals(testId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.measuredAt)]))
          .watch();

  String _duplicateKey(ImportedLabResult row) {
    final code = row.indicatorCode.trim().toUpperCase();
    final name = row.indicatorNameCn.trim();

    // 同一指标：优先使用代码，没有代码时使用名称
    final indicator = code.isNotEmpty ? 'code:$code' : 'name:$name';

    return [
      row.hospitalId ?? '',
      row.sampleDate.toIso8601String(),
      indicator,
      row.rawValue.trim(),
      row.unit.trim().replaceAll(RegExp(r'/l\b', caseSensitive: false), '/L'),
    ].join('\u001F');
  }

  // 统计重复记录数量，不修改数据库
  Future<int> countDuplicateImportedResults() async {
    final rows =
        await (select(importedLabResults)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([
                (t) => OrderingTerm.asc(t.importedAt),
                (t) => OrderingTerm.asc(t.id),
              ]))
            .get();

    final seen = <String>{};
    var duplicates = 0;

    for (final row in rows) {
      final key = _duplicateKey(row);

      if (!seen.add(key)) {
        duplicates++;
      }
    }

    return duplicates;
  }

  // 自动软删除重复记录
  Future<int> cleanupDuplicateImportedResults() async {
    return transaction(() async {
      final rows =
          await (select(importedLabResults)
                ..where((t) => t.deletedAt.isNull())
                ..orderBy([
                  (t) => OrderingTerm.asc(t.importedAt),
                  (t) => OrderingTerm.asc(t.id),
                ]))
              .get();

      final seen = <String>{};
      var removed = 0;

      for (final row in rows) {
        final key = _duplicateKey(row);

        // 第一条保留，后续重复记录软删除
        if (seen.add(key)) {
          continue;
        }

        await (update(
          importedLabResults,
        )..where((t) => t.id.equals(row.id))).write(
          ImportedLabResultsCompanion(deletedAt: Value(DateTime.now())),
        );

        removed++;
      }

      return removed;
    });
  }
}
