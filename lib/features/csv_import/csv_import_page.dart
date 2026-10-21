
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../core/database/app_database.dart';
import 'csv_import_service.dart';

// 监听已导入的 CSV 检查记录
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

  // ========================================
  // 1. 选择并解析 CSV
  // ========================================

  Future<void> choose() async {
    setState(() {
      busy = true;
      message = null;
    });

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (file == null) {
        return;
      }

      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        throw StateError('CSV 文件为空');
      }

      final parsed = CsvImportService(
        ref.read(databaseProvider),
      ).parse(bytes);

      debugPrint(
        'CSV valid rows: ${parsed.rows.length}',
      );

      debugPrint(
        'CSV errors: ${parsed.errors.length}',
      );

      if (!mounted) return;

      setState(() {
        preview = parsed;
        fileName = file.name;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        message = '读取失败：$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          busy = false;
        });
      }
    }
  }

  // ========================================
  // 2. 保存 CSV 到 SQLite
  // ========================================

  Future<void> save() async {
    final p = preview;

    if (p == null ||
        p.rows.isEmpty ||
        fileName == null) {
      return;
    }

    if (p.errors.isNotEmpty) {
      setState(() {
        message = '存在错误行，请修正 CSV 后重新导入。';
      });
      return;
    }

    setState(() {
      busy = true;
      message = null;
    });

    try {
      final outcome = await CsvImportService(
        ref.read(databaseProvider),
      ).importRows(p.rows, fileName!);

      if (!mounted) return;

      setState(() {
        message =
            '导入完成：新增 ${outcome.added} 条，'
            '跳过重复 ${outcome.skipped} 条。';

        preview = null;
        fileName = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        message = '导入失败：$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          busy = false;
        });
      }
    }
  }

  // ========================================
  // 3. 检查并清理历史重复记录
  // ========================================

  Future<void> cleanupDuplicates() async {
    if (busy) return;

    setState(() {
      busy = true;
      message = null;
    });

    try {
      final db = ref.read(databaseProvider);

      // 获取重复记录数量
      final duplicateCount =
          await db.countDuplicateImportedResults();

      if (!mounted) return;

      if (duplicateCount == 0) {
        setState(() {
          message = '检查完成：没有发现重复记录。';
        });
        return;
      }

      // 清理前要求用户确认
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('清理重复检查记录'),
            content: Text(
              '发现 $duplicateCount 条重复记录。\n\n'
              '判断条件：\n'
              '• 采样时间相同\n'
              '• 检查指标相同\n'
              '• 检查结果相同\n'
              '• 单位相同\n\n'
              '系统将保留每组最早导入的记录，'
              '其余记录进行软删除。\n\n'
              '是否继续？',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: const Text('确认清理'),
              ),
            ],
          );
        },
      );

      if (confirmed != true || !mounted) {
        return;
      }

      // 在数据库事务中进行清理
      final removed =
          await db.cleanupDuplicateImportedResults();

      if (!mounted) return;

      setState(() {
        message = '清理完成：已软删除 $removed 条重复记录。';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '已清理 $removed 条重复记录',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        message = '清理失败：$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          busy = false;
        });
      }
    }
  }

  // ========================================
  // 4. 页面 UI
  // ========================================

  @override
  Widget build(BuildContext context) {
    final imported = ref.watch(importedProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'CSV 检查报告导入',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 8),

        const Text(
          '支持 lab_results_cumulative.csv 的 9 列结构。'
          '导入后自动保存至本地数据库。',
        ),

        const SizedBox(height: 20),

        // ----------------------------
        // CSV 导入操作
        // ----------------------------

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: busy ? null : choose,
              icon: const Icon(Icons.folder_open),
              label: const Text('选择 CSV'),
            ),

            FilledButton.icon(
              onPressed: busy ||
                      preview == null ||
                      preview!.rows.isEmpty ||
                      preview!.errors.isNotEmpty
                  ? null
                  : save,
              icon: const Icon(Icons.save),
              label: const Text('确认导入'),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ----------------------------
        // 重复记录管理
        // ----------------------------

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '重复记录管理',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 8),

                const Text(
                  '根据采样时间、检查指标、结果和单位'
                  '识别历史重复记录。'
                  '不同 CSV 文件中的重复记录也会被识别。',
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed:
                      busy ? null : cleanupDuplicates,
                  icon: const Icon(
                    Icons.cleaning_services_outlined,
                  ),
                  label: const Text('检查并清理重复记录'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ----------------------------
        // 加载状态与提示
        // ----------------------------

        if (busy)
          const LinearProgressIndicator(),

        if (message != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: SelectableText(message!),
          ),

        // ----------------------------
        // CSV 预览
        // ----------------------------

        if (preview != null) ...[
          const SizedBox(height: 14),

          Text(
            '文件：$fileName\n'
            '合格：${preview!.rows.length} 行\n'
            '错误：${preview!.errors.length} 行',
          ),

          const SizedBox(height: 12),

          if (preview!.errors.isNotEmpty)
            for (final error in preview!.errors.take(20))
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),

          const SizedBox(height: 8),

          Text(
            '导入预览（前 30 行）',
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),

          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('采样时间')),
                DataColumn(label: Text('代码')),
                DataColumn(label: Text('指标')),
                DataColumn(label: Text('结果')),
                DataColumn(label: Text('单位')),
                DataColumn(label: Text('参考范围')),
              ],

              rows: [
                for (final r in preview!.rows.take(30))
                  DataRow(
                    cells: [
                      DataCell(
                        Text(r.values['sample_date'] ?? ''),
                      ),
                      DataCell(Text(r.code)),
                      DataCell(Text(r.name)),
                      DataCell(Text(r.rawValue)),
                      DataCell(
                        Text(r.values['unit'] ?? ''),
                      ),
                      DataCell(
                        Text(
                          r.values['reference_range'] ?? '',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],

        const Divider(height: 32),

        // ----------------------------
        // 已保存的 CSV 记录
        // ----------------------------

        imported.when(
          loading: () =>
              const LinearProgressIndicator(),

          error: (e, _) => Text(
            '数据库查询失败：$e',
          ),

          data: (items) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '已导入记录：${items.length} 条',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 8),

                for (final row in items.take(100))
                  ListTile(
                    dense: true,
                    title: Text(
                      '${row.indicatorNameCn} '
                      '(${row.indicatorCode}) · '
                      '${row.rawValue} ${row.unit}',
                    ),
                    subtitle: Text(
                      '${row.sampleDateRaw} · '
                      '${row.category} · '
                      '${row.referenceRange}',
                    ),
                  ),

                if (items.length > 100)
                  Text(
                    '仅显示最新 100 条，'
                    '共 ${items.length} 条。',
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
