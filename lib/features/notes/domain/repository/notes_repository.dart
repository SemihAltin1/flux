import '../../../../core/resources/data_state.dart';
import '../../data/models/get_notes_request.dart';
import '../../data/models/note_model.dart';

abstract class NotesRepository {
  // LOCAL
  Future<DataState<List<NoteModel>>> getNotes(GetNotesRequest request);
  Future<DataState<bool>> insertNotes(List<NoteModel> notes);
  Future<DataState<bool>> updateNotes(List<NoteModel> notes);
  Future<DataState<bool>> deleteNotes(List<int> ids);
  Future<DataState<bool>> deleteAllNotes();
  Future<DataState<List<NoteModel>>> getUnsyncedNotes();
  Future<DataState<List<NoteModel>>> getDeletedNotes();
  Future<DataState<bool>> hardDeleteNotesFromLocal(List<int> ids);

  // REMOTE
  Future<DataState<List<NoteModel>>> saveNotesToRemote(List<NoteModel> notes);
  Future<DataState<bool>> updateNotesToRemote(List<NoteModel> notes);
  Future<DataState<List<NoteModel>>> getNotesFromRemote();
  Future<DataState<bool>> deleteNotesFromRemote(List<int> noteIds);
}