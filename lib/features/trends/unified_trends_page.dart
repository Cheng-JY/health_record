import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';
import '../csv_import/csv_import_page.dart';

/// Read-only view over both sources. No schema changes or copying data.
class _TrendRecord {
  const _TrendRecord({
    required this.date,
    required this.value,
    required this.rawValue,
    required this.unit,
    required this.source,
  });

  final DateTime date;
  final double? value;
  final String rawValue;
  final String unit;
  final String source;
}

class _TrendSeries {
  _TrendSeries(this.label);
  final String label;
  final List<_TrendRecord> records = [];
}

class UnifiedTrendsPage extends ConsumerStatefulWidget {
  const UnifiedTrendsPage({super.key});

  @override
  ConsumerState<UnifiedTrendsPage> createState() => _UnifiedTrendsPageState();
}

class _UnifiedTrendsPageState extends ConsumerState<UnifiedTrendsPage> {
  String? selectedKey;
  String? selectedUnit;

  String _key(String code, String name, String category) {
    final normalized = code.trim().toUpperCase();
    if (normalized.isNotEmpty) return 'code:$normalized';
    return 'name:${category.trim()}:${name.trim()}';
  }

  // Convert DateTime to a real, monotonic chart x-axis (days since epoch).
  double _x(DateTime date) =>
      date.millisecondsSinceEpoch / Duration.millisecondsPerDay;

