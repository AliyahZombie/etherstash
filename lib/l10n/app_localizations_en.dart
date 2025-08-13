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
}
