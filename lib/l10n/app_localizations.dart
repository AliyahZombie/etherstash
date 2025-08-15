import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'EtherStash'**
  String get app_name;

  /// No description provided for @empty_note_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Tap to edit...'**
  String get empty_note_placeholder;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search_bar_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Search your notes...'**
  String get search_bar_hint_text;

  /// No description provided for @no_notes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get no_notes;

  /// No description provided for @no_matches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get no_matches;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @worker_settings.
  ///
  /// In en, this message translates to:
  /// **'Worker Settings'**
  String get worker_settings;

  /// No description provided for @base_url.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get base_url;

  /// No description provided for @base_url_hint.
  ///
  /// In en, this message translates to:
  /// **'https://your-worker.example.workers.dev'**
  String get base_url_hint;

  /// No description provided for @auth_key.
  ///
  /// In en, this message translates to:
  /// **'Auth Key'**
  String get auth_key;

  /// No description provided for @auth_key_hint.
  ///
  /// In en, this message translates to:
  /// **'Your secret key'**
  String get auth_key_hint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @verify_connection.
  ///
  /// In en, this message translates to:
  /// **'Verify connection'**
  String get verify_connection;

  /// No description provided for @saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get saved_successfully;

  /// No description provided for @save_failed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get save_failed;

  /// No description provided for @connection_verified.
  ///
  /// In en, this message translates to:
  /// **'Connection verified'**
  String get connection_verified;

  /// No description provided for @unauthorized_invalid_key.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized: invalid key'**
  String get unauthorized_invalid_key;

  /// No description provided for @verify_error.
  ///
  /// In en, this message translates to:
  /// **'Verify error'**
  String get verify_error;

  /// No description provided for @failed_http.
  ///
  /// In en, this message translates to:
  /// **'Failed: HTTP {code}'**
  String failed_http(Object code);

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @tips_base_url.
  ///
  /// In en, this message translates to:
  /// **'• Base URL: your Worker domain, e.g. https://your-worker.example.workers.dev'**
  String get tips_base_url;

  /// No description provided for @tips_auth.
  ///
  /// In en, this message translates to:
  /// **'• Authorization: send Authorization: Bearer {AUTH_SECRET_KEY}'**
  String tips_auth(Object AUTH_SECRET_KEY);

  /// No description provided for @tips_content_type.
  ///
  /// In en, this message translates to:
  /// **'• Content-Type: application/json for requests with body'**
  String get tips_content_type;

  /// No description provided for @base_url_required.
  ///
  /// In en, this message translates to:
  /// **'Base URL is required'**
  String get base_url_required;

  /// No description provided for @invalid_url.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL'**
  String get invalid_url;

  /// No description provided for @auth_key_required.
  ///
  /// In en, this message translates to:
  /// **'Auth Key is required'**
  String get auth_key_required;

  /// No description provided for @enable_worker_sync.
  ///
  /// In en, this message translates to:
  /// **'Enable Worker Sync'**
  String get enable_worker_sync;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @sync_success.
  ///
  /// In en, this message translates to:
  /// **'Sync successful'**
  String get sync_success;

  /// No description provided for @sync_failed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get sync_failed;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
