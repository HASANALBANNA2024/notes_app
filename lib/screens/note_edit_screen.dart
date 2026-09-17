import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../models/note.dart';
import '../models/note_colors.dart';
import '../models/note_labels.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_top_bar.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;

  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String? _selectedLabel;
  int? _selectedColor;
  bool _isPinned = false;
  bool _isLocked = false;
  DateTime? _reminderAt;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.description ?? '');
    _selectedLabel = widget.note?.label;
    _selectedColor = widget.note?.colorValue;
    _isPinned = widget.note?.isPinned ?? false;
    _isLocked = widget.note?.isLocked ?? false;
    _reminderAt = widget.note?.reminderAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty && description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title or some notes')),
      );
      return;
    }

    final now = DateTime.now();
    final bloc = context.read<NotesBloc>();

    if (_isEditing) {
      final updated = widget.note!.copyWith(
        title: title,
        description: description,
        label: _selectedLabel,
        clearLabel: _selectedLabel == null,
        colorValue: _selectedColor,
        clearColor: _selectedColor == null,
        isPinned: _isPinned,
        isLocked: _isLocked,
        reminderAt: _reminderAt,
        clearReminder: _reminderAt == null,
        updatedAt: now,
      );
      bloc.add(UpdateNote(updated));
    } else {
      // Compute the next display sequence (NOTE-001 style) from the
      // current highest one — the bloc doesn't keep a separate counter.
      final nextSequence = bloc.state.allNotes.isEmpty
          ? 1
          : bloc.state.allNotes
                  .map((n) => n.sequenceNumber)
                  .reduce((a, b) => a > b ? a : b) +
              1;
      final created = Note(
        id: const Uuid().v4(),
        sequenceNumber: nextSequence,
        title: title,
        description: description,
        label: _selectedLabel,
        colorValue: _selectedColor,
        isPinned: _isPinned,
        isLocked: _isLocked,
        reminderAt: _reminderAt,
        createdAt: now,
        updatedAt: now,
      );
      bloc.add(AddNote(created));
    }

    Navigator.of(context).pop();
  }

  Future<void> _pickColor() async {
    final choice = await showModalBottomSheet<int?>(
      context: context,
      backgroundColor: _surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Note color',
                    style: AppText.sora(size: 14, weight: FontWeight.w700)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: kNoteColorSwatches.map((colorValue) {
                    final current = _selectedColor ?? kNoNoteColor;
                    final isSelected = current == colorValue;
                    return GestureDetector(
                      onTap: () => Navigator.pop(sheetContext, colorValue),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Color(colorValue),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.border,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (choice != null) {
      setState(() => _selectedColor = choice == kNoNoteColor ? null : choice);
    }
  }

  Future<void> _pickLabel() async {
    final choice = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: _surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Label',
                    style: AppText.sora(size: 14, weight: FontWeight.w700)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('None'),
                      selected: _selectedLabel == null,
                      onSelected: (_) => Navigator.pop(sheetContext, ''),
                    ),
                    ...kLabelPresets.map(
                      (preset) => ChoiceChip(
                        label: Text('${preset.emoji} ${preset.name}'),
                        selected: _selectedLabel == preset.name,
                        onSelected: (_) =>
                            Navigator.pop(sheetContext, preset.name),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (choice != null) {
      setState(() => _selectedLabel = choice.isEmpty ? null : choice);
    }
  }

  Future<void> _pickReminder() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderAt ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reminderAt ?? now),
    );
    if (time == null) return;

    setState(() {
      _reminderAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _openMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              if (_reminderAt != null)
                ListTile(
                  leading: const Icon(Icons.alarm_off_outlined),
                  title: const Text('Remove reminder'),
                  subtitle:
                      Text(DateFormat('MMM d, h:mm a').format(_reminderAt!)),
                  onTap: () {
                    setState(() => _reminderAt = null);
                    Navigator.pop(sheetContext);
                  },
                ),
              if (_isEditing)
                ListTile(
                  leading:
                      const Icon(Icons.delete_outline, color: AppColors.red),
                  title: const Text('Delete note',
                      style: TextStyle(color: AppColors.red)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmDelete();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<NotesBloc>().add(DeleteNote(widget.note!.id));
      Navigator.of(context).pop();
    }
  }

  Color _surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : AppColors.surface;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        leading: AppIconButton(
            icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
        title: _isEditing ? 'Edit Note' : 'New Note',
        actions: [AppIconButton(icon: Icons.check, onTap: _save)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: AppTextField(
              controller: _titleController,
              hint: 'Title',
              style: AppTextFieldStyle.title,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: AppTextField(
                controller: _descriptionController,
                hint: 'Take a note...',
                style: AppTextFieldStyle.body,
                expands: true,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppIconButton(
                    icon: Icons.palette_outlined, onTap: _pickColor, size: 36),
                AppIconButton(
                    icon: Icons.label_outline, onTap: _pickLabel, size: 36),
                AppIconButton(
                  icon: Icons.alarm_outlined,
                  onTap: _pickReminder,
                  active: _reminderAt != null,
                  size: 36,
                ),
                AppIconButton(
                  icon: _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  active: _isPinned,
                  onTap: () => setState(() => _isPinned = !_isPinned),
                  size: 36,
                ),
                AppIconButton(
                  icon: _isLocked ? Icons.lock : Icons.lock_outline,
                  active: _isLocked,
                  onTap: () => setState(() => _isLocked = !_isLocked),
                  size: 36,
                ),
                AppIconButton(
                    icon: Icons.more_vert, onTap: _openMoreMenu, size: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
