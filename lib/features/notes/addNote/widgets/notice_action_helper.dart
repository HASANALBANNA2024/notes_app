import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/reminder_picker.dart';

class NoteActionHelper {
  /// Notification Permission Check & Settings Fallback
  static Future<bool> ensureNotificationPermission(BuildContext context) async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await Permission.notification.request();
      if (status.isGranted) return true;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Notification Permission Needed'),
            content: const Text(
              'Please allow notification permission to receive alarms and task reminders.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    }

    return false;
  }

  /// Schedule Picker calendar and time selector
  static Future<DateTime?> pickDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date == null) return null;
    if (!context.mounted) return null;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Date & Time Picker (Alarm / Reminder-for)
  static Future<DateTime?> pickReminder(BuildContext context) async {
    return await ReminderPicker.pickDateTime(context);
  }

  /// Color Picker
  static Future<Color?> pickColor(BuildContext context) async {
    final colors = [
      Colors.white,
      Colors.red.shade100,
      Colors.pink.shade100,
      Colors.orange.shade100,
      Colors.amber.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.purple.shade100,
    ];

    return await showModalBottomSheet<Color>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, colors[index]),
                child: CircleAvatar(
                  backgroundColor: colors[index],
                  radius: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Label Picker
  static Future<String?> pickLabel(BuildContext context) async {
    final labels = ['Personal', 'Work', 'Ideas', 'Urgent'];
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Label'),
          children: labels
              .map(
                (label) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, label),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(label, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  /// More Options Bottom Sheet
  static void showMoreOptions(
    BuildContext context, {
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share Note'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Duplicate'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
