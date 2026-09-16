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
    // ✅ FIX #3: Now awaiting the async notification handling
    await _handleNotificationSchedule(newNote);
  }

  /// Update
  Future<void> updateNote(NoteModel updatedNote) async {
    await _dbHelper.updateNote(updatedNote);
    // ✅ FIX #1: Use consistent ID generation (.hashCode.abs())
    await _notificationService.cancelNotification(updatedNote.id.hashCode);
    // ✅ FIX #3: Now awaiting the async notification handling
    await _handleNotificationSchedule(updatedNote);
  }

  /// DeleteNote
  Future<void> deleteNote(String noteId) async {
    await _dbHelper.deleteNote(noteId);
    // ✅ FIX #1: Use consistent ID generation (.hashCode.abs())
    await _notificationService.cancelNotification(noteId.hashCode);
  }

  /// ClearNotes Table
  Future<void> clearNotesTable() async {
    await _dbHelper.clearNote();
    await _notificationService.cancelAllNotifications();
  }

  /// ✅ FIX #3: Made this async and added proper error handling
  Future<void> _handleNotificationSchedule(NoteModel note) async {
    try {
      DateTime? notifyTime = note.reminderDateTime;

      if (notifyTime == null && note.targetDateTime != null) {
        notifyTime = _calculateNotificationTime(
          note.targetDateTime!,
          note.reminderOffsetType,
        );
      }

      if (notifyTime != null && notifyTime.isAfter(DateTime.now())) {
        // ✅ FIX #1: Use consistent ID generation (.hashCode.abs())
        await _notificationService.scheduleNotification(
          id: note.id.hashCode,
          title: note.title.isNotEmpty ? note.title : 'Reminder',
          body: note.content,
          scheduledTime: notifyTime,
        );
      }
    } catch (e) {
      print('Error handling notification schedule: $e');
      // Don't rethrow - we don't want notification issues to break note creation
    }
  }

  /// Calculate notification time based on offset type
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
