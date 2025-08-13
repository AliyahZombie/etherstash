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

    MyAppState(){
        _notes = _noteRepo.getNotes();
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

    void saveNote(Note note){
        // 检查笔记是否已存在
        bool noteExists = _notes.any((element) => element.id == note.id);
        
        if (noteExists) {
            // 更新现有笔记
            _noteRepo.saveNote(note);
            _notes = _noteRepo.getNotes();
        } else {
            // 添加新笔记
            _noteRepo.saveNote(note);
            _notes = _noteRepo.getNotes();
        }
        notifyListeners();
    } 

    void deleteNote(Note note){
        _notes.remove(note);
        _noteRepo.deleteNote(note);
        notifyListeners();
    }
}