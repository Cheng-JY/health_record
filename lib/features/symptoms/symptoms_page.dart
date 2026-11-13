import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

class SymptomEntry {
  const SymptomEntry({
    required this.id,
    required this.symptom,
    required this.severity,
    required this.occurredAt,
    required this.notes,
  });
  final String id;
  final String symptom;
  final int severity;
  final DateTime occurredAt;
  final String notes;
}

final symptomsProvider = FutureProvider<List<SymptomEntry>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db
      .customSelect(
        'SELECT id, symptom, severity, occurred_at, notes '
        'FROM symptom_entries ORDER BY occurred_at DESC, created_at DESC',
      )
      .get();
  return [
    for (final row in rows)
      SymptomEntry(
        id: row.read<String>('id'),
        symptom: row.read<String>('symptom'),
        severity: row.read<int>('severity'),
        occurredAt: DateTime.parse(row.read<String>('occurred_at')),
        notes: row.readNullable<String>('notes') ?? '',
      ),
  ];
});

class SymptomsPage extends ConsumerStatefulWidget {
  const SymptomsPage({super.key, this.openEditor = false});
  final bool openEditor;

  @override
  ConsumerState<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends ConsumerState<SymptomsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.openEditor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _edit();
      });
    }
  }

  Future<void> _edit([SymptomEntry? original]) async {
    final symptomController = TextEditingController(
      text: original?.symptom ?? '',
    );
    final notesController = TextEditingController(text: original?.notes ?? '');
    var severity = original?.severity ?? 3;
    var occurred = original?.occurredAt ?? DateTime.now();
    try {
      final payload =
          await showDialog<
            ({String symptom, String notes, int severity, DateTime occurred})
          >(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setDialogState) => AlertDialog(
                title: Text(original == null ? '记录新症状' : '编辑症状'),
                content: SizedBox(
                  width: 450,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: symptomController,
                          autofocus: true,
                          maxLength: 100,
                          decoration: const InputDecoration(
                            labelText: '症状名称 *',
                            hintText: '例如：关节疼痛、疲劳、皮疹',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('严重程度：$severity / 10'),
                        Slider(
                          value: severity.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: '$severity',
                          onChanged: (v) =>
                              setDialogState(() => severity = v.round()),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.event),
                          label: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(occurred),
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              initialDate: occurred,
                            );
                            if (date == null || !context.mounted) return;
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(occurred),
                            );
                            if (time == null || !context.mounted) return;
                            setDialogState(() {
                              occurred = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: notesController,
                          maxLines: 3,
                          maxLength: 1000,
                          decoration: const InputDecoration(
                            labelText: '备注（可选）',
                            hintText: '持续多久、出现位置、诱因、伴随症状等',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: () {
                      final name = symptomController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请填写症状名称')),
                        );
                        return;
                      }
                      Navigator.pop(context, (
                        symptom: name,
                        severity: severity,
                        notes: notesController.text.trim(),
                        occurred: occurred,
                      ));
                    },
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          );
      if (payload == null || !mounted) return;
      final db = ref.read(databaseProvider);
      final now = DateTime.now().toIso8601String();
      if (original == null) {
        await db.customStatement(
          'INSERT INTO symptom_entries '
          '(id, symptom, severity, occurred_at, notes, created_at, updated_at) '
          'VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            const Uuid().v4(),
            payload.symptom,
            payload.severity,
            payload.occurred.toIso8601String(),
            payload.notes,
            now,
            now,
          ],
        );
      } else {
        await db.customStatement(
          'UPDATE symptom_entries SET symptom = ?, severity = ?, '
          'occurred_at = ?, notes = ?, updated_at = ? WHERE id = ?',
          [
            payload.symptom,
            payload.severity,
            payload.occurred.toIso8601String(),
            payload.notes,
            now,
            original.id,
          ],
        );
      }
      ref.invalidate(symptomsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('保存症状失败：$e')));
      }
    } finally {
      // DialogRoute exit animation may still be running; defer disposal safely.
      // Controllers are small; disposal on a later UI frame is sufficient.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        symptomController.dispose();
        notesController.dispose();
      });
    }
  }

  Future<void> _delete(SymptomEntry item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除症状记录？'),
        content: Text('确定删除“${item.symptom}”这条记录吗？'),
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
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(databaseProvider).customStatement(
        'DELETE FROM symptom_entries WHERE id = ?',
        [item.id],
      );
      ref.invalidate(symptomsProvider);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('删除失败：$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(symptomsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('症状记录')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('新增症状'),
      ),
      body: records.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('读取症状失败：$e')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('还没有症状记录，点击右下角开始添加。'))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  final item = items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.symptom),
                      subtitle: Text(
                        '${DateFormat('yyyy-MM-dd HH:mm').format(item.occurredAt)}'
                        ' · 严重程度 ${item.severity}/10'
                        '${item.notes.isEmpty ? '' : '\n${item.notes}'}',
                      ),
                      isThreeLine: item.notes.isNotEmpty,
                      onTap: () => _edit(item),
                      trailing: PopupMenuButton<String>(
                        tooltip: '操作',
                        onSelected: (value) {
                          if (value == 'edit') _edit(item);
                          if (value == 'delete') _delete(item);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('编辑')),
                          PopupMenuItem(value: 'delete', child: Text('删除')),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
