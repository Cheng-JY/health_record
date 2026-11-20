// Flutter Web implementation: stores PDF bytes in local SQLite as base64.
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:drift/drift.dart' show Variable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

class VisitPdfPage extends ConsumerStatefulWidget {
  const VisitPdfPage({super.key, required this.visitId});
  final String visitId;

  @override
  ConsumerState<VisitPdfPage> createState() => _VisitPdfPageState();
}

class _PdfItem {
  const _PdfItem(
    this.id,
    this.fileName,
    this.title,
    this.note,
    this.size,
    this.addedAt,
  );
  final String id;
  final String fileName;
  final String title;
  final String note;
  final int size;
  final String addedAt;
}

class _VisitPdfPageState extends ConsumerState<VisitPdfPage> {
  late Future<List<_PdfItem>> _items;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _items = _load();
  }

  void _refresh() {
    _items = _load();
    if (mounted) setState(() {});
  }

  Future<List<_PdfItem>> _load() async {
    final rows = await ref
        .read(databaseProvider)
        .customSelect(
          'SELECT id, file_name, title, note, size_bytes, created_at '
          'FROM visit_pdf_attachments WHERE visit_id = ? ORDER BY created_at DESC',
          variables: [Variable.withString(widget.visitId)],
        )
        .get();
    return [
      for (final row in rows)
        _PdfItem(
          row.read<String>('id'),
          row.read<String>('file_name'),
          row.read<String>('title'),
          row.read<String>('note'),
          row.read<int>('size_bytes'),
          row.read<String>('created_at'),
        ),
    ];
  }

  void _message(String value) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Future<void> _upload() async {
    if (busy) return;
    // Open the native chooser before awaiting: Chrome requires user activation.
    final input = html.FileUploadInputElement()
      ..accept = '.pdf,application/pdf';
    input.click();
    await input.onChange.first;
    final file = input.files?.isNotEmpty == true ? input.files!.first : null;
    if (file == null || !mounted) return;
    const maxBytes = 8 * 1024 * 1024;
    if (file.size > maxBytes) {
      _message('单个 PDF 不能超过 8 MB。可先压缩 PDF 再上传。');
      return;
    }
    setState(() => busy = true);
    try {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoadEnd.first;
      if (reader.error != null || reader.result is! ByteBuffer) {
        throw const FormatException('无法读取 PDF 文件。');
      }
      final bytes = Uint8List.view(reader.result as ByteBuffer);
      if (bytes.length < 5 ||
          utf8.decode(bytes.sublist(0, 5), allowMalformed: true) != '%PDF-') {
        throw const FormatException('文件内容不是有效的 PDF 格式。');
      }
      if (!mounted) return;
      final details = await _askMetadata(
        initialTitle: file.name.replaceFirst(
          RegExp(r'\.pdf$', caseSensitive: false),
          '',
        ),
      );
      if (details == null || !mounted) return;
      final now = DateTime.now().toUtc().toIso8601String();
      await ref.read(databaseProvider).customStatement(
        'INSERT INTO visit_pdf_attachments '
        '(id, visit_id, file_name, title, note, size_bytes, pdf_base64, created_at, updated_at) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          const Uuid().v4(),
          widget.visitId,
          file.name,
          details.$1,
          details.$2,
          bytes.length,
          base64Encode(bytes),
          now,
          now,
        ],
      );
      _refresh();
      _message('PDF 已保存到本地数据库');
    } catch (e) {
      _message('添加 PDF 失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<(String, String)?> _askMetadata({
    required String initialTitle,
    String initialNote = '',
  }) async {
    final title = TextEditingController(text: initialTitle);
    final note = TextEditingController(text: initialNote);
    try {
      return await showDialog<(String, String)>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('PDF 名称与备注'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    maxLength: 120,
                    decoration: const InputDecoration(
                      labelText: '附件名称 *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: note,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 2000,
                    decoration: const InputDecoration(
                      labelText: '备注（可选）',
                      hintText: '例如：出院小结、检查结果、复诊需要注意的事项',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (title.text.trim().isEmpty) return;
                Navigator.pop(ctx, (title.text.trim(), note.text.trim()));
              },
              child: const Text('保存'),
            ),
          ],
        ),
      );
    } finally {
      // Prevent disposing controllers while the pop animation still uses them.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        title.dispose();
        note.dispose();
      });
    }
  }

  Future<void> _edit(_PdfItem item) async {
    final changed = await _askMetadata(
      initialTitle: item.title,
      initialNote: item.note,
    );
    if (changed == null || !mounted) return;
    try {
      await ref.read(databaseProvider).customStatement(
        'UPDATE visit_pdf_attachments SET title = ?, note = ?, updated_at = ? '
        'WHERE id = ? AND visit_id = ?',
        [
          changed.$1,
          changed.$2,
          DateTime.now().toUtc().toIso8601String(),
          item.id,
          widget.visitId,
        ],
      );
      _refresh();
    } catch (e) {
      _message('修改备注失败：$e');
    }
  }

  Future<void> _download(_PdfItem item) async {
    try {
      final rows = await ref
          .read(databaseProvider)
          .customSelect(
            'SELECT pdf_base64 FROM visit_pdf_attachments WHERE id = ? AND visit_id = ?',
            variables: [
              Variable.withString(item.id),
              Variable.withString(widget.visitId),
            ],
          )
          .get();
      if (rows.isEmpty) throw StateError('附件不存在');
      final bytes = base64Decode(rows.first.read<String>('pdf_base64'));
      final url = html.Url.createObjectUrlFromBlob(
        html.Blob([bytes], 'application/pdf'),
      );
      try {
        html.AnchorElement(href: url)
          ..download = item.fileName
          ..click();
        await Future<void>.delayed(const Duration(seconds: 2));
      } finally {
        html.Url.revokeObjectUrl(url);
      }
    } catch (e) {
      _message('下载失败：$e');
    }
  }

  Future<void> _delete(_PdfItem item) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除 PDF 附件？'),
        content: Text('将永久删除「${item.title}」及其本地文件内容，不影响其他就诊和检查结果。'),
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
    try {
      await ref.read(databaseProvider).customStatement(
        'DELETE FROM visit_pdf_attachments WHERE id = ? AND visit_id = ?',
        [item.id, widget.visitId],
      );
      _refresh();
      _message('附件已删除');
    } catch (e) {
      _message('删除失败：$e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('就诊 PDF 附件')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'PDF 文件与备注',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            FilledButton.icon(
              onPressed: busy ? null : _upload,
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('上传 PDF'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('附件保存于当前浏览器的 SQLite 数据库，并包含在完整 JSON 备份中。单个文件最多 8 MB。'),
        if (busy) const LinearProgressIndicator(),
        const SizedBox(height: 12),
        FutureBuilder<List<_PdfItem>>(
          future: _items,
          builder: (ctx, snapshot) {
            if (snapshot.hasError)
              return SelectableText('读取附件失败：${snapshot.error}');
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final rows = snapshot.data!;
            if (rows.isEmpty)
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Text('本次就诊尚无 PDF 附件。'),
              );
            return Column(
              children: [
                for (final item in rows)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.picture_as_pdf_outlined),
                      title: Text(item.title),
                      subtitle: Text(
                        '${item.fileName} · ${(item.size / 1024).toStringAsFixed(0)} KB'
                        '${item.note.isEmpty ? '' : '\n备注：${item.note}'}',
                      ),
                      isThreeLine: item.note.isNotEmpty,
                      onTap: () => _download(item),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) {
                          if (action == 'download') _download(item);
                          if (action == 'edit') _edit(item);
                          if (action == 'delete') _delete(item);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'download',
                            child: Text('下载 PDF'),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('编辑名称 / 备注'),
                          ),
                          PopupMenuItem(value: 'delete', child: Text('删除附件')),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    ),
  );
}
