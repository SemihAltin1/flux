import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/notes/data/services/notes_local_service.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/db_service.dart';
import '../models/get_notes_request.dart';
import '../models/note_model.dart';

final class NotesLocalServiceImpl implements NotesLocalService {
  final DatabaseService _dbService = DatabaseService.instance;

  @override
  Future<DataState<List<NoteModel>>> getNotes(GetNotesRequest request) async {
    try {
      final db = await _dbService.database;
      List<String> whereClauses = ['is_deleted_locally = 0'];
      List<dynamic> whereArgs = [];

      if (request.search != null && request.search!.isNotEmpty) {
        whereClauses.add('(title LIKE ? OR content LIKE ?)');
        whereArgs.addAll(['%${request.search}%', '%${request.search}%']);
      }

      if (request.categoryId != null && request.categoryId != "0") {
        whereClauses.add('category_id = ?');
        whereArgs.add(request.categoryId);
      }

      final result = await db.query(
        'notes',
        where: whereClauses.join(' AND '),
        whereArgs: whereArgs,
        orderBy: 'is_pinned DESC, created_at DESC',
      );

      return DataSuccess(result.map((e) => NoteModel.fromLocalJson(e)).toList());
    } catch (_) {
      return const DataFailed("Notes couldn't be loaded.");
    }
  }

  @override
  Future<DataState<List<NoteModel>>> getUnsyncedNotes() async {
    try {
      final db = await _dbService.database;
      final result = await db.query(
        'notes',
        where: 'is_synced != ? AND is_deleted_locally = ?',
        whereArgs: [0, 0],
      );

      return DataSuccess(result.map((e) => NoteModel.fromLocalJson(e)).toList());
    } catch (e) {
      return const DataFailed("Error fetching unsynced notes");
    }
  }

  @override
  Future<DataState<List<NoteModel>>> getDeletedNotes() async {
    try {
      final db = await _dbService.database;
      final result = await db.query('notes', where: 'is_deleted_locally = ?', whereArgs: [1]);
      return DataSuccess(result.map((e) => NoteModel.fromLocalJson(e)).toList());
    } catch (_) {
      return const DataFailed("Error fetching deleted notes");
    }
  }

  @override
  Future<DataState<bool>> insertNotes(List<NoteModel> notes) async {
    try {
      final db = await _dbService.database;
      final batch = db.batch();
      for (var note in notes) {
        batch.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      return const DataSuccess(true);
    } catch (_) {
      return const DataFailed("Multiple notes could not be saved.");
    }
  }

  @override
  Future<DataState<bool>> updateNotes(List<NoteModel> notes) async {
    try {
      final db = await _dbService.database;
      final batch = db.batch();
      for (var note in notes) {
        batch.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
      }
      await batch.commit(noResult: true);
      return const DataSuccess(true);
    } catch (_) {
      return const DataFailed("Multiple notes couldn't be updated.");
    }
  }

  @override
  Future<DataState<bool>> deleteNotes(List<int> ids) async {
    try {
      final db = await _dbService.database;
      final batch = db.batch();
      for (var id in ids) {
        batch.update(
          'notes',
          {'is_deleted_locally': 1, 'is_synced': 0},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
      await batch.commit(noResult: true);
      return const DataSuccess(true);
    } catch (_) {
      return const DataFailed("Multiple notes could not be marked for deletion.");
    }
  }

  @override
  Future<DataState<bool>> deleteAllNotes() async {
    try {
      final db = await _dbService.database;
      await db.delete('notes');
      return const DataSuccess(true);
    } catch (_) {
      return const DataFailed("Local data could not be cleared.");
    }
  }

  @override
  Future<DataState<bool>> hardDeleteNotes(List<int> ids) async {
    try {
      final db = await _dbService.database;
      final batch = db.batch();

      for (var id in ids) {
        batch.delete(
          'notes',
          where: 'id = ?',
          whereArgs: [id],
        );
      }
      await batch.commit(noResult: true);

      return const DataSuccess(true);
    } catch (e) {
      return const DataFailed("Could not permanently remove notes from local storage.");
    }
  }

  @override
  Future<DataState<bool>> restoreNote(NoteModel note) async {
    try {
      final db = await _dbService.database;

      await db.update(
        'notes',
        {
          'is_deleted_locally': 0,
          'is_synced': 2,
        },
        where: 'id = ?',
        whereArgs: [note.id],
      );

      return const DataSuccess(true);
    } catch (e) {
      return const DataFailed("Note could not be restored.");
    }
  }
}