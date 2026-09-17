import 'package:equatable/equatable.dart';
import '../models/note.dart';

enum NotesViewMode { list, grid }

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object?> get props => [];
}

/// Loads notes from local storage. Dispatched once at app startup.
class LoadNotes extends NotesEvent {
  const LoadNotes();
}

class AddNote extends NotesEvent {
  final Note note;
  const AddNote(this.note);
  @override
  List<Object?> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;
  const UpdateNote(this.note);
  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NotesEvent {
  final String noteId;
  const DeleteNote(this.noteId);
  @override
  List<Object?> get props => [noteId];
}

class ClearAllNotes extends NotesEvent {
  const ClearAllNotes();
}

class TogglePinNote extends NotesEvent {
  final String noteId;
  const TogglePinNote(this.noteId);
  @override
  List<Object?> get props => [noteId];
}

class ToggleLockNote extends NotesEvent {
  final String noteId;
  const ToggleLockNote(this.noteId);
  @override
  List<Object?> get props => [noteId];
}

class SearchQueryChanged extends NotesEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

/// Pass null to clear the active label filter.
class FilterByLabel extends NotesEvent {
  final String? label;
  const FilterByLabel(this.label);
  @override
  List<Object?> get props => [label];
}

class ToggleViewMode extends NotesEvent {
  const ToggleViewMode();
}
