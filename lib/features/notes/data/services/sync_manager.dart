import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flux/features/notes/data/models/note_model.dart';
import 'package:flux/features/notes/domain/use_cases/delete_notes_from_remote.dart';
import 'package:flux/features/notes/domain/use_cases/get_deleted_notes.dart';
import 'package:flux/features/notes/domain/use_cases/get_unsynced_notes.dart';
import 'package:flux/features/notes/domain/use_cases/hard_delete_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_local.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_remote.dart';
import 'package:flux/features/notes/domain/use_cases/update_notes_to_local.dart';
import 'package:flux/features/notes/domain/use_cases/update_notes_to_remote.dart';
import 'package:flux/service_locator.dart';
import '../../../../core/resources/data_state.dart';


final class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  SyncManager._internal();
  factory SyncManager() => _instance;

  final Connectivity _connectivity = Connectivity();
  bool _isInitialized = false;

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

  Future<void> performSync() async {
    try {
      await syncDeletedNotes();
      await syncCreatedNotes();
      await syncUpdatedNotes();
    } catch (e) {
      debugPrint("SyncManager Error: $e");
    }
  }

  Future<void> syncDeletedNotes() async {
    final deletedNotesResult = await serviceLocator<GetDeletedNotesUseCase>().execute();
    final deletedNotes = deletedNotesResult.data ?? [];

    if (deletedNotes.isEmpty) return;

    final noteIds = deletedNotes.map((e) => e.remoteId ?? 0).toList();
    final deleteRes = await serviceLocator<DeleteNotesFromRemoteUseCase>().execute(params: noteIds);

    if (deleteRes is DataSuccess) {
      await serviceLocator<HardDeleteNotesFromLocalUseCase>().execute(params: noteIds);
    }
  }

  Future<void> syncCreatedNotes() async {
    final unSyncedNotesResult = await serviceLocator<GetUnsyncedNotesUseCase>().execute();
    final unSyncedNotes = unSyncedNotesResult.data ?? [];
    if(unSyncedNotes.isEmpty) return;

    final createdNotes = unSyncedNotes.where((note) => note.isSynced == 1).toList();
    final createRes = await serviceLocator<SaveNotesToRemoteUseCase>().execute(params: createdNotes);

    if(createRes is DataSuccess) {
      final savedNotes = createRes.data ?? [];
      final newNoteList = savedNotes.map<NoteModel>((e) => e.copyWith(remoteId: e.id, isSynced: 0)).toList();

      final insertRes = await serviceLocator<SaveNotesToLocalUseCase>().execute(params: newNoteList);
      if(insertRes is DataSuccess) {
        final idList = createdNotes.map<int>((e) => e.id ?? 0).toList();
        await serviceLocator<HardDeleteNotesFromLocalUseCase>().execute(params: idList);
      }
    }
  }

  Future<void> syncUpdatedNotes() async {
    final unSyncedNotesResult = await serviceLocator<GetUnsyncedNotesUseCase>().execute();
    final unSyncedNotes = unSyncedNotesResult.data ?? [];
    if(unSyncedNotes.isEmpty) return;

    final updatedNotes = unSyncedNotes.where((note) => note.isSynced == 2).toList();
    final noteList = updatedNotes.map<NoteModel>((e) => e.copyWith(id: e.remoteId)).toList();
    final syncRes = await serviceLocator<UpdateNotesToRemoteUseCase>().execute(params: noteList);

    if (syncRes is DataSuccess) {
      final newNoteList = updatedNotes.map<NoteModel>((e) => e.copyWith(isSynced: 0)).toList();
      await serviceLocator<UpdateNotesToLocalUseCase>().execute(params: newNoteList);
    }
  }

}