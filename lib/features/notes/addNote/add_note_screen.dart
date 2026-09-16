import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/core/base/base_bloc_state.dart';
import 'package:notes_app/core/bloc/add_bloc.dart';
import 'package:notes_app/core/utils/snack_bar_helper.dart';
import 'package:notes_app/core/widgets/app_icon.dart';
import 'package:notes_app/core/widgets/app_icon_button.dart';
import 'package:notes_app/core/widgets/app_text.dart';
import 'package:notes_app/core/widgets/app_text_field.dart';
import 'package:notes_app/core/widgets/custom_app_bar.dart';
import 'package:notes_app/features/notes/addNote/widgets/note_action_bar.dart';
import 'package:notes_app/features/notes/addNote/widgets/notice_action_helper.dart';

import '../../../core/service/notification_service.dart';
import '../model/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _selectedLabel = '';
  bool _isPinned = false;
  bool _isLocked = false;

  DateTime? _selectedScheduleDate;
  DateTime? _selectedAlarmDate;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddBloc, BaseState>(
      listener: (context, state) {
        if (state is BaseSuccessState) {
          SnackBarHelper.show(context, "Note saved successfully!");
          Navigator.pop(context);
        } else if (state is BaseFailureState) {
          SnackBarHelper.show(context, state.errorMessage);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "New Note",
          leading: AppIconButton(
            icon: Icons.arrow_back,
            iconColor: Colors.black,
            backgroundColor: Colors.grey.shade100,
            onTap: () => Navigator.pop(context),
          ),
          actions: [
            AppIconButton(
              icon: Icons.check,
              iconColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: _onTapsaveNote,
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title Field
              AppTextField(
                controller: _titleController,
                hintText: "Title",
                labelText: "",
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.grey, thickness: 0.2),

              /// Active Selection Chips
              if (_isPinned ||
                  _isLocked ||
                  _selectedLabel.isNotEmpty ||
                  _selectedScheduleDate != null ||
                  _selectedAlarmDate != null) ...[
                Wrap(
                  spacing: 8.0,
                  runSpacing: 6.0,
                  children: [
                    if (_isPinned)
                      Chip(
                        backgroundColor: Colors.amber.shade100,
                        avatar: const AppIcon(
                          icon: Icons.push_pin,
                          iconSize: 14,
                          iconColor: Colors.amber,
                        ),
                        label: const AppText(
                          'Pinned',
                          fontSize: 11,
                          color: Colors.amber,
                        ),
                        onDeleted: () => setState(() => _isPinned = false),
                      ),
                    if (_isLocked)
                      Chip(
                        backgroundColor: Colors.grey.shade200,
                        avatar: const AppIcon(
                          icon: Icons.lock,
                          iconSize: 14,
                          iconColor: Colors.grey,
                        ),
                        label: AppText(
                          'Locked',
                          fontSize: 11,
                          color: Colors.grey.shade800,
                        ),
                        onDeleted: () => setState(() => _isLocked = false),
                      ),
                    if (_selectedLabel.isNotEmpty)
                      Chip(
                        backgroundColor: Colors.green.shade50,
                        avatar: const AppIcon(
                          icon: Icons.label,
                          iconSize: 14,
                          iconColor: Colors.green,
                        ),
                        label: AppText(
                          _selectedLabel,
                          fontSize: 11,
                          color: Colors.green.shade800,
                        ),
                        onDeleted: () => setState(() => _selectedLabel = ''),
                      ),
                    if (_selectedScheduleDate != null)
                      Chip(
                        backgroundColor: Colors.blue.shade50,
                        avatar: const AppIcon(
                          icon: Icons.calendar_today,
                          iconSize: 14,
                          iconColor: Colors.blue,
                        ),
                        label: AppText(
                          'Schedule: ${DateFormat('MMM dd, hh:mm a').format(_selectedScheduleDate!)}',
                          fontSize: 11,
                          color: Colors.blue.shade900,
                        ),
                        onDeleted: () =>
                            setState(() => _selectedScheduleDate = null),
                      ),
                    if (_selectedAlarmDate != null)
                      Chip(
                        backgroundColor: Colors.purple.shade50,
                        avatar: const AppIcon(
                          icon: Icons.alarm,
                          iconSize: 14,
                          iconColor: Colors.purple,
                        ),
                        label: AppText(
                          'Alarm: ${DateFormat('MMM dd, hh:mm a').format(_selectedAlarmDate!)}',
                          fontSize: 11,
                          color: Colors.purple.shade800,
                        ),
                        onDeleted: () =>
                            setState(() => _selectedAlarmDate = null),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Content Field
              AppTextField(
                controller: _contentController,
                labelText: "",
                hintText:
                    'Add your thoughts, ideas, and important information here. Your note will be automatically saved as you type.',
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),

              const Divider(color: Colors.grey, thickness: 0.2),
              const SizedBox(height: 12),

              /// Action Buttons Row
              NoteActionBar(
                isPinned: _isPinned,
                isLocked: _isLocked,
                onLabelTap: _handleLabelPick,
                onScheduleTap: _handleSchedulePick,
                onReminderTap: _handleAlarmPick,
                onPinTap: () => setState(() => _isPinned = !_isPinned),
                onLockTap: () => setState(() => _isLocked = !_isLocked),
                onMoreTap: () => NoteActionHelper.showMoreOptions(
                  context,
                  onDelete: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLabelPick() async {
    final label = await NoteActionHelper.pickLabel(context);
    if (label != null) setState(() => _selectedLabel = label);
  }

  /// permission check schedule pick
  Future<void> _handleSchedulePick() async {
    bool hasPermission = await NoteActionHelper.ensureNotificationPermission(
      context,
    );
    if (hasPermission) {
      if (!mounted) return;
      final picked = await NoteActionHelper.pickDateTime(context);
      if (picked != null) setState(() => _selectedScheduleDate = picked);
    }
  }

  /// permission check and alarm pick
  Future<void> _handleAlarmPick() async {
    bool hasPermission = await NoteActionHelper.ensureNotificationPermission(
      context,
    );
    if (hasPermission) {
      if (!mounted) return;
      final picked = await NoteActionHelper.pickReminder(context);
      if (picked != null) setState(() => _selectedAlarmDate = picked);
    }
  }

  /// ✅ FIX #4: Generate unique ID using full timestamp instead of weak remainder
  String _generateUniqueId() {
    // Use full timestamp + random component for guaranteed uniqueness
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (DateTime.now().microsecond % 10000).toString().padLeft(
      4,
      '0',
    );
    return '$timestamp$random';
  }

  /// note save and dynamic notification scheduling
  void _onTapsaveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      SnackBarHelper.show(context, "Please enter title or content");
      return;
    }

    // ✅ FIX #4: Generate unique ID using full timestamp
    final String uniqueId = _generateUniqueId();

    final newNote = NoteModel(
      id: uniqueId,
      title: title,
      content: content,
      date: DateTime.now().toIso8601String(),
      isPinned: _isPinned,
      isLocked: _isLocked,
      badgeText: _selectedLabel,
      badgeType: _selectedLabel.isNotEmpty ? 'label' : '',
      targetDateTime: _selectedScheduleDate,
      reminderDateTime: _selectedAlarmDate,
      reminderOffsetType: ReminderOffsetType.exact,
    );

    /// ✅ dynamic notification fire - use hashCode for consistent ID
    final DateTime? reminderTime = _selectedAlarmDate ?? _selectedScheduleDate;
    if (reminderTime != null && reminderTime.isAfter(DateTime.now())) {
      try {
        // ✅ FIX #1: Use hashCode.abs() to match notification service
        await NotificationService().scheduleNotification(
          id: uniqueId.hashCode,
          title: title.isNotEmpty ? title : 'Note Reminder 🔔',
          body: content.isNotEmpty
              ? content
              : 'You have a scheduled note task!',
          scheduledTime: reminderTime,
        );
      } catch (e) {
        print('Error scheduling notification: $e');
        if (!mounted) return;
        SnackBarHelper.show(
          context,
          "Note saved but notification scheduling failed",
        );
      }
    }

    if (!mounted) return;
    context.read<AddBloc>().add(AddNoteEvent(newNote));
  }
}
