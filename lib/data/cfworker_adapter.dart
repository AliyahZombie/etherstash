
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import 'cloud_sync_adapter.dart';

/// Cloudflare Worker implementation of CloudSyncAdapter.
///
/// It reads base URL and auth key from SharedPreferences using the same keys as
/// SettingsPage: 'worker_base_url' and 'worker_auth_key'.
class CFWorkerAdapter implements CloudSyncAdapter {
  static const String _kBaseUrlKey = 'worker_base_url';
  static const String _kAuthKey = 'worker_auth_key';

  CFWorkerAdapter();

  Future<_Config> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final base = (prefs.getString(_kBaseUrlKey) ?? '').trim();
    final key = (prefs.getString(_kAuthKey) ?? '').trim();
    if (base.isEmpty || key.isEmpty) {
      throw StateError('Missing base URL or auth key. Please configure settings.');
    }
    final normalized = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    return _Config(baseUrl: normalized, authKey: key);
  }

  Map<String, String> _headers(String authKey, {Map<String, String>? extra}) {
    return {
      'Authorization': 'Bearer $authKey',
      if (extra != null) ...extra,
    };
  }

  @override
  Future<List<Note>> getNotes() async {
    final cfg = await _loadConfig();
    final uri = Uri.parse('${cfg.baseUrl}/notes');
    final resp = await http.get(uri, headers: _headers(cfg.authKey)).timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) {
      throw http.ClientException('GET /notes failed: ${resp.statusCode}', uri);
    }
    final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
    final notes = data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
    // Ensure newest first just in case
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  @override
  Future<Note> saveNote(Note note) async {
    final cfg = await _loadConfig();
    final uri = Uri.parse('${cfg.baseUrl}/saveNote');
    final body = jsonEncode({
      'id': note.id,
      'content': note.content,
    });
    final resp = await http
        .post(
          uri,
          headers: _headers(cfg.authKey, extra: {'Content-Type': 'application/json'}),
          body: body,
        )
        .timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) {
      throw http.ClientException('POST /saveNote failed: ${resp.statusCode} ${resp.body}', uri);
    }
    final Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
    return Note.fromJson(data);
  }

  @override
  Future<Note> deleteNote(Note note) async {
    final cfg = await _loadConfig();
    final uri = Uri.parse('${cfg.baseUrl}/deleteNote/${Uri.encodeComponent(note.id)}');
    final resp = await http
        .delete(
          uri,
          headers: _headers(cfg.authKey),
        )
        .timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) {
      throw http.ClientException('DELETE /deleteNote failed: ${resp.statusCode}', uri);
    }
    final Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
    return Note.fromJson(data);
  }
}

class _Config {
  final String baseUrl;
  final String authKey;
  const _Config({required this.baseUrl, required this.authKey});
}
