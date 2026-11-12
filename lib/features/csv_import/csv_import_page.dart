import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker_web/file_picker_web.dart';

import '../../main.dart';
import '../../core/database/app_database.dart';
import 'csv_import_service.dart';
import '../hospitals/hospital_repository.dart';

// 监听已导入的 CSV 检查记录
final importedProvider = StreamProvider<List<ImportedLabResult>>(
  (ref) => ref.watch(databaseProvider).watchImportedResults(),
);

final hospitalsProvider = StreamProvider<List<Hospital>>(
  (ref) => HospitalRepository(ref.watch(databaseProvider)).watchHospitals(),
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
  String? selectedHospitalId;

  Future<void> addHospital() async {
    final nameController = TextEditingController();
    final cityController = TextEditingController();

    try {
      final result = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('添加医院'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '医院名称',
                  hintText: '例如 Klinikum Kassel',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: '城市（可选）'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, nameController.text.trim()),
              child: const Text('保存'),
            ),
          ],
        ),
      );

      if (result == null) return;

      if (result.isEmpty) {
        throw ArgumentError('请输入医院名称');
      }

      final hospitalId = await HospitalRepository(ref.read(databaseProvider))
          .createHospital(name: result, city: cityController.text);

      if (!mounted) return;

      setState(() {
        selectedHospitalId = hospitalId;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('保存医院失败：$e')));
    } finally {
      nameController.dispose();
      cityController.dispose();
    }
  }

  // ========================================
  // 1. 选择并解析 CSV
  // ========================================

  Future<void> choose() async {
    if (busy) {
      return;
    }

    setState(() {
      busy = true;
      message = '正在打开 CSV 文件选择窗口……';
    });

    try {
      debugPrint('[CSV] Opening file picker');

      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        webOptions: FilePickerWebOptions(cancelUploadOnWindowBlur: false),
      );

      if (file == null) {
        debugPrint('[CSV] File selection cancelled');

        if (!mounted) {
          return;
        }

        setState(() {
          message = '已取消文件选择';
        });
        return;
      }

      debugPrint('[CSV] Selected file: ${file.name}');

      if (!mounted) {
        return;
      }

      setState(() {
        message = '已选择 ${file.name}，正在读取文件……';
      });

      final bytes = await file.readAsBytes();

      debugPrint('[CSV] File size: ${bytes.length} bytes');

      if (bytes.isEmpty) {
        throw StateError('CSV 文件为空');
      }

      if (!mounted) {
        return;
      }

      setState(() {
        message = 'CSV 文件读取成功，正在解析……';
      });

      final parsed = CsvImportService(ref.read(databaseProvider)).parse(bytes);

      debugPrint('[CSV] Valid rows: ${parsed.rows.length}');
      debugPrint('[CSV] Errors: ${parsed.errors.length}');

      if (!mounted) {
        return;
      }

      setState(() {
        preview = parsed;
        fileName = file.name;

        if (parsed.errors.isNotEmpty) {
          message =
              'CSV 已读取，但存在 ${parsed.errors.length} 条解析错误。'
              '请查看下方错误详情。';
        } else if (parsed.rows.isEmpty) {
          message = 'CSV 已读取，但没有识别到有效检查记录。';
        } else {
          message =
              'CSV 读取成功：${parsed.rows.length} 条有效记录。'
              '现在可以确认导入。';
        }
      });
    } catch (e, stackTrace) {
      debugPrint('[CSV] ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        message = 'CSV 读取或解析失败：$e';
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

    // 1. 检查 CSV 是否已选择并成功解析
    if (p == null || p.rows.isEmpty || fileName == null) {
      return;
    }

    // 2. 检查是否存在解析错误
    if (p.errors.isNotEmpty) {
      setState(() {
        message = '存在错误行，请修正 CSV 后重新导入。';
      });
      return;
    }

    // 3. 检查是否已选择医院
    final hospitalId = selectedHospitalId;

    if (hospitalId == null) {
      setState(() {
        message = '请先选择或添加医院';
      });
      return;
    }

    // 4. 开始导入
    setState(() {
      busy = true;
      message = null;
    });

    try {
      final outcome = await CsvImportService(ref.read(databaseProvider))
          .importRows(p.rows, fileName!, hospitalId: hospitalId);

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
      final duplicateCount = await db.countDuplicateImportedResults();

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
      final removed = await db.cleanupDuplicateImportedResults();

      if (!mounted) return;

      setState(() {
        message = '清理完成：已软删除 $removed 条重复记录。';
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('已清理 $removed 条重复记录')));
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
    final hospitals = ref.watch(hospitalsProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ========================================
        // 1. 页面标题
        // ========================================

        Text('CSV 检查报告导入', style: Theme.of(context).textTheme.headlineSmall),

        const SizedBox(height: 8),

        const Text(
          '选择检查医院，然后导入 CSV 文件。'
          '检查数据将保存到本地数据库，并关联所选医院。',
        ),

        const SizedBox(height: 20),

        // ========================================
        // 2. 医院选择区域
        // ========================================
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('检查医院', style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: 12),

                hospitals.when(
                  loading: () => const LinearProgressIndicator(),

                  error: (error, _) => Text('加载医院失败：$error'),

                  data: (items) {
                    final ids = items.map((h) => h.id).toSet();

                    return DropdownButtonFormField<String>(
                      key: ValueKey(
                        '${selectedHospitalId ?? "none"}_${items.length}',
                      ),
                      initialValue: ids.contains(selectedHospitalId)
                          ? selectedHospitalId
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: '选择已保存的医院',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('请选择检查医院'),
                      items: items.map((hospital) {
                        final city = hospital.city?.trim();

                        return DropdownMenuItem<String>(
                          value: hospital.id,
                          child: Text(
                            city == null || city.isEmpty
                                ? hospital.name
                                : '${hospital.name} ($city)',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: busy
                          ? null
                          : (id) {
                              setState(() {
                                selectedHospitalId = id;
                              });
                            },
                    );
                  },
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: busy ? null : addHospital,
                  icon: const Icon(Icons.add),
                  label: const Text('添加新医院'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ========================================
        // 3. CSV 文件选择和确认导入
        // ========================================
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
              onPressed:
                  busy ||
                      selectedHospitalId == null ||
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

        const SizedBox(height: 10),

        // 直接在导入按钮下面显示禁用原因，避免提示被下方卡片遮挡。
        Builder(
          builder: (context) {
            final reason = busy
                ? '正在处理，请稍候……'
                : selectedHospitalId == null
                ? '请先选择检查医院（即使下拉框显示名称，也请重新点击选择一次）。'
                : preview == null
                ? '尚未成功读取 CSV。请查看下方错误提示。'
                : preview!.rows.isEmpty
                ? 'CSV 中没有有效检查记录。'
                : preview!.errors.isNotEmpty
                ? 'CSV 有 ${preview!.errors.length} 条解析错误，暂不能导入。'
                : '已准备好导入：${preview!.rows.length} 条有效记录。';
            return SelectableText(
              '导入状态：$reason\n'
              '医院 UUID：${selectedHospitalId ?? "未选择"}  |  '
              '文件：${fileName ?? "无"}  |  '
              '有效记录：${preview?.rows.length ?? 0}  |  '
              '错误：${preview?.errors.length ?? 0}',
              style: TextStyle(
                fontSize: 13,
                color:
                    preview != null &&
                        preview!.rows.isNotEmpty &&
                        preview!.errors.isEmpty &&
                        selectedHospitalId != null
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
            );
          },
        ),

        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SelectableText(message!),
          ),

        const SizedBox(height: 20),

        // ========================================
        // 4. 重复记录管理
        // ========================================
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('重复记录管理', style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: 8),

                const Text(
                  '根据医院、采样时间、检查指标、结果和单位'
                  '识别历史重复记录。'
                  '不同 CSV 文件中的相同记录也会被检查。',
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: busy ? null : cleanupDuplicates,
                  icon: const Icon(Icons.cleaning_services_outlined),
                  label: const Text('检查并清理重复记录'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ========================================
        // 5. 加载状态和操作结果
        // ========================================
        if (busy) const LinearProgressIndicator(),

        // ========================================
        // 6. CSV 文件预览
        // ========================================
        if (preview != null) ...[
          const SizedBox(height: 14),

          Text(
            '文件：${fileName ?? ""}\n'
            '有效记录：${preview!.rows.length} 条\n'
            '错误记录：${preview!.errors.length} 条',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 12),

          if (preview!.errors.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CSV 解析错误',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    for (final error in preview!.errors.take(20))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          Text('导入预览（前 30 行）', style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('采样时间')),
                DataColumn(label: Text('指标代码')),
                DataColumn(label: Text('指标名称')),
                DataColumn(label: Text('检查结果')),
                DataColumn(label: Text('单位')),
                DataColumn(label: Text('参考范围')),
              ],
              rows: [
                for (final row in preview!.rows.take(30))
                  DataRow(
                    cells: [
                      DataCell(Text(row.values['sample_date'] ?? '')),
                      DataCell(Text(row.code)),
                      DataCell(Text(row.name)),
                      DataCell(Text(row.rawValue)),
                      DataCell(Text(row.values['unit'] ?? '')),
                      DataCell(Text(row.values['reference_range'] ?? '')),
                    ],
                  ),
              ],
            ),
          ),
        ],

        const Divider(height: 32),

        // ========================================
        // 7. 已导入的 CSV 检查结果
        // ========================================
        imported.when(
          loading: () => const LinearProgressIndicator(),

          error: (error, _) => Text('数据库查询失败：$error'),

          data: (items) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '已导入记录：${items.length} 条',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 8),

                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('目前还没有导入检查记录。'),
                  ),

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
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '仅显示前 100 条，'
                      '共 ${items.length} 条。',
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
