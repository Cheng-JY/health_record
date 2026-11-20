import '../../core/localization/ui_i18n.dart'; // HEALTHRECORD_UI_I18N_V2

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'sync_engine.dart';

class HealthSyncPage extends ConsumerStatefulWidget {
  const HealthSyncPage({super.key});

  @override
  ConsumerState<HealthSyncPage> createState() => _HealthSyncPageState();
}

class _HealthSyncPageState extends ConsumerState<HealthSyncPage> {
  final url = TextEditingController();
  final token = TextEditingController();
  bool busy = false;
  String status = '未连接';
  bool revealToken = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = SharedPreferencesAsync();
    final storedUrl = await prefs.getString(HealthSyncEngine.urlKey);
    final storedToken = await prefs.getString(HealthSyncEngine.tokenKey);
    final saved = await prefs.getString(HealthSyncEngine.lastResultKey);
    if (!mounted) return;
    setState(() {
      url.text =
          storedUrl ??
          (Uri.base.scheme == 'https'
              ? Uri.base.origin
              : 'http://127.0.0.1:8765');
      token.text = storedToken ?? '';
      status = saved ?? '尚未同步';
    });
  }

  @override
  void dispose() {
    url.dispose();
    token.dispose();
    super.dispose();
  }

  Future<void> _saveAndSync() async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await HealthSyncEngine.configure(url.text, token.text);
      final result = await HealthSyncEngine.run(ref.read(databaseProvider));
      if (!mounted) return;
      setState(() => status = result.message);
      if (result.reload) html.window.location.reload();
    } catch (e) {
      if (mounted) setState(() => status = '配置失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const LText('Mac ↔ iPhone 同步')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const LText('实验性自动同步（页面打开期间每45秒检查）。只有单端有变化时自动传输；两端都改动则暂停，绝不悄悄覆盖。'),
        const SizedBox(height: 16),
        TextField(
          controller: url,
          decoration: const InputDecoration(
            labelText: '同步服务地址',
            hintText: 'https://mac-name.tailnet.ts.net',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: token,
          obscureText: !revealToken,
          decoration: InputDecoration(
            labelText: '同步密钥（仅从 Mac 本地复制）',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(revealToken ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => revealToken = !revealToken),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: busy ? null : _saveAndSync,
          icon: const Icon(Icons.sync),
          label: Text(busy ? '正在检查……' : '保存配置并立即同步'),
        ),
        const SizedBox(height: 16),
        SelectableText('状态：$status'),
        const SizedBox(height: 20),
        const LText(
          '重要：请先分别导出 Mac 和 iPhone 的 JSON 备份。首次配对时，如果两端已有不同医疗记录，系统不会自动合并。',
        ),
        const SizedBox(height: 8),
        const LText(
          '同步节点需要 Mac 持续开机并运行。仅通过 Tailscale Serve 私有 HTTPS 地址访问，不要使用公网 Funnel。',
        ),
        const SizedBox(height: 8),
        const LText(
          '此版本是完整快照同步，不是逐条合并；跨设备同时编辑会暂停并等待人工处理。备份在 Mac 磁盘上为明文，请启用 FileVault。',
        ),
      ],
    ),
  );
}
