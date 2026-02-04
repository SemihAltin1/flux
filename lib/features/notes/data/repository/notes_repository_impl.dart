import 'package:dio/dio.dart';
import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/notes/data/models/note_model.dart';
import 'package:flux/features/notes/data/services/notes_local_service.dart';
import 'package:flux/features/notes/data/services/notes_remote_service.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import 'package:flux/service_locator.dart';

import '../models/get_notes_request.dart';

final class NotesRepositoryImpl extends NotesRepository {
  final _localService = serviceLocator<NotesLocalService>();
  final _remoteService = serviceLocator<NotesRemoteService>();

  // LOCAL OPERATIONS
  @override
  Future<DataState<bool>> deleteAllNotes() {
    return _localService.deleteAllNotes();
  }

  @override
  Future<DataState<bool>> deleteNotes(List<int> ids) {
    return _localService.deleteNotes(ids);
  }

  @override
  Future<DataState<List<NoteModel>>> getDeletedNotes() {
    return _localService.getDeletedNotes();
  }

  @override
  Future<DataState<List<NoteModel>>> getNotes(GetNotesRequest request) {
    return _localService.getNotes(request);
  }

  @override
  Future<DataState<List<NoteModel>>> getUnsyncedNotes() {
    return _localService.getUnsyncedNotes();
  }

  @override
  Future<DataState<bool>> insertNotes(List<NoteModel> notes) {
    return _localService.insertNotes(notes);
  }

  @override
  Future<DataState<bool>> updateNotes(List<NoteModel> notes) {
    return _localService.updateNotes(notes);
  }

  @override
  Future<DataState<bool>> hardDeleteNotesFromLocal(List<int> ids) {
    return _localService.hardDeleteNotes(ids);
  }


  // REMOTE OPERATIONS
  @override
  Future<DataState<bool>> deleteNotesFromRemote(List<int> noteIds) async {
    try {
      await _remoteService.deleteNotes(noteIds);
      return const DataSuccess(true);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "The operation couldn't be completed";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("The operation couldn't be completed");
    }
  }

  @override
  Future<DataState<List<NoteModel>>> getNotesFromRemote() async {
    try {
      final res = await _remoteService.getNotes();
      final decodedData = res.data["data"]["notes"].map<NoteModel>((e) => NoteModel.fromRemoteJson(e)).toList();
      return DataSuccess(decodedData);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "The operation couldn't be completed";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("The operation couldn't be completed");
    }
  }

  @override
  Future<DataState<List<NoteModel>>> saveNotesToRemote(List<NoteModel> notes) async {
    try {
      final res = await _remoteService.saveNotes(notes);
      final decodedData = res.data["data"]["created"].map<NoteModel>((e) => NoteModel.fromRemoteJson(e)).toList();
      return DataSuccess(decodedData);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "The operation couldn't be completed";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("The operation couldn't be completed");
    }
  }

  @override
  Future<DataState<bool>> updateNotesToRemote(List<NoteModel> notes) async {
    try {
      await _remoteService.saveNotes(notes);
      return const DataSuccess(true);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "The operation couldn't be completed";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("The operation couldn't be completed");
    }
  }

}