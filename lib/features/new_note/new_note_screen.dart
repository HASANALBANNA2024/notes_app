import 'package:flutter/material.dart';
import 'package:notes_app/core/database/note_model.dart';
import 'package:notes_app/core/widgets/app_icon_button.dart';
import 'package:notes_app/core/widgets/app_text.dart';

import '../../controllers/note_form_controller.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_theme.dart';
import '../widgets/bottom_toolbar_section.dart';

class NewNoteScreen extends StatefulWidget {
  final NoteModel? note;

  const NewNoteScreen({super.key, this.note});

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  late NoteFormController _formController;

  @override
  void initState() {
    super.initState();

    /// Fixed parameter name matching controller constructor
    _formController = NoteFormController(existingNote: widget.note);
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Screen Open/Rebuild Tracker
    debugPrint(" NewNoteScreen Main Build Called");

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppIconButton(
            icon: Icons.arrow_back,
            onTap: () => _formController.onTapSavedAndPop(context),
          ),
        ),
        title: AppText(
          widget.note == null ? 'New Note' : 'Edit Note',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.start,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AppIconButton(
              icon: Icons.check,
              onTap: () => _formController.onTapSavedAndPop(context),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Divider(color: AppTheme.dividerColor, thickness: 1),
            AppTextField(
              controller: _formController.titleController,
              hintText: 'Idea, thinks about of title',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            const Divider(color: AppTheme.dividerColor, thickness: 1),
            const SizedBox(height: 10),
            Expanded(
              child: AppTextField(
                controller: _formController.contentController,
                hintText:
                    'Add your thoughts, ideas, and important information here. Your note will be automatically saved as you type.',
                fontSize: 14,
                maxLines: null,
              ),
            ),
            const Divider(color: AppTheme.dividerColor, thickness: 1),

            /// Isolated Bottom Toolbar Build Area
            BottomToolbarSection(formController: _formController),
          ],
        ),
      ),
    );
  }
}
