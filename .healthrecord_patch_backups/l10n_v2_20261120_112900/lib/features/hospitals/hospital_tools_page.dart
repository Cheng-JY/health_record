import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import 'hospital_repository.dart';
import 'hospitals_page.dart';

final unassignedImportedResultsProvider =
    StreamProvider<List<ImportedLabResult>>(
      (ref) => ref
          .watch(hospitalManagementRepositoryProvider)
          .watchUnassignedResults(),
    );

class HospitalToolsPage extends ConsumerStatefulWidget {
  const HospitalToolsPage({super.key});

  @override
  ConsumerState<HospitalToolsPage> createState() => _HospitalToolsPageState();
}

class _HospitalToolsPageState extends ConsumerState<HospitalToolsPage> {
  final selected = <String>{};
  String? assignTarget;
  String? mergeSource;
  String? mergeTarget;
  bool busy = false;

  void notify(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> assign() async {
    final target = assignTarget;
    if (busy || target == null || selected.isEmpty) return;
    final count = selected.length;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认批量分配医院'),
        content: Text('将 $count 条尚未分配医院的检查记录关联到所选医院？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('确认'),
          ),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    setState(() => busy = true);
    try {
      final changed = await ref
          .read(hospitalManagementRepositoryProvider)
          .assignUnassignedResults(
            hospitalId: target,
            resultIds: {...selected},
          );
      if (!mounted) return;
      setState(() => selected.clear());
      notify('成功为 $changed 条检查记录分配医院');
    } catch (e) {
      notify('批量分配失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> merge() async {
    final sourceId = mergeSource;
    final targetId = mergeTarget;
    if (busy || sourceId == null || targetId == null || sourceId == targetId)
      return;
    final summaries = ref.read(hospitalSummariesProvider).value;
    if (summaries == null) return;
    final source = summaries
        .where((e) => e.hospital.id == sourceId)
        .firstOrNull;
    final target = summaries
        .where((e) => e.hospital.id == targetId)
        .firstOrNull;
    if (source == null || target == null) return;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('合并医院（不可直接撤销）'),
        content: Text(
          '来源：${source.hospital.name}（${source.allResultCount} 条关联）\n'
          '目标：${target.hospital.name}\n\n'
          '来源医院的全部记录（包括软删除记录）将关联到目标医院 UUID，'
          '随后删除来源医院。检查记录不会自动去重。请确认两者确属同一家医院。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('确认合并'),
          ),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    setState(() => busy = true);
    try {
      final count = await ref
          .read(hospitalManagementRepositoryProvider)
          .mergeHospitals(sourceId: sourceId, targetId: targetId);
      if (!mounted) return;
      setState(() {
        mergeSource = null;
        mergeTarget = null;
      });
      notify('合并完成：迁移了 $count 条关联记录');
    } catch (e) {
      notify('合并失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget hospitalChoice({
    required String label,
    required String? value,
    required List<HospitalSummary> summaries,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label-$value-${summaries.length}'),
      initialValue: summaries.any((s) => s.hospital.id == value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        for (final item in summaries)
          DropdownMenuItem(
            value: item.hospital.id,
            child: Text(item.hospital.name, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: busy ? null : onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(hospitalSummariesProvider);
    final unassigned = ref.watch(unassignedImportedResultsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('医院关联工具')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('批量分配历史记录', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('仅列出尚未指定医院、且未删除的 CSV 记录。手动录入记录暂不支持医院关联。'),
          const SizedBox(height: 12),
          if (busy) const LinearProgressIndicator(),
          summaries.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('医院加载失败：$e'),
            data: (all) => Column(
              children: [
                hospitalChoice(
                  label: '分配到医院',
                  value: assignTarget,
                  summaries: all,
                  onChanged: (v) => setState(() => assignTarget = v),
                ),
                const SizedBox(height: 12),
                unassigned.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('历史记录读取失败：$e'),
                  data: (rows) {
                    final active = {for (final row in rows) row.id};
                    final selectedCount = selected.intersection(active).length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('待分配：${rows.length} 条 · 当前勾选：$selectedCount 条'),
                        Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: busy
                                  ? null
                                  : () => setState(() {
                                      selected
                                        ..clear()
                                        ..addAll(active);
                                    }),
                              child: const Text('全选'),
                            ),
                            OutlinedButton(
                              onPressed: busy
                                  ? null
                                  : () => setState(selected.clear),
                              child: const Text('清空选择'),
                            ),
                            FilledButton(
                              onPressed:
                                  busy ||
                                      assignTarget == null ||
                                      selectedCount == 0
                                  ? null
                                  : assign,
                              child: const Text('分配所选记录'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (rows.isEmpty) const Text('没有未指定医院的有效 CSV 记录'),
                        SizedBox(
                          height: rows.isEmpty ? 0 : 330,
                          child: ListView.builder(
                            itemCount: rows.length,
                            itemBuilder: (ctx, i) {
                              final row = rows[i];
                              return CheckboxListTile(
                                dense: true,
                                value: selected.contains(row.id),
                                onChanged: busy
                                    ? null
                                    : (checked) => setState(() {
                                        if (checked == true) {
                                          selected.add(row.id);
                                        } else {
                                          selected.remove(row.id);
                                        }
                                      }),
                                title: Text(
                                  '${row.indicatorNameCn} · ${row.rawValue} ${row.unit}',
                                ),
                                subtitle: Text(
                                  DateFormat('yyyy-MM-dd HH:mm')
                                      .format(row.sampleDate),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 40),
          Text('合并重复医院', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('目标医院 UUID 将保留；来源医院将删除。操作前请先备份数据。'),
          const SizedBox(height: 12),
          summaries.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('医院加载失败：$e'),
            data: (all) => Column(
              children: [
                hospitalChoice(
                  label: '来源医院（将删除）',
                  value: mergeSource,
                  summaries: all,
                  onChanged: (v) => setState(() => mergeSource = v),
                ),
                const SizedBox(height: 12),
                hospitalChoice(
                  label: '目标医院（保留）',
                  value: mergeTarget,
                  summaries: all,
                  onChanged: (v) => setState(() => mergeTarget = v),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed:
                      busy ||
                          mergeSource == null ||
                          mergeTarget == null ||
                          mergeSource == mergeTarget
                      ? null
                      : merge,
                  icon: const Icon(Icons.merge_type),
                  label: const Text('合并医院'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
