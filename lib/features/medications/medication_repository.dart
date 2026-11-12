import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class MedicationRepository {
  MedicationRepository(this.db);

  final AppDatabase db;
  static const _uuid = Uuid();

  Stream<List<Medication>> watchMedications() => (db.select(
    db.medications,
  )..orderBy([(m) => OrderingTerm.asc(m.name)])).watch();

  Stream<List<MedicationPlan>> watchPlans(String medicationId) =>
      (db.select(db.medicationPlans)
            ..where((p) => p.medicationId.equals(medicationId))
            ..orderBy([(p) => OrderingTerm.desc(p.startDate)]))
          .watch();

  Future<List<MedicationPlan>> getPlans(String medicationId) =>
      (db.select(db.medicationPlans)
            ..where((p) => p.medicationId.equals(medicationId))
            ..orderBy([(p) => OrderingTerm.desc(p.startDate)]))
          .get();

  static DateTime day(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static String? clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static void validatePlan({
    required String dose,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
  }) {
    if (dose.trim().isEmpty || frequency.trim().isEmpty) {
      throw ArgumentError('剂量和频率不能为空');
    }
    if (endDate != null && day(endDate).isBefore(day(startDate))) {
      throw ArgumentError('结束日期不能早于开始日期');
    }
  }

  /// Creates a medication and its initial regimen in one transaction.
  Future<String> addMedication({
    required String name,
    String? strength,
    String? form,
    String? purpose,
    String? notes,
    required String dose,
    required String frequency,
    String? times,
    required DateTime startDate,
    DateTime? endDate,
    String? instructions,
  }) async {
    if (name.trim().isEmpty) throw ArgumentError('药物名称不能为空');
    validatePlan(
      dose: dose,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    );
    final id = _uuid.v4();
    final now = DateTime.now();
    await db.transaction(() async {
      await db
          .into(db.medications)
          .insert(
            MedicationsCompanion.insert(
              id: id,
              name: name.trim(),
              strength: Value(clean(strength)),
              form: Value(clean(form)),
              purpose: Value(clean(purpose)),
              notes: Value(clean(notes)),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.medicationPlans)
          .insert(
            MedicationPlansCompanion.insert(
              id: _uuid.v4(),
              medicationId: id,
              dose: dose.trim(),
              frequency: frequency.trim(),
              times: Value(clean(times)),
              startDate: day(startDate),
              endDate: Value(endDate == null ? null : day(endDate)),
              instructions: Value(clean(instructions)),
              createdAt: now,
            ),
          );
    });
    return id;
  }

  /// Changes the current/latest plan without modifying the old historical dose.
  /// The new date must be after the latest plan's start date.
  Future<void> changePlan({
    required String medicationId,
    required String dose,
    required String frequency,
    String? times,
    required DateTime startDate,
    DateTime? endDate,
    String? changeReason,
    String? instructions,
  }) async {
    validatePlan(
      dose: dose,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    );
    final firstDay = day(startDate);
    await db.transaction(() async {
      final medication = await (db.select(
        db.medications,
      )..where((m) => m.id.equals(medicationId))).getSingleOrNull();
      if (medication == null) throw StateError('药物不存在');
      if (medication.archivedAt != null)
        throw StateError('已停用的药物不能直接修改剂量，请重新建立药物记录');
      final plans =
          await (db.select(db.medicationPlans)
                ..where((p) => p.medicationId.equals(medicationId))
                ..orderBy([(p) => OrderingTerm.desc(p.startDate)]))
              .get();
      if (plans.isEmpty) throw StateError('当前药物没有服药方案');
      final latest = plans.first;
      if (!firstDay.isAfter(day(latest.startDate))) {
        throw ArgumentError('调整日期必须晚于上一方案的开始日期');
      }
      if (latest.endDate != null &&
          firstDay.isAfter(day(latest.endDate!).add(const Duration(days: 1)))) {
        throw ArgumentError('新方案与上一方案之间存在未记录的停药间隔，请新建药物记录');
      }
      // Only truncate the prior plan if it overlaps the new plan.
      if (latest.endDate == null || !day(latest.endDate!).isBefore(firstDay)) {
        await (db.update(
          db.medicationPlans,
        )..where((p) => p.id.equals(latest.id))).write(
          MedicationPlansCompanion(
            endDate: Value(firstDay.subtract(const Duration(days: 1))),
          ),
        );
      }
      await db
          .into(db.medicationPlans)
          .insert(
            MedicationPlansCompanion.insert(
              id: _uuid.v4(),
              medicationId: medicationId,
              dose: dose.trim(),
              frequency: frequency.trim(),
              times: Value(clean(times)),
              startDate: firstDay,
              endDate: Value(endDate == null ? null : day(endDate)),
              changeReason: Value(clean(changeReason)),
              instructions: Value(clean(instructions)),
              createdAt: DateTime.now(),
            ),
          );
      await (db.update(db.medications)..where((m) => m.id.equals(medicationId)))
          .write(MedicationsCompanion(updatedAt: Value(DateTime.now())));
    });
  }

  /// End the latest plan, retain complete history; never delete medication rows.
  Future<void> stopMedication(String medicationId, DateTime stopDate) async {
    final stopDay = day(stopDate);
    await db.transaction(() async {
      final medication = await (db.select(
        db.medications,
      )..where((m) => m.id.equals(medicationId))).getSingleOrNull();
      if (medication == null) throw StateError('药物不存在');
      if (medication.archivedAt != null) throw StateError('此药物已经标记停用');
      final plans =
          await (db.select(db.medicationPlans)
                ..where((p) => p.medicationId.equals(medicationId))
                ..orderBy([(p) => OrderingTerm.desc(p.startDate)]))
              .get();
      if (plans.isEmpty) throw StateError('没有可以结束的服药方案');
      final latest = plans.first;
      if (stopDay.isBefore(day(latest.startDate)))
        throw ArgumentError('停药日期不能早于方案开始日期');
      if (latest.endDate != null && stopDay.isAfter(day(latest.endDate!))) {
        throw ArgumentError('方案已在更早日期结束');
      }
      await (db.update(db.medicationPlans)
            ..where((p) => p.id.equals(latest.id)))
          .write(MedicationPlansCompanion(endDate: Value(stopDay)));
      await (db.update(
        db.medications,
      )..where((m) => m.id.equals(medicationId))).write(
        MedicationsCompanion(
          archivedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<void> updateMedication({
    required Medication medication,
    required String name,
    String? strength,
    String? form,
    String? purpose,
    String? notes,
  }) async {
    if (name.trim().isEmpty) throw ArgumentError('药物名称不能为空');
    await (db.update(
      db.medications,
    )..where((m) => m.id.equals(medication.id))).write(
      MedicationsCompanion(
        name: Value(name.trim()),
        strength: Value(clean(strength)),
        form: Value(clean(form)),
        purpose: Value(clean(purpose)),
        notes: Value(clean(notes)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
