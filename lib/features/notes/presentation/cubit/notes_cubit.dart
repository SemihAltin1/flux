import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import '../../data/models/note_model.dart';
import 'notes_state.dart';


final class NotesCubit extends Cubit<NotesState> {
  final NotesRepository _repository;

  int _currentCategoryId = 0;
  String? _currentSearchQuery;

  NotesCubit(this._repository) : super(NotesInitial());


  Future<void> fetchNotesFromLocal({String? search, int? categoryId}) async {
    if (search != null) _currentSearchQuery = search;
    if (categoryId != null) _currentCategoryId = categoryId;

    emit(NotesLoading());

    final result = await _repository.getNotes(
      search: _currentSearchQuery,
      categoryId: _currentCategoryId == 0 ? null : _currentCategoryId,
    );

    if (result is DataSuccess) {
      emit(NotesLoaded(
        result.data ?? [],
        selectedCategoryId: _currentCategoryId,
      ));
    } else if (result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }

  }

  void changeCategory(int categoryId) {
    fetchNotesFromLocal(categoryId: categoryId);
  }

  Future<void> addNoteToLocal(NoteModel note) async {
    final result = await _repository.insertNote(note);
    if(result is DataSuccess) {
      await fetchNotesFromLocal();
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

  Future<void> deleteNoteToLocal(int id) async {
    final result = await _repository.deleteNote(id);
    if(result is DataSuccess) {
      await fetchNotesFromLocal();
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

  Future<void> updateNote(NoteModel note) async {
    final result = await _repository.updateNote(note);
    if(result is DataSuccess) {
      await fetchNotesFromLocal();
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

}