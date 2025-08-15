import 'dart:io';

import 'package:etherstash/l10n/app_localizations.dart';
import 'package:etherstash/screens/HomePage/views/serach_bar.dart';
import 'package:etherstash/screens/SettingsPage/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../../models/note.dart';
import '../../providers/my_app_state.dart';
import 'views/note_list_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TrayListener {
  var selectedIndex = 0;
  var _isSearching = false;

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'exit_app') {
        windowManager.close();
    }
  }

  Future<void> _initTrayIcon() async {
    await trayManager.setIcon(
      'images/tray_icon.png', 
    );
    await trayManager.setToolTip('EtherStash');
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'exit_app',
          label: 'Exit App',
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown ()async {
      bool isVisible = await windowManager.isVisible();
      isVisible ? await windowManager.hide() : await windowManager.show();
    }

  @override
  void onTrayIconRightMouseDown () async {
      trayManager.popUpContextMenu();
    }

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      trayManager.addListener(this);
      _initTrayIcon();
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.syncing)),
        );
    context.read<MyAppState>().sync().then(
              (value){
                if(value&&mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.sync_success)),
                  );
                }
                else if(!value&&mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.sync_failed)),
                  );
                }
              }
            );
    });

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: GestureDetector(
        onTap: () {
          setState(() {
            _isSearching = true;
          });

        },
        child: SearchView(
          isSearching: _isSearching, 
          onClose: () {
            context.read<MyAppState>().updateSearchParam("");
            setState(() {
              _isSearching = false;
            });
        })
        ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          tooltip: AppLocalizations.of(context)!.refresh,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.syncing)),
            );
            context.read<MyAppState>().sync().then(
              (value){
                if(value&&context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.sync_success)),
                  );
                }
                else if(!value&&context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.sync_failed)),
                  );
                }
              }
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          tooltip: AppLocalizations.of(context)!.add,
          onPressed: () {
            context.read<MyAppState>().saveNote(Note(id: DateTime.now().millisecondsSinceEpoch.toString(), content: '',createdAt: DateTime.now()));
          },
        ),
        IconButton(
          icon: Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(builder:   (context) => SettingsPage()));
          },
        ),
      ],
    ),
    body: NoteListView()
    );
  }
}

class SearchView extends StatelessWidget {
  final bool isSearching;
  final Function()? onClose;
  const SearchView({
    super.key,
    required this.isSearching,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return BeautifulSearchBar(
        onChanged: (value) {
          print(value);
          context.read<MyAppState>().updateSearchParam(value);
        },
        onClose: () {
          if(onClose != null){
            onClose!();
          }
        },
      );
    }
    else{
      return GestureDetector(
        child: Text(AppLocalizations.of(context)!.app_name));
      }
    
  }
}
