import 'package:notes_sqlite/core/database/database_helper.dart';
import 'package:notes_sqlite/data/models/note_model.dart';

abstract class NoteLocalDatasource {
  Future<int> insertNote(NoteModel note);
  Future<List<NoteModel>> getNotes();
  Future<int> updateNote(NoteModel note);
  Future<int> deleteNote(int id);
}

class NoteLocalDatasourceImpl implements NoteLocalDatasource {
  final DatabaseHelper dbHelper;

  NoteLocalDatasourceImpl({required this.dbHelper});

  @override
  Future<int> deleteNote(int id) async {
    final db = await dbHelper.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) => NoteModel.fromJson(maps[i]));
  }

  @override
  Future<int> insertNote(NoteModel note) async {
    final db = await dbHelper.database;
    return await db.insert('notes', note.toJson());
  }

  @override
  Future<int> updateNote(NoteModel note) async {
    final db = await dbHelper.database;
    return await db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
