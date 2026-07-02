import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_sqlite/domain/entities/note_entity.dart';
import 'package:notes_sqlite/domain/usecases/delete_note_usecase.dart';
import 'package:notes_sqlite/domain/usecases/get_notes_usecase.dart';
import 'package:notes_sqlite/domain/usecases/insert_note_usecase.dart';
import 'package:notes_sqlite/domain/usecases/update_note_usecase.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final GetNotesUsecase getNotesUsecase;
  final InsertNoteUsecase insertNoteUsecase;
  final UpdateNoteUsecase updateNoteUsecase;
  final DeleteNoteUsecase deleteNoteUsecase;
  NoteCubit({
    required this.getNotesUsecase,
    required this.insertNoteUsecase,
    required this.updateNoteUsecase,
    required this.deleteNoteUsecase,
  }) : super(NoteInitial());

  Future<void> getNotes() async {
    emit(NoteLoading());
    try {
      final notes = await getNotesUsecase();
      emit(NoteSuccess(notes: notes));
    } catch (e) {
      emit(NoteError(errorMessage: e.toString()));
    }
  }

  Future<void> insertNote(NoteEntity note) async {
    emit(NoteLoading());
    try {
      await insertNoteUsecase(note);

      emit(NoteSuccess(notes: await getNotesUsecase()));
    } catch (e) {
      emit(NoteError(errorMessage: e.toString()));
    }
  }

  Future<void> updateNote(NoteEntity note) async {
    emit(NoteLoading());
    try {
      await updateNoteUsecase(note);

      emit(NoteSuccess(notes: await getNotesUsecase()));
    } catch (e) {
      emit(NoteError(errorMessage: e.toString()));
    }
  }

  Future<void> deleteNote(int id) async {
    emit(NoteLoading());
    try {
      await deleteNoteUsecase(id);

      emit(NoteSuccess(notes: await getNotesUsecase()));
    } catch (e) {
      emit(NoteError(errorMessage: e.toString()));
    }
  }
}
