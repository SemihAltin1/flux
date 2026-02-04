import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/notes/data/models/get_notes_request.dart';
import 'package:flux/features/notes/data/services/sync_manager.dart';
import 'package:flux/features/notes/domain/use_cases/delete_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/get_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/restore_note.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_local.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_remote.dart';
import 'package:flux/features/notes/domain/use_cases/update_notes_to_local.dart';
import 'package:flux/features/notes/domain/use_cases/update_notes_to_remote.dart';
import 'package:flux/service_locator.dart';
import '../../data/models/note_model.dart';
import 'notes_state.dart';


final class NotesCubit extends Cubit<NotesState> with SyncManagerDelegate {
  String _currentCategoryId = "0";
  String? _currentSearchQuery;
  final SyncManager _syncManager = SyncManager();
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
    final connection = await _syncManager.checkCurrentConnection();
    if(connection) {
      final result = await serviceLocator<SaveNotesToRemoteUseCase>().execute(params: [note]);
      if(result is DataSuccess) {
        final savedNotes = result.data ?? [];
        await serviceLocator<SaveNotesToLocalUseCase>().execute(params: savedNotes);
        await fetchNotesFromLocal();
      }
    } else {
      final result = await serviceLocator<SaveNotesToLocalUseCase>().execute(params: [note]);
      if(result is DataSuccess) {
        await fetchNotesFromLocal();
      }
    }
  }

  Future<void> deleteNoteToLocal(NoteModel note) async {
    final result = await serviceLocator<DeleteNotesFromLocalUseCase>().execute(params: [note.id ?? 0]);
    if(result is DataSuccess) {
      emit(NoteDeleted(note));
      await fetchNotesFromLocal();
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

  Future<void> updateNoteToLocal(NoteModel note) async {
    final result = await serviceLocator<UpdateNotesToLocalUseCase>().execute(params: [note]);
    if(result is DataSuccess) {
      await fetchNotesFromLocal();
      final connection = await _syncManager.checkCurrentConnection();
      if(connection) await serviceLocator<UpdateNotesToRemoteUseCase>().execute(params: [note.copyWith(id: note.remoteId)]);
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

  Future<void> restoreNote(NoteModel note) async {
    final result = await serviceLocator<RestoreNoteUseCase>().execute(params: note);
    if(result is DataSuccess) {
      await fetchNotesFromLocal();
    } else if(result is DataFailed) {
      emit(NotesError(result.errorMessage ?? "The operation couldn't be completed."));
    }
  }

  Future<void> syncNotes() async {
    _syncManager.delegate = this;
    final isConnected = await _syncManager.checkCurrentConnection();
    if(isConnected) {
      await _syncManager.performSync();
    } else {
      fetchNotesFromLocal();
    }

    _syncManager.listenConnection();
  }


  @override
  void notify(bool isSynced) {
    if(isSynced) {
      fetchNotesFromLocal();
    }
  }

}