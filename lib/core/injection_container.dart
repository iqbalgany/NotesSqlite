import 'package:get_it/get_it.dart';
import 'package:notes_sqlite/core/database/database_helper.dart';
import 'package:notes_sqlite/data/datasources/local/note_local_datasource.dart';
import 'package:notes_sqlite/data/repositories/note_repository_impl.dart';
import 'package:notes_sqlite/domain/repositories/note_repository.dart';
import 'package:notes_sqlite/domain/usecases/delete_note_usecase.dart';
import 'package:notes_sqlite/domain/usecases/get_notes_usecase.dart';
import 'package:notes_sqlite/domain/usecases/insert_note_usecase.dart';
import 'package:notes_sqlite/domain/usecases/update_note_usecase.dart';
import 'package:notes_sqlite/presentations/cubits/note_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Database Helper
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Datasource
  getIt.registerLazySingleton<NoteLocalDatasource>(
    () => NoteLocalDatasourceImpl(dbHelper: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(noteLocalDatasource: getIt()),
  );

  // Usecase
  getIt.registerLazySingleton<GetNotesUsecase>(
    () => GetNotesUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<InsertNoteUsecase>(
    () => InsertNoteUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<DeleteNoteUsecase>(
    () => DeleteNoteUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<UpdateNoteUsecase>(
    () => UpdateNoteUsecase(repository: getIt()),
  );

  // Cubit
  getIt.registerFactory<NoteCubit>(
    () => NoteCubit(
      getNotesUsecase: getIt(),
      insertNoteUsecase: getIt(),
      updateNoteUsecase: getIt(),
      deleteNoteUsecase: getIt(),
    ),
  );
}
