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

const _doseUnitOptions = <String>['mg', 'g', 'µg', 'mL', 'IU', '单位'];

const _dailyFrequencyOptions = <String>[
  '每日1次',
  '每日2次',
  '每日3次',
  '每日4次',
  '每日5次',
  '每日6次',
];

// 对旧记录进行兼容：只对能识别的剂量与单位拆分；不转换旧的“片/粒”记录。
({String amount, String unit}) _splitDose(String? stored) {
  final value = (stored ?? '').trim();
  final match = RegExp(
    r'^([0-9]+(?:[.,][0-9]+)?)\s*(mg|g|µg|μg|mcg|mL|ml|IU|单位)$',
    caseSensitive: false,
  ).firstMatch(value);
  if (match == null) return (amount: '', unit: 'mg');
  final rawUnit = match.group(2)!;
  final normalizedUnit = rawUnit.toLowerCase() == 'mcg' || rawUnit == 'μg'
      ? 'µg'
      : rawUnit.toLowerCase() == 'ml'
      ? 'mL'
      : rawUnit.toLowerCase() == 'iu'
      ? 'IU'
      : rawUnit.toLowerCase() == 'mg'
      ? 'mg'
      : rawUnit.toLowerCase() == 'g'
      ? 'g'
      : rawUnit;
  return (amount: match.group(1)!.replaceAll(',', '.'), unit: normalizedUnit);
}

String _validatedDose(String input, String unit) {
  final number = double.tryParse(input.trim().replaceAll(',', '.'));
  if (number == null || !number.isFinite || number <= 0) {
    throw ArgumentError('每次剂量必须是大于 0 的有效数字');
  }
  if (!_doseUnitOptions.contains(unit)) throw ArgumentError('请选择正确的剂量单位');
  return '${input.trim().replaceAll(',', '.')} $unit';
}

String _date(DateTime? d) => d == null
    ? '持续中'
    : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

void _error(BuildContext context, Object error) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('操作失败：$error')));
}

