import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../csv_import/csv_import_page.dart';
import '../hospitals/hospitals_page.dart';
import '../settings/plot_settings.dart';

// A plotting replacement is never written back to the database.

class _ResultValue {
  const _ResultValue(this.number, {this.censored = false});
  final double? number;
  final bool censored;
}

class _Reference {
  const _Reference(this.low, this.high, this.original);
  final double? low;
  final double? high;
  final String original;

  bool get hasBound => low != null || high != null;
  String get signature => '${low ?? ""}|${high ?? ""}|${original.trim()}';
}

class _TrendRecord {
  const _TrendRecord({
    required this.date,
    required this.rawValue,
    required this.exactValue,
    required this.unit,
    required this.source,
    required this.reference,
  });
  final DateTime date;
  final String rawValue;
  final double? exactValue;
  final String unit;
  final String source;
  final _Reference reference;
}

class _TrendSeries {
  _TrendSeries(this.label);
  final String label;
  final List<_TrendRecord> records = [];
}

class _PlottedPoint {
  const _PlottedPoint(this.record, this.result);
  final _TrendRecord record;
  final _ResultValue result;
}

// Interpret only plain numeric values and explicit inequalities.
// Never parse qualitative results such as positive / negative into a number.
_ResultValue _parseValue(
  _TrendRecord record,
  PlotLessThanRule rule,
  double factor,
) {
  final raw = record.rawValue
      .trim()
      .replaceAll('≤', '<=')
      .replaceAll('≥', '>=')
      .replaceAll('＜', '<')
      .replaceAll('＞', '>');
  final normalized = raw.replaceAll(',', '.');
  final direct = double.tryParse(normalized);
  if (direct != null && direct.isFinite) {
    return _ResultValue(direct);
  }
  final match = RegExp(
    r'^(<=|>=|<|>)\s*([+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?)$',
  ).firstMatch(normalized);
  if (match == null) {
    final exact = record.exactValue;
    return _ResultValue(exact != null && exact.isFinite ? exact : null);
  }
  final threshold = double.tryParse(match.group(2)!);
  if (threshold == null || !threshold.isFinite) return const _ResultValue(null);
  final op = match.group(1)!;
  double plotted = threshold;
  if (op.startsWith('<')) {
    if (rule == PlotLessThanRule.half) {
      plotted = threshold / 2;
    } else if (rule == PlotLessThanRule.custom) {
      plotted = threshold * factor;
    }
  }
  // Values above a detection bound use their threshold as a boundary marker.
  // They are NOT exact measured values, even if they plot at the threshold.
  return _ResultValue(plotted, censored: true);
}

_Reference _referenceFromText(String raw) {
  final text = raw
      .trim()
      .replaceAll('≤', '<=')
      .replaceAll('≥', '>=')
      .replaceAll('＜', '<')
      .replaceAll('＞', '>')
      .replaceAll('–', '-')
      .replaceAll('—', '-')
      .replaceAll('~', '-')
      .replaceAll('～', '-')
      .replaceAll(',', '.');
  const number = r'([+-]?(?:\d+(?:\.\d*)?|\.\d+))';
  final between = RegExp('^$number\\s*-\\s*$number\$').firstMatch(text);
  if (between != null) {
    final a = double.tryParse(between.group(1)!);
    final b = double.tryParse(between.group(2)!);
    if (a != null && b != null && a <= b) return _Reference(a, b, raw);
  }
  final below = RegExp('^(?:<|<=)\\s*$number\$').firstMatch(text);
  if (below != null)
    return _Reference(null, double.tryParse(below.group(1)!), raw);
  final above = RegExp('^(?:>|>=)\\s*$number\$').firstMatch(text);
  if (above != null)
    return _Reference(double.tryParse(above.group(1)!), null, raw);
  return _Reference(null, null, raw);
}

