import 'package:notes_app/core/database/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Table Creation
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      createdAt TEXT NOT NULL,
      label TEXT NOT NULL,
      isFavorite INTEGER NOT NULL DEFAULT 0,
      isPinned INTEGER NOT NULL DEFAULT 0,
      isLocked INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  /// CREATE: New Note
  Future<int> insertNote(NoteModel note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  /// READ: Get All Notes (Pinned notes first, then latest created)
  Future<List<NoteModel>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      orderBy: 'isPinned DESC, id DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  /// READ: Get Notes by Label (Pinned notes first, then latest created)
  Future<List<NoteModel>> getNotesByLabel(String label) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'label = ?',
      whereArgs: [label],
      orderBy: 'isPinned DESC, id DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  /// UPDATE: Existing Note
  Future<int> updateNote(NoteModel note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// DELETE: Single Note
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// CLOSE Database
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
