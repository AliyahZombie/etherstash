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
}
