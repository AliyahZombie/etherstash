import '../models/note.dart';

class Noterepo {
    List<Note> notes = [];
    Noterepo(){
        notes.add(Note(id: '1', content: 'Hello World', createdAt: DateTime.now()));
        notes.add(Note(id: '2', content: 'Hello World 2', createdAt: DateTime.now().add(Duration(days: 1))));
        notes.add(Note(id: '3', content: 'Hello World 3', createdAt: DateTime.now().add(Duration(days: 2))));
        notes.add(Note(id: '4', content: 'Hello World 4', createdAt: DateTime.now().add(Duration(days: 3))));
    }
    List<Note> getNotes(){
        return notes;
    }
    
    void saveNote(Note note){
        bool noteExists = false;
        for (int i = 0; i < notes.length; i++){
          if (notes[i].id == note.id){
            notes[i] = note;
            noteExists = true;
            break;
          }
        }
        if (!noteExists) {
          notes.add(note);
        }
    } 

    void deleteNote(Note note){
        notes.remove(note);
    }
    
}