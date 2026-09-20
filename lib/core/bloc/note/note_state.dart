import 'package:notes_app/core/database/note_model.dart';

abstract class NoteState {}

class NoteInitialState extends NoteState {}

class NoteLoadingState extends NoteState {}

class NoteLoadedState extends NoteState {
  final List<NoteModel> notes;
  final Set<int> selectedNoteIds;

  NoteLoadedState(this.notes, {Set<int>? selectedNoteIds})
      : selectedNoteIds = selectedNoteIds ?? {};

  bool get isSelectionMode => selectedNoteIds.isNotEmpty;

  NoteLoadedState copyWith({
    List<NoteModel>? notes,
    Set<int>? selectedNoteIds,
  }) {
    return NoteLoadedState(
      notes ?? this.notes,
      selectedNoteIds: selectedNoteIds ?? this.selectedNoteIds,
    );
  }
}

class NoteErrorState extends NoteState {
  final String message;
  NoteErrorState(this.message);
}