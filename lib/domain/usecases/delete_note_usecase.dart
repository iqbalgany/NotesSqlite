import 'package:notes_sqlite/domain/repositories/note_repository.dart';

class DeleteNoteUsecase {
  final NoteRepository repository;

  DeleteNoteUsecase({required this.repository});

  Future<int> call(int id) async {
    return await repository.deleteNote(id);
  }
}