class UnifiedTrendsPage extends ConsumerStatefulWidget {
  const UnifiedTrendsPage({
    super.key,
    this.indicatorKey,
    this.hospitalFilter = 'all',
    this.embedded = false,
  });

  /// Identifies the same code/name group used in UnifiedLabPage.
  final String? indicatorKey;
  final String hospitalFilter;
  final bool embedded;

  @override
  ConsumerState<UnifiedTrendsPage> createState() => _UnifiedTrendsPageState();
}

class _UnifiedTrendsPageState extends ConsumerState<UnifiedTrendsPage> {
  String? selectedCategory;
  String? selectedKey;
  String? selectedUnit;
  String selectedHospital = 'all';

  @override
  void initState() {
    super.initState();
    selectedHospital = widget.hospitalFilter;
    selectedKey = widget.indicatorKey;
    plotSettings.addListener(_settingsChanged);
  }

  void _settingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    plotSettings.removeListener(_settingsChanged);
    super.dispose();
  }

  String _key(String code, String name, String category) {
    final normalized = code.trim().toUpperCase();
    if (normalized.isNotEmpty) return 'code:$normalized';
    return 'name:${category.trim()}:${name.trim()}';
  }

  double _x(DateTime date) =>
      date.millisecondsSinceEpoch / Duration.millisecondsPerDay;

  @override
  Widget build(BuildContext context) {
    final lessThanRule = plotSettings.value.rule;
    final customFactor = plotSettings.value.factor;
    final manual = ref.watch(resultsProvider);
    final csv = ref.watch(importedProvider);
    final tests = ref.watch(testsProvider);
    final categories = ref.watch(categoriesProvider);
    final hospitals = ref.watch(hospitalSummariesProvider);

    if (manual.hasError ||
        csv.hasError ||
        tests.hasError ||
        categories.hasError ||
        hospitals.hasError) {
      return Center(
        child: SelectableText(
          '读取趋势数据失败：${manual.error ?? csv.error ?? tests.error ?? categories.error ?? hospitals.error}',
        ),
      );
    }
    if (!manual.hasValue ||
        !csv.hasValue ||
        !tests.hasValue ||
        !categories.hasValue ||
        !hospitals.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    final hospitalList = hospitals.requireValue;
    final validHospitalIds = hospitalList.map((e) => e.hospital.id).toSet();
    final selected =
        selectedHospital == 'all' ||
            selectedHospital == 'unassigned' ||
            validHospitalIds.contains(selectedHospital)
        ? selectedHospital
        : 'all';
    final filteredCsv = csv.requireValue
        .where(
          (r) =>
              selected == 'all' ||
              (selected == 'unassigned'
                  ? r.hospitalId == null
                  : r.hospitalId == selected),
        )
        .toList();
    // Manual records have no hospitalId in schema v4.
    final filteredManual = manual.requireValue
        .where((_) => selected == 'all' || selected == 'unassigned')
        .toList();
    final testMap = {for (final t in tests.requireValue) t.id: t};
    final categoryMap = {
      for (final c in categories.requireValue) c.id: c.nameZh,
    };
    final series = <String, _TrendSeries>{};
    // An indicator can belong to more than one imported category.
    final indicatorCategories = <String, Set<String>>{};

    void add(String key, String label, String category, _TrendRecord record) {
      final cleanCategory = category.trim().isEmpty ? '未分类' : category.trim();
      indicatorCategories.putIfAbsent(key, () => <String>{}).add(cleanCategory);
      series.putIfAbsent(key, () => _TrendSeries(label)).records.add(record);
    }

    for (final r in filteredManual) {
      final t = testMap[r.testId];
      if (t == null) continue;
      final cat = categoryMap[t.categoryId] ?? '';
      add(
        _key(t.code, t.nameZh, cat),
        '${t.nameZh} (${t.code})',
        cat,
        _TrendRecord(
          date: r.measuredAt,
          rawValue: r.valueNumeric.toString(),
          exactValue: r.valueNumeric,
          unit: r.unit.trim(),
          source: '手动录入',
          reference: _Reference(
            r.referenceLow,
            r.referenceHigh,
            r.referenceLow == null && r.referenceHigh == null
                ? ''
                : '${r.referenceLow ?? ""}–${r.referenceHigh ?? ""}',
          ),
        ),
      );
    }

    for (final r in filteredCsv) {
      final code = r.indicatorCode.trim();
      add(
        _key(code, r.indicatorNameCn, r.category),
        code.isEmpty ? r.indicatorNameCn : '${r.indicatorNameCn} ($code)',
        r.category,
        _TrendRecord(
          date: r.sampleDate,
          rawValue: r.rawValue,
          exactValue: r.numericValue,
          unit: r.unit.trim(),
          source: 'CSV',
          reference: _referenceFromText(r.referenceRange),
        ),
      );
    }

    final keys = series.keys.toList()
      ..sort((a, b) => series[a]!.label.compareTo(series[b]!.label));
    final categoryOptions =
        indicatorCategories.values
            .expand((categories) => categories)
            .toSet()
            .toList()
          ..sort();
    final category = categoryOptions.contains(selectedCategory)
        ? selectedCategory
        : (categoryOptions.isEmpty ? null : categoryOptions.first);
    final categoryKeys = category == null
        ? <String>[]
        : keys
              .where((k) => indicatorCategories[k]?.contains(category) ?? false)
              .toList();
    final preferred = categoryKeys.where(
      (k) =>
          series[k]!.records
              .where(
                (r) =>
                    _parseValue(r, lessThanRule, customFactor).number != null,
              )
              .length >=
          2,
    );
    final key = widget.embedded
        ? (series.containsKey(widget.indicatorKey) ? widget.indicatorKey : null)
        : categoryKeys.contains(selectedKey)
        ? selectedKey
        : (preferred.isNotEmpty
              ? preferred.first
              : (categoryKeys.isEmpty ? null : categoryKeys.first));
    final group = key == null ? null : series[key];
    final units = group == null
        ? <String>[]
        : (group.records.map((r) => r.unit).toSet().toList()..sort());
    final unit = units.contains(selectedUnit)
        ? selectedUnit
        : (units.isEmpty ? null : units.first);
    final sameUnit = group == null
        ? <_TrendRecord>[]
        : (group.records.where((r) => r.unit == unit).toList()
            ..sort((a, b) => a.date.compareTo(b.date)));
    final plotted = [
      for (final r in sameUnit)
        _PlottedPoint(r, _parseValue(r, lessThanRule, customFactor)),
    ];
    final numeric = plotted
        .where((p) => p.result.number != null && p.result.number!.isFinite)
        .toList();
    final other = plotted.where((p) => p.result.number == null).toList();
    final references = sameUnit.where((r) => r.reference.hasBound).toList();
    final referenceSignatures = references
        .map((r) => '${r.reference.low}|${r.reference.high}')
        .toSet();
    final sameReference = referenceSignatures.length <= 1;
    // With conflicting ranges, no single line is portrayed as universal.
    final chartReference = sameReference && references.isNotEmpty
        ? references.last.reference
        : null;

    return ListView(
      shrinkWrap: widget.embedded,
      physics: widget.embedded ? const NeverScrollableScrollPhysics() : null,
      padding: widget.embedded ? EdgeInsets.zero : const EdgeInsets.all(16),
      children: [
        if (!widget.embedded) ...[
          Text('检查指标趋势', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('合并查看手动录入和 CSV 数据。不同单位分别显示；原始结果不会被修改。'),
          const SizedBox(height: 16),
        ] else ...[
          Text('趋势图', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
        ],
        if (!widget.embedded)
          DropdownButtonFormField<String>(
            key: ValueKey('hospital-$selected-${hospitalList.length}'),
            initialValue: selected,
            decoration: const InputDecoration(
              labelText: '筛选医院',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: 'all', child: Text('所有医院 / 全部来源')),
              const DropdownMenuItem(
                value: 'unassigned',
                child: Text('未指定医院（含手动记录）'),
              ),
              for (final item in hospitalList)
                DropdownMenuItem(
                  value: item.hospital.id,
                  child: Text(
                    item.hospital.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (v) => setState(() {
              selectedHospital = v ?? 'all';
              selectedCategory = null;
              selectedKey = null;
              selectedUnit = null;
            }),
          ),
        if (!widget.embedded) const SizedBox(height: 16),
        if (widget.embedded ? key == null : category == null) ...[
          const Text('该指标当前没有可显示的趋势记录。'),
        ] else ...[
          if (!widget.embedded)
            DropdownButtonFormField<String>(
              key: ValueKey('category-$selected-$category'),
              initialValue: category,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: '指标分类',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final c in categoryOptions)
                  DropdownMenuItem(
                    value: c,
                    child: Text(c, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() {
                selectedCategory = v;
                selectedKey = null;
                selectedUnit = null;
              }),
            ),
          const SizedBox(height: 12),
          if (!widget.embedded)
            DropdownButtonFormField<String>(
              key: ValueKey('indicator-$category-$key'),
              initialValue: key,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: '检查指标',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final k in categoryKeys)
                  DropdownMenuItem(
                    value: k,
                    child: Text(
                      series[k]!.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (v) => setState(() {
                selectedKey = v;
                selectedUnit = null;
              }),
            ),
          const SizedBox(height: 12),
          if (units.length > 1) ...[
            DropdownButtonFormField<String>(
              key: ValueKey('unit-$key-$unit'),
              initialValue: unit,
              decoration: const InputDecoration(
                labelText: '单位（分别绘制）',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final u in units)
                  DropdownMenuItem(
                    value: u,
                    child: Text(u.isEmpty ? '无单位' : u),
                  ),
              ],
              onChanged: (v) => setState(() => selectedUnit = v),
            ),
            const SizedBox(height: 12),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('界限值的绘图规则可在底部「设置」页面统一调整；原始检测值不会改变。'),
          ),
          const SizedBox(height: 14),
          Text(
            '数值点：${numeric.length}（含 ${numeric.where((p) => p.result.censored).length} 个界限值） · 非数值结果：${other.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          if (numeric.isEmpty)
            const Text('该指标在当前单位下没有可绘图的数值结果。')
          else
            _TrendChart(
              points: numeric,
              unit: unit ?? '',
              x: _x,
              reference: chartReference,
            ),
          if (numeric.length == 1)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('目前只有一个可绘制数据点。'),
            ),
          if (!sameReference)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('不同记录的参考范围不一致：图表不显示统一参考线，具体范围见各条记录。'),
            ),
          if (chartReference != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '图中参考范围：${chartReference.original.isEmpty ? "按记录上下限" : chartReference.original} ${unit ?? ""}',
              ),
            ),
          if (!widget.embedded) const SizedBox(height: 18),
          if (!widget.embedded)
            Text('历史记录', style: Theme.of(context).textTheme.titleLarge),
          for (final p
              in widget.embedded ? <_PlottedPoint>[] : plotted.reversed)
            ListTile(
              dense: true,
              title: Text(
                '${p.record.rawValue} ${p.record.unit}${p.result.censored && p.result.number != null ? "  · 绘图值 ${_formatNumber(p.result.number!)}" : ""}',
              ),
              subtitle: Text(
                '${DateFormat('yyyy-MM-dd HH:mm').format(p.record.date)} · ${p.record.source}'
                '${p.record.reference.original.trim().isEmpty ? "" : " · 参考范围 ${p.record.reference.original}"}',
              ),
            ),
          const SizedBox(height: 12),
          const Text('提示：界限值的绘图替代数值不是实际检测结果；不同医院或检测方法的参考范围可能不同。'),
        ],
      ],
    );
  }
}

String _formatNumber(double n) {
  final result = n.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
  return result.isEmpty || result == '-0' ? '0' : result;
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({
    required this.points,
    required this.unit,
    required this.x,
    required this.reference,
  });
  final List<_PlottedPoint> points;
  final String unit;
  final double Function(DateTime) x;
  final _Reference? reference;

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (final p in points) FlSpot(x(p.record.date), p.result.number!),
    ];
    final values = [
      ...spots.map((s) => s.y),
      if (reference?.low != null) reference!.low!,
      if (reference?.high != null) reference!.high!,
    ];
    final low = values.reduce(math.min);
    final high = values.reduce(math.max);
    final padding = high == low
        ? (high.abs() * 0.1 + 0.1)
        : (high - low) * 0.15;
    final minX = spots.first.x;
    final maxX = spots.last.x;
    final spread = maxX - minX;
    final xPad = spread == 0 ? 1.0 : spread * 0.04;
    final xInterval = spread == 0 ? 1.0 : (spread / 4).ceilToDouble();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('数值趋势${unit.isEmpty ? "" : " ($unit)"}'),
        const SizedBox(height: 8),
        SizedBox(
          height: 320,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: LineChart(
              LineChartData(
                minX: minX - xPad,
                maxX: maxX + xPad,
                minY: low - padding,
                maxY: high + padding,
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
                      reservedSize: 32,
                      interval: xInterval,
                      getTitlesWidget: (v, meta) {
                        final dt = DateTime.fromMillisecondsSinceEpoch(
                          (v * Duration.millisecondsPerDay).round(),
                        );
                        return Text(
                          DateFormat('MM/dd').format(dt),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                // Light green background marks the reported reference interval.
                // One-sided bounds (<5 or >10) extend to the visible chart edge.
                rangeAnnotations: RangeAnnotations(
                  horizontalRangeAnnotations: [
                    if (reference != null && reference!.hasBound)
                      HorizontalRangeAnnotation(
                        y1: reference!.low ?? (low - padding),
                        y2: reference!.high ?? (high + padding),
                        color: Colors.green.withValues(alpha: 0.20),
                      ),
                  ],
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    if (reference?.low != null)
                      HorizontalLine(
                        y: reference!.low!,
                        color: Colors.green.shade700,
                        strokeWidth: 1,
                        dashArray: [6, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          labelResolver: (_) =>
                              '下限 ${_formatNumber(reference!.low!)}',
                        ),
                      ),
                    if (reference?.high != null)
                      HorizontalLine(
                        y: reference!.high!,
                        color: Colors.green.shade700,
                        strokeWidth: 1,
                        dashArray: [6, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.bottomRight,
                          labelResolver: (_) =>
                              '上限 ${_formatNumber(reference!.high!)}',
                        ),
                      ),
                  ],
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touched) => touched.map((s) {
                      final point = points[s.spotIndex];
                      final time = DateFormat('yyyy-MM-dd HH:mm')
                          .format(point.record.date);
                      final original = '${point.record.rawValue} $unit';
                      final estimate = point.result.censored
                          ? '\n绘图值：${_formatNumber(s.y)} $unit（代用值）'
                          : '';
                      final ref = point.record.reference.original.trim();
                      return LineTooltipItem(
                        '$time\n原始值：$original$estimate${ref.isEmpty ? "" : "\n参考范围：$ref"}',
                        TextStyle(color: theme.colorScheme.onInverseSurface),
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
        if (reference != null && reference!.hasBound)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.20),
                    border: Border.all(color: Colors.green.shade700),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '绿色区域：该检查报告的参考范围',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        if (points.any((p) => p.result.censored))
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '部分点由 < / > 等界限结果换算，仅用于显示趋势，不代表实测值。',
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}
