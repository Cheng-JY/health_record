import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../core/database/app_database.dart';

String dateText(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(resultsProvider);
    final tests = ref.watch(testsProvider);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('健康数据概览', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            title: const Text('已保存检查结果'),
            subtitle: const Text('本地 SQLite 数据库'),
            trailing: Text(
              results.when(
                data: (r) => '${r.length}',
                loading: () => '…',
                error: (_, _) => '!',
              ),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('可录入指标'),
            trailing: Text(
              tests.when(
                data: (t) => '${t.length}',
                loading: () => '…',
                error: (_, _) => '!',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('目前为本地优先 MVP：请只输入模拟数据。尚未启用加密、备份和报告识别。'),
      ],
    );
  }
}

class LabListPage extends ConsumerWidget {
  const LabListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(testsProvider);
    final results = ref.watch(resultsProvider);
    final cats = ref.watch(categoriesProvider);
    return tests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (allTests) => cats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (categories) => results.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (items) => ListView(
            children: [
              for (final cat in categories) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                  child: Text(
                    cat.nameZh,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                for (final test in allTests.where(
                  (t) => t.categoryId == cat.id,
                ))
                  ListTile(
                    title: Text('${test.nameZh} (${test.code})'),
                    subtitle: Text(test.nameDe ?? test.canonicalUnit),
                    trailing: Text(
                      '${items.where((r) => r.testId == test.id).length} 条',
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LabDetailPage(test: test),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LabDetailPage extends ConsumerWidget {
  const LabDetailPage({super.key, required this.test});
  final LabTest test;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(testResultsProvider(test.id));
    return Scaffold(
      appBar: AppBar(title: Text(test.nameZh)),
      body: stream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('尚无记录，点击右下角录入'))
            : ListView(
                children: [
                  for (final item in items.reversed)
                    ListTile(
                      title: Text('${item.valueNumeric} ${item.unit}'),
                      subtitle: Text(dateText(item.measuredAt)),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LabFormPage(existing: item),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: '删除',
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('删除记录？'),
                              content: const Text('该操作将隐藏这条记录。'),
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
                          if (confirmed == true) {
                            await ref
                                .read(labRepositoryProvider)
                                .remove(item.id);
                          }
                        },
                      ),
                    ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LabFormPage(initialTest: test)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LabFormPage extends ConsumerStatefulWidget {
  const LabFormPage({super.key, this.initialTest, this.existing});
  final LabTest? initialTest;
  final LabResult? existing;
  @override
  ConsumerState<LabFormPage> createState() => _LabFormPageState();
}

class _LabFormPageState extends ConsumerState<LabFormPage> {
  final formKey = GlobalKey<FormState>();
  final valueCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final lowCtrl = TextEditingController();
  final highCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String? testId;
  DateTime date = DateTime.now();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    testId = widget.existing?.testId ?? widget.initialTest?.id;
    if (widget.existing case final r?) {
      date = r.measuredAt;
      valueCtrl.text = r.valueNumeric.toString();
      unitCtrl.text = r.unit;
      lowCtrl.text = r.referenceLow?.toString() ?? '';
      highCtrl.text = r.referenceHigh?.toString() ?? '';
      noteCtrl.text = r.note ?? '';
    } else if (widget.initialTest != null) {
      unitCtrl.text = widget.initialTest!.canonicalUnit;
    }
  }

  @override
  void dispose() {
    for (final c in [valueCtrl, unitCtrl, lowCtrl, highCtrl, noteCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tests = ref.watch(testsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? '录入检查结果' : '编辑检查结果'),
      ),
      body: tests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (options) => Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<String>(
                initialValue: options.any((t) => t.id == testId)
                    ? testId
                    : null,
                decoration: const InputDecoration(
                  labelText: '检查指标',
                  border: OutlineInputBorder(),
                ),
                items: options
                    .map(
                      (t) => DropdownMenuItem(
                        value: t.id,
                        child: Text('${t.nameZh} (${t.code})'),
                      ),
                    )
                    .toList(),
                validator: (v) => v == null ? '请选择指标' : null,
                onChanged: (v) {
                  setState(() => testId = v);
                  final t = options.where((t) => t.id == v).firstOrNull;
                  if (t != null && widget.existing == null) {
                    unitCtrl.text = t.canonicalUnit;
                  }
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text('检查日期：${dateText(date)}'),
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) setState(() => date = d);
                },
              ),
              const SizedBox(height: 12),
              _field(valueCtrl, '结果数值', requiredField: true),
              _field(unitCtrl, '单位', requiredField: true, number: false),
              _field(lowCtrl, '参考范围下限（选填）'),
              _field(highCtrl, '参考范围上限（选填）'),
              _field(noteCtrl, '备注（选填）', number: false),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setState(() => saving = true);
                        try {
                          await ref
                              .read(labRepositoryProvider)
                              .save(
                                id: widget.existing?.id,
                                testId: testId!,
                                date: date,
                                value: double.parse(
                                  valueCtrl.text.trim().replaceAll(',', '.'),
                                ),
                                unit: unitCtrl.text,
                                low: _optionalNumber(lowCtrl.text),
                                high: _optionalNumber(highCtrl.text),
                                note: noteCtrl.text.trim(),
                              );
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('保存失败：$e')));
                          }
                        } finally {
                          if (mounted) setState(() => saving = false);
                        }
                      },
                child: Text(saving ? '保存中…' : '保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? _optionalNumber(String s) =>
      s.trim().isEmpty ? null : double.parse(s.trim().replaceAll(',', '.'));

  Widget _field(
    TextEditingController ctrl,
    String label, {
    bool requiredField = false,
    bool number = true,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: number
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
          : TextInputType.text,
      validator: (v) {
        if (requiredField && (v == null || v.trim().isEmpty)) return '不能为空';
        if (number && v != null && v.trim().isNotEmpty) {
          final d = double.tryParse(v.trim().replaceAll(',', '.'));
          if (d == null || !d.isFinite) return '请输入有效数字';
        }
        return null;
      },
    ),
  );
}

class TrendsPage extends ConsumerStatefulWidget {
  const TrendsPage({super.key});
  @override
  ConsumerState<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends ConsumerState<TrendsPage> {
  String? selected;
  @override
  Widget build(BuildContext context) {
    final tests = ref.watch(testsProvider);
    return tests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (options) {
        if (options.isEmpty) return const Center(child: Text('暂无指标'));
        final id = options.any((t) => t.id == selected)
            ? selected!
            : options.first.id;
        final test = options.firstWhere((t) => t.id == id);
        final results = ref.watch(testResultsProvider(id));
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: id,
              decoration: const InputDecoration(
                labelText: '选择指标',
                border: OutlineInputBorder(),
              ),
              items: options
                  .map(
                    (t) => DropdownMenuItem(
                      value: t.id,
                      child: Text('${t.nameZh} (${t.code})'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selected = v),
            ),
            const SizedBox(height: 24),
            Text(
              '历史趋势 · ${test.canonicalUnit}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('读取失败：$e'),
              data: (items) {
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(36),
                    child: Text('还没有这个指标的记录，请先去“检查结果”录入。'),
                  );
                }
                if (items.any((e) => e.unit != test.canonicalUnit)) {
                  return const Text('存在与标准单位不同的记录，尚未实现单位转换。为避免误导，暂停绘图；请核对单位。');
                }
                final points = items
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.valueNumeric))
                    .toList();
                final minY = items
                    .map((r) => r.valueNumeric)
                    .reduce((a, b) => a < b ? a : b);
                final maxY = items
                    .map((r) => r.valueNumeric)
                    .reduce((a, b) => a > b ? a : b);
                final pad = (maxY - minY).abs() < 0.000001
                    ? (maxY.abs() * .1 + 1)
                    : (maxY - minY) * .15;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: LineChart(
                          LineChartData(
                            minY: minY - pad,
                            maxY: maxY + pad,
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                  getTitlesWidget: (v, meta) {
                                    final i = v.toInt();
                                    if (i < 0 ||
                                        i >= items.length ||
                                        v != i.toDouble()) {
                                      return const SizedBox.shrink();
                                    }
                                    if (items.length > 7 &&
                                        i % ((items.length / 6).ceil()) != 0) {
                                      return const SizedBox.shrink();
                                    }
                                    return Text(
                                      DateFormat('MM/dd')
                                          .format(items[i].measuredAt),
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: points,
                                isCurved: false,
                                barWidth: 2,
                                dotData: const FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final r in items.reversed)
                      ListTile(
                        title: Text('${r.valueNumeric} ${r.unit}'),
                        subtitle: Text(dateText(r.measuredAt)),
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
