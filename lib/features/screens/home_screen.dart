import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/base/base_bloc_state.dart';
import 'package:notes_app/core/bloc/notes_bloc.dart';
import 'package:notes_app/core/widgets/app_icon_button.dart';
import 'package:notes_app/core/widgets/custom_app_bar.dart';
import 'package:notes_app/features/notes/addNote/add_note_screen.dart';
import 'package:notes_app/features/notes/model/note_model.dart';
import 'package:notes_app/features/screens/widgets/note_card.dart';

import '../../../core/widgets/screen_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        /// Custom AppBar
        appBar: CustomAppBar(
          title: "Notes",
          actions: [
            AppIconButton(
              icon: Icons.search_rounded,
              backgroundColor: Colors.white70,
              iconColor: Colors.blue,
              iconSize: 16,
              onTap: () {},
            ),
            AppIconButton(
              icon: Icons.more_vert,
              backgroundColor: Colors.white70,
              iconColor: Colors.blue,
              iconSize: 16,
              onTap: () {},
            ),
          ],
        ),

        // Body Content
        body: BlocBuilder<NotesBloc, BaseState>(
          builder: (context, state) {
            if (state is BaseLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF0EA5A0)),
              );
            }

            if (state is BaseFailureState) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is BaseSuccessState<List<NoteModel>>) {
              final notes = state.data;

              if (notes.isEmpty) {
                return const Center(
                  child: Text(
                    'No notes added yet!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF161B26),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                color: const Color(0xFF0EA5A0),
                onRefresh: () async {
                  context.read<NotesBloc>().add(FetchDataEvent());
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return NoteCard(
                      note: notes[index],
                      index: index,
                      onTap: () {},
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),

        /// Floating Action Button
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0EA5A0),
          elevation: 4,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNoteScreen()),
            ).then((_) {
              if (mounted) {
                context.read<NotesBloc>().add(FetchDataEvent());
              }
            });
          },
          child: const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
