import '../models/note.dart';

/// Cloud sync adapter abstraction for remote Note operations.
abstract class CloudSyncAdapter {
  Future<List<Note>> getNotes();
  Future<Note> saveNote(Note note);
  Future<Note> deleteNote(Note note);
}
