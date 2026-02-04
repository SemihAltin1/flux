import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      remote_id INTEGER,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      category_name TEXT,
      category_id TEXT,
      is_pinned INTEGER NOT NULL,
      is_synced INTEGER NOT NULL,
      is_deleted_locally INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
    ''');
  }

}