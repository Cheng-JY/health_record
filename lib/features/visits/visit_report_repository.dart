import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

/// A CSV or manually entered result; source IDs stay unchanged.
class LinkableLabResult {
  const LinkableLabResult({
    required this.kind,
    required this.id,
    required this.date,
    required this.title,
    required this.value,
    this.hospitalId,
    this.reportId,
  });
  final String kind;
  final String id;
  final DateTime date;
  final String title;
  final String value;
  final String? hospitalId;
  final String? reportId;
  String get key => '$kind:$id';
}

class VisitReportRepository {
  const VisitReportRepository(this.db);
  final AppDatabase db;

  Stream<List<VisitReport>> watchReports(String visitId) =>
      (db.select(db.visitReports)
            ..where((r) => r.visitId.equals(visitId))
            ..orderBy([(r) => OrderingTerm.desc(r.reportDate)]))
          .watch();

  Stream<List<ReportResultLink>> watchLinks() =>
      db.select(db.reportResultLinks).watch();
  Stream<List<ImportedLabResult>> watchCsv() => db.watchImportedResults();
  Stream<List<LabResult>> watchManual() => db.watchResults();
  Stream<List<LabTest>> watchTests() => db.watchTests();

  Future<String> createReport({
    required String visitId,
    required String title,
    required DateTime reportDate,
    String? notes,
  }) async {
    if (title.trim().isEmpty) throw ArgumentError('报告名称不能为空');
    final visit = await (db.select(
      db.visits,
    )..where((v) => v.id.equals(visitId))).getSingleOrNull();
    if (visit == null) throw StateError('就诊记录不存在');
    final id = const Uuid().v4();
    await db
        .into(db.visitReports)
        .insert(
          VisitReportsCompanion.insert(
            id: id,
            visitId: visitId,
            title: title.trim(),
            reportDate: reportDate,
            notes: Value(notes?.trim().isEmpty == true ? null : notes?.trim()),
            createdAt: DateTime.now(),
          ),
        );
    return id;
  }

  /// Never alters a raw result. A result can belong to only one report.
  /// CSV hospital must equal the visit hospital; unassigned CSVs must first
  /// be assigned a hospital through Hospital Tools.
  Future<int> attachResults({
    required String reportId,
    required Set<String> csvIds,
    required Set<String> manualIds,
  }) async {
    return db.transaction(() async {
      final report = await (db.select(
        db.visitReports,
      )..where((r) => r.id.equals(reportId))).getSingleOrNull();
      if (report == null) throw StateError('报告不存在');
      final visit = await (db.select(
        db.visits,
      )..where((v) => v.id.equals(report.visitId))).getSingleOrNull();
      if (visit == null) throw StateError('就诊不存在');
      int added = 0;
      for (final id in csvIds) {
        final item =
            await (db.select(db.importedLabResults)
                  ..where((r) => r.id.equals(id) & r.deletedAt.isNull()))
                .getSingleOrNull();
        if (item == null) throw StateError('CSV 检查结果不存在：$id');
        if (item.hospitalId != visit.hospitalId) {
          throw StateError('CSV 检查结果的医院与本次就诊不一致，请先在医院管理中分配正确医院');
        }
        await _insertLink(reportId, 'csv', id);
        added++;
      }
      for (final id in manualIds) {
        final item =
            await (db.select(db.labResults)
                  ..where((r) => r.id.equals(id) & r.deletedAt.isNull()))
                .getSingleOrNull();
        if (item == null) throw StateError('手动检查结果不存在：$id');
        // Manual records have no hospital field yet. User explicitly chooses
        // the visit/report; no automatic hospital inference is performed.
        await _insertLink(reportId, 'manual', id);
        added++;
      }
      return added;
    });
  }

  Future<void> _insertLink(String reportId, String kind, String id) async {
    final existing =
        await (db.select(db.reportResultLinks)
              ..where((l) => l.sourceKind.equals(kind) & l.resultId.equals(id)))
            .getSingleOrNull();
    if (existing != null) {
      if (existing.reportId == reportId) return;
      throw StateError('检查结果已关联到另一份报告，请先解除旧关联');
    }
    await db
        .into(db.reportResultLinks)
        .insert(
          ReportResultLinksCompanion.insert(
            reportId: reportId,
            sourceKind: kind,
            resultId: id,
          ),
        );
  }

  Future<void> detachResult({
    required String kind,
    required String resultId,
  }) async {
    await (db.delete(db.reportResultLinks)..where(
          (l) => l.sourceKind.equals(kind) & l.resultId.equals(resultId),
        ))
        .go();
  }

  /// Remove only report metadata and links; original labs stay intact.
  Future<void> deleteReport(String id) async {
    await db.transaction(() async {
      await (db.delete(
        db.reportResultLinks,
      )..where((l) => l.reportId.equals(id))).go();
      await (db.delete(db.visitReports)..where((r) => r.id.equals(id))).go();
    });
  }
}
