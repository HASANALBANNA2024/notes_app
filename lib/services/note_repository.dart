import '../models/note.dart';
import 'database_service.dart';

/// Domain-level API for note persistence. NotesBloc only ever talks to
/// this class — it never sees SQL or the raw [DatabaseService].
class NoteRepository {
  final DatabaseService _databaseService;

  NoteRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService.instance;

  Future<List<Note>> getAllNotes() async {
    final db = await _databaseService.database;
    final rows = await db.query(DatabaseService.tableNotes);
    return rows.map(Note.fromMap).toList();
  }

  Future<void> insertNote(Note note) async {
    final db = await _databaseService.database;
    await db.insert(DatabaseService.tableNotes, note.toMap());
  }

  Future<void> updateNote(Note note) async {
    final db = await _databaseService.database;
    await db.update(
      DatabaseService.tableNotes,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      DatabaseService.tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllNotes() async {
    final db = await _databaseService.database;
    await db.delete(DatabaseService.tableNotes);
  }
}
