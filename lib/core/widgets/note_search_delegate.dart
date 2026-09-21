import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/note/note_bloc.dart';
import 'package:notes_app/core/bloc/note/note_event.dart';
import 'package:notes_app/core/bloc/note/note_state.dart';

import '../../features/home_screen/widgets/note_card.dart';
import '../../features/new_note/new_note_screen.dart';
import '../database/note_model.dart';

class NoteSearchDelegate extends SearchDelegate<NoteModel?> {
  final NoteBloc noteBloc;

  NoteSearchDelegate({required this.noteBloc});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            noteBloc.add(ClearSearchEvent());
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        noteBloc.add(ClearSearchEvent());
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    noteBloc.add(SearchNotesEvent(query));
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    noteBloc.add(SearchNotesEvent(query));
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return BlocBuilder<NoteBloc, NoteState>(
      bloc: noteBloc,
      builder: (context, state) {
        if (state is NoteLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NoteLoadedState) {
          /// filter
          final results = state.notes.where((note) {
            final q = query.toLowerCase().trim();
            if (q.isEmpty) return true;
            return note.title.toLowerCase().contains(q) ||
                note.content.toLowerCase().contains(q);
          }).toList();

          if (results.isEmpty) {
            return const Center(
              child: Text('No notes found!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final note = results[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NoteCard(
                  note: note,
                  onTap: () {
                    noteBloc.add(ClearSearchEvent());
                    close(context, note);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewNoteScreen(note: note),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
