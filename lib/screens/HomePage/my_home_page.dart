import 'package:etherstash/l10n/app_localizations.dart';
import 'package:etherstash/l10n/app_localizations_zh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note.dart';
import '../../providers/my_app_state.dart';
import 'views/note_list_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.app_name),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          tooltip: AppLocalizations.of(context)!.add,
          onPressed: () {
            context.read<MyAppState>().saveNote(Note(id: DateTime.now().millisecondsSinceEpoch.toString(), content: '',createdAt: DateTime.now()));
          },
        ),
      ],
    ),
    body: NoteListView(),
    );
  }
}
