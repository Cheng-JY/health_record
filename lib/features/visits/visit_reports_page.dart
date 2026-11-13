import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';
import 'visit_report_repository.dart';

final visitReportRepositoryProvider = Provider<VisitReportRepository>(
  (ref) => VisitReportRepository(ref.watch(databaseProvider)),
);
final visitReportsProvider = StreamProvider.family<List<VisitReport>, String>(
  (ref, visitId) =>
      ref.watch(visitReportRepositoryProvider).watchReports(visitId),
);
final reportLinksProvider = StreamProvider<List<ReportResultLink>>(
  (ref) => ref.watch(visitReportRepositoryProvider).watchLinks(),
);
final reportCsvProvider = StreamProvider<List<ImportedLabResult>>(
  (ref) => ref.watch(visitReportRepositoryProvider).watchCsv(),
);
final reportManualProvider = StreamProvider<List<LabResult>>(
  (ref) => ref.watch(visitReportRepositoryProvider).watchManual(),
);
final reportTestsProvider = StreamProvider<List<LabTest>>(
  (ref) => ref.watch(visitReportRepositoryProvider).watchTests(),
);

String _date(DateTime value) => DateFormat('yyyy-MM-dd').format(value);

class VisitReportsPage extends ConsumerStatefulWidget {
  const VisitReportsPage({super.key, required this.visit});
  final Visit visit;

  @override
  ConsumerState<VisitReportsPage> createState() => _VisitReportsPageState();
}

