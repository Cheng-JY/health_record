import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class VisitRepository {
  const VisitRepository(this.db);
  final AppDatabase db;

  Stream<List<Visit>> watchVisits() => (db.select(
    db.visits,
  )..orderBy([(v) => OrderingTerm.desc(v.startDate)])).watch();

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
    final hospital = await (db.select(
      db.hospitals,
    )..where((h) => h.id.equals(hospitalId))).getSingleOrNull();
    if (hospital == null) throw StateError('医院不存在，请重新选择');
    final now = DateTime.now();
    String? clean(String? s) => s?.trim().isEmpty == true ? null : s?.trim();
    if (id == null) {
      await db
          .into(db.visits)
          .insert(
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
      final affected =
          await (db.update(db.visits)..where((v) => v.id.equals(id))).write(
            VisitsCompanion(
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
            ),
          );
      if (affected != 1) throw StateError('要编辑的就诊记录不存在');
    }
  }

  Future<void> deleteVisit(String id) async {
    await (db.delete(db.visits)..where((v) => v.id.equals(id))).go();
  }
}
