import 'package:flutter/material.dart';

import 'plot_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PlotSettingsValue>(
      valueListenable: plotSettings,
      builder: (context, settings, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('设置', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '检查结果趋势图',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<PlotLessThanRule>(
                    key: ValueKey('rule-${settings.rule.name}'),
                    initialValue: settings.rule,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: '小于号结果的绘图规则',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: PlotLessThanRule.threshold,
                        child: Text('取阈值：<3 → 3'),
                      ),
                      DropdownMenuItem(
                        value: PlotLessThanRule.half,
                        child: Text('取一半：<3 → 1.5'),
                      ),
                      DropdownMenuItem(
                        value: PlotLessThanRule.custom,
                        child: Text('自定义比例：<3 → 3 × 系数'),
                      ),
                    ],
                    onChanged: (rule) {
                      if (rule != null) {
                        plotSettings.setRule(rule).catchError((Object error) {
                          debugPrint('Failed to save plot rule: $error');
                        });
                      }
                    },
                  ),
                  if (settings.rule == PlotLessThanRule.custom) ...[
                    const SizedBox(height: 18),
                    Text('绘图系数：${settings.factor.toStringAsFixed(2)}'),
                    Slider(
                      value: settings.factor,
                      min: 0.05,
                      max: 1,
                      divisions: 19,
                      label: settings.factor.toStringAsFixed(2),
                      onChanged: (factor) {
                        plotSettings.setFactor(factor).catchError((
                          Object error,
                        ) {
                          debugPrint('Failed to save plot factor: $error');
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    '这个设置仅影响含 <、≤ 等界限值的图表绘制。原始检查结果始终保留，不会覆盖数据库中的检测数值。',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
