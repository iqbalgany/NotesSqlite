import 'package:notes_sqlite/domain/entities/note_entity.dart';
import 'package:notes_sqlite/domain/repositories/note_repository.dart';

class GetNotesUsecase {
  final NoteRepository repository;

  GetNotesUsecase({required this.repository});

  Future<List<NoteEntity>> call() async {
    return await repository.getNotes();
  }
}
