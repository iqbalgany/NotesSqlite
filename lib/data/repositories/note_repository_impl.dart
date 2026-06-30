import 'package:notes_sqlite/data/datasources/local/note_local_datasource.dart';
import 'package:notes_sqlite/data/models/note_model.dart';
import 'package:notes_sqlite/domain/entities/note_entity.dart';
import 'package:notes_sqlite/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDatasource noteLocalDatasource;

  NoteRepositoryImpl({required this.noteLocalDatasource});

  @override
  Future<int> deleteNote(int id) async {
    return await noteLocalDatasource.deleteNote(id);
  }

  @override
  Future<List<NoteEntity>> getNotes() async {
    final List<NoteModel> notes = await noteLocalDatasource.getNotes();
    return notes.map((note) => note.toEntity()).toList();
  }

  @override
  Future<int> insertNote(NoteEntity note) async {
    final noteModel = NoteModel.fromEntity(note);
    return await noteLocalDatasource.insertNote(noteModel);
  }

  @override
  Future<int> updateNote(NoteEntity note) async {
    final noteModel = NoteModel.fromEntity(note);
    return await noteLocalDatasource.updateNote(noteModel);
  }
}
