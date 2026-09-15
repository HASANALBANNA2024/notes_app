import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/add_bloc.dart';
import 'package:notes_app/core/utils/reminder_picker.dart';
import 'package:notes_app/core/utils/snack_bar_helper.dart';
import 'package:notes_app/features/notes/model/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  DateTime? _selectedReminder;
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<void> _pickReminder() async {
    final selected = await ReminderPicker.pickDateTime(context);
    if (selected != null) {
      setState(() {
        _selectedReminder = selected;
      });
    }
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      SnackBarHelper.show(context, "Please enter title or content/notes");
      return;
    }
    final newNote = NoteModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      date: DateTime.now().toString(),
      badgeText: '',
      badgeType: '',
      reminderDateTime: _selectedReminder,
    );
    context.read<AddBloc>().add(AddNoteEvent(newNote));
  }
}
