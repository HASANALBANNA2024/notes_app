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
  }
}
