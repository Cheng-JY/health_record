import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

/// Each photo stays in local SQLite (base64 text), and is included in JSON backups.
/// No network upload or external storage is required.
class SymptomPhoto {
  const SymptomPhoto({
    required this.id,
    required this.mime,
    required this.bytes,
  });
  final String id;
  final String mime;
  final Uint8List bytes;
}

class SymptomEntry {
  const SymptomEntry({
    required this.id,
    required this.symptom,
    required this.severity,
    required this.occurredAt,
    required this.notes,
    required this.photos,
  });
  final String id;
  final String symptom;
  final int severity;
  final DateTime occurredAt;
  final String notes;
  final List<SymptomPhoto> photos;
}

final symptomsProvider = FutureProvider<List<SymptomEntry>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db
      .customSelect(
        'SELECT id, symptom, severity, occurred_at, notes '
        'FROM symptom_entries ORDER BY occurred_at DESC, created_at DESC',
      )
      .get();
  final photoRows = await db
      .customSelect(
        'SELECT id, symptom_id, mime_type, image_base64 FROM symptom_photos '
        'ORDER BY created_at ASC',
      )
      .get();
  final bySymptom = <String, List<SymptomPhoto>>{};
  for (final row in photoRows) {
    try {
      final photo = SymptomPhoto(
        id: row.read<String>('id'),
        mime: row.read<String>('mime_type'),
        bytes: base64Decode(row.read<String>('image_base64')),
      );
      bySymptom
          .putIfAbsent(row.read<String>('symptom_id'), () => [])
          .add(photo);
    } catch (_) {
      // A damaged image must not hide other medical records.
    }
  }
  return [
    for (final row in rows)
      SymptomEntry(
        id: row.read<String>('id'),
        symptom: row.read<String>('symptom'),
        severity: row.read<int>('severity'),
        occurredAt: DateTime.parse(row.read<String>('occurred_at')),
        notes: row.readNullable<String>('notes') ?? '',
        photos: bySymptom[row.read<String>('id')] ?? const [],
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
  static const maxPhotos = 3;
  static const maxPhotoBytes = 3 * 1024 * 1024;

  @override
  void initState() {
    super.initState();
    if (widget.openEditor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _edit();
      });
    }
  }

  void _notice(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _preview(SymptomPhoto photo) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        child: Stack(
          children: [
            SizedBox(
              width: 750,
              height: 560,
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5,
                child: Image.memory(photo.bytes, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton.filledTonal(
                tooltip: '关闭照片',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit([SymptomEntry? original]) async {
    final symptomController = TextEditingController(
      text: original?.symptom ?? '',
    );
    final notesController = TextEditingController(text: original?.notes ?? '');
    var severity = original?.severity ?? 3;
    var occurred = original?.occurredAt ?? DateTime.now();
    final photos = <SymptomPhoto>[...?original?.photos];
    var picking = false;
    final editorContext = context;

    try {
      final payload =
          await showDialog<
            ({
              String symptom,
              String notes,
              int severity,
              DateTime occurred,
              List<SymptomPhoto> photos,
            })
          >(
            context: context,
            builder: (dialogContext) => StatefulBuilder(
              builder: (dialogContext, setDialogState) => AlertDialog(
                title: Text(original == null ? '记录新症状' : '编辑症状'),
                content: SizedBox(
                  width: 490,
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
                              context: dialogContext,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              initialDate: occurred,
                            );
                            if (date == null || !dialogContext.mounted) return;
                            final time = await showTimePicker(
                              context: dialogContext,
                              initialTime: TimeOfDay.fromDateTime(occurred),
                            );
                            if (time == null || !dialogContext.mounted) return;
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '症状照片（${photos.length}/$maxPhotos）',
                                style: Theme.of(dialogContext)
                                    .textTheme
                                    .titleSmall,
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(
                                Icons.add_photo_alternate_outlined,
                              ),
                              label: const Text('添加照片'),
                              onPressed: picking || photos.length >= maxPhotos
                                  ? null
                                  : () async {
                                      setDialogState(() => picking = true);
                                      try {
                                        final selected =
                                            await FilePicker.pickFiles(
                                              type: FileType.image,
                                            );
                                        if (!dialogContext.mounted ||
                                            selected.isEmpty)
                                          return;
                                        var skipped = 0;
                                        for (final file in selected) {
                                          if (photos.length >= maxPhotos) {
                                            skipped++;
                                            continue;
                                          }
                                          final bytes = await file
                                              .readAsBytes();
                                          final name = file.name.toLowerCase();
                                          final isPng = name.endsWith('.png');
                                          final isJpeg =
                                              name.endsWith('.jpg') ||
                                              name.endsWith('.jpeg');
                                          final isWebp = name.endsWith('.webp');
                                          if (bytes == null ||
                                              bytes.isEmpty ||
                                              bytes.length > maxPhotoBytes ||
                                              !(isPng || isJpeg || isWebp)) {
                                            skipped++;
                                            continue;
                                          }
                                          photos.add(
                                            SymptomPhoto(
                                              id: const Uuid().v4(),
                                              mime: isPng
                                                  ? 'image/png'
                                                  : isWebp
                                                  ? 'image/webp'
                                                  : 'image/jpeg',
                                              bytes: bytes,
                                            ),
                                          );
                                        }
                                        if (dialogContext.mounted)
                                          setDialogState(() {});
                                        if (skipped > 0 &&
                                            editorContext.mounted) {
                                          ScaffoldMessenger.of(
                                            editorContext,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '有 $skipped 张照片未添加（仅支持 JPG/PNG/WebP、单张不超过 3 MB、最多 3 张）',
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (editorContext.mounted) {
                                          ScaffoldMessenger.of(editorContext)
                                              .showSnackBar(
                                                SnackBar(
                                                  content: Text('读取照片失败：$e'),
                                                ),
                                              );
                                        }
                                      } finally {
                                        if (dialogContext.mounted) {
                                          setDialogState(() => picking = false);
                                        }
                                      }
                                    },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (photos.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final photo in photos)
                                Stack(
                                  children: [
                                    InkWell(
                                      onTap: () => _preview(photo),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          photo.bytes,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton.filledTonal(
                                        icon: const Icon(Icons.close, size: 16),
                                        tooltip: '从本条记录移除照片',
                                        onPressed: () => setDialogState(
                                          () => photos.remove(photo),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        const SizedBox(height: 6),
                        Text(
                          '照片仅保存于本地数据库，最多 3 张，每张不超过 3 MB。',
                          style: Theme.of(dialogContext).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: picking
                        ? null
                        : () {
                            final name = symptomController.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                const SnackBar(content: Text('请填写症状名称')),
                              );
                              return;
                            }
                            Navigator.pop(dialogContext, (
                              symptom: name,
                              severity: severity,
                              notes: notesController.text.trim(),
                              occurred: occurred,
                              photos: List<SymptomPhoto>.of(photos),
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
      final id = original?.id ?? const Uuid().v4();
      await db.transaction(() async {
        if (original == null) {
          await db.customStatement(
            'INSERT INTO symptom_entries '
            '(id, symptom, severity, occurred_at, notes, created_at, updated_at) '
            'VALUES (?, ?, ?, ?, ?, ?, ?)',
            [
              id,
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
              id,
            ],
          );
        }
        final existing =
            original?.photos.map((p) => p.id).toSet() ?? <String>{};
        final keep = payload.photos.map((p) => p.id).toSet();
        for (final removed in existing.difference(keep)) {
          await db.customStatement(
            'DELETE FROM symptom_photos WHERE id = ? AND symptom_id = ?',
            [removed, id],
          );
        }
        for (final photo in payload.photos.where(
          (p) => !existing.contains(p.id),
        )) {
          await db.customStatement(
            'INSERT INTO symptom_photos '
            '(id, symptom_id, mime_type, image_base64, created_at) '
            'VALUES (?, ?, ?, ?, ?)',
            [photo.id, id, photo.mime, base64Encode(photo.bytes), now],
          );
        }
      });
      ref.invalidate(symptomsProvider);
    } catch (e) {
      _notice('保存症状失败：$e');
    } finally {
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
        content: Text('确定删除“${item.symptom}”这条记录及关联照片吗？'),
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
      final db = ref.read(databaseProvider);
      await db.transaction(() async {
        await db.customStatement(
          'DELETE FROM symptom_photos WHERE symptom_id = ?',
          [item.id],
        );
        await db.customStatement('DELETE FROM symptom_entries WHERE id = ?', [
          item.id,
        ]);
      });
      ref.invalidate(symptomsProvider);
    } catch (e) {
      _notice('删除失败：$e');
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
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
                        if (item.photos.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final photo in item.photos)
                                  InkWell(
                                    onTap: () => _preview(photo),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        photo.bytes,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
