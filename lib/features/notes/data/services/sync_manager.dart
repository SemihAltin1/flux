import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flux/features/notes/data/models/note_model.dart';
import 'package:flux/features/notes/domain/use_cases/delete_all_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/delete_notes_from_remote.dart';
import 'package:flux/features/notes/domain/use_cases/get_deleted_notes.dart';
import 'package:flux/features/notes/domain/use_cases/get_notes_from_remote.dart';
import 'package:flux/features/notes/domain/use_cases/get_unsynced_notes.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_local.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_remote.dart';
import 'package:flux/features/notes/domain/use_cases/update_notes_to_remote.dart';
import 'package:flux/service_locator.dart';
import '../../../../core/resources/data_state.dart';


final class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  SyncManager._internal();
  factory SyncManager() => _instance;

  final Connectivity _connectivity = Connectivity();
  bool _isInitialized = false;
  SyncManagerDelegate? delegate;

  void listenConnection() {
    if (_isInitialized) return;

    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final hasConnection = results.any((result) => result != ConnectivityResult.none);
      if (hasConnection) {
        performSync();
      }
    });
    _isInitialized = true;
  }

  Future<bool> checkCurrentConnection() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();

    if (results.any((result) => result != ConnectivityResult.none)) {
      return true;
    }

    return false;
  }

  Future<void> performSync() async {
    try {
      await syncDeletedNotes();
      await syncCreatedNotes();
      await syncUpdatedNotes();
      await getNotesFromRemote();
      delegate?.notify(true);
    } catch (e) {
      delegate?.notify(false);
      debugPrint("SyncManager Error: $e");
    }
  }

  Future<void> syncDeletedNotes() async {
    final deletedNotesResult = await serviceLocator<GetDeletedNotesUseCase>().execute();
    final deletedNotes = deletedNotesResult.data ?? [];

    if (deletedNotes.isEmpty) return;

    final noteIds = deletedNotes.map((e) => e.remoteId ?? 0).toList();
    await serviceLocator<DeleteNotesFromRemoteUseCase>().execute(params: noteIds);
  }

  Future<void> syncCreatedNotes() async {
    final unSyncedNotesResult = await serviceLocator<GetUnsyncedNotesUseCase>().execute();
    final unSyncedNotes = unSyncedNotesResult.data ?? [];
    if(unSyncedNotes.isEmpty) return;

    final createdNotes = unSyncedNotes.where((note) => note.isSynced == 1).toList();
    await serviceLocator<SaveNotesToRemoteUseCase>().execute(params: createdNotes);
  }

  Future<void> syncUpdatedNotes() async {
    final unSyncedNotesResult = await serviceLocator<GetUnsyncedNotesUseCase>().execute();
    final unSyncedNotes = unSyncedNotesResult.data ?? [];
    if(unSyncedNotes.isEmpty) return;

    final updatedNotes = unSyncedNotes.where((note) => note.isSynced == 2).toList();
    final noteList = updatedNotes.map<NoteModel>((e) => e.copyWith(id: e.remoteId)).toList();
    await serviceLocator<UpdateNotesToRemoteUseCase>().execute(params: noteList);
  }

  Future<void> getNotesFromRemote() async {
    final result = await serviceLocator<GetNotesFromRemoteUseCase>().execute();
    if(result is DataSuccess) {
      await serviceLocator<DeleteAllNotesFromLocalUseCase>().execute();
      final list = result.data ?? [];
      final newNoteList = list.map<NoteModel>((e) => e.copyWith(isSynced: 0, remoteId: e.id)).toList();
      await serviceLocator<SaveNotesToLocalUseCase>().execute(params: newNoteList);
    }
  }
}

mixin SyncManagerDelegate {
  void notify(bool isSynced);
}