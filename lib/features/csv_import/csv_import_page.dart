import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../core/database/app_database.dart';
import 'csv_import_service.dart';

final importedProvider = StreamProvider<List<ImportedLabResult>>(
  (ref) => ref.watch(databaseProvider).watchImportedResults(),
);

class CsvImportPage extends ConsumerStatefulWidget {
  const CsvImportPage({super.key});
  @override
  ConsumerState<CsvImportPage> createState() => _CsvImportPageState();
}

class _CsvImportPageState extends ConsumerState<CsvImportPage> {
  CsvPreview? preview;
  String? fileName;
  bool busy = false;
  String? message;

  
  Future<void> choose() async {
    setState(() {
      busy = true;
      message = null;
    });

    try {
      // 1. 选择一个 CSV 文件
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // 用户取消文件选择
      if (file == null) {
        return;
      }

      // 2. 读取文件内容
      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        throw StateError('CSV 文件为空');
      }

      // 3. 解析 CSV
      final parsed = CsvImportService(
        ref.read(databaseProvider),
      ).parse(bytes);

      // 4. 检查 Widget 是否仍然存在
      if (!mounted) {
        return;
      }

      // 5. 更新预览界面
      setState(() {
        preview = parsed;
        fileName = file.name;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          message = '读取失败：$e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          busy = false;
        });
      }
    }
  }


  Future<void> save() async {
    final p = preview;
    if (p == null || p.rows.isEmpty || fileName == null) return;
    if (p.errors.isNotEmpty) {
      setState(() => message = '有错误行，暂不允许导入。请修正 CSV 后重新选择文件。');
      return;
    }
    setState(() {busy = true; message = null;});
    try {
      final outcome = await CsvImportService(ref.read(databaseProvider)).importRows(p.rows, fileName!);
      if (!mounted) return;
      setState(() {
        message = '导入成功：新增 ${outcome.added} 条，跳过重复 ${outcome.skipped} 条。';
        preview = null;
      });
    } catch (e) {
      if (mounted) setState(() => message = '导入失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imported = ref.watch(importedProvider);
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('CSV 检查报告导入', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 8),
      const Text('支持当前 lab_results_cumulative.csv 的 9 列结构；结果原文完整保存。'),
      const SizedBox(height: 12),
      Wrap(spacing: 10, children: [
        FilledButton.icon(onPressed: busy ? null : choose, icon: const Icon(Icons.folder_open), label: const Text('选择 CSV')),
        FilledButton.icon(onPressed: busy || preview == null || preview!.rows.isEmpty || preview!.errors.isNotEmpty ? null : save,
          icon: const Icon(Icons.save), label: const Text('确认导入')),
      ]),
      if (busy) const LinearProgressIndicator(),
      if (message != null) Padding(padding: const EdgeInsets.all(8), child: SelectableText(message!)),
      if (preview != null) ...[
        const SizedBox(height: 14),
        Text('文件：$fileName · 合格 ${preview!.rows.length} 行 · 错误 ${preview!.errors.length} 行'),
        if (preview!.errors.isNotEmpty) ...[
          for (final e in preview!.errors.take(20)) Text(e, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 8),
        const Text('预览（前 30 行）'),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(columns: const [
          DataColumn(label: Text('采样时间')), DataColumn(label: Text('代码')), DataColumn(label: Text('指标')),
          DataColumn(label: Text('结果')), DataColumn(label: Text('单位')), DataColumn(label: Text('参考范围')),
        ], rows: [for (final r in preview!.rows.take(30)) DataRow(cells: [
          DataCell(Text(r.values['sample_date']!)), DataCell(Text(r.code)), DataCell(Text(r.name)),
          DataCell(Text(r.rawValue)), DataCell(Text(r.values['unit']!)),
          DataCell(Text(r.values['reference_range']!)),
        ])])),
      ],
      const Divider(height: 32),
      imported.when(
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('数据库查询失败：$e'),
        data: (items) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('已导入记录：${items.length} 条', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final row in items.take(100)) ListTile(
            dense: true,
            title: Text('${row.indicatorNameCn} (${row.indicatorCode}) · ${row.rawValue} ${row.unit}'),
            subtitle: Text('${row.sampleDateRaw} · ${row.category} · ${row.referenceRange}'),
          ),
          if (items.length > 100) Text('仅显示最新 100 条，共 ${items.length} 条。'),
        ]),
      ),
    ]);
  }
}
