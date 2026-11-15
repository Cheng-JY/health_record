import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import '../backup/backup_service.dart';

/// Experimental, conflict-stopping whole-snapshot replication for Flutter Web.
/// Never silently overwrites divergent medical histories.
class SyncOutcome {
  const SyncOutcome(this.message, {this.reload = false, this.conflict = false});
  final String message;
  final bool reload;
  final bool conflict;
}

class HealthSyncEngine {
  static const urlKey = 'healthrecord_sync_url_v1';
  static const tokenKey = 'healthrecord_sync_token_v1';
  static const baseRevisionKey = 'healthrecord_sync_base_revision_v1';
  static const baseHashKey = 'healthrecord_sync_base_hash_v1';
  static const lastResultKey = 'healthrecord_sync_last_result_v1';
  static bool _busy = false;

  static String _fingerprint(Map<String, dynamic> snapshot) {
    final tables = snapshot['tables'] as Map<String, dynamic>;
    final normalized = <String, List<String>>{};
    final tableNames = tables.keys.toList()..sort();
    for (final table in tableNames) {
      final rows = tables[table] as List;
      final encoded = <String>[];
      for (final value in rows) {
        final row = Map<String, dynamic>.from(value as Map);
        final keys = row.keys.toList()..sort();
        encoded.add(jsonEncode({for (final key in keys) key: row[key]}));
      }
      encoded.sort();
      normalized[table] = encoded;
    }
    return sha256.convert(utf8.encode(jsonEncode(normalized))).toString();
  }

  static bool _hasPersonalData(Map<String, dynamic> snapshot) {
    final tables = snapshot['tables'] as Map<String, dynamic>;
    // Seeded lab category/test definitions alone do not count as user data.
    for (final entry in tables.entries) {
      if (entry.key == 'lab_categories' || entry.key == 'lab_tests') continue;
      if ((entry.value as List).isNotEmpty) return true;
    }
    return false;
  }

  static String _validatedUrl(String url) {
    final parsed = Uri.tryParse(url.trim());
    if (parsed == null ||
        parsed.host.isEmpty ||
        parsed.hasQuery ||
        parsed.hasFragment ||
        (parsed.scheme != 'https' &&
            !(parsed.scheme == 'http' &&
                (parsed.host == '127.0.0.1' || parsed.host == 'localhost')))) {
      throw const FormatException(
        '同步地址必须是 HTTPS，或 Mac 本机 http://127.0.0.1:8765',
      );
    }
    final clean = url.trim().replaceAll(RegExp(r'/+$'), '');
    return '$clean/api/snapshot';
  }

  static Future<void> configure(String url, String token) async {
    if (token.trim().length < 20) throw const FormatException('同步密钥长度不足');
    _validatedUrl(url);
    final prefs = SharedPreferencesAsync();
    final oldUrl = await prefs.getString(urlKey);
    final oldToken = await prefs.getString(tokenKey);
    if ((oldUrl != null && oldUrl != url.trim()) ||
        (oldToken != null && oldToken != token.trim())) {
      // Pairing against a different server requires a new baseline.
      await prefs.remove(baseRevisionKey);
      await prefs.remove(baseHashKey);
    }
    await prefs.setString(urlKey, url.trim());
    await prefs.setString(tokenKey, token.trim());
  }

