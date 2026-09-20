import 'package:flutter/material.dart';
import 'package:notes_app/core/database/note_model.dart';
import 'package:notes_app/features/new_note/new_note_screen.dart';

class NoteSheetHelper {
  ///  Full-Screen Bottom Sheet Launcher for New Note / Edit Note
  static void openNoteBottomSheet(BuildContext context, {NoteModel? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(modalContext).padding.top + 25,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: NewNoteScreen(note: note),
            ),
          ),
        );
      },
    );
  }
}