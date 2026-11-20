import '../../core/localization/display_i18n_v5.dart'; // HEALTHRECORD_DISPLAY_I18N_V5
import '../../core/localization/ui_i18n.dart'; // HEALTHRECORD_UI_I18N_V2

import 'package:flutter/material.dart';

import 'plot_settings.dart';
import '../../l10n/app_localizations.dart';
import '../../core/localization/app_locale.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PlotSettingsValue>(
      valueListenable: plotSettings,
      builder: (context, settings, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            AppLocalizations.of(context).settings,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ValueListenableBuilder<String>(
                valueListenable: appLocale,
                builder: (ctx, selection, _) => DropdownButtonFormField<String>(
                  key: ValueKey('language-$selection'),
                  initialValue: selection,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(ctx).language,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(AppLocalizations.of(ctx).systemLanguage),
                    ),
                    DropdownMenuItem(
                      value: 'zh',
                      child: Text(AppLocalizations.of(ctx).chinese),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(AppLocalizations.of(ctx).english),
                    ),
                    DropdownMenuItem(
                      value: 'de',
                      child: Text(AppLocalizations.of(ctx).german),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null)
                      appLocale.setLanguage(v).catchError((Object error) {
                        debugPrint('Unable to save language: $error');
                      });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LText(
                    '检查结果趋势图',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<PlotLessThanRule>(
                    key: ValueKey('rule-${settings.rule.name}'),
                    initialValue: settings.rule,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: DisplayI18nV5.tr(
                        context,
                        '小于号结果的绘图规则',
                        'Plotting rule for less-than results',
                        'Darstellung von Ergebnissen mit Kleiner-als-Zeichen',
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: PlotLessThanRule.threshold,
                        child: Text(
                          DisplayI18nV5.tr(
                            context,
                            '取阈值：<3 → 3',
                            'Use threshold: <3 → 3',
                            'Grenzwert verwenden: <3 → 3',
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: PlotLessThanRule.half,
                        child: Text(
                          DisplayI18nV5.tr(
                            context,
                            '取一半：<3 → 1.5',
                            'Use half: <3 → 1.5',
                            'Hälfte verwenden: <3 → 1,5',
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: PlotLessThanRule.custom,
                        child: Text(
                          DisplayI18nV5.tr(
                            context,
                            '自定义比例：<3 → 3 × 系数',
                            'Custom factor: <3 → 3 × factor',
                            'Eigener Faktor: <3 → 3 × Faktor',
                          ),
                        ),
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
                    Text(
                      '${DisplayI18nV5.tr(context, '绘图系数', 'Plot factor', 'Diagrammfaktor')}: ${settings.factor.toStringAsFixed(2)}',
                    ),
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
                  Text(
                    DisplayI18nV5.tr(
                      context,
                      '这个设置仅影响含 <、≤ 等界限值的图表绘制。原始检查结果始终保留，不会覆盖数据库中的检测数值。',
                      'This setting changes how limit values (<, ≤) are plotted. Original lab measurements are never overwritten.',
                      'Diese Einstellung betrifft nur die Darstellung von Grenzwerten (<, ≤). Originalwerte werden nicht überschrieben.',
                    ),
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
