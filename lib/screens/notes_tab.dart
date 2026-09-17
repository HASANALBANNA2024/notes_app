import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../models/note_labels.dart';
import '../theme/app_theme.dart';
import '../widgets/app_chip.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/note_card.dart';
import 'note_edit_screen.dart';
import 'note_view_screen.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({super.key});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() => setState(() => _isSearching = true);

  void _closeSearch() {
    _searchController.clear();
    context.read<NotesBloc>().add(const SearchQueryChanged(''));
    setState(() => _isSearching = false);
  }

  void _openNote(String noteId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NoteViewScreen(noteId: noteId)),
    );
  }

  void _openMoreMenu() {
    final bloc = context.read<NotesBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final isGrid = bloc.state.viewMode == NotesViewMode.grid;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded),
                title: Text(isGrid ? 'Switch to list view' : 'Switch to grid view'),
                onTap: () {
                  bloc.add(const ToggleViewMode());
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        titleWidget: _isSearching
            ? AppTextField(
                controller: _searchController,
                autofocus: true,
                hint: 'Search notes by title...',
                onChanged: (value) =>
                    context.read<NotesBloc>().add(SearchQueryChanged(value)),
              )
            : Text('Notes', style: AppText.sora(size: 16, weight: FontWeight.w700)),
        actions: [
          AppIconButton(
            icon: _isSearching ? Icons.close : Icons.search,
            onTap: _isSearching ? _closeSearch : _openSearch,
          ),
          AppIconButton(icon: Icons.more_vert, onTap: _openMoreMenu),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<NotesBloc, NotesState>(
            buildWhen: (previous, current) => previous.labelFilter != current.labelFilter,
            builder: (context, state) {
              if (state.labelFilter == null) return const SizedBox.shrink();
              final preset = findLabelPreset(state.labelFilter);
              return Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppChip(
                    label: '${preset?.emoji ?? ''} ${state.labelFilter}',
                    onDeleted: () => context.read<NotesBloc>().add(const FilterByLabel(null)),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state.status == NotesStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                }
                if (state.visibleNotes.isEmpty) {
                  final hasFilter = state.searchQuery.isNotEmpty || state.labelFilter != null;
                  return AppEmptyState(
                    icon: hasFilter ? Icons.search_off : Icons.edit_note_rounded,
                    title: hasFilter ? 'No Matches Found' : 'No Notes Yet',
                    subtitle: hasFilter
                        ? 'Try a different search or clear the label filter'
                        : 'Create your first note to get started',
                  );
                }
                if (state.viewMode == NotesViewMode.grid) {
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 88),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: state.visibleNotes.length,
                    itemBuilder: (context, index) {
                      final note = state.visibleNotes[index];
                      return NoteCard(
                        note: note,
                        compact: true,
                        onTap: () => _openNote(note.id),
                      );
                    },
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 88),
                  itemCount: state.visibleNotes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final note = state.visibleNotes[index];
                    return NoteCard(note: note, onTap: () => _openNote(note.id));
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        elevation: 0,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NoteEditScreen()),
        ),
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
    );
  }
}
