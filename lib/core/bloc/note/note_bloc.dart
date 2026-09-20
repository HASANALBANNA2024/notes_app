import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/note/note_event.dart';
import 'package:notes_app/core/database/database_helper.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitialState()) {
    /// Get (Load Notes)
    on<LoadNotesEvent>((event, emit) async {
      emit(NoteLoadingState());
      try {
        final notes = await DatabaseHelper.instance.getAllNotes();
        emit(NoteLoadedState(notes));
      } catch (e) {
        emit(NoteErrorState("Failed to load notes: $e"));
      }
    });

    /// add notes
    on<AddNoteEvent>((event, emit) async {
      try {
        await DatabaseHelper.instance.insertNote(event.note);
        add(LoadNotesEvent());
      } catch (e) {
        emit(NoteErrorState("Failed to add notes:  $e"));
      }
    });

    /// update notes
    on<UpdateNoteEvent>((event, emit) async {
      try {
        await DatabaseHelper.instance.updateNote(event.note);
        add(LoadNotesEvent());
      } catch (e) {
        emit(NoteErrorState("Failed to update notes: $e"));
      }
    });

    /// Delete Notes
    on<DeleteNoteEvent>((event, emit) async {
      try {
        await DatabaseHelper.instance.deleteNote(event.id);
        add(LoadNotesEvent());
      } catch (e) {
        emit(NoteErrorState("Failed to delete notes: $e"));
      }
    });

    ///  Toggle Single Selection
    on<ToggleSelectNoteEvent>((event, emit) {
      if (state is NoteLoadedState) {
        final currentState = state as NoteLoadedState;
        final updatedIds = Set<int>.from(currentState.selectedNoteIds);

        if (updatedIds.contains(event.noteId)) {
          updatedIds.remove(event.noteId);
        } else {
          updatedIds.add(event.noteId);
        }

        emit(currentState.copyWith(selectedNoteIds: updatedIds));
      }
    });

    ///  Select All Notes
    on<SelectAllNotesEvent>((event, emit) {
      if (state is NoteLoadedState) {
        final currentState = state as NoteLoadedState;
        final allIds = currentState.notes
            .where((n) => n.id != null)
            .map((n) => n.id!)
            .toSet();

        emit(currentState.copyWith(selectedNoteIds: allIds));
      }
    });

    ///  Clear Selection
    on<ClearSelectionEvent>((event, emit) {
      if (state is NoteLoadedState) {
        final currentState = state as NoteLoadedState;
        emit(currentState.copyWith(selectedNoteIds: {}));
      }
    });

    ///  Delete Selected Notes
    on<DeleteSelectedNotesEvent>((event, emit) async {
      if (state is NoteLoadedState) {
        final currentState = state as NoteLoadedState;
        try {
          for (int id in currentState.selectedNoteIds) {
            await DatabaseHelper.instance.deleteNote(id);
          }
          add(LoadNotesEvent());
        } catch (e) {
          emit(NoteErrorState("Failed to delete selected notes: $e"));
        }
      }
    });
  }
}