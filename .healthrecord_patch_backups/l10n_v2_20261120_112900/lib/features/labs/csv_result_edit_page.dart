import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';

class CsvResultEditPage extends ConsumerStatefulWidget {
  const CsvResultEditPage({super.key, required this.result});
  final ImportedLabResult result;

  @override
  ConsumerState<CsvResultEditPage> createState() => _CsvResultEditPageState();
}

class _CsvResultEditPageState extends ConsumerState<CsvResultEditPage> {
  late final TextEditingController date;
  late final TextEditingController value;
  late final TextEditingController unit;
  late final TextEditingController reference;
  late final TextEditingController note;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final r = widget.result;
    date = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(r.sampleDate),
    );
    value = TextEditingController(text: r.rawValue);
    unit = TextEditingController(text: r.unit);
    reference = TextEditingController(text: r.referenceRange);
    note = TextEditingController(text: r.note ?? '');
  }

  @override
  void dispose() {
    date.dispose();
    value.dispose();
    unit.dispose();
    reference.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final selectedDate = DateTime.tryParse(
      date.text.trim().replaceFirst(' ', 'T'),
    );
    if (selectedDate == null || value.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写有效日期（yyyy-MM-dd HH:mm）和结果')),
      );
      return;
    }
    setState(() => saving = true);
    try {
      await ref
          .read(databaseProvider)
          .editImportedResult(
            original: widget.result,
            sampleDate: selectedDate,
            rawValue: value.text,
            unit: unit.text,
            referenceRange: reference.text,
            note: note.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('保存失败：$error')));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    return Scaffold(
      appBar: AppBar(title: const Text('修改 CSV 检查结果')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${r.indicatorNameCn} (${r.indicatorCode})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('来源：${r.fileName}  ·  报告：${r.reportId}'),
          const SizedBox(height: 16),
          TextField(
            controller: date,
            decoration: const InputDecoration(
              labelText: '采样时间',
              hintText: '2026-10-21 09:30',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: value,
            decoration: const InputDecoration(
              labelText: '结果（数字、阳性、阴性或滴度）',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: unit,
            decoration: const InputDecoration(
              labelText: '单位',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: reference,
            decoration: const InputDecoration(
              labelText: '参考范围',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: note,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '修改备注',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('首次修改会保存原始 CSV 字段快照。修改仅影响数据库，不会改动 CSV 文件。'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: saving ? null : save,
            child: Text(saving ? '保存中…' : '保存修改'),
          ),
        ],
      ),
    );
  }
}
