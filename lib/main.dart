import 'dart:io';

import 'package:etherstash/models/note.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:window_manager/window_manager.dart';

import 'providers/my_app_state.dart';
import 'package:etherstash/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/HomePage/my_home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
  if(Platform.isWindows){
      await windowManager.ensureInitialized();
  }
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'EtherStash',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

