import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class VisitRepository {
  const VisitRepository(this.db);
  final AppDatabase db;

  Stream<List<Visit>> watchVisits() =>
      (db.select(db.visits)
            ..orderBy([(v) => OrderingTerm.desc(v.startDate)]))
          .watch();

  Future<void> saveVisit({
    String? id,
    required String hospitalId,
    required String visitType,
    required DateTime startDate,
    DateTime? endDate,
    String? department,
    String? doctor,
    String? reason,
    String? diagnosis,
    String? notes,
  }) async {
    if (endDate != null && endDate.isBefore(startDate)) {
      throw ArgumentError('结束日期不能早于开始日期');
    }
    final hospital = await (db.select(db.hospitals)
          ..where((h) => h.id.equals(hospitalId)))
        .getSingleOrNull();
    if (hospital == null) throw StateError('医院不存在，请重新选择');
    final now = DateTime.now();
    String? clean(String? s) => s?.trim().isEmpty == true ? null : s?.trim();
    if (id == null) {
      await db.into(db.visits).insert(
        VisitsCompanion.insert(
          id: const Uuid().v4(),
          hospitalId: hospitalId,
          visitType: visitType,
          startDate: startDate,
          endDate: Value(endDate),
          department: Value(clean(department)),
          doctor: Value(clean(doctor)),
          reason: Value(clean(reason)),
          diagnosis: Value(clean(diagnosis)),
          notes: Value(clean(notes)),
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      // Keep linked CSV results consistent with the visit's hospital.
      final old = await (db.select(db.visits)
            ..where((v) => v.id.equals(id)))
          .getSingleOrNull();
      if (old == null) throw StateError('要编辑的就诊记录不存在');
      if (old.hospitalId != hospitalId) {
        final reports = await (db.select(db.visitReports)
              ..where((r) => r.visitId.equals(id))).get();
        for (final report in reports) {
          final linkedCsv = await (db.select(db.reportResultLinks)
                ..where((l) => l.reportId.equals(report.id) &
                    l.sourceKind.equals('csv'))).get();
          if (linkedCsv.isNotEmpty) {
            throw StateError('本次就诊已有 CSV 检查结果关联，请先解除相关报告关联，再修改医院');
          }
        }
      }
      final affected = await (db.update(db.visits)
            ..where((v) => v.id.equals(id)))
          .write(VisitsCompanion(
            hospitalId: Value(hospitalId),
            visitType: Value(visitType),
            startDate: Value(startDate),
            endDate: Value(endDate),
            department: Value(clean(department)),
            doctor: Value(clean(doctor)),
            reason: Value(clean(reason)),
            diagnosis: Value(clean(diagnosis)),
            notes: Value(clean(notes)),
            updatedAt: Value(now),
          ));
      if (affected != 1) throw StateError('要编辑的就诊记录不存在');
    }
  }

  Future<void> deleteVisit(String id) async {
    await db.transaction(() async {
      final reports = await (db.select(db.visitReports)
            ..where((r) => r.visitId.equals(id))).get();
      for (final report in reports) {
        await (db.delete(db.reportResultLinks)
              ..where((l) => l.reportId.equals(report.id))).go();
      }
      await (db.delete(db.visitReports)
            ..where((r) => r.visitId.equals(id))).go();
      await (db.delete(db.visits)..where((v) => v.id.equals(id))).go();
    });
  }
}
