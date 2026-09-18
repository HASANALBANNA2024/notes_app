import 'package:notes_app/core/database/note_model.dart';

abstract class NoteState {}

class NoteInitialState extends NoteState {}

class NoteLoadingState extends NoteState {}

class NoteLoadedState extends NoteState {
  final List<NoteModel> notes;
  NoteLoadedState(this.notes);
}

class NoteErrorState extends NoteState {
  final String message;
  NoteErrorState(this.message);
}