  @override
  Widget build(BuildContext context) {
    final manual = ref.watch(resultsProvider);
    final csv = ref.watch(importedProvider);
    final tests = ref.watch(testsProvider);
    final categories = ref.watch(categoriesProvider);

    if (manual.hasError || csv.hasError || tests.hasError || categories.hasError) {
      return Center(
        child: SelectableText(
          '读取趋势数据失败：${manual.error ?? csv.error ?? tests.error ?? categories.error}',
        ),
      );
    }
    if (!manual.hasValue || !csv.hasValue || !tests.hasValue || !categories.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    final testMap = {for (final t in tests.requireValue) t.id: t};
    final categoryMap = {for (final c in categories.requireValue) c.id: c.nameZh};
    final series = <String, _TrendSeries>{};

    void add(String key, String label, _TrendRecord record) {
      series.putIfAbsent(key, () => _TrendSeries(label)).records.add(record);
    }

    for (final r in manual.requireValue) {
      final t = testMap[r.testId];
      if (t == null) continue;
      final cat = categoryMap[t.categoryId] ?? '';
      add(
        _key(t.code, t.nameZh, cat),
        '${t.nameZh} (${t.code})',
        _TrendRecord(
          date: r.measuredAt,
          value: r.valueNumeric,
          rawValue: r.valueNumeric.toString(),
          unit: r.unit.trim(),
          source: '手动录入',
        ),
      );
    }

    for (final r in csv.requireValue) {
      final code = r.indicatorCode.trim();
      add(
        _key(code, r.indicatorNameCn, r.category),
        code.isEmpty ? r.indicatorNameCn : '${r.indicatorNameCn} ($code)',
        _TrendRecord(
          date: r.sampleDate,
          value: r.numericValue,
          rawValue: r.rawValue,
          unit: r.unit.trim(),
          source: 'CSV',
        ),
      );
    }

    if (series.isEmpty) {
      return const Center(child: Text('还没有检查记录，请先录入或导入 CSV。'));
    }

    final keys = series.keys.toList()
      ..sort((a, b) => series[a]!.label.compareTo(series[b]!.label));
    final preferred = keys.where((k) => series[k]!.records.where((r) => r.value != null).length >= 2);
    final key = series.containsKey(selectedKey)
        ? selectedKey!
        : (preferred.isNotEmpty ? preferred.first : keys.first);
    final group = series[key]!;
    final units = group.records.map((r) => r.unit).toSet().toList()..sort();
    final unit = units.contains(selectedUnit) ? selectedUnit! : units.first;
    final sameUnit = group.records.where((r) => r.unit == unit).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final numeric = sameUnit.where((r) => r.value != null && r.value!.isFinite).toList();
    final other = sameUnit.where((r) => r.value == null || !r.value!.isFinite).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('检查指标趋势', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('合并查看手动录入和 CSV 数据。不同单位分别展示，不自动转换。'),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          key: ValueKey('indicator-$key'),
          initialValue: key,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '检查指标', border: OutlineInputBorder()),
          items: [
            for (final k in keys)
              DropdownMenuItem(value: k, child: Text(series[k]!.label, overflow: TextOverflow.ellipsis)),
          ],
          onChanged: (k) => setState(() {
            selectedKey = k;
            selectedUnit = null;
          }),
        ),
        const SizedBox(height: 12),
        if (units.length > 1) ...[
          DropdownButtonFormField<String>(
            key: ValueKey('unit-$key-$unit'),
            initialValue: unit,
            decoration: const InputDecoration(labelText: '单位（分别绘制）', border: OutlineInputBorder()),
            items: [for (final u in units) DropdownMenuItem(value: u, child: Text(u.isEmpty ? '无单位' : u))],
            onChanged: (u) => setState(() => selectedUnit = u),
          ),
          const SizedBox(height: 12),
        ],
        Text('数值记录：${numeric.length} · 非数值记录：${other.length}',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        if (numeric.isEmpty)
          const Text('该指标在当前单位下没有可绘图的数值结果。')
        else
          _TrendChart(points: numeric, unit: unit, x: _x),
        if (numeric.length == 1)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('目前只有一个数值数据点，暂无连续趋势。'),
          ),
        const SizedBox(height: 20),
        Text('历史记录', style: Theme.of(context).textTheme.titleLarge),
        for (final r in sameUnit.reversed)
          ListTile(
            dense: true,
            title: Text('${r.rawValue} ${r.unit}'),
            subtitle: Text('${DateFormat('yyyy-MM-dd HH:mm').format(r.date)} · ${r.source}'),
          ),
        const SizedBox(height: 12),
        const Text('提示：这是数据展示，不是医学诊断；相同指标代码不一定保证相同检测方法或标本。'),
      ],
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.points, required this.unit, required this.x});
  final List<_TrendRecord> points;
  final String unit;
  final double Function(DateTime) x;

  @override
  Widget build(BuildContext context) {
    final spots = [for (final p in points) FlSpot(x(p.date), p.value!)];
    final values = spots.map((s) => s.y).toList();
    final low = values.reduce((a, b) => a < b ? a : b);
    final high = values.reduce((a, b) => a > b ? a : b);
    final padding = high == low ? (high.abs() * .1 + 0.1) : (high - low) * 0.15;
    final minX = spots.first.x;
    final maxX = spots.last.x;
    final spread = maxX - minX;
    final xPad = spread == 0 ? 1.0 : spread * 0.04;
    final xInterval = spread == 0 ? 1.0 : (spread / 4).ceilToDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('数值趋势${unit.isEmpty ? '' : ' ($unit)'}'),
        const SizedBox(height: 8),
        SizedBox(
          height: 280,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LineChart(
              LineChartData(
                minX: minX - xPad,
                maxX: maxX + xPad,
                minY: low - padding,
                maxY: high + padding,
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: xInterval,
                      getTitlesWidget: (v, meta) {
                        final dt = DateTime.fromMillisecondsSinceEpoch(
                          (v * Duration.millisecondsPerDay).round(),
                        );
                        return Text(DateFormat('MM/dd').format(dt),
                            style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
                      final dt = DateTime.fromMillisecondsSinceEpoch(
                        (s.x * Duration.millisecondsPerDay).round(),
                      );
                      return LineTooltipItem(
                        '${DateFormat('yyyy-MM-dd HH:mm').format(dt)}\n${s.y} $unit',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    barWidth: 2,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
