import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/notes/data/models/get_notes_request.dart';
import 'package:flux/features/notes/domain/use_cases/delete_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/get_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/get_notes_from_remote.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_local.dart';
import 'package:flux/features/notes/domain/use_cases/update_notes_to_local.dart';
import 'package:flux/service_locator.dart';
import '../../data/models/note_model.dart';
import 'notes_state.dart';


final class NotesCubit extends Cubit<NotesState> {
  String _currentCategoryId = "0";
  String? _currentSearchQuery;

  NotesCubit() : super(NotesInitial());


  Future<void> fetchNotesFromLocal({String? search, String? categoryId}) async {
    if (search != null) _currentSearchQuery = search;
    if (categoryId != null) _currentCategoryId = categoryId;

    emit(NotesLoading());

    final request = GetNotesRequest(
      search: _currentSearchQuery,
      categoryId: _currentCategoryId == "0" ? null : _currentCategoryId,
    );
    final result = await serviceLocator<GetNotesFromLocalUseCase>().execute(params: request);

    if (result is DataSuccess) {
      emit(NotesLoaded(
        result.data ?? [],
        selectedCategoryId: _currentCategoryId,
      ));
    } else if (result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }

  }

  void changeCategory(String categoryId) {
    fetchNotesFromLocal(categoryId: categoryId);
  }

  Future<void> addNoteToLocal(NoteModel note) async {
    final result = await serviceLocator<SaveNotesToLocalUseCase>().execute(params: [note]);
    if(result is DataSuccess) {
      await fetchNotesFromLocal();
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

  Future<void> deleteNoteToLocal(int id) async {
    final result = await serviceLocator<DeleteNotesFromLocalUseCase>().execute(params: [id]);
    if(result is DataSuccess) {
      await fetchNotesFromLocal();
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

  Future<void> updateNoteToLocal(NoteModel note) async {
    final result = await serviceLocator<UpdateNotesToLocalUseCase>().execute(params: [note]);
    if(result is DataSuccess) {
      await fetchNotesFromLocal();
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

  Future<void> getNotesFromRemote() async {
    emit(NotesLoading());
    final result = await serviceLocator<GetNotesFromRemoteUseCase>().execute();
    if(result is DataSuccess) {
      final noteList = result.data ?? [];
      final newNoteList = noteList.map<NoteModel>((e) => e.copyWith(id: null, remoteId: e.id, isSynced: 0)).toList();

      final saveResult = await serviceLocator<SaveNotesToLocalUseCase>().execute(params: newNoteList);
      if(saveResult is DataSuccess) {
        fetchNotesFromLocal();
      } else if(saveResult is DataFailed) {
        emit(NotesError(result.errorMessage ?? "Notes couldn't be loaded."));
      }

    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "Notes couldn't be loaded."));
    }
  }


}