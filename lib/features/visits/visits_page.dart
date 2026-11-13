import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';
import '../hospitals/hospital_repository.dart';
import 'visit_repository.dart';

final visitRepositoryProvider = Provider<VisitRepository>(
  (ref) => VisitRepository(ref.watch(databaseProvider)),
);
final visitsProvider = StreamProvider<List<Visit>>(
  (ref) => ref.watch(visitRepositoryProvider).watchVisits(),
);
final visitHospitalsProvider = StreamProvider<List<Hospital>>(
  (ref) => HospitalRepository(ref.watch(databaseProvider)).watchHospitals(),
);

const _visitTypes = <String, String>{
  'outpatient': '门诊',
  'inpatient': '住院',
  'emergency': '急诊',
  'other': '其他',
};

String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

class VisitsPage extends ConsumerStatefulWidget {
  const VisitsPage({super.key, this.initialHospitalId});
  final String? initialHospitalId;

  @override
  ConsumerState<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends ConsumerState<VisitsPage> {
  String? hospitalFilter;
  String search = '';
  bool busy = false;

  @override
  void initState() {
    super.initState();
    hospitalFilter = widget.initialHospitalId;
  }

  void notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> editVisit(List<Hospital> hospitals, [Visit? original]) async {
    if (hospitals.isEmpty) {
      notify('请先在医院管理中添加一家医院');
      return;
    }
    final result = await showDialog<_VisitFormValues>(
      context: context,
      builder: (_) => _VisitDialog(
        hospitals: hospitals,
        original: original,
        initialHospitalId: original?.hospitalId ?? hospitalFilter,
      ),
    );
    if (result == null || !mounted) return;
    setState(() => busy = true);
    try {
      await ref
          .read(visitRepositoryProvider)
          .saveVisit(
            id: original?.id,
            hospitalId: result.hospitalId,
            visitType: result.visitType,
            startDate: result.startDate,
            endDate: result.endDate,
            department: result.department,
            doctor: result.doctor,
            reason: result.reason,
            diagnosis: result.diagnosis,
            notes: result.notes,
          );
      notify(original == null ? '就诊记录已新增' : '就诊记录已更新');
    } catch (e) {
      notify('保存失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> deleteVisit(Visit visit) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除就诊记录'),
        content: Text('确定删除 ${_formatDate(visit.startDate)} 的就诊记录吗？此操作无法撤销。'),
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
    if (yes != true || !mounted) return;
    setState(() => busy = true);
    try {
      await ref.read(visitRepositoryProvider).deleteVisit(visit.id);
      notify('就诊记录已删除');
    } catch (e) {
      notify('删除失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visits = ref.watch(visitsProvider);
    final hospitals = ref.watch(visitHospitalsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('医院与就诊管理')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            hospitals.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('医院读取失败：$e'),
              data: (items) {
                final ids = items.map((h) => h.id).toSet();
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        key: ValueKey(
                          'filter-${hospitalFilter ?? 'all'}-${items.length}',
                        ),
                        initialValue: ids.contains(hospitalFilter)
                            ? hospitalFilter
                            : null,
                        decoration: const InputDecoration(
                          labelText: '按医院筛选',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('全部医院'),
                          ),
                          for (final h in items)
                            DropdownMenuItem<String>(
                              value: h.id,
                              child: Text(
                                h.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (value) => setState(() {
                          hospitalFilter = value == '' ? null : value;
                        }),
                      ),
                    ),
                    SizedBox(
                      width: 280,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: '搜索科室、医生、诊断或备注',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => setState(() {
                          search = value.trim().toLowerCase();
                        }),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: busy ? null : () => editVisit(items),
                      icon: const Icon(Icons.add),
                      label: const Text('新增就诊'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            if (busy) const LinearProgressIndicator(),
            Expanded(
              child: visits.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => SelectableText('就诊记录读取失败：$e'),
                data: (rows) => hospitals.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('医院读取失败：$e'),
                  data: (items) {
                    final names = {for (final h in items) h.id: h.name};
                    final filtered = rows.where((v) {
                      if (hospitalFilter != null &&
                          v.hospitalId != hospitalFilter) {
                        return false;
                      }
                      final q =
                          '${v.department ?? ''} ${v.doctor ?? ''} '
                                  '${v.diagnosis ?? ''} ${v.reason ?? ''} ${v.notes ?? ''}'
                              .toLowerCase();
                      return q.contains(search);
                    }).toList();
                    if (filtered.isEmpty) {
                      return const Center(child: Text('暂无符合条件的就诊记录'));
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final v = filtered[index];
                        final type = _visitTypes[v.visitType] ?? v.visitType;
                        final period = v.endDate == null
                            ? _formatDate(v.startDate)
                            : '${_formatDate(v.startDate)} 至 ${_formatDate(v.endDate!)}';
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.event_note_outlined),
                            title: Text(
                              '${names[v.hospitalId] ?? '未知医院'} · $type',
                            ),
                            subtitle: Text(
                              [
                                period,
                                if (v.department?.isNotEmpty == true)
                                  '科室：${v.department}',
                                if (v.doctor?.isNotEmpty == true)
                                  '医生：${v.doctor}',
                                if (v.diagnosis?.isNotEmpty == true)
                                  '诊断：${v.diagnosis}',
                                if (v.reason?.isNotEmpty == true)
                                  '就诊原因：${v.reason}',
                                if (v.notes?.isNotEmpty == true)
                                  '备注：${v.notes}',
                              ].join('\n'),
                            ),
                            isThreeLine: true,
                            trailing: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                IconButton(
                                  tooltip: '编辑',
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: busy
                                      ? null
                                      : () => editVisit(items, v),
                                ),
                                IconButton(
                                  tooltip: '删除',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: busy ? null : () => deleteVisit(v),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitFormValues {
  const _VisitFormValues({
    required this.hospitalId,
    required this.visitType,
    required this.startDate,
    this.endDate,
    required this.department,
    required this.doctor,
    required this.reason,
    required this.diagnosis,
    required this.notes,
  });
  final String hospitalId;
  final String visitType;
  final DateTime startDate;
  final DateTime? endDate;
  final String department;
  final String doctor;
  final String reason;
  final String diagnosis;
  final String notes;
}

class _VisitDialog extends StatefulWidget {
  const _VisitDialog({
    required this.hospitals,
    this.original,
    this.initialHospitalId,
  });
  final List<Hospital> hospitals;
  final Visit? original;
  final String? initialHospitalId;
  @override
  State<_VisitDialog> createState() => _VisitDialogState();
}

class _VisitDialogState extends State<_VisitDialog> {
  late String hospitalId;
  late String visitType;
  late DateTime startDate;
  DateTime? endDate;
  late final TextEditingController department;
  late final TextEditingController doctor;
  late final TextEditingController reason;
  late final TextEditingController diagnosis;
  late final TextEditingController notes;

  @override
  void initState() {
    super.initState();
    final ids = widget.hospitals.map((h) => h.id).toSet();
    hospitalId = ids.contains(widget.initialHospitalId)
        ? widget.initialHospitalId!
        : widget.hospitals.first.id;
    visitType = widget.original?.visitType ?? 'outpatient';
    startDate = widget.original?.startDate ?? DateTime.now();
    endDate = widget.original?.endDate;
    department = TextEditingController(text: widget.original?.department ?? '');
    doctor = TextEditingController(text: widget.original?.doctor ?? '');
    reason = TextEditingController(text: widget.original?.reason ?? '');
    diagnosis = TextEditingController(text: widget.original?.diagnosis ?? '');
    notes = TextEditingController(text: widget.original?.notes ?? '');
  }

  @override
  void dispose() {
    department.dispose();
    doctor.dispose();
    reason.dispose();
    diagnosis.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> pickDate({required bool end}) async {
    final current = end ? (endDate ?? startDate) : startDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (end) {
        endDate = picked;
      } else {
        startDate = picked;
      }
    });
  }

  void save() {
    if (endDate != null && endDate!.isBefore(startDate)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('结束日期不能早于开始日期')));
      return;
    }
    Navigator.pop(
      context,
      _VisitFormValues(
        hospitalId: hospitalId,
        visitType: visitType,
        startDate: startDate,
        endDate: endDate,
        department: department.text,
        doctor: doctor.text,
        reason: reason.text,
        diagnosis: diagnosis.text,
        notes: notes.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.original == null ? '新增就诊' : '编辑就诊'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: hospitalId,
                decoration: const InputDecoration(
                  labelText: '医院',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                items: widget.hospitals
                    .map(
                      (h) => DropdownMenuItem<String>(
                        value: h.id,
                        child: Text(h.name, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => hospitalId = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: visitType,
                decoration: const InputDecoration(
                  labelText: '就诊类型',
                  border: OutlineInputBorder(),
                ),
                items: _visitTypes.entries
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => visitType = value);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text('开始日期：${_formatDate(startDate)}'),
                trailing: const Icon(Icons.calendar_month),
                onTap: () => pickDate(end: false),
              ),
              ListTile(
                title: Text(
                  endDate == null
                      ? '结束日期：未设置（门诊通常无需填写）'
                      : '结束日期：${_formatDate(endDate!)}',
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: () => pickDate(end: true),
              ),
              if (endDate != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => endDate = null),
                    child: const Text('清除结束日期'),
                  ),
                ),
              for (final pair in [
                (department, '科室'),
                (doctor, '医生'),
                (reason, '就诊原因'),
                (diagnosis, '诊断'),
                (notes, '备注'),
              ]) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: pair.$1,
                  maxLines: pair.$2 == '备注' ? 3 : 1,
                  decoration: InputDecoration(
                    labelText: pair.$2,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(onPressed: save, child: const Text('保存')),
      ],
    );
  }
}
