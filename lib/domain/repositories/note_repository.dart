import 'package:notes_sqlite/domain/entities/note_entity.dart';

abstract class NoteRepository {
  Future<int> insertNote(NoteEntity note);
  Future<List<NoteEntity>> getNotes();
  Future<int> updateNote(NoteEntity note);
  Future<int> deleteNote(int id);
}