class _VisitReportsPageState extends ConsumerState<VisitReportsPage> {
  bool busy = false;
  void showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> addReport() async {
    final title = TextEditingController();
    final notes = TextEditingController();
    DateTime date = widget.visit.startDate;
    try {
      final values =
          await showDialog<({String title, String notes, DateTime date})>(
            context: context,
            builder: (ctx) => StatefulBuilder(
              builder: (ctx, setDialogState) => AlertDialog(
                title: const Text('新增检查报告'),
                content: SizedBox(
                  width: 440,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: title,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '报告名称 *',
                            hintText: '例如：2026-06-25 血常规',
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final selected = await showDatePicker(
                              context: ctx,
                              initialDate: date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (selected != null)
                              setDialogState(() => date = selected);
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: Text('报告日期：${_date(date)}'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: notes,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '备注（可选）',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (title.text.trim().isEmpty) return;
                      Navigator.pop(ctx, (
                        title: title.text.trim(),
                        notes: notes.text.trim(),
                        date: date,
                      ));
                    },
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          );
      if (values == null || !mounted) return;
      setState(() => busy = true);
      await ref
          .read(visitReportRepositoryProvider)
          .createReport(
            visitId: widget.visit.id,
            title: values.title,
            reportDate: values.date,
            notes: values.notes,
          );
      showMessage('报告分组创建成功');
    } catch (e) {
      showMessage('新建报告失败：$e');
    } finally {
      title.dispose();
      notes.dispose();
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> chooseResults(
    VisitReport report,
    List<LinkableLabResult> available,
  ) async {
    // Matching uses the report date and the result sample date (day only).
    // The report may be linked to results from other dates by turning off the filter.
    final reportDate = _date(report.reportDate);
    final selected = <String>{};
    String search = '';
    bool sameDateOnly = true;

    final result = await showDialog<Set<String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final query = search.trim().toLowerCase();
          final filtered = available.where((r) {
            if (sameDateOnly && _date(r.date) != reportDate) return false;
            if (query.isEmpty) return true;
            return '${r.title} ${r.value} ${_date(r.date)}'
                .toLowerCase()
                .contains(query);
          }).toList();

          // Never discard selections when searching or changing the date filter.
          final filteredKeys = filtered.map((r) => r.key).toSet();
          final selectedInFilter = filteredKeys
              .where((key) => selected.contains(key))
              .length;

          return AlertDialog(
            title: Text('关联检查结果 · ${report.title}'),
            content: SizedBox(
              width: 650,
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '只显示同医院的 CSV 结果及尚未关联的手动记录。'
                    '手动记录没有医院字段，请自行核对来源。',
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      labelText: '搜索指标、结果或日期',
                    ),
                    onChanged: (v) => setDialogState(() => search = v),
                  ),
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('仅显示同采样日期（$reportDate）'),
                    value: sameDateOnly,
                    onChanged: (value) =>
                        setDialogState(() => sameDateOnly = value ?? true),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      OutlinedButton.icon(
                        onPressed:
                            filtered.isEmpty ||
                                selectedInFilter == filtered.length
                            ? null
                            : () => setDialogState(
                                () => selected.addAll(filteredKeys),
                              ),
                        icon: const Icon(Icons.select_all),
                        label: const Text('全选当前结果'),
                      ),
                      TextButton.icon(
                        onPressed: selectedInFilter == 0
                            ? null
                            : () => setDialogState(
                                () => selected.removeAll(filteredKeys),
                              ),
                        icon: const Icon(Icons.deselect),
                        label: const Text('取消全选'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '可选 ${available.length} 条 · 当前筛选 ${filtered.length} 条 · '
                    '当前已选 $selectedInFilter 条 · 总共已选 ${selected.length} 条',
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              sameDateOnly
                                  ? '报告日期 $reportDate 没有可关联的检查结果。'
                                        '可关闭日期筛选，查看其他日期。'
                                  : '没有符合搜索条件的检查结果。',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (ctx, i) {
                              final r = filtered[i];
                              return CheckboxListTile(
                                value: selected.contains(r.key),
                                title: Text('${r.title} · ${r.value}'),
                                subtitle: Text(
                                  '${r.kind == 'csv' ? 'CSV' : '手动'} · '
                                  '${_date(r.date)}',
                                ),
                                onChanged: (checked) => setDialogState(() {
                                  if (checked == true) {
                                    selected.add(r.key);
                                  } else {
                                    selected.remove(r.key);
                                  }
                                }),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: selected.isEmpty
                    ? null
                    : () => Navigator.pop(ctx, Set<String>.of(selected)),
                child: Text('关联所选记录（${selected.length}）'),
              ),
            ],
          );
        },
      ),
    );
    if (result == null || result.isEmpty || !mounted) return;
    setState(() => busy = true);
    try {
      final csvIds = <String>{};
      final manualIds = <String>{};
      for (final r in available) {
        if (!result.contains(r.key)) continue;
        if (r.kind == 'csv') {
          csvIds.add(r.id);
        } else {
          manualIds.add(r.id);
        }
      }
      final count = await ref
          .read(visitReportRepositoryProvider)
          .attachResults(
            reportId: report.id,
            csvIds: csvIds,
            manualIds: manualIds,
          );
      showMessage('已关联 $count 条检查记录');
    } catch (e) {
      showMessage('关联失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> removeLink(LinkableLabResult row) async {
    try {
      await ref
          .read(visitReportRepositoryProvider)
          .detachResult(kind: row.kind, resultId: row.id);
      showMessage('已解除关联，原始检查结果仍保留');
    } catch (e) {
      showMessage('解除关联失败：$e');
    }
  }

  Future<void> deleteReport(VisitReport report) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除报告分组'),
        content: Text('删除「${report.title}」及其关联关系？原始检查结果不会删除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(visitReportRepositoryProvider).deleteReport(report.id);
      showMessage('报告分组已删除，检查结果保留');
    } catch (e) {
      showMessage('删除失败：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(visitReportsProvider(widget.visit.id));
    final links = ref.watch(reportLinksProvider);
    final csv = ref.watch(reportCsvProvider);
    final manual = ref.watch(reportManualProvider);
    final tests = ref.watch(reportTestsProvider);
    final err =
        reports.asError?.error ??
        links.asError?.error ??
        csv.asError?.error ??
        manual.asError?.error ??
        tests.asError?.error;
    final loading =
        reports.asData == null ||
        links.asData == null ||
        csv.asData == null ||
        manual.asData == null ||
        tests.asData == null;
    if (err != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('本次检查报告')),
        body: Center(child: SelectableText('读取失败：$err')),
      );
    }
    final rows = <LinkableLabResult>[];
    if (!loading) {
      final names = {for (final t in tests.requireValue) t.id: t.nameZh};
      rows.addAll(
        csv.requireValue.map(
          (r) => LinkableLabResult(
            kind: 'csv',
            id: r.id,
            date: r.sampleDate,
            title: r.indicatorNameCn,
            value: '${r.rawValue} ${r.unit}',
            hospitalId: r.hospitalId,
          ),
        ),
      );
      rows.addAll(
        manual.requireValue.map(
          (r) => LinkableLabResult(
            kind: 'manual',
            id: r.id,
            date: r.measuredAt,
            title: names[r.testId] ?? r.testId,
            value: '${r.valueNumeric} ${r.unit}',
          ),
        ),
      );
      rows.sort((a, b) => b.date.compareTo(a.date));
    }
    final ownedKeys = loading
        ? <String>{}
        : {
            for (final link in links.requireValue)
              '${link.sourceKind}:${link.resultId}',
          };
    final byKey = {for (final row in rows) row.key: row};
    final available = rows
        .where(
          (r) =>
              !ownedKeys.contains(r.key) &&
              (r.kind == 'manual' || r.hospitalId == widget.visit.hospitalId),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('本次检查报告与结果')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '就诊日期：${_date(widget.visit.startDate)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            const Text('新建报告分组，再从已有检查数据中选择记录关联。日期不要求与就诊日期完全一致。'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: busy ? null : addReport,
              icon: const Icon(Icons.note_add_outlined),
              label: const Text('新增报告分组'),
            ),
            if (busy) const LinearProgressIndicator(),
            const SizedBox(height: 12),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : reports.requireValue.isEmpty
                  ? const Center(child: Text('本次就诊尚未关联检查报告'))
                  : ListView(
                      children: [
                        for (final report in reports.requireValue)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${report.title} · ${_date(report.reportDate)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  if (report.notes?.isNotEmpty == true)
                                    Text(report.notes!),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: busy
                                            ? null
                                            : () => chooseResults(
                                                report,
                                                available,
                                              ),
                                        icon: const Icon(Icons.add_link),
                                        label: const Text('关联检查结果'),
                                      ),
                                      TextButton.icon(
                                        onPressed: busy
                                            ? null
                                            : () => deleteReport(report),
                                        icon: const Icon(Icons.delete_outline),
                                        label: const Text('删除报告分组'),
                                      ),
                                    ],
                                  ),
                                  ...links.requireValue
                                      .where((l) => l.reportId == report.id)
                                      .map((link) {
                                        final row =
                                            byKey['${link.sourceKind}:${link.resultId}'];
                                        return ListTile(
                                          dense: true,
                                          title: Text(
                                            row?.title ?? '(检查结果已被删除)',
                                          ),
                                          subtitle: Text(
                                            row == null
                                                ? '${link.sourceKind}: ${link.resultId}'
                                                : '${_date(row.date)} · ${row.value}',
                                          ),
                                          trailing: IconButton(
                                            tooltip: '解除关联',
                                            icon: const Icon(Icons.link_off),
                                            onPressed: busy || row == null
                                                ? null
                                                : () => removeLink(row),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
