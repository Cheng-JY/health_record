import 'package:drift/drift.dart' show QueryRow, Variable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';
import '../../core/database/app_database.dart';
import 'medications_page.dart';

class _Batch {
  _Batch(this.row);
  final QueryRow row;
  String get id => row.read<String>('id');
  String get medicationId => row.read<String>('medication_id');
  String get brand => row.read<String>('brand');
  String get batchNo => row.read<String>('batch_no');
  String get unit => row.read<String>('strength_unit');
  double get strength => row.read<double>('strength');
  int get packSize => row.read<int>('pack_size');
  int get parts => row.read<int>('parts_per_unit');
  int get remaining => row.read<int>('remaining_parts');
  int? get daily => row.readNullable<int>('daily_parts');
  String get form => row.read<String>('form');
  String get splitStatus => row.read<String>('split_status');
  String? get expiry => row.readNullable<String>('expiry_date');
  String get displayUnit => form == '胶囊' ? '粒' : '片';
  double get tablets => remaining / parts;
  int? get days => daily == null || daily! <= 0 ? null : remaining ~/ daily!;
}

final _inventoryBatchesProvider = FutureProvider<List<_Batch>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db
      .customSelect(
        'SELECT * FROM medication_inventory_batches ORDER BY created_at DESC',
      )
      .get();
  return rows.map(_Batch.new).toList();
});

String _number(double value) =>
    value.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');

