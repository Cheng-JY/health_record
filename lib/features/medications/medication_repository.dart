import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class MedicationRepository {
  MedicationRepository(this.db);

  final AppDatabase db;
  static const _uuid = Uuid();

  Stream<List<Medication>> watchMedications() =>
      (db.select(db.medications)
            ..orderBy([(m) => OrderingTerm.asc(m.name)]))
          .watch();

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

  static DateTime day(DateTime date) => DateTime(date.year, date.month, date.day);

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
    validatePlan(dose: dose, frequency: frequency, startDate: startDate, endDate: endDate);
    final id = _uuid.v4();
    final now = DateTime.now();
    await db.transaction(() async {
      await db.into(db.medications).insert(MedicationsCompanion.insert(
        id: id,
        name: name.trim(),
        strength: Value(clean(strength)),
        form: Value(clean(form)),
        purpose: Value(clean(purpose)),
        notes: Value(clean(notes)),
        createdAt: now,
        updatedAt: now,
      ));
      await db.into(db.medicationPlans).insert(MedicationPlansCompanion.insert(
        id: _uuid.v4(),
        medicationId: id,
        dose: dose.trim(),
        frequency: frequency.trim(),
        times: Value(clean(times)),
        startDate: day(startDate),
        endDate: Value(endDate == null ? null : day(endDate)),
        instructions: Value(clean(instructions)),
        createdAt: now,
      ));
    });
    return id;
  }

  /// Add a past, current or future regimen. All date ranges are inclusive.
  /// An empty end date automatically ends before the next known stage.
  /// The preceding open-ended stage is automatically closed before this one.
  /// All changes are validated before any database write, in one transaction.
  Future<void> changePlan({
    required String medicationId,
    required String dose,
    required String frequency,
    String? times,
    required DateTime startDate,
    DateTime? endDate,
    String? changeReason,
    String? instructions,
    bool closePreviousOpenPlan = false, // retained for older callers
  }) async {
    validatePlan(
      dose: dose,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    );
    final start = day(startDate);
    final requestedEnd = endDate == null ? null : day(endDate);

    await db.transaction(() async {
      final medication = await (db.select(db.medications)
            ..where((m) => m.id.equals(medicationId)))
          .getSingleOrNull();
      if (medication == null) throw StateError('药物不存在');
      if (medication.archivedAt != null) {
        throw StateError('已停用药物不能新增方案');
      }

      final existing = await (db.select(db.medicationPlans)
            ..where((p) => p.medicationId.equals(medicationId))
            ..orderBy([(p) => OrderingTerm.asc(p.startDate)]))
          .get();
      final next = existing.where((p) => day(p.startDate).isAfter(start)).firstOrNull;
      final actualEnd = requestedEnd ??
          (next == null ? null : day(next.startDate).subtract(const Duration(days: 1)));

      // Detect the stage immediately preceding the requested start date.
      MedicationPlan? previous;
      for (final p in existing) {
        if (day(p.startDate).isBefore(start)) previous = p;
      }
      final previousToClose = previous != null && previous.endDate == null
          ? previous
          : null;
      final previousEnd = start.subtract(const Duration(days: 1));

      // Reject all overlaps before making any changes.
      for (final other in existing) {
        final otherStart = day(other.startDate);
        final otherEnd = identical(other, previousToClose)
            ? previousEnd
            : (other.endDate == null ? null : day(other.endDate!));
        final endsBeforeOther = actualEnd != null && actualEnd.isBefore(otherStart);
        final beginsAfterOther = otherEnd != null && start.isAfter(otherEnd);
        if (!endsBeforeOther && !beginsAfterOther) {
          throw ArgumentError('新方案与 ${otherStart.year}-${otherStart.month}-${otherStart.day} 起的已有方案日期重叠。请先编辑已有方案。');
        }
      }

      if (previousToClose != null) {
        await (db.update(db.medicationPlans)
              ..where((p) => p.id.equals(previousToClose.id)))
            .write(MedicationPlansCompanion(endDate: Value(previousEnd)));
      }
      await db.into(db.medicationPlans).insert(
        MedicationPlansCompanion.insert(
          id: _uuid.v4(),
          medicationId: medicationId,
          dose: dose.trim(),
          frequency: frequency.trim(),
          times: Value(clean(times)),
          startDate: start,
          endDate: Value(actualEnd),
          changeReason: Value(clean(changeReason)),
          instructions: Value(clean(instructions)),
          createdAt: DateTime.now(),
        ),
      );
      await (db.update(db.medications)
            ..where((m) => m.id.equals(medicationId)))
          .write(MedicationsCompanion(updatedAt: Value(DateTime.now())));
    });
  }

  /// End the latest plan, retain complete history; never delete medication rows.
  Future<void> stopMedication(String medicationId, DateTime stopDate) async {
    final stopDay = day(stopDate);
    await db.transaction(() async {
      final medication = await (db.select(db.medications)
            ..where((m) => m.id.equals(medicationId))).getSingleOrNull();
      if (medication == null) throw StateError('药物不存在');
      if (medication.archivedAt != null) throw StateError('此药物已经标记停用');
      final plans = await (db.select(db.medicationPlans)
            ..where((p) => p.medicationId.equals(medicationId))
            ..orderBy([(p) => OrderingTerm.desc(p.startDate)])).get();
      if (plans.isEmpty) throw StateError('没有可以结束的服药方案');
      final latest = plans.first;
      if (stopDay.isBefore(day(latest.startDate))) throw ArgumentError('停药日期不能早于方案开始日期');
      if (latest.endDate != null && stopDay.isAfter(day(latest.endDate!))) {
        throw ArgumentError('方案已在更早日期结束');
      }
      await (db.update(db.medicationPlans)..where((p) => p.id.equals(latest.id))).write(
        MedicationPlansCompanion(endDate: Value(stopDay)),
      );
      await (db.update(db.medications)..where((m) => m.id.equals(medicationId))).write(
        MedicationsCompanion(
          archivedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  /// Edit one stage. If its end is left blank and a later stage exists,
  /// end it on the day before that later stage. The immediately preceding
  /// open-ended stage is also closed if necessary.
  Future<void> updatePlan({
    required String planId,
    required String medicationId,
    required String dose,
    required String frequency,
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
    final start = day(startDate);
    final requestedEnd = endDate == null ? null : day(endDate);

    await db.transaction(() async {
      final current = await (db.select(db.medicationPlans)
            ..where((p) => p.id.equals(planId) & p.medicationId.equals(medicationId)))
          .getSingleOrNull();
      if (current == null) throw StateError('这条用药历史不存在');
      final others = await (db.select(db.medicationPlans)
            ..where((p) => p.medicationId.equals(medicationId) & p.id.equals(planId).not())
            ..orderBy([(p) => OrderingTerm.asc(p.startDate)]))
          .get();
      final next = others.where((p) => day(p.startDate).isAfter(start)).firstOrNull;
      final actualEnd = requestedEnd ??
          (next == null ? null : day(next.startDate).subtract(const Duration(days: 1)));
      MedicationPlan? previous;
      for (final p in others) {
        if (day(p.startDate).isBefore(start)) previous = p;
      }
      final previousToClose = previous != null && previous.endDate == null
          ? previous
          : null;
      final previousEnd = start.subtract(const Duration(days: 1));

      for (final other in others) {
        final otherStart = day(other.startDate);
        final otherEnd = identical(other, previousToClose)
            ? previousEnd
            : (other.endDate == null ? null : day(other.endDate!));
        final endsBeforeOther = actualEnd != null && actualEnd.isBefore(otherStart);
        final beginsAfterOther = otherEnd != null && start.isAfter(otherEnd);
        if (!endsBeforeOther && !beginsAfterOther) {
          throw ArgumentError('日期与 ${otherStart.year}-${otherStart.month}-${otherStart.day} 起的方案重叠，请调整日期');
        }
      }

      if (previousToClose != null) {
        await (db.update(db.medicationPlans)
              ..where((p) => p.id.equals(previousToClose.id)))
            .write(MedicationPlansCompanion(endDate: Value(previousEnd)));
      }
      await (db.update(db.medicationPlans)..where((p) => p.id.equals(planId)))
          .write(MedicationPlansCompanion(
            dose: Value(dose.trim()),
            frequency: Value(frequency.trim()),
            startDate: Value(start),
            endDate: Value(actualEnd),
            changeReason: Value(clean(changeReason)),
            instructions: Value(clean(instructions)),
          ));
      await (db.update(db.medications)
            ..where((m) => m.id.equals(medicationId)))
          .write(MedicationsCompanion(updatedAt: Value(DateTime.now())));
    });
  }

  /// Delete exactly one history record. Does not change neighbouring doses or
  /// dates, which prevents silently assigning a past dose to a different period.
  Future<void> deletePlan({
    required String planId,
    required String medicationId,
  }) async {
    await db.transaction(() async {
      final plans = await (db.select(db.medicationPlans)
            ..where((p) => p.medicationId.equals(medicationId)))
          .get();
      if (!plans.any((p) => p.id == planId)) {
        throw StateError('要删除的历史记录不存在');
      }
      if (plans.length <= 1) {
        throw StateError('不能删除唯一的服药方案；如需停止记录，请使用停药功能');
      }
      await (db.delete(db.medicationPlans)
            ..where((p) => p.id.equals(planId) & p.medicationId.equals(medicationId)))
          .go();
      await (db.update(db.medications)..where((m) => m.id.equals(medicationId))).write(
        MedicationsCompanion(updatedAt: Value(DateTime.now())),
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
    await (db.update(db.medications)..where((m) => m.id.equals(medication.id))).write(
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
