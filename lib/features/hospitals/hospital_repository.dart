import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

/// Read model for a hospital and its linked imported lab results.
class HospitalSummary {
  const HospitalSummary({
    required this.hospital,
    required this.activeResultCount,
    required this.allResultCount,
  });

  final Hospital hospital;
  final int activeResultCount;
  final int allResultCount;
}

class HospitalRepository {
  HospitalRepository(this.db);

  final AppDatabase db;

  Stream<List<Hospital>> watchHospitals() => (db.select(
    db.hospitals,
  )..orderBy([(h) => OrderingTerm.asc(h.name)])).watch();

  Stream<List<ImportedLabResult>> watchActiveResults(String hospitalId) =>
      (db.select(db.importedLabResults)
            ..where(
              (r) => r.hospitalId.equals(hospitalId) & r.deletedAt.isNull(),
            )
            ..orderBy([(r) => OrderingTerm.desc(r.sampleDate)]))
          .watch();

  /// Includes soft-deleted rows in total count, to prevent unsafe deletion.
  Stream<List<HospitalSummary>> watchSummaries() {
    return db
        .customSelect(
          '''
      SELECT h.id AS hospital_id,
             COUNT(r.id) AS total_count,
             SUM(CASE WHEN r.id IS NOT NULL AND r.deleted_at IS NULL
                      THEN 1 ELSE 0 END) AS active_count
      FROM hospitals AS h
      LEFT JOIN imported_lab_results AS r ON r.hospital_id = h.id
      GROUP BY h.id
      ORDER BY h.name COLLATE NOCASE ASC
      ''',
          readsFrom: {db.hospitals, db.importedLabResults},
        )
        .watch()
        .asyncMap((rows) async {
          final hospitals = await db.select(db.hospitals).get();
          final byId = {for (final h in hospitals) h.id: h};
          return [
            for (final row in rows)
              if (byId[row.read<String>('hospital_id')] != null)
                HospitalSummary(
                  hospital: byId[row.read<String>('hospital_id')]!,
                  activeResultCount: row.read<int>('active_count'),
                  allResultCount: row.read<int>('total_count'),
                ),
          ];
        });
  }

  Future<String> createHospital({required String name, String? city}) async {
    final normalizedName = name.trim();
    final normalizedCity = _cleanCity(city);
    if (normalizedName.isEmpty) {
      throw ArgumentError('医院名称不能为空');
    }

    return db.transaction(() async {
      final existing = await db.select(db.hospitals).get();
      for (final hospital in existing) {
        if (_sameHospital(hospital, normalizedName, normalizedCity)) {
          // Re-use the stable ID instead of creating a duplicate hospital.
          return hospital.id;
        }
      }

      final id = const Uuid().v4();
      await db
          .into(db.hospitals)
          .insert(
            HospitalsCompanion.insert(
              id: id,
              name: normalizedName,
              city: Value(normalizedCity),
              createdAt: DateTime.now(),
            ),
          );
      return id;
    });
  }

  Future<void> updateHospital({
    required String id,
    required String name,
    String? city,
  }) async {
    final normalizedName = name.trim();
    final normalizedCity = _cleanCity(city);
    if (normalizedName.isEmpty) {
      throw ArgumentError('医院名称不能为空');
    }
    await db.transaction(() async {
      final existing = await db.select(db.hospitals).get();
      if (!existing.any((h) => h.id == id)) {
        throw StateError('医院已不存在');
      }
      if (existing.any(
        (h) => h.id != id && _sameHospital(h, normalizedName, normalizedCity),
      )) {
        throw StateError('已经存在同名、同城市的医院');
      }
      await (db.update(db.hospitals)..where((h) => h.id.equals(id))).write(
        HospitalsCompanion(
          name: Value(normalizedName),
          city: Value(normalizedCity),
        ),
      );
    });
  }

  /// Only allows deleting unused hospitals. Linked records are not modified.
  Future<void> deleteHospitalIfUnused(String id) async {
    await db.transaction(() async {
      final linked = await (db.select(
        db.importedLabResults,
      )..where((r) => r.hospitalId.equals(id))).get();
      if (linked.isNotEmpty) {
        throw StateError('这家医院关联了 ${linked.length} 条记录（包括已软删除记录），不能直接删除。');
      }
      final visits = await (db.select(
        db.visits,
      )..where((v) => v.hospitalId.equals(id))).get();
      if (visits.isNotEmpty) {
        throw StateError('这家医院关联了 ${visits.length} 次就诊，不能直接删除。');
      }
      await (db.delete(db.hospitals)..where((h) => h.id.equals(id))).go();
    });
  }

  /// All active imported rows without a hospital. Used by the batch assignment UI.
  Stream<List<ImportedLabResult>> watchUnassignedResults() =>
      (db.select(db.importedLabResults)
            ..where((r) => r.hospitalId.isNull() & r.deletedAt.isNull())
            ..orderBy([(r) => OrderingTerm.desc(r.sampleDate)]))
          .watch();

  /// Only active rows without a hospital may be batch assigned.
  /// Returns the number of rows actually updated.
  Future<int> assignUnassignedResults({
    required String hospitalId,
    required Set<String> resultIds,
  }) async {
    if (resultIds.isEmpty) return 0;
    return db.transaction(() async {
      final hospital = await (db.select(
        db.hospitals,
      )..where((h) => h.id.equals(hospitalId))).getSingleOrNull();
      if (hospital == null) throw StateError('目标医院不存在');
      var updated = 0;
      for (final id in resultIds) {
        updated +=
            await (db.update(db.importedLabResults)..where(
                  (r) =>
                      r.id.equals(id) &
                      r.hospitalId.isNull() &
                      r.deletedAt.isNull(),
                ))
                .write(
                  ImportedLabResultsCompanion(hospitalId: Value(hospitalId)),
                );
      }
      return updated;
    });
  }

  /// Merge source hospital into target (stable target UUID).
  /// Preserves ALL imported results, including soft-deleted rows.
  /// Does not automatically deduplicate records.
  Future<int> mergeHospitals({
    required String sourceId,
    required String targetId,
  }) async {
    if (sourceId == targetId) throw ArgumentError('不能合并同一家医院');
    return db.transaction(() async {
      final source = await (db.select(
        db.hospitals,
      )..where((h) => h.id.equals(sourceId))).getSingleOrNull();
      final target = await (db.select(
        db.hospitals,
      )..where((h) => h.id.equals(targetId))).getSingleOrNull();
      if (source == null || target == null) throw StateError('来源或目标医院不存在');
      final moved =
          await (db.update(db.importedLabResults)
                ..where((r) => r.hospitalId.equals(sourceId)))
              .write(ImportedLabResultsCompanion(hospitalId: Value(targetId)));
      // Move visits as well before deleting source hospital.
      await (db.update(db.visits)..where((v) => v.hospitalId.equals(sourceId)))
          .write(VisitsCompanion(hospitalId: Value(targetId)));
      await (db.delete(db.hospitals)..where((h) => h.id.equals(sourceId))).go();
      return moved;
    });
  }

  String? _cleanCity(String? city) {
    final value = city?.trim() ?? '';
    return value.isEmpty ? null : value;
  }

  bool _sameHospital(Hospital hospital, String name, String? city) =>
      hospital.name.trim().toLowerCase() == name.toLowerCase() &&
      (hospital.city ?? '').trim().toLowerCase() == (city ?? '').toLowerCase();
}
