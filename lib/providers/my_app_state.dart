import 'dart:collection';

import 'package:flutter/material.dart';
import '../models/note.dart';
import '../data/note_repo.dart';

class MyAppState extends ChangeNotifier { 
    List<Note> _notes = [];
    final Noterepo _noteRepo = Noterepo();

    UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);

    MyAppState(){
        _notes = _noteRepo.getNotes();
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