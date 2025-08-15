// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get app_name => '以太笔记';

  @override
  String get empty_note_placeholder => '点击添加内容...';

  @override
  String get add => '添加';

  @override
  String get search_bar_hint_text => '搜索你的笔记...';

  @override
  String get no_notes => '无笔记';

  @override
  String get no_matches => '无匹配项';

  @override
  String get settings => '设置';

  @override
  String get worker_settings => 'Worker 设置';

  @override
  String get base_url => '基础地址';

  @override
  String get base_url_hint => 'https://your-worker.example.workers.dev';

  @override
  String get auth_key => '认证密钥';

  @override
  String get auth_key_hint => '你的密钥';

  @override
  String get save => '保存';

  @override
  String get verify_connection => '验证连接';

  @override
  String get saved_successfully => '保存成功';

  @override
  String get save_failed => '保存失败';

  @override
  String get connection_verified => '连接成功';

  @override
  String get unauthorized_invalid_key => '未授权：无效密钥';

  @override
  String get verify_error => '验证出错';

  @override
  String failed_http(Object code) {
    return '失败：HTTP $code';
  }

  @override
  String get tips => '提示';

  @override
  String get tips_base_url => '• 基础地址：你的 Worker 域名，例如 https://your-worker.example.workers.dev';

  @override
  String tips_auth(Object AUTH_SECRET_KEY) {
    return '• 认证：使用 Authorization: Bearer $AUTH_SECRET_KEY';
  }

  @override
  String get tips_content_type => '• 内容类型：带请求体时使用 application/json';

  @override
  String get base_url_required => '请输入基础地址';

  @override
  String get invalid_url => 'URL 不合法';

  @override
  String get auth_key_required => '请输入认证密钥';

  @override
  String get enable_worker_sync => '启用 Worker 同步';

  @override
  String get refresh => '刷新';

  @override
  String get sync_success => '同步成功';

  @override
  String get sync_failed => '同步失败';

  @override
  String get syncing => '正在同步...';
}
