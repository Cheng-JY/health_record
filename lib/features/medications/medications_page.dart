import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';
import 'medication_repository.dart';

final medicationRepositoryProvider = Provider<MedicationRepository>(
  (ref) => MedicationRepository(ref.watch(databaseProvider)),
);
final medicationsProvider = StreamProvider<List<Medication>>(
  (ref) => ref.watch(medicationRepositoryProvider).watchMedications(),
);

String _date(DateTime? d) => d == null
    ? '持续中'
    : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

void _error(BuildContext context, Object error) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('操作失败：$error')));
}

class MedicationsPage extends ConsumerStatefulWidget {
  const MedicationsPage({super.key});

  @override
  ConsumerState<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends ConsumerState<MedicationsPage> {
  String search = '';
  bool showStopped = true;

  @override
  Widget build(BuildContext context) {
    final meds = ref.watch(medicationsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('用药管理')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openMedicationEditor(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('添加药物'),
      ),
      body: meds.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载药物失败：$e')),
        data: (all) {
          final filtered = all.where((m) {
            if (!showStopped && m.archivedAt != null) return false;
            final q = search.trim().toLowerCase();
            return q.isEmpty ||
                m.name.toLowerCase().contains(q) ||
                (m.purpose ?? '').toLowerCase().contains(q);
          }).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: '搜索药物名称或用途',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => search = value),
              ),
              SwitchListTile(
                title: const Text('显示已停用药物'),
                value: showStopped,
                onChanged: (v) => setState(() => showStopped = v),
              ),
              if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(child: Text('暂无药物记录，点击右下角添加')),
                ),
              for (final medication in filtered)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.medication_outlined),
                    title: Text(medication.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          [
                            medication.strength,
                            medication.form,
                          ].where((s) => s != null && s.isNotEmpty).join(' · '),
                        ),
                        if (medication.purpose != null)
                          Text('用途：${medication.purpose}'),
                        Text(
                          medication.archivedAt == null
                              ? '药物档案：未标记停用'
                              : '已停用（保留历史）',
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            MedicationDetailsPage(medication: medication),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

class MedicationDetailsPage extends ConsumerWidget {
  const MedicationDetailsPage({super.key, required this.medication});
  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(medicationRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(medication.name)),
      body: StreamBuilder<List<MedicationPlan>>(
        stream: repo.watchPlans(medication.id),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('读取方案失败：${snapshot.error}'));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final plans = snapshot.data!;
          final today = MedicationRepository.day(DateTime.now());
          MedicationPlan? todayPlan;
          for (final p in plans) {
            if (!MedicationRepository.day(p.startDate).isAfter(today) &&
                (p.endDate == null ||
                    !MedicationRepository.day(p.endDate!).isBefore(today))) {
              todayPlan = p;
              break;
            }
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('药物资料', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('名称：${medication.name}'),
              Text('规格：${medication.strength ?? '未填写'}'),
              Text('剂型：${medication.form ?? '未填写'}'),
              Text('用途：${medication.purpose ?? '未填写'}'),
              if (medication.notes != null) Text('备注：${medication.notes}'),
              const SizedBox(height: 16),
              Text('今天的服药方案', style: Theme.of(context).textTheme.titleLarge),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: todayPlan == null
                      ? const Text('今天没有生效的服药方案')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '剂量：${todayPlan.dose}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text('频率：${todayPlan.frequency}'),
                            Text('服用时间：${todayPlan.times ?? '未填写'}'),
                            if (todayPlan.instructions != null)
                              Text('说明：${todayPlan.instructions}'),
                          ],
                        ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (medication.archivedAt == null)
                    FilledButton.icon(
                      onPressed: () =>
                          _openPlanEditor(context, repo, medication.id, plans),
                      icon: const Icon(Icons.edit_calendar_outlined),
                      label: const Text('调整剂量 / 时间'),
                    ),
                  if (medication.archivedAt == null)
                    OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date == null || !context.mounted) return;
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('确认停药记录'),
                            content: Text(
                              '将用药方案结束日期记为 ${_date(date)}。历史剂量保留。\n请注意，这只是记录操作，不是停药建议。',
                            ),
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
                        if (confirmed != true) return;
                        try {
                          await repo.stopMedication(medication.id, date);
                          if (context.mounted) Navigator.of(context).pop();
                        } catch (e) {
                          if (context.mounted) _error(context, e);
                        }
                      },
                      icon: const Icon(Icons.stop_circle_outlined),
                      label: const Text('记录停药'),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                '剂量与服药时间变更历史',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              for (final p in plans)
                Card(
                  child: ListTile(
                    title: Text('${p.dose} · ${p.frequency}'),
                    subtitle: Text(
                      [
                        '${_date(p.startDate)} 至 ${_date(p.endDate)}',
                        '时间：${p.times ?? '未填写'}',
                        if (p.changeReason != null) '调整原因：${p.changeReason}',
                        if (p.instructions != null) '说明：${p.instructions}',
                      ].join('\n'),
                    ),
                    isThreeLine: true,
                  ),
                ),
              const SizedBox(height: 60),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _openMedicationEditor(BuildContext context, WidgetRef ref) async {
  final repo = ref.read(medicationRepositoryProvider);
  final name = TextEditingController();
  final strength = TextEditingController();
  final form = TextEditingController();
  final purpose = TextEditingController();
  final dose = TextEditingController();
  final frequency = TextEditingController(text: '每日');
  final times = TextEditingController(text: '08:00');
  final instructions = TextEditingController();
  DateTime start = DateTime.now();
  bool working = false;
  try {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text('添加药物和初始服药方案'),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(labelText: '药物名称 *'),
                    ),
                    TextField(
                      controller: strength,
                      decoration: const InputDecoration(
                        labelText: '规格（例如 500 mg/片）',
                      ),
                    ),
                    TextField(
                      controller: form,
                      decoration: const InputDecoration(labelText: '剂型（例如 片剂）'),
                    ),
                    TextField(
                      controller: purpose,
                      decoration: const InputDecoration(labelText: '用途／适应证'),
                    ),
                    TextField(
                      controller: dose,
                      decoration: const InputDecoration(
                        labelText: '每次剂量 *（例如 2片）',
                      ),
                    ),
                    TextField(
                      controller: frequency,
                      decoration: const InputDecoration(
                        labelText: '服药频率 *（例如 每日）',
                      ),
                    ),
                    TextField(
                      controller: times,
                      decoration: const InputDecoration(
                        labelText: '时间（例如 08:00,20:00）',
                      ),
                    ),
                    TextField(
                      controller: instructions,
                      decoration: const InputDecoration(labelText: '说明（如随餐）'),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text('开始日期：${_date(start)}'),
                      onPressed: working
                          ? null
                          : () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: start,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null)
                                setDialogState(() => start = picked);
                            },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: working ? null : () => Navigator.pop(ctx),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: working
                    ? null
                    : () async {
                        setDialogState(() => working = true);
                        try {
                          await repo.addMedication(
                            name: name.text,
                            strength: strength.text,
                            form: form.text,
                            purpose: purpose.text,
                            dose: dose.text,
                            frequency: frequency.text,
                            times: times.text,
                            startDate: start,
                            instructions: instructions.text,
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                        } catch (e) {
                          if (ctx.mounted) _error(ctx, e);
                        } finally {
                          if (ctx.mounted)
                            setDialogState(() => working = false);
                        }
                      },
                child: const Text('保存'),
              ),
            ],
          );
        },
      ),
    );
  } finally {
    name.dispose();
    strength.dispose();
    form.dispose();
    purpose.dispose();
    dose.dispose();
    frequency.dispose();
    times.dispose();
    instructions.dispose();
  }
}

