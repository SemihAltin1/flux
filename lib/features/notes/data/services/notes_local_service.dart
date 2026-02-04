import 'package:flux/core/resources/data_state.dart';
import '../models/get_notes_request.dart';
import '../models/note_model.dart';

abstract class NotesLocalService {

  Future<DataState<List<NoteModel>>> getNotes(GetNotesRequest request);

  Future<DataState<bool>> insertNotes(List<NoteModel> notes);

  Future<DataState<bool>> updateNotes(List<NoteModel> notes);

  Future<DataState<bool>> deleteNotes(List<int> ids);

  Future<DataState<bool>> deleteAllNotes();

  Future<DataState<List<NoteModel>>> getUnsyncedNotes();

  Future<DataState<List<NoteModel>>> getDeletedNotes();

  Future<DataState<bool>> hardDeleteNotes(List<int> ids);

}