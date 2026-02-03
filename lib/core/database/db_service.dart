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
      remoteId TEXT,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      categoryName TEXT,
      categoryId INTEGER,
      isPinned INTEGER NOT NULL,
      isSynced INTEGER NOT NULL,
      isDeletedLocally INTEGER NOT NULL,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )
    ''');
  }

}