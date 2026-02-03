import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/notes/data/services/notes_local_service.dart';
import '../../../../core/database/db_service.dart';
import '../models/note_model.dart';

final class NotesLocalServiceImpl implements NotesLocalService {
  final DatabaseService _dbService = DatabaseService.instance;

  @override
  Future<DataState<bool>> deleteNote(int id) async {
    try {
      final db = await _dbService.database;
      await db.delete('notes', where: 'id = ?', whereArgs: [id]);
      return const DataSuccess(true);
    } catch(_) {
      return const DataFailed("Notes couldn't be deleted. Please try again later");
    }
  }

  @override
  Future<DataState<List<NoteModel>>> getNotes({String? search, int? categoryId}) async {
    try {
      final db = await _dbService.database;

      List<String> whereClauses = [];
      List<dynamic> whereArgs = [];

      if (search != null && search.isNotEmpty) {
        whereClauses.add('(title LIKE ? OR content LIKE ?)');
        whereArgs.addAll(['%$search%', '%$search%']);
      }

      if (categoryId != null && categoryId != 0) {
        whereClauses.add('categoryId = ?');
        whereArgs.add(categoryId);
      }

      String? finalWhere = whereClauses.isEmpty ? null : whereClauses.join(' AND ');

      final result = await db.query(
        'notes',
        where: finalWhere,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: 'isPinned DESC, createdAt DESC',
      );

      final decodedData = result.map((e) => NoteModel.fromMap(e)).toList();
      return DataSuccess(decodedData);
    } catch (_) {
      return const DataFailed("Notes couldn't be loaded. Please try again later");
    }
  }

  @override
  Future<DataState<bool>> insertNote(NoteModel note) async {
    try {
      final db = await _dbService.database;
      await db.insert('notes', note.toMap());
      return const DataSuccess(true);
    } catch(_) {
      return const DataFailed("The note couldn't be saved. Please try again later.");
    }
  }

  @override
  Future<DataState<bool>> updateNote(NoteModel note) async {
    try {
      final db = await _dbService.database;
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
      return const DataSuccess(true);
    } catch(_) {
      return const DataFailed("The note couldn't be updated. Please try again later.");
    }
  }

  @override
  Future<DataState<bool>> deleteAllNotes() async {
    try {
      final db = await _dbService.database;
      await db.delete('notes');
      return const DataSuccess(true);
    } catch (e) {
      return const DataFailed("Local data could not be cleared.");
    }
  }

}