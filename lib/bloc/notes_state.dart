import 'package:equatable/equatable.dart';
import '../models/note.dart';
import 'notes_event.dart';

enum NotesStatus { initial, loading, loaded }

class NotesState extends Equatable {
  final NotesStatus status;
  final List<Note> allNotes;
  final List<Note> visibleNotes;
  final String searchQuery;
  final String? labelFilter;
  final NotesViewMode viewMode;

  const NotesState({
    this.status = NotesStatus.initial,
    this.allNotes = const [],
    this.visibleNotes = const [],
    this.searchQuery = '',
    this.labelFilter,
    this.viewMode = NotesViewMode.list,
  });

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? allNotes,
    List<Note>? visibleNotes,
    String? searchQuery,
    String? labelFilter,
    bool clearLabelFilter = false,
    NotesViewMode? viewMode,
  }) {
    return NotesState(
      status: status ?? this.status,
      allNotes: allNotes ?? this.allNotes,
      visibleNotes: visibleNotes ?? this.visibleNotes,
      searchQuery: searchQuery ?? this.searchQuery,
      labelFilter: clearLabelFilter ? null : (labelFilter ?? this.labelFilter),
      viewMode: viewMode ?? this.viewMode,
    );
  }

  @override
  List<Object?> get props =>
      [status, allNotes, visibleNotes, searchQuery, labelFilter, viewMode];
}
