import 'package:etherstash/data/cfworker_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class Noterepo {
  final Box<Note> _noteBox = Hive.box<Note>('notes');

  Noterepo();

  Future<List<Note>> getNotes() async {
    final notes = _noteBox.values.toList();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<void> saveNote(Note note) async {
    await _noteBox.put(note.id, note);
    SharedPreferences.getInstance().then((prefs) {
      if(prefs.getBool('worker_enabled') == true){
        final adapter = CFWorkerAdapter();
        adapter.saveNote(note);
      }
    });
  }

  Future<void> deleteNote(Note note) async {
    await _noteBox.delete(note.id);
    SharedPreferences.getInstance().then((prefs) {
      if(prefs.getBool('worker_enabled') == true){
        final adapter = CFWorkerAdapter();
        adapter.deleteNote(note);
      }
    });
  }

  Future<List<Note>> getNotesLocal() async {
    final notes = _noteBox.values.toList();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<void> saveNoteLocal(Note note) async {
    await _noteBox.put(note.id, note);
  }

  Future<void> deleteNoteLocal(Note note) async {
    await _noteBox.delete(note.id);
  }

  Future<List<Note>> syncFromCloud() async {
    if((await SharedPreferences.getInstance()).getBool('worker_enabled') == true){
      final adapter = CFWorkerAdapter();
      for (final note in await adapter.getNotes()) {
        if (note.content.isEmpty){
          deleteNoteLocal(note);
        }
        else{
          saveNoteLocal(note);
        }
      }
    }
    return getNotesLocal();
  }
  Future<void> syncToCloud() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('worker_enabled') == true) {
      final adapter = CFWorkerAdapter();

      // Fetch once to avoid N requests
      final cloudList = await adapter.getNotes();
      final Map<String, Note> cloudById = {
        for (final n in cloudList) n.id: n,
      };

      // Iterate local notes
      final localNotes = await getNotesLocal();
      for (final note in localNotes) {
        if (note.content.isEmpty) {
          // Treat empty content as delete-on-cloud and remove locally
          await adapter.deleteNote(note);
          await deleteNoteLocal(note);
        } else {
          final remote = cloudById[note.id];
          final isDifferent = remote == null || remote.content != note.content;
          if (isDifferent) {
            await adapter.saveNote(note);
          }
        }
      }
    }
  }
}
