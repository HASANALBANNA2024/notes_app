import 'package:notes_app/core/database/note_model.dart';

abstract class NoteEvent {}

/// get all notes
class LoadNotesEvent extends NoteEvent {}

/// post (create)
class AddNoteEvent extends NoteEvent {
  final NoteModel note;
  AddNoteEvent(this.note);
}

/// put (update)
class UpdateNoteEvent extends NoteEvent {
  final NoteModel note;
  UpdateNoteEvent(this.note);
}

/// Delete
class DeleteNoteEvent extends NoteEvent {
  final int id;
  DeleteNoteEvent(this.id);
}

/// multi selection events
class ToggleSelectNoteEvent extends NoteEvent {
  final int noteId;
  ToggleSelectNoteEvent(this.noteId);
}

class SelectAllNotesEvent extends NoteEvent {}

class ClearSelectionEvent extends NoteEvent {}

class DeleteSelectedNotesEvent extends NoteEvent {}

/// Search Event
class SearchNotesEvent extends NoteEvent {
  final String query;
  SearchNotesEvent(this.query);
}

class ClearSearchEvent extends NoteEvent {}
