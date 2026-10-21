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

@DriftDatabase(tables: [LabCategories, LabTests, LabResults])
class AppDatabase extends _$AppDatabase {
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

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
}