  static Future<SyncOutcome> run(AppDatabase db) async {
    if (_busy) return const SyncOutcome('同步进行中');
    _busy = true;
    try {
      final prefs = SharedPreferencesAsync();
      final url = await prefs.getString(urlKey);
      final token = await prefs.getString(tokenKey);
      if (url == null || url.isEmpty || token == null || token.isEmpty) {
        return const SyncOutcome('尚未配置同步');
      }
      final endpoint = Uri.parse(_validatedUrl(url));
      final headers = <String, String>{
        'X-HealthRecord-Token': token,
        'Content-Type': 'application/json; charset=utf-8',
      };
      final response = await http
          .get(endpoint, headers: headers)
          .timeout(const Duration(seconds: 25));
      if (response.statusCode != 200) {
        return SyncOutcome('无法读取同步节点（HTTP ${response.statusCode}）');
      }
      final remote =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final revision = (remote['revision'] as num).toInt();
      final remoteRaw = remote['snapshot'];
      final service = HealthRecordBackupService(db);
      final localText = await service.exportJson();
      final local = jsonDecode(localText) as Map<String, dynamic>;
      if (local['schemaVersion'] != 11) {
        return const SyncOutcome('仅支持 v11 数据库，请先升级版本');
      }
      final localHash = _fingerprint(local);
      Map<String, dynamic>? remoteSnapshot;
      String? remoteHash;
      if (remoteRaw != null) {
        remoteSnapshot = Map<String, dynamic>.from(remoteRaw as Map);
        service.inspect(jsonEncode(remoteSnapshot));
        if (remoteSnapshot['schemaVersion'] != 11) {
          return const SyncOutcome('远端数据库版本不一致，已停止同步');
        }
        remoteHash = _fingerprint(remoteSnapshot);
      }
      final baseHash = await prefs.getString(baseHashKey);
      final baseRevision = await prefs.getInt(baseRevisionKey);

      Future<SyncOutcome> remember(
        String message,
        String hash,
        int rev, {
        bool reload = false,
      }) async {
        await prefs.setString(baseHashKey, hash);
        await prefs.setInt(baseRevisionKey, rev);
        await prefs.setString(
          lastResultKey,
          '${DateTime.now().toLocal().toIso8601String()} · $message',
        );
        return SyncOutcome(message, reload: reload);
      }

      Future<SyncOutcome> conflict(String reason) async {
        const warning = '发现双端数据差异，已暂停自动覆盖。请先分别导出两端备份。';
        await prefs.setString(lastResultKey, '$warning $reason');
        return const SyncOutcome(warning, conflict: true);
      }

      Future<SyncOutcome> push() async {
        final put = await http
            .post(
              endpoint,
              headers: headers,
              body: jsonEncode({'baseRevision': revision, 'snapshot': local}),
            )
            .timeout(const Duration(seconds: 60));
        if (put.statusCode == 409) return conflict('远端刚刚更新');
        if (put.statusCode != 200) {
          return SyncOutcome('上传失败（HTTP ${put.statusCode}）');
        }
        final result =
            jsonDecode(utf8.decode(put.bodyBytes)) as Map<String, dynamic>;
        return remember(
          '已上传到 Mac 同步节点',
          localHash,
          (result['revision'] as num).toInt(),
        );
      }

      Future<SyncOutcome> pull() async {
        final snapshot = remoteSnapshot;
        final hash = remoteHash;
        if (snapshot == null || hash == null) {
          return conflict('远端缺少快照');
        }
        // restoreJson performs a transactional, validated replacement.
        await service.restoreJson(jsonEncode(snapshot));
        return remember('已从 Mac 同步节点更新本机，正在刷新页面', hash, revision, reload: true);
      }

      if (remoteHash == localHash) {
        return remember('两端数据一致', localHash, revision);
      }
      // First-pair recovery: if the device has no medical records and the
      // server has a validated snapshot, download it even if an earlier
      // buggy waiting state recorded a baseline. Never overwrite personal data.
      if (remoteSnapshot != null && !_hasPersonalData(local)) {
        return pull();
      }
      if (baseHash == null || baseRevision == null) {
        if (remoteSnapshot == null) {
          if (!_hasPersonalData(local)) {
            // FIRST_PAIR_EMPTY_DEVICE_FIX_V1
            // An empty device must not establish a baseline before any
            // server snapshot exists. Seed catalog differences are not edits.
            return const SyncOutcome('已连接：等待 Mac 上传首条数据');
          }
          return push();
        }
        if (!_hasPersonalData(local)) return pull();
        return conflict('首次配对时两端均已有数据');
      }

      // If the server was reset, never silently destroy its paired history.
      if (remoteSnapshot == null && baseRevision != 0) {
        return conflict('服务器数据已重置');
      }
      if (remoteHash == baseHash && localHash != baseHash) return push();
      if (localHash == baseHash && remoteHash != baseHash) return pull();
      if (remoteHash == null && revision == 0 && baseRevision == 0)
        return push();
      return conflict('双方都修改了数据');
    } catch (error) {
      final message = '同步暂不可用：$error';
      try {
        await SharedPreferencesAsync().setString(lastResultKey, message);
      } catch (_) {}
      return SyncOutcome(message);
    } finally {
      _busy = false;
    }
  }
}
