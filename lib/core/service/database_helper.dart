import 'package:notes_app/features/notes/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// create Database function
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // ✅ FIX #2: Version 3 for complete schema with all columns
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create Table Function - Complete schema
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''\
     CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        date TEXT,
        badgeText TEXT,
        badgeType TEXT,
        isPinned INTEGER,
        isLocked INTEGER,
        targetDateTime TEXT,
        reminderDateTime TEXT,
        reminderOffsetType TEXT
     )
    ''');
  }

  /// ✅ FIX #2: Handle migration/upgrade properly from v1 -> v2 -> v3
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Upgrade from v1 to v2
    if (oldVersion < 2) {
      try {
        await db.execute(
          'ALTER TABLE notes ADD COLUMN isLocked INTEGER DEFAULT 0',
        );
        print('Migration v1->v2: Added isLocked column');
      } catch (e) {
        print('Migration v1->v2 warning (column might exist): $e');
      }
    }

    // Upgrade from v2 to v3 (or v1 to v3)
    if (oldVersion < 3) {
      try {
        // Add reminderOffsetType if it doesn't exist
        await db.execute(
          'ALTER TABLE notes ADD COLUMN reminderOffsetType TEXT DEFAULT "exact"',
        );
        print('Migration v2->v3: Added reminderOffsetType column');
      } catch (e) {
        print('Migration v2->v3 warning (column might exist): $e');
      }
    }
  }

  /// Insert Function (Note Save)
  Future<int> insertNote(NoteModel note) async {
    final db = await instance.database;
    return await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// get all notes for read
  Future<List<NoteModel>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'isPinned DESC, date DESC');
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  /// Update function of notes
  Future<int> updateNote(NoteModel note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id=?',
      whereArgs: [note.id],
    );
  }

  /// delete note
  Future<int> deleteNote(String id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id=?', whereArgs: [id]);
  }

  /// clear all
  Future<int> clearNote() async {
    final db = await instance.database;
    return await db.delete('notes');
  }
}