class MedicationInventoryPage extends ConsumerWidget {
  const MedicationInventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meds = ref.watch(medicationsProvider);
    final batches = ref.watch(_inventoryBatchesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('药品库存'),
        actions: [
          TextButton.icon(
            onPressed: meds.hasValue && meds.requireValue.isNotEmpty
                ? () => _addStock(context, ref, meds.requireValue)
                : null,
            icon: const Icon(Icons.add),
            label: const Text('新增库存'),
          ),
        ],
      ),
      body: meds.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('读取药物失败：$e')),
        data: (items) => batches.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('读取库存失败：$e')),
          data: (all) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('库存天数根据每批确认的实际每日消耗片数估算；不会自动按 mg 换算，也不会自动扣减服用量。'),
              const SizedBox(height: 12),
              if (items.isEmpty) const Text('请先到用药管理添加药物，再登记库存。'),
              for (final medication in items) ...[
                Builder(
                  builder: (context) {
                    final list = all
                        .where((b) => b.medicationId == medication.id)
                        .toList();
                    final configured = list.where(
                      (b) => b.daily != null && b.daily! > 0,
                    );
                    final unconfigured = list
                        .where((b) => b.remaining > 0 && b.daily == null)
                        .length;
                    final days = configured.fold<int>(
                      0,
                      (sum, b) => sum + (b.days ?? 0),
                    );
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.medication_outlined),
                        title: Text(medication.name),
                        subtitle: Text(
                          list.isEmpty
                              ? '尚未登记库存'
                              : unconfigured > 0
                              ? '已配置批次约 $days 天；另有 $unconfigured 批待设置消耗'
                              : '已登记 ${list.length} 批 · 按已确认的消耗规则估算',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              list.isEmpty
                                  ? '—'
                                  : unconfigured > 0
                                  ? '≥$days 天'
                                  : '$days 天',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                _InventoryDetails(medication: medication),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryDetails extends ConsumerWidget {
  const _InventoryDetails({required this.medication});
  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batches = ref.watch(_inventoryBatchesProvider);
    return Scaffold(
      appBar: AppBar(title: Text('${medication.name} · 库存详情')),
      body: batches.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final list = all
              .where((b) => b.medicationId == medication.id)
              .toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('不同规格分别记账。预计天数只统计明确设置了每日实际消耗量的批次。'),
              const SizedBox(height: 12),
              if (list.isEmpty) const Text('没有库存批次，请在库存首页点击「新增库存」。'),
              for (final b in list)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${b.brand.isEmpty ? medication.name : b.brand} · ${_number(b.strength)} ${b.unit}/${b.displayUnit}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '批号：${b.batchNo.isEmpty ? '未填写' : b.batchNo} · 每盒 ${b.packSize} ${b.displayUnit}',
                        ),
                        Text(
                          '允许分割：${b.splitStatus == 'unknown'
                              ? '尚不确定'
                              : b.parts == 1
                              ? '否'
                              : '最小 1/${b.parts} ${b.displayUnit}'}',
                        ),
                        Text(
                          '剩余：${_number(b.tablets)} ${b.displayUnit} · 预计 ${b.days == null ? '未配置消耗' : '${b.days} 天'}',
                        ),
                        if (b.daily != null)
                          Text(
                            '每日实际消耗：${_number(b.daily! / b.parts)} ${b.displayUnit}',
                          ),
                        if (b.expiry != null && b.expiry!.isNotEmpty)
                          Text('有效期：${b.expiry}'),
                        ExpansionTile(
                          title: const Text('库存变动记录'),
                          children: [
                            FutureBuilder<List<QueryRow>>(
                              future: ref
                                  .read(databaseProvider)
                                  .customSelect(
                                    'SELECT * FROM medication_inventory_movements WHERE batch_id = ? ORDER BY created_at DESC',
                                    variables: [Variable.withString(b.id)],
                                  )
                                  .get(),
                              builder: (context, snapshot) => snapshot.hasError
                                  ? Text('读取失败：${snapshot.error}')
                                  : !snapshot.hasData
                                  ? const LinearProgressIndicator()
                                  : Column(
                                      children: [
                                        for (final row in snapshot.data!)
                                          ListTile(
                                            dense: true,
                                            title: Text(
                                              '${row.read<String>('kind')}：${_number(row.read<int>('delta_parts') / b.parts)} ${b.displayUnit}',
                                            ),
                                            subtitle: Text(
                                              '${row.read<String>('created_at').substring(0, 10)} · ${row.read<String>('note')}',
                                            ),
                                          ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _editInventoryBatch(context, ref, b),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('编辑'),
                              ),
                              TextButton.icon(
                                onPressed: () => _adjustStock(context, ref, b),
                                icon: const Icon(Icons.tune),
                                label: const Text('使用 / 盘点'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _addStock(
  BuildContext context,
  WidgetRef ref,
  List<Medication> meds,
) async {
  String? medicationId = meds.first.id;
  String form = '片剂';
  String unit = 'mg';
  String splitting = 'unknown';
  int parts = 2;
  final strength = TextEditingController();
  final brand = TextEditingController();
  final pack = TextEditingController();
  final boxes = TextEditingController(text: '1');
  final loose = TextEditingController(text: '0');
  final batch = TextEditingController();
  final expiry = TextEditingController();
  final daily = TextEditingController();
  String? error;
  bool working = false;
  try {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, update) => AlertDialog(
          title: const Text('新增库存'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: medicationId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: '选择已有药物 *'),
                    items: [
                      for (final m in meds)
                        DropdownMenuItem(
                          value: m.id,
                          child: Text(m.name, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    onChanged: working
                        ? null
                        : (v) => update(() => medicationId = v),
                  ),
                  TextField(
                    controller: brand,
                    decoration: const InputDecoration(labelText: '品牌 / 厂家（可选）'),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: form,
                    decoration: const InputDecoration(labelText: '剂型'),
                    items: const [
                      DropdownMenuItem(value: '片剂', child: Text('片剂')),
                      DropdownMenuItem(value: '胶囊', child: Text('胶囊')),
                    ],
                    onChanged: working
                        ? null
                        : (v) => update(() {
                            form = v ?? '片剂';
                            if (form == '胶囊') splitting = 'no';
                          }),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: strength,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: '每片/粒含量 *',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 110,
                        child: DropdownButtonFormField<String>(
                          initialValue: unit,
                          decoration: const InputDecoration(labelText: '单位'),
                          items: const ['mg', 'µg', 'g', 'IU']
                              .map(
                                (u) =>
                                    DropdownMenuItem(value: u, child: Text(u)),
                              )
                              .toList(),
                          onChanged: working
                              ? null
                              : (v) => update(() => unit = v ?? 'mg'),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: pack,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '每盒多少片/粒 *'),
                  ),
                  TextField(
                    controller: boxes,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '新购入盒数 *'),
                  ),
                  TextField(
                    controller: loose,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '额外散片/粒数量',
                      helperText: '已开封但尚有余量的散片可单独填写',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('药剂能否分割？*', style: Theme.of(ctx).textTheme.titleSmall),
                  if (form == '胶囊') const Text('胶囊默认不可拆分。'),
                  if (form != '胶囊') ...[
                    RadioListTile<String>(
                      title: const Text('不可分割'),
                      value: 'no',
                      groupValue: splitting,
                      onChanged: working
                          ? null
                          : (v) => update(() => splitting = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('可以分割'),
                      value: 'yes',
                      groupValue: splitting,
                      onChanged: working
                          ? null
                          : (v) => update(() => splitting = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('不确定'),
                      value: 'unknown',
                      groupValue: splitting,
                      onChanged: working
                          ? null
                          : (v) => update(() => splitting = v!),
                    ),
                    if (splitting == 'yes')
                      DropdownButtonFormField<int>(
                        initialValue: parts,
                        decoration: const InputDecoration(
                          labelText: '最小允许分割量 *',
                        ),
                        items: const [2, 4, 8]
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text('1/$v 片'),
                              ),
                            )
                            .toList(),
                        onChanged: working
                            ? null
                            : (v) => update(() => parts = v ?? 2),
                      ),
                  ],
                  const Text('允许分割需以具体药品说明书或药师确认为准。'),
                  TextField(
                    controller: daily,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: '每天实际消耗多少片/粒（可暂不填）',
                      helperText: '按实际片数填写，如 1 或 0.5；不按 mg 自动换算',
                    ),
                  ),
                  TextField(
                    controller: batch,
                    decoration: const InputDecoration(
                      labelText: '购入批号 / 批次（可选）',
                    ),
                  ),
                  TextField(
                    controller: expiry,
                    decoration: const InputDecoration(
                      labelText: '有效期（YYYY-MM-DD，可选）',
                    ),
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        error!,
                        style: TextStyle(
                          color: Theme.of(ctx).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: working ? null : () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: working
                  ? null
                  : () async {
                      final s = double.tryParse(
                        strength.text.replaceAll(',', '.'),
                      );
                      final perPack = int.tryParse(pack.text.trim());
                      final count = int.tryParse(boxes.text.trim());
                      final extra = int.tryParse(loose.text.trim());
                      final perDay = daily.text.trim().isEmpty
                          ? null
                          : double.tryParse(daily.text.replaceAll(',', '.'));
                      final divisor = splitting == 'yes' && form != '胶囊'
                          ? parts
                          : 1;
                      final dailyParts = perDay == null
                          ? null
                          : (perDay * divisor).round();
                      final validDaily =
                          perDay == null ||
                          (perDay > 0 &&
                              (perDay * divisor - dailyParts!).abs() <
                                  0.000001);
                      if (medicationId == null ||
                          s == null ||
                          !s.isFinite ||
                          s <= 0 ||
                          perPack == null ||
                          perPack <= 0 ||
                          count == null ||
                          count < 0 ||
                          extra == null ||
                          extra < 0 ||
                          count * perPack + extra <= 0 ||
                          !validDaily ||
                          (expiry.text.trim().isNotEmpty &&
                              DateTime.tryParse(expiry.text.trim()) == null)) {
                        update(
                          () =>
                              error = '请确认药物、规格、数量、分割规则和每日实际消耗。分片数必须符合最小分割份数。',
                        );
                        return;
                      }
                      update(() {
                        working = true;
                        error = null;
                      });
                      try {
                        final db = ref.read(databaseProvider);
                        final id = const Uuid().v4();
                        final totalParts = (count * perPack + extra) * divisor;
                        final now = DateTime.now().toIso8601String();
                        await db.transaction(() async {
                          await db.customStatement(
                            '''INSERT INTO medication_inventory_batches
                  (id, medication_id, brand, batch_no, form, strength, strength_unit,
                   pack_size, purchased_boxes, parts_per_unit, split_status, remaining_parts, daily_parts,
                   expiry_date, created_at)
                  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
                            [
                              id,
                              medicationId,
                              brand.text.trim(),
                              batch.text.trim(),
                              form,
                              s,
                              unit,
                              perPack,
                              count,
                              divisor,
                              splitting,
                              totalParts,
                              dailyParts,
                              expiry.text.trim().isEmpty
                                  ? null
                                  : expiry.text.trim(),
                              now,
                            ],
                          );
                          await db.customStatement(
                            '''INSERT INTO medication_inventory_movements
                  (id, batch_id, delta_parts, kind, note, created_at)
                  VALUES (?, ?, ?, ?, ?, ?)''',
                            [
                              const Uuid().v4(),
                              id,
                              totalParts,
                              'purchase',
                              '$count 盒，散片/粒 $extra',
                              now,
                            ],
                          );
                        });
                        ref.invalidate(_inventoryBatchesProvider);
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        update(() {
                          working = false;
                          error = '保存失败：$e';
                        });
                      }
                    },
              child: const Text('保存库存'),
            ),
          ],
        ),
      ),
    );
  } finally {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in [
        strength,
        brand,
        pack,
        boxes,
        loose,
        batch,
        expiry,
        daily,
      ]) {
        c.dispose();
      }
    });
  }
}

Future<void> _adjustStock(
  BuildContext context,
  WidgetRef ref,
  _Batch batch,
) async {
  String mode = 'consume';
  final quantity = TextEditingController();
  final note = TextEditingController();
  String? error;
  bool saving = false;
  try {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, update) => AlertDialog(
          title: Text(
            '库存调整 · ${batch.brand.isEmpty ? batch.batchNo : batch.brand}',
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: mode,
                  decoration: const InputDecoration(labelText: '操作'),
                  items: const [
                    DropdownMenuItem(value: 'consume', child: Text('已服用 / 使用')),
                    DropdownMenuItem(value: 'discard', child: Text('丢弃 / 过期')),
                    DropdownMenuItem(value: 'count', child: Text('盘点：设为实际剩余')),
                  ],
                  onChanged: saving
                      ? null
                      : (v) => update(() => mode = v ?? 'consume'),
                ),
                TextField(
                  controller: quantity,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: mode == 'count'
                        ? '实际剩余 ${batch.displayUnit}数'
                        : '扣除 ${batch.displayUnit}数',
                    helperText: '最小可记录 1/${batch.parts} ${batch.displayUnit}',
                  ),
                ),
                TextField(
                  controller: note,
                  decoration: const InputDecoration(labelText: '备注（可选）'),
                ),
                if (error != null)
                  Text(
                    error!,
                    style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      final amount = double.tryParse(
                        quantity.text.replaceAll(',', '.'),
                      );
                      final n = amount == null
                          ? null
                          : (amount * batch.parts).round();
                      if (amount == null ||
                          amount < 0 ||
                          n == null ||
                          (amount * batch.parts - n).abs() > 0.000001 ||
                          (mode != 'count' && n <= 0)) {
                        update(() => error = '请输入符合最小分割单位的有效数量');
                        return;
                      }
                      final delta = mode == 'count' ? n - batch.remaining : -n;
                      if (batch.remaining + delta < 0) {
                        update(() => error = '剩余数量不能为负');
                        return;
                      }
                      update(() {
                        saving = true;
                        error = null;
                      });
                      try {
                        final db = ref.read(databaseProvider);
                        await db.transaction(() async {
                          await db.customStatement(
                            'UPDATE medication_inventory_batches SET remaining_parts = remaining_parts + ? WHERE id = ?',
                            [delta, batch.id],
                          );
                          await db.customStatement(
                            '''INSERT INTO medication_inventory_movements
                  (id, batch_id, delta_parts, kind, note, created_at) VALUES (?, ?, ?, ?, ?, ?)''',
                            [
                              const Uuid().v4(),
                              batch.id,
                              delta,
                              mode,
                              note.text.trim(),
                              DateTime.now().toIso8601String(),
                            ],
                          );
                        });
                        ref.invalidate(_inventoryBatchesProvider);
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        update(() {
                          saving = false;
                          error = '操作失败：$e';
                        });
                      }
                    },
              child: const Text('确认'),
            ),
          ],
        ),
      ),
    );
  } finally {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      quantity.dispose();
      note.dispose();
    });
  }
}

/// Edits a batch's descriptive data without silently changing stock quantities.
/// Changes to the splitting denominator are allowed only for an untouched batch,
/// and all subunit counts are re-scaled atomically to retain the same pill count.
Future<void> _editInventoryBatch(
  BuildContext context,
  WidgetRef ref,
  _Batch batch,
) async {
  final brand = TextEditingController(text: batch.brand);
  final strength = TextEditingController(text: _number(batch.strength));
  final pack = TextEditingController(text: batch.packSize.toString());
  final lot = TextEditingController(text: batch.batchNo);
  final expiry = TextEditingController(text: batch.expiry ?? '');
  final daily = TextEditingController(
    text: batch.daily == null ? '' : _number(batch.daily! / batch.parts),
  );
  var form = batch.form;
  var unit = batch.unit;
  var splitting = batch.splitStatus;
  var parts = batch.parts > 1 ? batch.parts : 2;
  var saving = false;
  String? error;

  try {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, update) => AlertDialog(
          title: const Text('编辑库存批次'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('当前剩余：${_number(batch.tablets)} ${batch.displayUnit}'),
                  const SizedBox(height: 6),
                  const Text('剩余数量请通过「使用 / 盘点」修改；购入数量和原始流水不会被改写。'),
                  TextField(
                    controller: brand,
                    decoration: const InputDecoration(labelText: '品牌 / 厂家'),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: form,
                    decoration: const InputDecoration(labelText: '剂型'),
                    items: const [
                      DropdownMenuItem(value: '片剂', child: Text('片剂')),
                      DropdownMenuItem(value: '胶囊', child: Text('胶囊')),
                    ],
                    onChanged: saving
                        ? null
                        : (v) => update(() {
                            form = v ?? '片剂';
                            if (form == '胶囊') splitting = 'no';
                          }),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: strength,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: '每片/粒含量 *',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 110,
                        child: DropdownButtonFormField<String>(
                          initialValue: unit,
                          decoration: const InputDecoration(labelText: '单位'),
                          items: const ['mg', 'µg', 'g', 'IU']
                              .map(
                                (u) =>
                                    DropdownMenuItem(value: u, child: Text(u)),
                              )
                              .toList(),
                          onChanged: saving
                              ? null
                              : (v) => update(() => unit = v ?? 'mg'),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: pack,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '每盒片数 *'),
                  ),
                  const SizedBox(height: 10),
                  Text('药片是否可分割？', style: Theme.of(ctx).textTheme.titleSmall),
                  if (form == '胶囊') const Text('胶囊不提供分片选项。'),
                  if (form != '胶囊') ...[
                    RadioListTile<String>(
                      title: const Text('不可分割'),
                      value: 'no',
                      groupValue: splitting,
                      onChanged: saving
                          ? null
                          : (v) => update(() => splitting = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('可以分割'),
                      value: 'yes',
                      groupValue: splitting,
                      onChanged: saving
                          ? null
                          : (v) => update(() => splitting = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('不确定'),
                      value: 'unknown',
                      groupValue: splitting,
                      onChanged: saving
                          ? null
                          : (v) => update(() => splitting = v!),
                    ),
                    if (splitting == 'yes')
                      DropdownButtonFormField<int>(
                        key: ValueKey('edit-split-$parts'),
                        initialValue: parts,
                        decoration: const InputDecoration(labelText: '最小可分割量'),
                        items: const [2, 4, 8]
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text('1/$v 片'),
                              ),
                            )
                            .toList(),
                        onChanged: saving
                            ? null
                            : (v) => update(() => parts = v ?? 2),
                      ),
                  ],
                  TextField(
                    controller: daily,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: '每日实际消耗片数（可留空）',
                      helperText: '例如 1 或 0.5；按片计数，不按 mg 自动换算',
                    ),
                  ),
                  TextField(
                    controller: lot,
                    decoration: const InputDecoration(labelText: '购入批号 / 批次'),
                  ),
                  TextField(
                    controller: expiry,
                    decoration: const InputDecoration(
                      labelText: '有效期 YYYY-MM-DD',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('允许分片及最小分片份数必须经药品说明书或药师确认。'),
                  if (error != null)
                    Text(
                      error!,
                      style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      final s = double.tryParse(
                        strength.text.trim().replaceAll(',', '.'),
                      );
                      final size = int.tryParse(pack.text.trim());
                      final newParts = splitting == 'yes' && form != '胶囊'
                          ? parts
                          : 1;
                      final perDay = daily.text.trim().isEmpty
                          ? null
                          : double.tryParse(
                              daily.text.trim().replaceAll(',', '.'),
                            );
                      final scaledDay = perDay == null
                          ? null
                          : (perDay * newParts).round();
                      final exp = expiry.text.trim();
                      final validExpiry =
                          exp.isEmpty ||
                          (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(exp) &&
                              DateTime.tryParse(exp) != null &&
                              DateFormat('yyyy-MM-dd')
                                      .format(DateTime.parse(exp)) ==
                                  exp);
                      if (s == null ||
                          !s.isFinite ||
                          s <= 0 ||
                          size == null ||
                          size <= 0 ||
                          !validExpiry ||
                          (perDay != null &&
                              (perDay <= 0 ||
                                  !perDay.isFinite ||
                                  (perDay * newParts - scaledDay!).abs() >
                                      0.000001))) {
                        update(() => error = '请检查药物规格、每盒片数、日期和每日实际片数。');
                        return;
                      }
                      update(() {
                        saving = true;
                        error = null;
                      });
                      try {
                        final db = ref.read(databaseProvider);
                        await db.transaction(() async {
                          final current = await db
                              .customSelect(
                                'SELECT remaining_parts, parts_per_unit FROM medication_inventory_batches WHERE id = ?',
                                variables: [Variable.withString(batch.id)],
                              )
                              .getSingle();
                          final oldParts = current.read<int>('parts_per_unit');
                          final remaining = current.read<int>(
                            'remaining_parts',
                          );
                          if (oldParts != newParts) {
                            final movements = await db
                                .customSelect(
                                  'SELECT id, delta_parts, kind FROM medication_inventory_movements WHERE batch_id = ?',
                                  variables: [Variable.withString(batch.id)],
                                )
                                .get();
                            // Prior consumption/stocktaking could include fractions.
                            // Do not modify or reinterpret historical movement records.
                            if (movements.any(
                              (m) => m.read<String>('kind') != 'purchase',
                            )) {
                              throw StateError(
                                '已有使用或盘点流水，无法改变最小分割份数。请保留原规则并新建另一批次。',
                              );
                            }
                            if ((remaining * newParts) % oldParts != 0 ||
                                movements.any(
                                  (m) =>
                                      (m.read<int>('delta_parts') * newParts) %
                                          oldParts !=
                                      0,
                                )) {
                              throw StateError('已有零散片数无法按新的分割规则精确表示。');
                            }
                            for (final m in movements) {
                              final converted =
                                  m.read<int>('delta_parts') *
                                  newParts ~/
                                  oldParts;
                              await db.customStatement(
                                'UPDATE medication_inventory_movements SET delta_parts = ? WHERE id = ?',
                                [converted, m.read<String>('id')],
                              );
                            }
                            await db.customStatement(
                              'UPDATE medication_inventory_batches SET remaining_parts = ?, parts_per_unit = ? WHERE id = ?',
                              [
                                remaining * newParts ~/ oldParts,
                                newParts,
                                batch.id,
                              ],
                            );
                          }
                          await db.customStatement(
                            'UPDATE medication_inventory_batches '
                            'SET brand = ?, batch_no = ?, form = ?, strength = ?, strength_unit = ?, '
                            'pack_size = ?, split_status = ?, daily_parts = ?, expiry_date = ? '
                            'WHERE id = ?',
                            [
                              brand.text.trim(),
                              lot.text.trim(),
                              form,
                              s,
                              unit,
                              size,
                              splitting,
                              scaledDay,
                              exp.isEmpty ? null : exp,
                              batch.id,
                            ],
                          );
                        });
                        ref.invalidate(_inventoryBatchesProvider);
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        if (ctx.mounted)
                          update(() {
                            saving = false;
                            error = '保存失败：$e';
                          });
                      }
                    },
              child: const Text('保存修改'),
            ),
          ],
        ),
      ),
    );
  } finally {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in [brand, strength, pack, lot, expiry, daily]) {
        c.dispose();
      }
    });
  }
}
