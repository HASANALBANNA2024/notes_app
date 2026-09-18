import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/note/note_bloc.dart';
import 'package:notes_app/core/bloc/note/note_event.dart';
import 'package:notes_app/core/widgets/app_icon_button.dart';
import 'package:notes_app/core/widgets/app_text.dart';
import 'package:notes_app/core/widgets/custom_app_bar.dart';
import 'package:notes_app/features/home_screen/widgets/note_card.dart';
import 'package:notes_app/features/new_note/new_note_screen.dart';

import '../../core/bloc/note/note_state.dart';
import '../../core/widgets/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(LoadNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomAppBar(
        backgroundColor: AppTheme.background,
        title: "Notes",
        textColor: AppTheme.textPrimary,
        action: [
          AppIconButton(
            icon: Icons.search_off,
            onTap: () {},
            backgroundColor: Colors.white60,
            iconColor: Colors.blue,
            iconSize: 14,
          ),
          const SizedBox(
            width: 5,
          ),
          AppIconButton(
            icon: Icons.more_vert,
            onTap: () {},
            backgroundColor: Colors.white60,
            iconColor: Colors.black,
            iconSize: 14,
          )
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
        if (state is NoteLoadedState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NoteLoadedState) {
          if (state.notes.isEmpty) {
            return const Center(
              child: AppText(
                  'No notes found!\nTap + to create your first note.',
                  textAlign: TextAlign.center),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];

              return NoteCard(
                  note: note,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewNoteScreen(
                                  note: note,
                                )));
                  });
            },
          );
        }
        if (state is NoteErrorState) {
          return Center(
            child: AppText(state.message, textAlign: TextAlign.center),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
