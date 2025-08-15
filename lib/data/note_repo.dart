import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

/// Local-only Note repository. Networking has been disabled for redesign.
class Noterepo {
  final Box<Note> _noteBox = Hive.box<Note>('notes');

  Noterepo();


  Future<List<Note>> fetchRemoteNotes() async {
    return getNotes();
  }


  Future<List<Note>> getNotes() async {
    final notes = _noteBox.values.toList();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }


  Future<void> saveNote(Note note) async {
    await _noteBox.put(note.id, note);
  }


  Future<void> deleteNote(Note note) async {
    await _noteBox.delete(note.id);
  }

}
