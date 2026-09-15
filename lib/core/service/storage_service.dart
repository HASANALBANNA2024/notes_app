import 'package:get_storage/get_storage.dart';

import '../../features/notes/model/note_model.dart';
import 'notification_service.dart';

class StorageService {
  final GetStorage _box = GetStorage();
  final NotificationService _notificationService = NotificationService();

  static const String _notesTable = 'notes_table';

  /// all notes (Read)
  List<NoteModel> getAllNotes() {
    final List<dynamic>? storedData = _box.read<List<dynamic>>(_notesTable);
    if (storedData != null && storedData.isNotEmpty) {
      return storedData
          .map((item) => NoteModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }

  /// Create
  Future<void> insertNote(NoteModel newNote) async {
    List<NoteModel> notes = getAllNotes();
    notes.insert(0, newNote);

    await _box.write(_notesTable, notes.map((n) => n.toJson()).toList());
    _handleNotificationSchedule(newNote);
  }

  /// Update
  Future<void> updateNote(NoteModel updatedNote) async {
    List<NoteModel> notes = getAllNotes();
    int index = notes.indexWhere((n) => n.id == updatedNote.id);

    if (index != -1) {
      notes[index] = updatedNote;
      await _box.write(_notesTable, notes.map((n) => n.toJson()).toList());

      /// old schedule change and new schedule
      await _notificationService.cancelNotification(updatedNote.id.hashCode);
      _handleNotificationSchedule(updatedNote);
    }
  }

  /// Delete
  Future<void> deleteNote(String noteId) async {
    List<NoteModel> notes = getAllNotes();
    notes.removeWhere((n) => n.id == noteId);

    await _box.write(_notesTable, notes.map((n) => n.toJson()).toList());
    await _notificationService.cancelNotification(noteId.hashCode);
  }

  /// clear all schedule
  Future<void> clearNotesTable() async {
    await _box.remove(_notesTable);
    await _notificationService.cancelAllNotifications();
  }

  /// notification scheduling handler
  void _handleNotificationSchedule(NoteModel note) {
    DateTime? notifyTime = note.reminderDateTime;

    if (notifyTime == null && note.targetDateTime != null) {
      notifyTime = _calculateNotificationTime(
        note.targetDateTime!,
        note.reminderOffsetType,
      );
    }

    /// schedule after time
    if (notifyTime != null && notifyTime.isAfter(DateTime.now())) {
      _notificationService.scheduleNotification(
        id: note.id.hashCode,
        title: 'Reminder: ${note.title}',
        body: note.content,
        scheduledTime: notifyTime,
      );
    }
  }

  /// private time based custom offset
  DateTime? _calculateNotificationTime(
    DateTime targetTime,
    ReminderOffsetType offsetType,
  ) {
    switch (offsetType) {
      case ReminderOffsetType.min30Before:
        return targetTime.subtract(const Duration(minutes: 30));
      case ReminderOffsetType.hour1Before:
        return targetTime.subtract(const Duration(hours: 1));
      case ReminderOffsetType.day1Before:
        return targetTime.subtract(const Duration(days: 1));
      case ReminderOffsetType.exact:
      default:
        return targetTime;
    }
  }
}
