import 'package:notes_sqlite/domain/entities/note_entity.dart';
import 'package:notes_sqlite/domain/repositories/note_repository.dart';

class UpdateNoteUsecase {
  final NoteRepository repository;

  UpdateNoteUsecase({required this.repository});

  Future<int> call(NoteEntity note) async {
    return await repository.updateNote(note);
  }
}
