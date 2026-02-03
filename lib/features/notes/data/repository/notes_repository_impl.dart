import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/notes/data/models/note_model.dart';
import 'package:flux/features/notes/data/services/notes_local_service.dart';
import 'package:flux/features/notes/data/services/notes_remote_service.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import 'package:flux/service_locator.dart';

final class NotesRepositoryImpl extends NotesRepository {
  final _localService = serviceLocator<NotesLocalService>();
  final _remoteService = serviceLocator<NotesRemoteService>();

  @override
  Future<DataState<bool>> deleteNote(int id) {
    return _localService.deleteNote(id);
  }

  @override
  Future<DataState<List<NoteModel>>> getNotes({String? search, int? categoryId}) {
    return _localService.getNotes(search: search, categoryId: categoryId);
  }

  @override
  Future<DataState<bool>> insertNote(NoteModel note) {
    return _localService.insertNote(note);
  }

  @override
  Future<DataState<bool>> updateNote(NoteModel note) {
    return _localService.updateNote(note);
  }

  @override
  Future<DataState<bool>> deleteAllNotes() {
    return _localService.deleteAllNotes();
  }

}