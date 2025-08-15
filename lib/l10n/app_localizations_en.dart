// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'EtherStash';

  @override
  String get empty_note_placeholder => 'Tap to edit...';

  @override
  String get add => 'Add';

  @override
  String get search_bar_hint_text => 'Search your notes...';

  @override
  String get no_notes => 'No notes';

  @override
  String get no_matches => 'No matches';

  @override
  String get settings => 'Settings';

  @override
  String get worker_settings => 'Worker Settings';

  @override
  String get base_url => 'Base URL';

  @override
  String get base_url_hint => 'https://your-worker.example.workers.dev';

  @override
  String get auth_key => 'Auth Key';

  @override
  String get auth_key_hint => 'Your secret key';

  @override
  String get save => 'Save';

  @override
  String get verify_connection => 'Verify connection';

  @override
  String get saved_successfully => 'Saved successfully';

  @override
  String get save_failed => 'Save failed';

  @override
  String get connection_verified => 'Connection verified';

  @override
  String get unauthorized_invalid_key => 'Unauthorized: invalid key';

  @override
  String get verify_error => 'Verify error';

  @override
  String failed_http(Object code) {
    return 'Failed: HTTP $code';
  }

  @override
  String get tips => 'Tips';

  @override
  String get tips_base_url => '• Base URL: your Worker domain, e.g. https://your-worker.example.workers.dev';

  @override
  String tips_auth(Object AUTH_SECRET_KEY) {
    return '• Authorization: send Authorization: Bearer $AUTH_SECRET_KEY';
  }

  @override
  String get tips_content_type => '• Content-Type: application/json for requests with body';

  @override
  String get base_url_required => 'Base URL is required';

  @override
  String get invalid_url => 'Invalid URL';

  @override
  String get auth_key_required => 'Auth Key is required';

  @override
  String get enable_worker_sync => 'Enable Worker Sync';

  @override
  String get refresh => 'Refresh';

  @override
  String get sync_success => 'Sync successful';

  @override
  String get sync_failed => 'Sync failed';

  @override
  String get syncing => 'Syncing...';

  @override
  String get platform_settings => 'Platform Settings';

  @override
  String platform_hint(Object platform) {
    return 'EtherStash on $platform';
  }
}
