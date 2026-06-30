part of 'note_cubit.dart';

sealed class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}

final class NoteSuccess extends NoteState {
  final List<NoteEntity>? notes;

  const NoteSuccess({this.notes = const []});

  @override
  List<Object?> get props => [notes];
}

final class NoteError extends NoteState {
  final String errorMessage;

  const NoteError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
