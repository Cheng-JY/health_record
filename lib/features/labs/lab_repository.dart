import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class LabRepository {
  LabRepository(this.db);
  final AppDatabase db;
  static const _uuid = Uuid();

  Stream<List<LabCategory>> categories() => db.watchCategories();
  Stream<List<LabTest>> tests() => db.watchTests();
  Stream<List<LabResult>> results() => db.watchResults();
  Stream<List<LabResult>> byTest(String testId) => db.watchByTest(testId);

  Future<void> seedCatalog() async {
    final existing = await db.select(db.labCategories).get();
    if (existing.isNotEmpty) return;
    await db.transaction(() async {
      await db.batch((batch) {
        batch.insertAll(db.labCategories, [
          LabCategoriesCompanion.insert(
            id: 'blood',
            code: 'BLOOD',
            nameZh: '血常规',
            sortOrder: const Value(1),
          ),
          LabCategoriesCompanion.insert(
            id: 'inflam',
            code: 'INFLAM',
            nameZh: '炎症指标',
            sortOrder: const Value(2),
          ),
          LabCategoriesCompanion.insert(
            id: 'immune',
            code: 'IMMUNE',
            nameZh: '免疫指标',
            sortOrder: const Value(3),
          ),
          LabCategoriesCompanion.insert(
            id: 'kidney',
            code: 'KIDNEY',
            nameZh: '肾功能',
            sortOrder: const Value(4),
          ),
        ]);
        batch.insertAll(db.labTests, [
          LabTestsCompanion.insert(
            id: 'wbc',
            categoryId: 'blood',
            code: 'WBC',
            nameZh: '白细胞',
            nameDe: const Value('Leukozyten'),
            canonicalUnit: '10^9/L',
          ),
          LabTestsCompanion.insert(
            id: 'hb',
            categoryId: 'blood',
            code: 'HB',
            nameZh: '血红蛋白',
            nameDe: const Value('Hämoglobin'),
            canonicalUnit: 'g/dL',
          ),
          LabTestsCompanion.insert(
            id: 'crp',
            categoryId: 'inflam',
            code: 'CRP',
            nameZh: 'C反应蛋白',
            nameDe: const Value('C-reaktives Protein'),
            canonicalUnit: 'mg/L',
          ),
          LabTestsCompanion.insert(
            id: 'c3',
            categoryId: 'immune',
            code: 'C3',
            nameZh: '补体C3',
            nameDe: const Value('Komplement C3'),
            canonicalUnit: 'g/L',
          ),
          LabTestsCompanion.insert(
            id: 'c4',
            categoryId: 'immune',
            code: 'C4',
            nameZh: '补体C4',
            nameDe: const Value('Komplement C4'),
            canonicalUnit: 'g/L',
          ),
          LabTestsCompanion.insert(
            id: 'creatinine',
            categoryId: 'kidney',
            code: 'CREA',
            nameZh: '肌酐',
            nameDe: const Value('Kreatinin'),
            canonicalUnit: 'mg/dL',
          ),
        ]);
      });
    });
  }

  Future<void> save({
    String? id,
    required String testId,
    required DateTime date,
    required double value,
    required String unit,
    double? low,
    double? high,
    String? note,
  }) async {
    if (!value.isFinite ||
        (low != null && !low.isFinite) ||
        (high != null && !high.isFinite)) {
      throw ArgumentError('请输入有效的数值');
    }
    if (low != null && high != null && low > high) {
      throw ArgumentError('参考范围下限不能大于上限');
    }
    if (unit.trim().isEmpty) throw ArgumentError('单位不能为空');
    final now = DateTime.now();
    if (id == null) {
      await db
          .into(db.labResults)
          .insert(
            LabResultsCompanion.insert(
              id: _uuid.v4(),
              testId: testId,
              measuredAt: date,
              valueNumeric: value,
              unit: unit.trim(),
              referenceLow: Value(low),
              referenceHigh: Value(high),
              note: Value(note),
              createdAt: now,
              updatedAt: now,
            ),
          );
    } else {
      final n =
          await (db.update(
            db.labResults,
          )..where((r) => r.id.equals(id) & r.deletedAt.isNull())).write(
            LabResultsCompanion(
              testId: Value(testId),
              measuredAt: Value(date),
              valueNumeric: Value(value),
              unit: Value(unit.trim()),
              referenceLow: Value(low),
              referenceHigh: Value(high),
              note: Value(note),
              updatedAt: Value(now),
            ),
          );
      if (n == 0) throw StateError('记录不存在');
    }
  }

  Future<void> remove(String id) async {
    await (db.update(db.labResults)..where((t) => t.id.equals(id))).write(
      LabResultsCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
