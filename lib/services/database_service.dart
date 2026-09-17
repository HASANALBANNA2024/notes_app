import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Owns the raw SQLite connection and schema. Nothing above this class
/// (NoteRepository, NotesBloc, screens) should ever touch [Database]
/// directly — they only ever go through [NoteRepository].
class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();

  static const String tableNotes = 'notes';
  static const int _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    // Reuse the same open connection instead of reopening it on every call.
    _database ??= await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'notes_app.db');

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableNotes (
            id TEXT PRIMARY KEY,
            sequenceNumber INTEGER NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            label TEXT,
            colorValue INTEGER,
            isPinned INTEGER NOT NULL DEFAULT 0,
            isLocked INTEGER NOT NULL DEFAULT 0,
            reminderAt TEXT,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
