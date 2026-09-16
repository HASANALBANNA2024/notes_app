import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/notes/model/note_model.dart';
import '../base/base_bloc_state.dart';
import '../service/storage_service.dart';

class NotesBloc extends Bloc<BaseEvent, BaseState> {
  final StorageService _storageService = StorageService();

  NotesBloc() : super(BaseInitialState()) {
    on<FetchDataEvent>(_onFetchNotes);
  }

  int _getLabelPriority(String? label) {
    if (label == null || label.trim().isEmpty) return 5;

    switch (label.toLowerCase().trim()) {
      case 'urgent':
        return 1;
      case 'ideas':
        return 2;
      case 'work':
        return 3;
      case 'personal':
        return 4;
      default:
        return 5;
    }
  }

  Future<void> _onFetchNotes(
    FetchDataEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(BaseLoadingState());
    try {
      final List<NoteModel> notes = await _storageService.getAllNotes();

      if (notes.isNotEmpty) {
        // Pinned & Priority Label Sorting
        notes.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;

          final int priorityA = _getLabelPriority(a.badgeText);
          final int priorityB = _getLabelPriority(b.badgeText);

          return priorityA.compareTo(priorityB);
        });

        emit(BaseSuccessState<List<NoteModel>>(notes));
      } else {
        emit(const BaseSuccessState<List<NoteModel>>([]));
      }
    } catch (e) {
      emit(const BaseFailureState("Failed to load notes"));
    }
  }
}
