import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';
import '../hospitals/hospital_repository.dart';
import '../labs/lab_pages.dart';
import '../medications/medications_page.dart';
import '../visits/visits_page.dart';
import '../symptoms/symptoms_page.dart';

/// Only reads medication plans. Does not change medication history.
final _homePlansProvider = StreamProvider<List<MedicationPlan>>(
  (ref) => ref
      .watch(databaseProvider)
      .select(ref.watch(databaseProvider).medicationPlans)
      .watch(),
);

class HealthDashboardPage extends ConsumerStatefulWidget {
  const HealthDashboardPage({super.key});

  @override
  ConsumerState<HealthDashboardPage> createState() =>
      _HealthDashboardPageState();
}

class _HealthDashboardPageState extends ConsumerState<HealthDashboardPage> {
  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final medicationState = ref.watch(medicationsProvider);
    final plansState = ref.watch(_homePlansProvider);
    final visitsState = ref.watch(visitsProvider);
    final hospitalsState = ref.watch(visitHospitalsProvider);
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('我的健康', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('健康记录与日常管理', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
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
            OutlinedButton.icon(
              icon: const Icon(Icons.healing_outlined),
              label: const Text('症状记录'),
              onPressed: () => _open(const SymptomsPage()),
            ),
          ],
        ),
        const SizedBox(height: 20),
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
        _sectionTitle(context, '症状记录'),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.healing_outlined),
                title: const Text('我的症状日记'),
                subtitle: const Text('记录症状、发生时间、严重程度与备注'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _open(const SymptomsPage()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonalIcon(
                    onPressed: () =>
                        _open(const SymptomsPage(openEditor: true)),
                    icon: const Icon(Icons.add),
                    label: const Text('记录新症状'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
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
