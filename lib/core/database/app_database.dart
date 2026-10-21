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
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [LabCategories, LabTests, LabResults, ImportedLabResults])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(driftDatabase(
          name: 'health_record',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.dart.js'),
          ),
        ));

  @override
  int get schemaVersion => 3;



  @override
  MigrationStrategy get migration => MigrationStrategy(
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
    },

    beforeOpen: (details) async {
      await customStatement(
        'PRAGMA foreign_keys = ON',
      );
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
    final snapshot = original.originalSnapshot ?? jsonEncode({
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
    await (update(importedLabResults)..where((t) => t.id.equals(original.id)))
        .write(ImportedLabResultsCompanion(
      sampleDate: Value(sampleDate),
      sampleDateRaw: Value(sampleDate.toIso8601String()),
      rawValue: Value(cleanValue),
      numericValue: Value(numeric),
      unit: Value(unit.trim()),
      referenceRange: Value(referenceRange.trim()),
      note: Value(note.trim()),
      originalSnapshot: Value(snapshot),
      editedAt: Value(DateTime.now()),
    ));
  }

  /// Soft-delete: hides the result but retains the provenance and row id.
  Future<void> deleteImportedResult(String id) async {
    await (update(importedLabResults)..where((t) => t.id.equals(id)))
        .write(ImportedLabResultsCompanion(deletedAt: Value(DateTime.now())));
  }

  Stream<List<ImportedLabResult>> watchImportedResults() =>
      (select(importedLabResults)
        ..where((t) => t.deletedAt.isNull())
        ..orderBy([(t) => OrderingTerm.desc(t.sampleDate)])).watch();

  Stream<List<LabCategory>> watchCategories() =>
      (select(labCategories)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).watch();

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
    final indicator = code.isNotEmpty
        ? 'code:$code'
        : 'name:$name';

    return [
      row.sampleDate.toIso8601String(),
      indicator,
      row.rawValue.trim(),
      row.unit.trim(),
    ].join('\u001F');
  }

  // 统计重复记录数量，不修改数据库
  Future<int> countDuplicateImportedResults() async {
    final rows = await (select(importedLabResults)
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
      final rows = await (select(importedLabResults)
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

        await (update(importedLabResults)
              ..where((t) => t.id.equals(row.id)))
            .write(
          ImportedLabResultsCompanion(
            deletedAt: Value(DateTime.now()),
          ),
        );

        removed++;
      }

      return removed;
    });
  }

}
