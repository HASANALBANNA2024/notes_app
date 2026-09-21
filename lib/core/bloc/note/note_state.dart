import 'package:notes_app/core/database/note_model.dart';

abstract class NoteState {}

class NoteInitialState extends NoteState {}

class NoteLoadingState extends NoteState {}

class NoteLoadedState extends NoteState {
  final List<NoteModel> notes;
  final Set<int> selectedNoteIds;
  final String searchQuery;

  NoteLoadedState(this.notes,
      {Set<int>? selectedNoteIds, this.searchQuery = ''})
      : selectedNoteIds = selectedNoteIds ?? {};

  bool get isSelectionMode => selectedNoteIds.isNotEmpty;

  /// search notes getter
  List<NoteModel> get filteredNotes {
    if (searchQuery.isEmpty) return notes;
    final q = searchQuery.toLowerCase();
    return notes.where((note) {
      final title = note.title.toLowerCase();
      final content = note.content.toLowerCase();
      return title.contains(q) || content.contains(q);
    }).toList();
  }

  NoteLoadedState copyWith({
    List<NoteModel>? notes,
    Set<int>? selectedNoteIds,
    String? searchQuery,
  }) {
    return NoteLoadedState(notes ?? this.notes,
        selectedNoteIds: selectedNoteIds ?? this.selectedNoteIds,
        searchQuery: searchQuery ?? this.searchQuery);
  }
}

class NoteErrorState extends NoteState {
  final String message;
  NoteErrorState(this.message);
}
