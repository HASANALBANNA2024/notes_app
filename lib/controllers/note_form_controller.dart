import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/note/note_bloc.dart';
import 'package:notes_app/core/bloc/note/note_event.dart';
import '../core/database/note_model.dart';

class NoteFormController {
  late TextEditingController titleController;
  late TextEditingController contentController;

  /// Local State Management with ValueNotifier
  late ValueNotifier<bool> isPinnedNotifier;
  late ValueNotifier<bool> isFavoriteNotifier;

  final NoteModel? existingNote;

  NoteFormController({this.existingNote, NoteModel? note}) {
    titleController = TextEditingController(text: existingNote?.title ?? '');
    contentController =
        TextEditingController(text: existingNote?.content ?? '');

    isPinnedNotifier = ValueNotifier<bool>(existingNote?.isPinned ?? false);
    isFavoriteNotifier = ValueNotifier<bool>(existingNote?.isFavorite ?? false);
  }

  /// Toggle methods
  void togglePin() {
    isPinnedNotifier.value = !isPinnedNotifier.value;
  }


  void toggleFavorite() {
    isFavoriteNotifier.value = !isFavoriteNotifier.value;
  }

  /// Save Note Action
  void onTapSavedAndPop(BuildContext context) {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isNotEmpty || content.isNotEmpty) {
      final note = NoteModel(
        id: existingNote?.id,
        title: title,
        content: content,
        createdAt: existingNote?.createdAt ?? DateTime.now().toString(),
        isPinned: isPinnedNotifier.value,
        isFavorite: isFavoriteNotifier.value,
      );

      if (existingNote == null) {
        context.read<NoteBloc>().add(AddNoteEvent(note));
      } else {
        context.read<NoteBloc>().add(UpdateNoteEvent(note));
      }
    }
    Navigator.pop(context);
  }

  /// Dispose method for clean memory
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    isPinnedNotifier.dispose();
    isFavoriteNotifier.dispose();
  }
}
