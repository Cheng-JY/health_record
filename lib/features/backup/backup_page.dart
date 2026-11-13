// This page is intended for HealthRecord Flutter Web (Chrome/Safari/Edge).
import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import 'backup_service.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool working = false;

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _export() async {
    if (working) return;
    setState(() => working = true);
    try {
      final text = await HealthRecordBackupService(ref.read(databaseProvider))
          .exportJson();
      final stamp = DateTime.now().toIso8601String().substring(0, 10);
      final blob = html.Blob([text], 'application/json;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);
      try {
        html.AnchorElement(href: url)
          ..download = 'health_record_backup_$stamp.json'
          ..click();
        // Give the browser time to consume the object URL.
        await Future<void>.delayed(const Duration(seconds: 2));
      } finally {
        html.Url.revokeObjectUrl(url);
      }
      _message('备份下载已发起，请确认浏览器已保存文件。');
    } catch (e) {
      _message('导出失败：$e');
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> _import() async {
    if (working) return;
    // Open the file picker synchronously in the click handler.
    final input = html.FileUploadInputElement()
      ..accept = '.json,application/json';
    input.click();
    final event = await input.onChange.first;
    // Suppress unused warning while keeping subscription wait explicit.
    if (event.type.isEmpty) return;
    final file = input.files?.isNotEmpty == true ? input.files!.first : null;
    if (file == null || !mounted) return;

    setState(() => working = true);
    try {
      final reader = html.FileReader();
      reader.readAsText(file);
      await reader.onLoadEnd.first;
      if (reader.error != null || reader.result is! String) {
        throw const FormatException('读取备份文件失败。');
      }
      final jsonText = reader.result as String;
      final service = HealthRecordBackupService(ref.read(databaseProvider));
      final preview = service.inspect(jsonText);
      if (!mounted) return;

      final approved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('确认恢复备份？'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('备份时间（UTC）：${preview.exportedAt}'),
                Text('记录总数（含分类、指标）：${preview.totalRecords}'),
                const SizedBox(height: 12),
                for (final entry in preview.rowCounts.entries)
                  Text('${entry.key}: ${entry.value}'),
                const SizedBox(height: 12),
                const Text(
                  '警告：此操作会完全替换当前浏览器的 HealthRecord 数据。'
                  '请先导出当前数据备份，并确保文件已经保存！',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('确认替换并恢复'),
            ),
          ],
        ),
      );
      if (approved != true) return;
      await service.restoreJson(jsonText);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('恢复成功'),
          content: const Text('数据已写入本地浏览器数据库。点击确定后重新载入页面。'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      html.window.location.reload();
    } catch (e) {
      _message('恢复失败（数据库事务会回滚）：$e');
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('本地备份与恢复')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('备份将包括检查结果、医院、就诊、报告关联及完整用药历史。'),
        const SizedBox(height: 8),
        const Text('文件仅下载到你的设备，不上传到服务器。JSON 是明文格式，请妥善保管。'),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: working ? null : _export,
          icon: const Icon(Icons.download),
          label: const Text('导出完整 JSON 备份'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: working ? null : _import,
          icon: const Icon(Icons.upload_file),
          label: const Text('导入备份并替换本地数据'),
        ),
        const SizedBox(height: 20),
        const Text('请先导出并检查备份文件，再尝试恢复。导入会替换当前浏览器中的全部记录，不会自动合并。'),
        if (working)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    ),
  );
}
