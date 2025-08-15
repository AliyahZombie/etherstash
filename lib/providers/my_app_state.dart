import 'dart:collection';

import 'package:flutter/material.dart';
import '../models/note.dart';
import '../data/note_repo.dart';

class MyAppState extends ChangeNotifier { 
    List<Note> _notes = [];
    final Noterepo _noteRepo = Noterepo();
    String _searchParam = '';

    UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);
    String get searchParam => _searchParam;

    MyAppState() {
      loadNotes();
      
    }

    void loadNotes() async {
      _notes = await _noteRepo.getNotes();
      notifyListeners();
    }

    void updateSearchParam(String newParam) {
      _searchParam = newParam;
      notifyListeners(); // 这一步至关重要，它会触发UI刷新！
    }

    List<Note> get filteredNotes {
    // 如果搜索词是空的，就返回全部笔记
    if (searchParam.isEmpty) {
      return _notes;
    } else {
      // 否则，进行筛选
      return _notes.where((note) {
        // 在笔记内容中进行不区分大小写的搜索
        final contentLower = note.content.toLowerCase();
        final searchLower = searchParam.toLowerCase();
        return contentLower.contains(searchLower);
      }).toList();
    }
}

    void saveNote(Note note) async{
      await _noteRepo.saveNote(note);
      _notes = await _noteRepo.getNotes();
      notifyListeners();
    } 

    void deleteNote(Note note) async{
        _noteRepo.deleteNote(note);
        _notes = await _noteRepo.getNotes();
        notifyListeners();
    }
}