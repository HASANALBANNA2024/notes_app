import '../../features/notes/model/note_model.dart';
import 'database_helper.dart';
import 'notification_service.dart';

///  database helper connect to
class StorageService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final NotificationService _notificationService = NotificationService();

  /// READ
  Future<List<NoteModel>> getAllNotes() async {
    return await _dbHelper.getAllNotes();
  }

  /// Insert
  Future<void> insertNote(NoteModel newNote) async {
    await _dbHelper.insertNote(newNote);
    _handleNotificationSchedule(newNote);
  }

  /// Update
  Future<void> updateNote(NoteModel updatedNote) async {
    await _dbHelper.updateNote(updatedNote);
    await _notificationService.cancelNotification(updatedNote.id.hashCode);
    _handleNotificationSchedule(updatedNote);
  }

  /// DeleteNote
  Future<void> deleteNote(String noteId) async {
    await _dbHelper.deleteNote(noteId);
    await _notificationService.cancelNotification(noteId.hashCode);
  }

  /// ClearNotes Table
  Future<void> clearNotesTable() async {
    await _dbHelper.clearNote();
    await _notificationService.cancelAllNotifications();
  }

  /// _handleNotificationSchedule
  void _handleNotificationSchedule(NoteModel note) {
    DateTime? notifyTime = note.reminderDateTime;

    if (notifyTime == null && note.targetDateTime != null) {
      notifyTime = _calculateNotificationTime(
        note.targetDateTime!,
        note.reminderOffsetType,
      );
    }

    if (notifyTime != null && notifyTime.isAfter(DateTime.now())) {
      _notificationService.scheduleNotification(
        id: note.id.hashCode,
        title: note.title.isNotEmpty ? note.title : 'Reminder',
        body: note.content,
        scheduledTime: notifyTime,
      );
    }
  }

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
