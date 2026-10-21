import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';
import '../csv_import/csv_import_page.dart';
import 'lab_pages.dart';
import 'csv_result_edit_page.dart';

/// Presentation-only merge: no copying or rewriting of medical records.
/// CSV values remain in ImportedLabResults, manual values remain in LabResults.
class _ResultItem {
  const _ResultItem.manual(this.manual, this.displayName, this.category)
    : imported = null;
  const _ResultItem.csv(this.imported, this.displayName, this.category)
    : manual = null;

  final LabResult? manual;
  final ImportedLabResult? imported;
  final String displayName;
  final String category;
  DateTime get date => manual?.measuredAt ?? imported!.sampleDate;
  String get unit => manual?.unit ?? imported!.unit;
  String get value => manual?.valueNumeric.toString() ?? imported!.rawValue;
  String get source => imported == null ? '手动录入' : 'CSV 导入';
}

class _IndicatorGroup {
  _IndicatorGroup(this.title, this.category, this.manualTest);
  String title;
  String category;
  LabTest? manualTest;
  final List<_ResultItem> entries = [];
}

class UnifiedLabPage extends ConsumerWidget {
  const UnifiedLabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final csv = ref.watch(importedProvider);
    final manual = ref.watch(resultsProvider);
    final tests = ref.watch(testsProvider);
    final categories = ref.watch(categoriesProvider);
    if (csv.hasError ||
        manual.hasError ||
        tests.hasError ||
        categories.hasError) {
      return Center(
        child: SelectableText(
          '读取失败：${csv.error ?? manual.error ?? tests.error ?? categories.error}',
        ),
      );
    }
    if (!csv.hasValue ||
        !manual.hasValue ||
        !tests.hasValue ||
        !categories.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    final testById = {for (final t in tests.requireValue) t.id: t};
    final categoryById = {
      for (final c in categories.requireValue) c.id: c.nameZh,
    };
    final groups = <String, _IndicatorGroup>{};

    String keyFor(String code, String name, String category) {
      final normalized = code.trim().toUpperCase();
      // Missing code must not collapse unrelated indicators into one.
      return normalized.isNotEmpty
          ? 'code:$normalized'
          : 'name:$category:${name.trim()}';
    }

    for (final result in manual.requireValue) {
      final test = testById[result.testId];
      if (test == null) continue;
      final category = categoryById[test.categoryId] ?? '其他';
      final key = keyFor(test.code, test.nameZh, category);
      final group = groups.putIfAbsent(
        key,
        () => _IndicatorGroup(test.nameZh, category, test),
      );
      group.manualTest ??= test;
      group.entries.add(_ResultItem.manual(result, test.nameZh, category));
    }

    for (final result in csv.requireValue) {
      final category = result.category.trim().isEmpty
          ? '未分类'
          : result.category.trim();
      final key = keyFor(
        result.indicatorCode,
        result.indicatorNameCn,
        category,
      );
      final group = groups.putIfAbsent(
        key,
        () => _IndicatorGroup(result.indicatorNameCn, category, null),
      );
      group.entries.add(
        _ResultItem.csv(result, result.indicatorNameCn, category),
      );
    }

    final byCategory = <String, List<_IndicatorGroup>>{};
    for (final group in groups.values) {
      // Keep CSV category as supplied, unless an existing manual item defines it.
      byCategory.putIfAbsent(group.category, () => []).add(group);
    }
    final names = byCategory.keys.toList()..sort();
    for (final category in names) {
      byCategory[category]!.sort((a, b) => a.title.compareTo(b.title));
    }
    final total = groups.values.fold<int>(
      0,
      (sum, g) => sum + g.entries.length,
    );

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
          child: Text(
            '检查结果 · 共 $total 条（手动 ${manual.requireValue.length} / CSV ${csv.requireValue.length}）',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('按指标代码合并显示，保留每条记录的原始来源；未自动进行单位换算。'),
        ),
        if (total == 0)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('暂无检查结果，请先手动录入或导入 CSV。'),
          ),
        for (final category in names) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
            child: Text(
              category,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (final group in byCategory[category]!)
            ListTile(
              title: Text(group.title),
              subtitle: Text(
                '最新：${DateFormat('yyyy-MM-dd').format(group.entries.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b))}',
              ),
              trailing: Text('${group.entries.length} 条'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _UnifiedDetailPage(group: group),
                ),
              ),
            ),
        ],
        const SizedBox(height: 60),
      ],
    );
  }
}

class _UnifiedDetailPage extends ConsumerWidget {
  const _UnifiedDetailPage({required this.group});
  final _IndicatorGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorted = [...group.entries]..sort((a, b) => b.date.compareTo(a.date));
    return Scaffold(
      appBar: AppBar(title: Text(group.title)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${group.category} · 共 ${sorted.length} 条',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final item in sorted)
            ListTile(
              title: Text(
                '${item.value}${item.unit.isEmpty ? '' : ' ${item.unit}'}',
              ),
              subtitle: Text(
                '${DateFormat('yyyy-MM-dd HH:mm').format(item.date)} · ${item.source}'
                '${item.imported == null ? '' : '\n参考范围：${item.imported!.referenceRange}'
                          '\n报告：${item.imported!.reportId}'}',
              ),
              isThreeLine: item.imported != null,
              trailing: item.imported == null
                  ? const Icon(Icons.edit_outlined)
                  : PopupMenuButton<String>(
                      tooltip: '修改或删除',
                      onSelected: (action) async {
                        final r = item.imported!;
                        if (action == 'edit') {
                          final changed = await Navigator.of(context)
                              .push<bool>(
                                MaterialPageRoute(
                                  builder: (_) => CsvResultEditPage(result: r),
                                ),
                              );
                          if (changed == true && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        } else if (action == 'delete') {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('删除导入记录？'),
                              content: Text(
                                '确定隐藏 ${r.indicatorNameCn} 的这条检查结果吗？原始记录仍保留在数据库。',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                  child: const Text('取消'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, true),
                                  child: const Text('删除'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            try {
                              await ref
                                  .read(databaseProvider)
                                  .deleteImportedResult(r.id);
                              if (context.mounted) Navigator.of(context).pop();
                            } catch (error) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('删除失败：$error')),
                                );
                              }
                            }
                          }
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('编辑')),
                        PopupMenuItem(value: 'delete', child: Text('删除')),
                      ],
                    ),
              onTap: item.manual != null
                  ? () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => LabFormPage(existing: item.manual),
                      ),
                    )
                  : () async {
                      final changed = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) =>
                              CsvResultEditPage(result: item.imported!),
                        ),
                      );
                      if (changed == true && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
            ),
        ],
      ),
      floatingActionButton: group.manualTest == null
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LabFormPage(initialTest: group.manualTest),
                ),
              ),
              child: const Icon(Icons.add),
            ),
    );
  }
}
