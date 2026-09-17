import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/note.dart';
import '../services/note_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository _repository;

  NotesBloc({NoteRepository? repository})
      : _repository = repository ?? NoteRepository(),
        super(const NotesState()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<ClearAllNotes>(_onClearAllNotes);
    on<TogglePinNote>(_onTogglePinNote);
    on<ToggleLockNote>(_onToggleLockNote);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<FilterByLabel>(_onFilterByLabel);
    on<ToggleViewMode>(_onToggleViewMode);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.loading));
    final notes = await _repository.getAllNotes();
    emit(state.copyWith(
      status: NotesStatus.loaded,
      allNotes: notes,
      visibleNotes: _applyFilters(notes, state.searchQuery, state.labelFilter),
    ));
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    await _repository.insertNote(event.note);
    final updated = [...state.allNotes, event.note];
    _emitNotes(updated, emit);
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    await _repository.updateNote(event.note);
    final updated = state.allNotes
        .map((n) => n.id == event.note.id ? event.note : n)
        .toList();
    _emitNotes(updated, emit);
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    await _repository.deleteNote(event.noteId);
    final updated = state.allNotes.where((n) => n.id != event.noteId).toList();
    _emitNotes(updated, emit);
  }

  Future<void> _onClearAllNotes(
      ClearAllNotes event, Emitter<NotesState> emit) async {
    await _repository.clearAllNotes();
    _emitNotes(const [], emit);
  }

  Future<void> _onTogglePinNote(
      TogglePinNote event, Emitter<NotesState> emit) async {
    final target =
        state.allNotes.where((n) => n.id == event.noteId).firstOrNull;
    if (target == null) return;

    final updatedNote =
        target.copyWith(isPinned: !target.isPinned, updatedAt: DateTime.now());
    await _repository.updateNote(updatedNote);

    final updated = state.allNotes
        .map((n) => n.id == event.noteId ? updatedNote : n)
        .toList();
    _emitNotes(updated, emit);
  }

  Future<void> _onToggleLockNote(
      ToggleLockNote event, Emitter<NotesState> emit) async {
    final target =
        state.allNotes.where((n) => n.id == event.noteId).firstOrNull;
    if (target == null) return;

    final updatedNote =
        target.copyWith(isLocked: !target.isLocked, updatedAt: DateTime.now());
    await _repository.updateNote(updatedNote);

    final updated = state.allNotes
        .map((n) => n.id == event.noteId ? updatedNote : n)
        .toList();
    _emitNotes(updated, emit);
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<NotesState> emit) {
    emit(state.copyWith(
      searchQuery: event.query,
      visibleNotes:
          _applyFilters(state.allNotes, event.query, state.labelFilter),
    ));
  }

  void _onFilterByLabel(FilterByLabel event, Emitter<NotesState> emit) {
    emit(state.copyWith(
      labelFilter: event.label,
      clearLabelFilter: event.label == null,
      visibleNotes:
          _applyFilters(state.allNotes, state.searchQuery, event.label),
    ));
  }

  void _onToggleViewMode(ToggleViewMode event, Emitter<NotesState> emit) {
    emit(state.copyWith(
      viewMode: state.viewMode == NotesViewMode.list
          ? NotesViewMode.grid
          : NotesViewMode.list,
    ));
  }

  /// Emits a fresh state built from an already-persisted notes list —
  /// the database write itself has already happened by the time this
  /// is called.
  void _emitNotes(List<Note> notes, Emitter<NotesState> emit) {
    emit(state.copyWith(
      status: NotesStatus.loaded,
      allNotes: notes,
      visibleNotes: _applyFilters(notes, state.searchQuery, state.labelFilter),
    ));
  }

  List<Note> _applyFilters(List<Note> notes, String query, String? label) {
    final trimmedQuery = query.trim().toLowerCase();

    final filtered = notes.where((n) {
      final matchesQuery =
          trimmedQuery.isEmpty || n.title.toLowerCase().contains(trimmedQuery);
      final matchesLabel = label == null || n.label == label;
      return matchesQuery && matchesLabel;
    }).toList();

    // Pinned notes float to the top; within each group, most recently
    // updated first.
    filtered.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return filtered;
  }
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
