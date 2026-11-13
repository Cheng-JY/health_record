#!/usr/bin/env python3
"""Integrate existing HealthRecord trends into each unified lab indicator detail.
Run at the HealthRecord project root. Uses exact guarded replacements and creates
backup files; leaves original data and Drift schema unchanged.
"""
from pathlib import Path
from datetime import datetime
import shutil
import sys

root = Path.cwd()
files = {
    'main': root / 'lib/main.dart',
    'lab': root / 'lib/features/labs/unified_lab_page.dart',
    'trend': root / 'lib/features/trends/unified_trends_page.dart',
}
for key, path in files.items():
    if not path.is_file():
        sys.exit(f'找不到文件：{path}。请先 cd 到 health_record 项目根目录。')
contents = {key: path.read_text(encoding='utf-8-sig') for key, path in files.items()}


def replace_one(text, old, new, description):
    amount = text.count(old)
    if amount != 1:
        raise ValueError(f'无法安全修改 {description}：预期找到 1 处，实际 {amount} 处。未写入任何文件。')
    return text.replace(old, new, 1)

try:
    main = contents['main']
    main = replace_one(main,
        "import 'features/trends/unified_trends_page.dart';\n", '', '删除独立趋势页导入')
    main = replace_one(main,
        '            UnifiedTrendsPage(),\n', '', '删除独立趋势页内容')
    main = replace_one(main,
        "          NavigationDestination(icon: Icon(Icons.show_chart), label: '趋势'),\n", '', '删除底部趋势导航')

    lab = contents['lab']
    lab = replace_one(lab,
        "import 'csv_result_edit_page.dart';\n",
        "import 'csv_result_edit_page.dart';\nimport '../trends/unified_trends_page.dart';\n",
        '导入趋势组件')
    lab = replace_one(lab,
        '  _IndicatorGroup(this.title, this.category, this.manualTest);\n',
        '  _IndicatorGroup(this.key, this.title, this.category, this.manualTest);\n  final String key;\n',
        '为指标组加入唯一识别码')
    lab = replace_one(lab,
        '_IndicatorGroup(test.nameZh, category, test)',
        '_IndicatorGroup(key, test.nameZh, category, test)',
        '手动结果指标标识')
    lab = replace_one(lab,
        '_IndicatorGroup(result.indicatorNameCn, category, null)',
        '_IndicatorGroup(key, result.indicatorNameCn, category, null)',
        'CSV结果指标标识')
    lab = replace_one(lab,
        'builder: (_) => _UnifiedDetailPage(group: group),',
        'builder: (_) => _UnifiedDetailPage(\n                    group: group, hospitalFilter: selectedHospital,\n                  ),',
        '详情页透传医院筛选')
    # Category headers now expand/collapse their indicator lists.
    # Default expanded, preserving the existing initial browsing experience.
    lab = replace_one(lab,
        """        for (final category in names) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
            child: Text(
              category,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (final group in byCategory[category]!)
            ListTile(
              title: Text(group.title),
              subtitle: Text(
                '最新：${DateFormat('yyyy-MM-dd').format(group.entries.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b))}',
              ),
              trailing: Text('${group.entries.length} 条'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _UnifiedDetailPage(
                    group: group, hospitalFilter: selectedHospital,
                  ),
                ),
              ),
            ),
        ],
""",
        """        for (final category in names)
          Card(
            margin: const EdgeInsets.fromLTRB(8, 6, 8, 0),
            child: ExpansionTile(
              key: PageStorageKey('lab-category-$category'),
              initiallyExpanded: true,
              title: Text(
                category,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                '${byCategory[category]!.length} 个指标',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              children: [
                for (final group in byCategory[category]!)
                  ListTile(
                    title: Text(group.title),
                    subtitle: Text(
                      '最新：${DateFormat('yyyy-MM-dd').format(group.entries.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b))}',
                    ),
                    trailing: Text('${group.entries.length} 条'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => _UnifiedDetailPage(
                          group: group, hospitalFilter: selectedHospital,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
""",
        '按分类折叠/展开检查指标列表')
    lab = replace_one(lab,
        '  const _UnifiedDetailPage({required this.group});\n  final _IndicatorGroup group;\n',
        '  const _UnifiedDetailPage({\n    required this.group,\n    required this.hospitalFilter,\n  });\n  final _IndicatorGroup group;\n  final String hospitalFilter;\n',
        '详情页增加医院筛选参数')
    lab = replace_one(lab,
        "          for (final item in sorted)\n            ListTile(",
        "          Padding(\n"
        "            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),\n"
        "            child: UnifiedTrendsPage(\n"
        "              indicatorKey: group.key,\n"
        "              hospitalFilter: hospitalFilter,\n"
        "              embedded: true,\n"
        "            ),\n"
        "          ),\n"
        "          Padding(\n"
        "            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),\n"
        "            child: Text('检查历史记录', style: Theme.of(context).textTheme.titleLarge),\n"
        "          ),\n"
        "          for (final item in sorted)\n"
        "            ListTile(",
        '在指标详情页显示趋势')

    trend = contents['trend']
    trend = replace_one(trend,
        '  const UnifiedTrendsPage({super.key});\n\n  @override',
        '  const UnifiedTrendsPage({\n'
        '    super.key,\n'
        '    this.indicatorKey,\n'
        "    this.hospitalFilter = 'all',\n"
        '    this.embedded = false,\n'
        '  });\n\n'
        '  /// Identifies the same code/name group used in UnifiedLabPage.\n'
        '  final String? indicatorKey;\n'
        '  final String hospitalFilter;\n'
        '  final bool embedded;\n\n'
        '  @override',
        '趋势页添加嵌入参数')
    trend = replace_one(trend,
        "  String selectedHospital = 'all';\n  _LessThanRule lessThanRule",
        "  String selectedHospital = 'all';\n\n"
        "  @override\n"
        "  void initState() {\n"
        "    super.initState();\n"
        "    selectedHospital = widget.hospitalFilter;\n"
        "    selectedKey = widget.indicatorKey;\n"
        "  }\n\n"
        "  _LessThanRule lessThanRule",
        '初始化医院和指标')
    has_category_selector = "labelText: '指标分类'" in trend
    if has_category_selector:
        trend = replace_one(trend,
            "    final key = categoryKeys.contains(selectedKey)\n",
            "    final key = widget.embedded\n"
            "        ? (series.containsKey(widget.indicatorKey) ? widget.indicatorKey : null)\n"
            "        : categoryKeys.contains(selectedKey)\n",
            '固定嵌入的指标（兼容已有分类选择器）')
    else:
        trend = replace_one(trend,
            "    final key = series.containsKey(selectedKey)\n",
            "    final key = widget.embedded\n"
            "        ? (series.containsKey(widget.indicatorKey) ? widget.indicatorKey : null)\n"
            "        : series.containsKey(selectedKey)\n",
            '固定嵌入的指标')
    trend = replace_one(trend,
        '    return ListView(\n      padding: const EdgeInsets.all(16),\n      children: [\n'
        "        Text('检查指标趋势', style: Theme.of(context).textTheme.headlineSmall),\n"
        '        const SizedBox(height: 8),\n'
        "        const Text('合并查看手动录入和 CSV 数据。不同单位分别显示；原始结果不会被修改。'),\n"
        '        const SizedBox(height: 16),\n'
        '        DropdownButtonFormField<String>(\n',
        '    return ListView(\n'
        '      shrinkWrap: widget.embedded,\n'
        '      physics: widget.embedded\n'
        '          ? const NeverScrollableScrollPhysics()\n'
        '          : null,\n'
        '      padding: widget.embedded ? EdgeInsets.zero : const EdgeInsets.all(16),\n'
        '      children: [\n'
        '        if (!widget.embedded) ...[\n'
        "          Text('检查指标趋势', style: Theme.of(context).textTheme.headlineSmall),\n"
        '          const SizedBox(height: 8),\n'
        "          const Text('合并查看手动录入和 CSV 数据。不同单位分别显示；原始结果不会被修改。'),\n"
        '          const SizedBox(height: 16),\n'
        '        ] else ...[\n'
        "          Text('趋势图', style: Theme.of(context).textTheme.titleLarge),\n"
        '          const SizedBox(height: 10),\n'
        '        ],\n'
        '        if (!widget.embedded) DropdownButtonFormField<String>(\n',
        '嵌入模式移除顶部简介和医院筛选')
    if has_category_selector:
        trend = replace_one(trend,
            '        const SizedBox(height: 16),\n        if (category == null) ...[\n',
            '        if (!widget.embedded) const SizedBox(height: 16),\n'
            '        if (widget.embedded ? key == null : category == null) ...[\n',
            '调整选择器间距（兼容已有分类选择器）')
    else:
        trend = replace_one(trend,
            '        const SizedBox(height: 16),\n        if (key == null) ...[\n',
            '        if (!widget.embedded) const SizedBox(height: 16),\n        if (key == null) ...[\n',
            '调整选择器间距')
    trend = replace_one(trend,
        "          const Text('当前医院没有可显示的趋势记录。'),",
        "          const Text('该指标当前没有可显示的趋势记录。'),",
        '嵌入空状态')
    if has_category_selector:
        trend = replace_one(trend,
            "          DropdownButtonFormField<String>(\n            key: ValueKey('category-$selected-$category'),",
            "          if (!widget.embedded) DropdownButtonFormField<String>(\n            key: ValueKey('category-$selected-$category'),",
            '嵌入模式隐藏分类下拉框')
        trend = replace_one(trend,
            "          DropdownButtonFormField<String>(\n            key: ValueKey('indicator-$category-$key'),",
            "          if (!widget.embedded) DropdownButtonFormField<String>(\n            key: ValueKey('indicator-$category-$key'),",
            '嵌入模式隐藏指标下拉框')
    else:
        trend = replace_one(trend,
            "          DropdownButtonFormField<String>(\n            key: ValueKey('indicator-$key'),",
            "          if (!widget.embedded) DropdownButtonFormField<String>(\n            key: ValueKey('indicator-$key'),",
            '嵌入模式隐藏指标下拉框')
    trend = replace_one(trend,
        "          const SizedBox(height: 18),\n          Text('历史记录', style: Theme.of(context).textTheme.titleLarge),\n          for (final p in plotted.reversed)\n",
        "          if (!widget.embedded) const SizedBox(height: 18),\n"
        "          if (!widget.embedded)\n"
        "            Text('历史记录', style: Theme.of(context).textTheme.titleLarge),\n"
        "          for (final p in widget.embedded ? <_PlottedPoint>[] : plotted.reversed)\n",
        '避免在详情页重复显示历史')
    trend = replace_one(trend,
        "          const SizedBox(height: 12),\n          const Text('提示：界限值的绘图替代数值不是实际检测结果；不同医院或检测方法的参考范围可能不同。'),",
        "          const SizedBox(height: 12),\n"
        "          const Text('提示：界限值的绘图替代数值不是实际检测结果；不同医院或检测方法的参考范围可能不同。'),",
        '保留风险提示') if False else trend

    changed = {'main': main, 'lab': lab, 'trend': trend}
    for key, path in files.items():
        original = contents[key]
        if changed[key] == original:
            raise ValueError(f'{path} 没有发生修改')
    stamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    for key, path in files.items():
        backup = path.with_name(path.name + f'.before_integrated_trends_{stamp}.bak')
        shutil.copy2(path, backup)
    for key, path in files.items():
        path.write_text(changed[key], encoding='utf-8')
    print('✅ 已将趋势图整合至检查指标详情页，且移除底部独立趋势导航。')
    print('✅ 原文件已备份为 .bak；数据库未修改。')
    print('下一步：dart format lib/main.dart lib/features/labs/unified_lab_page.dart lib/features/trends/unified_trends_page.dart')
    print('然后运行 flutter analyze')
except Exception as exc:
    sys.exit(f'❌ {exc}')
