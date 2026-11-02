import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../main.dart';
import 'hospital_repository.dart';
import 'hospital_tools_page.dart';

final hospitalManagementRepositoryProvider = Provider<HospitalRepository>(
  (ref) => HospitalRepository(ref.watch(databaseProvider)),
);

final hospitalSummariesProvider = StreamProvider<List<HospitalSummary>>(
  (ref) => ref.watch(hospitalManagementRepositoryProvider).watchSummaries(),
);

class HospitalsPage extends ConsumerStatefulWidget {
  const HospitalsPage({super.key});

  @override
  ConsumerState<HospitalsPage> createState() => _HospitalsPageState();
}

class _HospitalsPageState extends ConsumerState<HospitalsPage> {
  String search = '';
  bool busy = false;

  Future<void> _editHospital([Hospital? hospital]) async {
    final nameController = TextEditingController(text: hospital?.name ?? '');
    final cityController = TextEditingController(text: hospital?.city ?? '');
    try {
      final values = await showDialog<({String name, String city})>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(hospital == null ? '添加医院' : '编辑医院'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: '医院名称 *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: '城市（可选）',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                Navigator.pop(dialogContext, (
                  name: nameController.text.trim(),
                  city: cityController.text.trim(),
                ));
              },
              child: const Text('保存'),
            ),
          ],
        ),
      );
      if (values == null || !mounted) return;
      setState(() => busy = true);
      final repo = ref.read(hospitalManagementRepositoryProvider);
      if (hospital == null) {
        await repo.createHospital(name: values.name, city: values.city);
      } else {
        await repo.updateHospital(
          id: hospital.id,
          name: values.name,
          city: values.city,
        );
      }
      if (mounted) _notify('医院已保存');
    } catch (e) {
      if (mounted) _notify('保存失败：$e');
    } finally {
      nameController.dispose();
      cityController.dispose();
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _deleteHospital(HospitalSummary summary) async {
    if (summary.allResultCount > 0) {
      _notify('医院已关联 ${summary.allResultCount} 条记录，不能删除。可先修改医院名称。');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除医院'),
        content: Text('确认删除「${summary.hospital.name}」？该医院当前没有关联的检查记录。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => busy = true);
    try {
      await ref
          .read(hospitalManagementRepositoryProvider)
          .deleteHospitalIfUnused(summary.hospital.id);
      if (mounted) _notify('医院已删除');
    } catch (e) {
      if (mounted) _notify('删除失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(hospitalSummariesProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('医院管理', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('医院 UUID 固定不变。编辑医院名称不会影响已有检查记录的关联。'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: '搜索医院或城市',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) =>
                    setState(() => search = value.trim().toLowerCase()),
              ),
            ),
            OutlinedButton.icon(
              onPressed: busy
                  ? null
                  : () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const HospitalToolsPage(),
                      ),
                    ),
              icon: const Icon(Icons.settings_suggest_outlined),
              label: const Text('批量分配 / 合并医院'),
            ),
            FilledButton.icon(
              onPressed: busy ? null : () => _editHospital(),
              icon: const Icon(Icons.add),
              label: const Text('添加医院'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (busy) const LinearProgressIndicator(),
        summaries.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => SelectableText('医院读取失败：$e'),
          data: (all) {
            final filtered = all.where((summary) {
              final hospital = summary.hospital;
              return hospital.name.toLowerCase().contains(search) ||
                  (hospital.city ?? '').toLowerCase().contains(search);
            }).toList();
            if (filtered.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text('没有符合条件的医院。'),
              );
            }
            return Column(
              children: [
                for (final summary in filtered)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.local_hospital_outlined),
                      title: Text(summary.hospital.name),
                      subtitle: Text(
                        '${summary.hospital.city ?? "未填写城市"} · '
                        '有效检查 ${summary.activeResultCount} 条 · '
                        '全部关联 ${summary.allResultCount} 条',
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              HospitalResultsPage(hospital: summary.hospital),
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            tooltip: '编辑医院',
                            onPressed: busy
                                ? null
                                : () => _editHospital(summary.hospital),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            tooltip: summary.allResultCount > 0
                                ? '有检查记录关联，不能删除'
                                : '删除医院',
                            onPressed: busy
                                ? null
                                : () => _deleteHospital(summary),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
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

/// Shows only active CSV results associated with this hospital.
/// Manual LabResults currently have no hospitalId in the existing schema.
class HospitalResultsPage extends ConsumerWidget {
  const HospitalResultsPage({required this.hospital, super.key});

  final Hospital hospital;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(hospital.name)),
      body: StreamBuilder<List<ImportedLabResult>>(
        stream: ref
            .watch(hospitalManagementRepositoryProvider)
            .watchActiveResults(hospital.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: SelectableText('读取失败：${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snapshot.data!;
          if (rows.isEmpty) {
            return const Center(child: Text('该医院暂无有效的 CSV 检查结果'));
          }
          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, index) {
              final item = rows[index];
              return ListTile(
                title: Text(
                  '${item.indicatorNameCn} · ${item.rawValue} ${item.unit}',
                ),
                subtitle: Text(
                  '${item.sampleDateRaw} · ${item.category} · ${item.referenceRange}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
