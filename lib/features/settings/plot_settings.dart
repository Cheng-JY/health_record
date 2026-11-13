import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Only controls how less-than measurement results appear on charts.
/// Never overwrites the original lab value saved in the database.
enum PlotLessThanRule { threshold, half, custom }

class PlotSettingsValue {
  const PlotSettingsValue({
    this.rule = PlotLessThanRule.threshold,
    this.factor = 0.95,
  });
  final PlotLessThanRule rule;
  final double factor;
}

class PlotSettings extends ValueNotifier<PlotSettingsValue> {
  PlotSettings() : super(const PlotSettingsValue());

  static const _ruleKey = 'health_record_plot_less_than_rule';
  static const _factorKey = 'health_record_plot_factor';
  final _prefs = SharedPreferencesAsync();

  Future<void> load() async {
    try {
      final name = await _prefs.getString(_ruleKey);
      final factor = await _prefs.getDouble(_factorKey);
      value = PlotSettingsValue(
        rule: PlotLessThanRule.values.firstWhere(
          (rule) => rule.name == name,
          orElse: () => PlotLessThanRule.threshold,
        ),
        factor: (factor ?? 0.95).clamp(0.05, 1.0).toDouble(),
      );
    } catch (error) {
      debugPrint('Failed to load chart preferences: $error');
    }
  }

  Future<void> setRule(PlotLessThanRule rule) async {
    value = PlotSettingsValue(rule: rule, factor: value.factor);
    await _prefs.setString(_ruleKey, rule.name);
  }

  Future<void> setFactor(double factor) async {
    final safeFactor = factor.clamp(0.05, 1.0).toDouble();
    value = PlotSettingsValue(rule: value.rule, factor: safeFactor);
    await _prefs.setDouble(_factorKey, safeFactor);
  }
}

final plotSettings = PlotSettings();
