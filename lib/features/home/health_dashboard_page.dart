import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';
import '../csv_import/csv_import_page.dart';
import '../hospitals/hospital_repository.dart';
import '../labs/lab_pages.dart';
import '../medications/medications_page.dart';
import '../trends/unified_trends_page.dart';
import '../visits/visits_page.dart';

/// Only reads medication plans. Does not change medication history.
final _homePlansProvider = StreamProvider<List<MedicationPlan>>(
  (ref) => ref
      .watch(databaseProvider)
      .select(ref.watch(databaseProvider).medicationPlans)
      .watch(),
);

class _HomeIndicator {
  const _HomeIndicator({
    required this.key,
    required this.label,
    required this.date,
    required this.value,
  });
  final String key;
  final String label;
  final DateTime date;
  final String value;
}

class HealthDashboardPage extends ConsumerStatefulWidget {
  const HealthDashboardPage({super.key});

  @override
  ConsumerState<HealthDashboardPage> createState() =>
      _HealthDashboardPageState();
}

class _HealthDashboardPageState extends ConsumerState<HealthDashboardPage> {
  static const _favoritesStorageKey =
      'health_record_home_favorite_indicators_v1';
  final _preferences = SharedPreferencesAsync();
  Set<String> favoriteKeys = {};
  bool favoritesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final saved = await _preferences.getStringList(_favoritesStorageKey);
      if (!mounted) return;
      setState(() {
        favoriteKeys = saved?.toSet() ?? <String>{};
        favoritesLoaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => favoritesLoaded = true);
    }
  }

  Future<void> _chooseFavorites(Map<String, _HomeIndicator> indicators) async {
    final chosen = Set<String>.of(favoriteKeys);
    final all = indicators.values.toList()
      ..sort((a, b) => a.label.compareTo(b.label));
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, update) => AlertDialog(
          title: const Text('选择关注的检查指标'),
          content: SizedBox(
            width: 520,
            height: 440,
            child: all.isEmpty
                ? const Center(child: Text('暂无检查指标，请先录入或导入检查结果。'))
                : ListView.builder(
                    itemCount: all.length,
                    itemBuilder: (ctx, i) {
                      final item = all[i];
                      return CheckboxListTile(
                        title: Text(item.label),
                        subtitle: Text(
                          '最近检查：${DateFormat('yyyy-MM-dd').format(item.date)}',
                        ),
                        value: chosen.contains(item.key),
                        onChanged: (checked) => update(() {
                          if (checked == true) {
                            chosen.add(item.key);
                          } else {
                            chosen.remove(item.key);
                          }
                        }),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(chosen),
              child: const Text('保存选择'),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;
    try {
      await _preferences.setStringList(
        _favoritesStorageKey,
        result.toList()..sort(),
      );
      if (mounted) setState(() => favoriteKeys = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('保存关注指标失败：$e')));
      }
    }
  }

  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final medicationState = ref.watch(medicationsProvider);
    final plansState = ref.watch(_homePlansProvider);
    final visitsState = ref.watch(visitsProvider);
    final hospitalsState = ref.watch(visitHospitalsProvider);
    final importedState = ref.watch(importedProvider);
    final manualState = ref.watch(resultsProvider);
    final testsState = ref.watch(testsProvider);
    final categoriesState = ref.watch(categoriesProvider);

    final today = DateUtils.dateOnly(DateTime.now());
    final medications = medicationState.asData?.value ?? <Medication>[];
    final plans = plansState.asData?.value ?? <MedicationPlan>[];
    final activePlans = <({Medication medication, MedicationPlan plan})>[];
    for (final medication in medications) {
      if (medication.archivedAt != null) continue;
      for (final plan in plans.where((p) => p.medicationId == medication.id)) {
        final begins = !DateUtils.dateOnly(plan.startDate).isAfter(today);
        final ends =
            plan.endDate == null ||
            !DateUtils.dateOnly(plan.endDate!).isBefore(today);
        if (begins && ends)
          activePlans.add((medication: medication, plan: plan));
      }
    }
    activePlans.sort((a, b) => a.medication.name.compareTo(b.medication.name));

    final visits = visitsState.asData?.value ?? <Visit>[];
    final latestVisit = visits.isEmpty
        ? null
        : (List<Visit>.from(
            visits,
          )..sort((a, b) => b.startDate.compareTo(a.startDate))).first;
    final hospitalNames = {
      for (final hospital in hospitalsState.asData?.value ?? <Hospital>[])
        hospital.id: hospital.name,
    };

    final indicators = <String, _HomeIndicator>{};
    final testMap = {
      for (final t in testsState.asData?.value ?? <LabTest>[]) t.id: t,
    };
    final categoryMap = {
      for (final c in categoriesState.asData?.value ?? <LabCategory>[])
        c.id: c.nameZh,
    };

    void addIndicator(
      String code,
      String name,
      String category,
      DateTime date,
      String value,
    ) {
      final cleanCode = code.trim().toUpperCase();
      final key = cleanCode.isNotEmpty
          ? 'code:$cleanCode'
          : 'name:${category.trim()}:${name.trim()}';
      final existing = indicators[key];
      if (existing == null || date.isAfter(existing.date)) {
        indicators[key] = _HomeIndicator(
          key: key,
          label: name,
          date: date,
          value: value,
        );
      }
    }

    for (final result in importedState.asData?.value ?? <ImportedLabResult>[]) {
      addIndicator(
        result.indicatorCode,
        result.indicatorNameCn,
        result.category,
        result.sampleDate,
        '${result.rawValue}${result.unit.trim().isEmpty ? '' : ' ${result.unit}'}',
      );
    }
    for (final result in manualState.asData?.value ?? <LabResult>[]) {
      final test = testMap[result.testId];
      if (test == null) continue;
      addIndicator(
        test.code,
        test.nameZh,
        categoryMap[test.categoryId] ?? '',
        result.measuredAt,
        '${result.valueNumeric}${result.unit.trim().isEmpty ? '' : ' ${result.unit}'}',
      );
    }
    final favorites =
        favoriteKeys
            .map((k) => indicators[k])
            .whereType<_HomeIndicator>()
            .toList()
          ..sort((a, b) => a.label.compareTo(b.label));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('我的健康', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('健康记录与日常管理', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 22),
        _sectionTitle(context, '当前用药'),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.medication_outlined),
                title: const Text('今日用药计划'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _open(const MedicationsPage()),
              ),
              if (medicationState.isLoading || plansState.isLoading)
                const LinearProgressIndicator()
              else if (medicationState.hasError || plansState.hasError)
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('用药记录暂时无法读取，请进入用药管理查看。'),
                  ),
                )
              else if (activePlans.isEmpty)
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('今天没有生效的服药方案。'),
                  ),
                )
              else
                for (final row in activePlans)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.medication.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${row.plan.dose} · ${row.plan.frequency}',
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _sectionTitle(context, '最近一次就诊'),
        Card(
          child: ListTile(
            leading: const Icon(Icons.local_hospital_outlined),
            title: Text(
              latestVisit == null
                  ? '暂无就诊记录'
                  : (hospitalNames[latestVisit.hospitalId] ?? '就诊记录'),
            ),
            subtitle: Text(
              latestVisit == null
                  ? '点击添加或查看就诊记录'
                  : '${DateFormat('yyyy-MM-dd').format(latestVisit.startDate)}'
                        '${latestVisit.department?.isNotEmpty == true ? ' · ${latestVisit.department}' : ''}'
                        '${latestVisit.reason?.isNotEmpty == true ? '\n${latestVisit.reason}' : ''}',
            ),
            isThreeLine: latestVisit?.reason?.isNotEmpty == true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(const VisitsPage()),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _sectionTitle(context, '关注的检查指标')),
            TextButton.icon(
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('选择指标'),
              onPressed: favoritesLoaded
                  ? () => _chooseFavorites(indicators)
                  : null,
            ),
          ],
        ),
        Card(
          child: !favoritesLoaded
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(),
                )
              : favorites.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('还没有关注的检查指标。点击右上角“选择指标”添加。'),
                )
              : Column(
                  children: [
                    for (final item in favorites)
                      ListTile(
                        title: Text(item.label),
                        subtitle: Text(
                          '最近检查：${DateFormat('yyyy-MM-dd').format(item.date)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item.value),
                            const SizedBox(width: 6),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => _open(_HomeIndicatorTrendPage(item: item)),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 14),
        _sectionTitle(context, '快捷操作'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.tonalIcon(
              icon: const Icon(Icons.edit_note_outlined),
              label: const Text('录入检查'),
              onPressed: () => _open(const LabFormPage()),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.event_note_outlined),
              label: const Text('就诊管理'),
              onPressed: () => _open(const VisitsPage()),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.medication_outlined),
              label: const Text('用药管理'),
              onPressed: () => _open(const MedicationsPage()),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          '首页仅展示已有记录，不提供诊断或调整用药建议。',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _HomeIndicatorTrendPage extends StatelessWidget {
  const _HomeIndicatorTrendPage({required this.item});
  final _HomeIndicator item;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(item.label)),
    body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '最近一次：${item.value} · ${DateFormat('yyyy-MM-dd').format(item.date)}',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: UnifiedTrendsPage(indicatorKey: item.key, embedded: true),
        ),
      ],
    ),
  );
}