/// Wait until the dialog route has fully left the widget tree before callers
/// dispose their TextEditingControllers. Prevents teardown during exit animation.
Future<T?> _showEditorDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<T>(context: context, builder: builder);
  final result = await navigator.push<T>(route);
  await route.completed;
  return result;
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
    final currentMedication = ref.watch(medicationsProvider).asData?.value
            .where((m) => m.id == medication.id)
            .firstOrNull ??
        medication;
    return Scaffold(
      appBar: AppBar(title: Text(currentMedication.name)),
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
              Row(
                children: [
                  Expanded(
                    child: Text('药物资料',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _openMedicationDetailsEditor(
                      context,
                      repo,
                      currentMedication,
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('编辑资料'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('名称：${currentMedication.name}'),
              Text('用途：${currentMedication.purpose ?? '未填写'}'),
              if (currentMedication.notes != null) Text('备注：${currentMedication.notes}'),
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
                              '每次剂量：${todayPlan.dose}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text('每日服用次数：${todayPlan.frequency}'),
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
                  if (currentMedication.archivedAt == null)
                    FilledButton.icon(
                      onPressed: () =>
                          _openPlanEditor(context, repo, medication.id, plans),
                      icon: const Icon(Icons.edit_calendar_outlined),
                      label: const Text('调整每次剂量 / 频率'),
                    ),
                  if (currentMedication.archivedAt == null)
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
                '每次剂量与服用次数变更历史',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              for (final p in ([
                ...plans,
              ]..sort((a, b) => b.startDate.compareTo(a.startDate))))
                Card(
                  child: ListTile(
                    title: Text('每次 ${p.dose} · ${p.frequency}'),
                    subtitle: Text(
                      [
                        '${_date(p.startDate)} 至 ${_date(p.endDate)}',
                        if (p.changeReason != null) '调整原因：${p.changeReason}',
                        if (p.instructions != null) '说明：${p.instructions}',
                      ].join('\n'),
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      tooltip: '管理历史方案',
                      onSelected: (action) async {
                        if (action == 'edit') {
                          await _editHistoryPlan(context, repo, p);
                        } else if (action == 'delete') {
                          await _deleteHistoryPlan(context, repo, p, plans.length);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text('编辑历史'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('删除历史'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
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

// Edits a single historical plan rather than creating an additional plan.
Future<void> _editHistoryPlan(
  BuildContext context,
  MedicationRepository repo,
  MedicationPlan plan,
) async {
  final old = _splitDose(plan.dose);
  final dose = TextEditingController(text: old.amount);
  final reason = TextEditingController(text: plan.changeReason ?? '');
  final instructions = TextEditingController(text: plan.instructions ?? '');
  String unit = old.unit;
  String frequency = _dailyFrequencyOptions.contains(plan.frequency)
      ? plan.frequency
      : '每日1次';
  DateTime start = MedicationRepository.day(plan.startDate);
  DateTime? end = plan.endDate == null
      ? null
      : MedicationRepository.day(plan.endDate!);
  bool working = false;
  try {
    await _showEditorDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('编辑用药历史'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('可调整这一阶段的起止日期。结束日期留空时会自动衔接下一阶段；已有前一段持续中方案也会自动截止。'),
                  if (old.amount.isEmpty)
                    Text('原始剂量“${plan.dose}”无法自动拆分，请根据原记录重新填写。'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dose,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: '每次总剂量 *'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 115,
                        child: DropdownButtonFormField<String>(
                          initialValue: unit,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: '单位'),
                          items: _doseUnitOptions
                              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                              .toList(),
                          onChanged: working ? null : (v) {
                            if (v != null) setDialogState(() => unit = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: frequency,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: '每日服用次数'),
                    items: _dailyFrequencyOptions
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: working ? null : (v) {
                      if (v != null) setDialogState(() => frequency = v);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: working ? null : () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: start,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (!ctx.mounted) return;
                      if (picked != null) setDialogState(() => start = picked);
                    },
                    icon: const Icon(Icons.event_outlined),
                    label: Text('开始日期：${_date(start)}'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: working ? null : () async {
                            final suggested = end != null && !end!.isBefore(start)
                                ? end!
                                : start;
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate: suggested,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (!ctx.mounted) return;
                            if (picked != null) setDialogState(() => end = picked);
                          },
                          icon: const Icon(Icons.event_available_outlined),
                          label: Text('结束日期：${_date(end)}'),
                        ),
                      ),
                      if (end != null)
                        IconButton(
                          tooltip: '设为持续中',
                          onPressed: working ? null : () => setDialogState(() => end = null),
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  ),
                  TextField(
                    controller: reason,
                    decoration: const InputDecoration(labelText: '调整原因（可选）'),
                  ),
                  TextField(
                    controller: instructions,
                    decoration: const InputDecoration(labelText: '说明（可选）'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: working ? null : () => Navigator.of(ctx).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: working ? null : () async {
                setDialogState(() => working = true);
                try {
                  await repo.updatePlan(
                    planId: plan.id,
                    medicationId: plan.medicationId,
                    dose: _validatedDose(dose.text, unit),
                    frequency: frequency,
                    startDate: start,
                    endDate: end,
                    changeReason: reason.text,
                    instructions: instructions.text,
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                } catch (e) {
                  if (ctx.mounted) _error(ctx, e);
                } finally {
                  if (ctx.mounted && ModalRoute.of(ctx)?.isCurrent == true) {
                    setDialogState(() => working = false);
                  }
                }
              },
              child: const Text('保存修改'),
            ),
          ],
        ),
      ),
    );
  } finally {
    dose.dispose();
    reason.dispose();
    instructions.dispose();
  }
}

Future<void> _deleteHistoryPlan(
  BuildContext context,
  MedicationRepository repo,
  MedicationPlan plan,
  int planCount,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('删除这条用药历史？'),
      content: Text(
        '将删除 ${_date(plan.startDate)} 起的方案：每次 ${plan.dose}，${plan.frequency}。\n\n'
        '删除后不会自动修改其他方案的日期或剂量，可能使部分日期没有服药方案。此操作无法在 App 中撤销。'
        '${planCount <= 1 ? "\n\n这是唯一的方案，不允许删除。" : ""}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: planCount <= 1 ? null : () => Navigator.pop(ctx, true),
          child: const Text('确认删除'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  try {
    await repo.deletePlan(planId: plan.id, medicationId: plan.medicationId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('历史记录已删除；请检查剩余方案的日期是否连续')),
      );
    }
  } catch (e) {
    if (context.mounted) _error(context, e);
  }
}

Future<void> _openMedicationEditor(BuildContext context, WidgetRef ref) async {
  final repo = ref.read(medicationRepositoryProvider);
  final name = TextEditingController();
  final purpose = TextEditingController();
  final dose = TextEditingController();
  String unit = 'mg';
  String frequency = '每日1次';
  final instructions = TextEditingController();
  DateTime start = DateTime.now();
  bool working = false;
  try {
    await _showEditorDialog<void>(
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
                      controller: purpose,
                      decoration: const InputDecoration(labelText: '用途／适应证'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: dose,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: '每次总剂量 *',
                              hintText: '例如 500',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 115,
                          child: DropdownButtonFormField<String>(
                            initialValue: unit,
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: '单位'),
                            items: _doseUnitOptions
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                            onChanged: working
                                ? null
                                : (v) {
                                    if (v != null)
                                      setDialogState(() => unit = v);
                                  },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: frequency,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: '每日服用次数'),
                      items: _dailyFrequencyOptions
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: working
                          ? null
                          : (value) {
                              if (value != null)
                                setDialogState(() => frequency = value);
                            },
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
                              if (!ctx.mounted) {
                                return;
                              }
                              if (picked != null) {
                                setDialogState(() {
                                  start = picked;
                                });
                              }
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
                            purpose: purpose.text,
                            dose: _validatedDose(dose.text, unit),
                            frequency: frequency,
                            startDate: start,
                            instructions: instructions.text,
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                        } catch (e) {
                          if (ctx.mounted) _error(ctx, e);
                        } finally {
                          if (ctx.mounted && ModalRoute.of(ctx)?.isCurrent == true) {
                            setDialogState(() => working = false);
                          }
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
    purpose.dispose();
    dose.dispose();
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
  final previousDose = _splitDose(previous?.dose);
  final dose = TextEditingController(text: previousDose.amount);
  String unit = previousDose.unit;
  String frequency = _dailyFrequencyOptions.contains(previous?.frequency)
      ? previous!.frequency
      : '每日1次';
  final reason = TextEditingController();
  final instructions = TextEditingController(
    text: previous?.instructions ?? '',
  );
  DateTime start = MedicationRepository.day(DateTime.now());
  DateTime? end;
  bool working = false;
  try {
    await _showEditorDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('新增历史或未来服药方案'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('可选择过去或未来的任意日期；前一段持续中方案会自动截止到新方案开始前一天。其他日期重叠会阻止保存。'),
                  if (previous != null &&
                      previous.dose.trim().isNotEmpty &&
                      previousDose.amount.isEmpty)
                    Text('上一方案为“${previous.dose}”，无法自动换算为质量/体积单位，请按实际处方重新填写。'),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dose,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: '新的每次总剂量 *',
                            hintText: '例如 500',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 115,
                        child: DropdownButtonFormField<String>(
                          initialValue: unit,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: '单位'),
                          items: _doseUnitOptions
                              .map(
                                (v) =>
                                    DropdownMenuItem(value: v, child: Text(v)),
                              )
                              .toList(),
                          onChanged: working
                              ? null
                              : (v) {
                                  if (v != null) setDialogState(() => unit = v);
                                },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: frequency,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: '每日服用次数'),
                    items: _dailyFrequencyOptions
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: working
                        ? null
                        : (value) {
                            if (value != null)
                              setDialogState(() => frequency = value);
                          },
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
                            if (!ctx.mounted) {
                              return;
                            }
                            if (picked != null) {
                              setDialogState(() => start = picked);
                            }
                          },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.event_outlined),
                    label: Text(end == null
                        ? '结束日期：持续中'
                        : '结束日期：${_date(end)}'),
                    onPressed: working
                        ? null
                        : () async {
                            final initial = end != null &&
                                    !end!.isBefore(start)
                                ? end!
                                : start;
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate: initial,
                              firstDate: start,
                              lastDate: DateTime(2100),
                            );
                            if (!ctx.mounted) return;
                            if (picked != null) {
                              setDialogState(() => end = picked);
                            }
                          },
                  ),
                  if (end != null)
                    TextButton(
                      onPressed: working
                          ? null
                          : () => setDialogState(() => end = null),
                      child: const Text('清除结束日期（持续中）'),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '未填写结束日期时，如果已有下一阶段，将自动截止到下一阶段开始前一天。'
                      '新增较晚方案时，前一段未填写结束日期的方案也会自动截止。'
                      '其他日期重叠会阻止保存。',
                    ),
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
                          dose: _validatedDose(dose.text, unit),
                          frequency: frequency,
                          startDate: start,
                          endDate: end,
                          changeReason: reason.text,
                          instructions: instructions.text,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        if (ctx.mounted) _error(ctx, e);
                      } finally {
                        if (ctx.mounted && ModalRoute.of(ctx)?.isCurrent == true) {
                    setDialogState(() => working = false);
                  }
                      }
                    },
              child: const Text('保存新方案'),
            ),
          ],
        ),
      ),
    );
  } finally {
    dose.dispose();
    reason.dispose();
    instructions.dispose();
  }
}

/// Edit the medication catalog entry without changing historical dose records.
Future<void> _openMedicationDetailsEditor(
  BuildContext context,
  MedicationRepository repo,
  Medication medication,
) async {
  final name = TextEditingController(text: medication.name);
  final purpose = TextEditingController(text: medication.purpose ?? '');
  final notes = TextEditingController(text: medication.notes ?? '');
  try {
    final result = await _showEditorDialog<({String name, String purpose, String notes})>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('编辑药物资料'),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: '药物名称 *'),
                ),
                TextField(
                  controller: purpose,
                  decoration: const InputDecoration(labelText: '用途／适应证'),
                ),
                TextField(
                  controller: notes,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '备注'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty) {
                _error(ctx, '药物名称不能为空');
                return;
              }
              Navigator.of(ctx).pop((
                name: name.text.trim(),
                purpose: purpose.text.trim(),
                notes: notes.text.trim(),
              ));
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result == null) return;
    await repo.updateMedication(
      medication: medication,
      name: result.name,
      purpose: result.purpose,
      notes: result.notes,
      strength: medication.strength,
      form: medication.form,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('药物资料已更新')),
      );
    }
  } catch (e) {
    if (context.mounted) _error(context, e);
  } finally {
    name.dispose();
    purpose.dispose();
    notes.dispose();
  }
}