Future<void> _openPlanEditor(
  BuildContext context,
  MedicationRepository repo,
  String medicationId,
  List<MedicationPlan> plans,
) async {
  final previous = plans.isNotEmpty ? plans.first : null;
  final dose = TextEditingController(text: previous?.dose ?? '');
  final frequency = TextEditingController(text: previous?.frequency ?? '每日');
  final times = TextEditingController(text: previous?.times ?? '');
  final reason = TextEditingController();
  final instructions = TextEditingController(
    text: previous?.instructions ?? '',
  );
  DateTime start = DateTime.now();
  if (previous != null && !start.isAfter(previous.startDate)) {
    start = previous.startDate.add(const Duration(days: 1));
  }
  bool working = false;
  try {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('记录新的服药方案'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('新方案会保留之前的剂量历史，不会覆盖旧记录。'),
                  TextField(
                    controller: dose,
                    decoration: const InputDecoration(labelText: '新剂量 *'),
                  ),
                  TextField(
                    controller: frequency,
                    decoration: const InputDecoration(labelText: '服药频率 *'),
                  ),
                  TextField(
                    controller: times,
                    decoration: const InputDecoration(
                      labelText: '时间（例如 08:00,20:00）',
                    ),
                  ),
                  TextField(
                    controller: reason,
                    decoration: const InputDecoration(labelText: '调整原因（可选）'),
                  ),
                  TextField(
                    controller: instructions,
                    decoration: const InputDecoration(labelText: '其他说明（可选）'),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text('新方案起始日期：${_date(start)}'),
                    onPressed: working
                        ? null
                        : () async {
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate: start,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null)
                              setDialogState(() => start = picked);
                          },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: working ? null : () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: working
                  ? null
                  : () async {
                      setDialogState(() => working = true);
                      try {
                        await repo.changePlan(
                          medicationId: medicationId,
                          dose: dose.text,
                          frequency: frequency.text,
                          times: times.text,
                          startDate: start,
                          changeReason: reason.text,
                          instructions: instructions.text,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        if (ctx.mounted) _error(ctx, e);
                      } finally {
                        if (ctx.mounted) setDialogState(() => working = false);
                      }
                    },
              child: const Text('保存调整'),
            ),
          ],
        ),
      ),
    );
  } finally {
    dose.dispose();
    frequency.dispose();
    times.dispose();
    reason.dispose();
    instructions.dispose();
  }
}
