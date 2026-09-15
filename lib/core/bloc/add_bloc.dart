import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/base/base_bloc_state.dart';
import 'package:notes_app/core/service/storage_service.dart';
import 'package:notes_app/features/notes/model/note_model.dart';

class AddNoteEvent extends BaseEvent {
  final NoteModel note;
  const AddNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class AddBloc extends Bloc<BaseEvent, BaseState> {
  final StorageService storageService;

  AddBloc({StorageService? storageservice})
    : storageService = storageservice ?? StorageService(),
      super(BaseInitialState()) {
    /// note add event
    on<AddNoteEvent>((event, emit) async {
      emit(BaseLoadingState());
      try {
        await storageService.insertNote(event.note);
        final updatedNotes = storageService.getAllNotes();
        emit(BaseSuccessState<List<NoteModel>>(updatedNotes));
      } catch (e) {
        emit(BaseFailureState(e.toString()));
      }
    });
  }
}
