import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/note/note_bloc.dart';
import 'package:notes_app/core/bloc/note/note_event.dart';
import 'package:notes_app/core/widgets/note_search_delegate.dart';
import 'package:notes_app/features/home_screen/widgets/note_card.dart';

import '../../core/bloc/note/note_state.dart';
import '../../core/widgets/app_icon_button.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/app_theme.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../new_note/new_note_screen.dart';

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
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        final isSelectionMode =
            state is NoteLoadedState && state.isSelectionMode;
        final selectedCount =
            state is NoteLoadedState ? state.selectedNoteIds.length : 0;
        final totalNotesCount =
            state is NoteLoadedState ? state.notes.length : 0;

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: isSelectionMode
              ? CustomAppBar(
                  backgroundColor: Colors.blue.shade100,
                  title: "$selectedCount Selected",
                  textColor: Colors.blue.shade900,
                  leadingIcon: AppIconButton(
                    icon: Icons.close,
                    onTap: () {
                      context.read<NoteBloc>().add(ClearSelectionEvent());
                    },
                    backgroundColor: Colors.transparent,
                    iconColor: Colors.black,
                    iconSize: 20,
                  ),
                  action: [
                    AppIconButton(
                      icon: selectedCount == totalNotesCount
                          ? Icons.deselect
                          : Icons.select_all,
                      onTap: () {
                        if (selectedCount == totalNotesCount) {
                          context.read<NoteBloc>().add(ClearSelectionEvent());
                        } else {
                          context.read<NoteBloc>().add(SelectAllNotesEvent());
                        }
                      },
                      backgroundColor: Colors.transparent,
                      iconColor: Colors.black,
                      iconSize: 20,
                    ),
                    const SizedBox(width: 8),
                    AppIconButton(
                      icon: Icons.delete_outline,
                      onTap: () {
                        _showDeleteConfirmation(context, selectedCount);
                      },
                      backgroundColor: Colors.transparent,
                      iconColor: Colors.red,
                      iconSize: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                )
              : CustomAppBar(
                  backgroundColor: AppTheme.background,
                  title: "Notes",
                  textColor: AppTheme.textPrimary,
                  action: [
                    AppIconButton(
                      icon: Icons.search_rounded,
                      onTap: () {
                        /// previous clear
                        context.read<NoteBloc>().add(ClearSearchEvent());
                        showSearch(
                            context: context,
                            delegate: NoteSearchDelegate(
                                noteBloc: context.read<NoteBloc>()));
                      },
                      backgroundColor: Colors.white60,
                      iconColor: Colors.blue,
                      iconSize: 22,
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NoteState state) {
    if (state is NoteLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is NoteLoadedState) {
      if (state.notes.isEmpty) {
        return const Center(
          child: AppText(
            'No notes found!\nTap + to create your first note.',
            textAlign: TextAlign.center,
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: state.notes.length,
        itemBuilder: (context, index) {
          final note = state.notes[index];
          final isSelected =
              note.id != null && state.selectedNoteIds.contains(note.id);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected ? Colors.blue.shade700 : AppTheme.dividerColor,
                width: isSelected ? 2.5 : 1,
              ),
              color: isSelected ? Colors.blue.shade50 : Colors.white,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.blue.withValues(alpha: 0.15),
                highlightColor: Colors.blue.withValues(alpha: 0.05),
                onLongPress: () {
                  if (note.id != null) {
                    context
                        .read<NoteBloc>()
                        .add(ToggleSelectNoteEvent(note.id!));
                  }
                },
                onTap: () {
                  if (state.isSelectionMode) {
                    if (note.id != null) {
                      context
                          .read<NoteBloc>()
                          .add(ToggleSelectNoteEvent(note.id!));
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewNoteScreen(note: note),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    IgnorePointer(
                      child: NoteCard(
                        note: note,
                        onTap: () {},
                      ),
                    ),
                    if (state.isSelectionMode)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Checkbox(
                          value: isSelected,
                          activeColor: Colors.blue,
                          onChanged: (_) {
                            if (note.id != null) {
                              context
                                  .read<NoteBloc>()
                                  .add(ToggleSelectNoteEvent(note.id!));
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    if (state is NoteErrorState) {
      return Center(
        child: AppText(state.message, textAlign: TextAlign.center),
      );
    }
    return const SizedBox.shrink();
  }

  void _showDeleteConfirmation(BuildContext context, int count) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Notes'),
        content:
            Text('Are you sure you want to delete $count selected note(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteBloc>().add(DeleteSelectedNotesEvent());
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
