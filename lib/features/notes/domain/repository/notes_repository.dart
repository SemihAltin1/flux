import '../../../../core/resources/data_state.dart';
import '../../data/models/note_model.dart';

abstract class NotesRepository {

  Future<DataState<List<NoteModel>>> getNotes({String? search, int? categoryId});

  Future<DataState<bool>> insertNote(NoteModel note);

  Future<DataState<bool>> updateNote(NoteModel note);

  Future<DataState<bool>> deleteNote(int id);

  Future<DataState<bool>> deleteAllNotes();
}