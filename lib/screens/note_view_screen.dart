import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../models/note.dart';
import '../models/note_labels.dart';
import '../theme/app_theme.dart';
import '../widgets/app_chip.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_top_bar.dart';
import 'note_edit_screen.dart';

class NoteViewScreen extends StatelessWidget {
  final String noteId;

  const NoteViewScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (previous, current) => previous.allNotes != current.allNotes,
      builder: (context, state) {
        final matches = state.allNotes.where((n) => n.id == noteId);

        if (matches.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) Navigator.of(context).pop();
          });
          return const Scaffold(body: SizedBox.shrink());
        }

        final note = matches.first;
        final preset = findLabelPreset(note.label);

        return Scaffold(
          appBar: AppTopBar(
            leading: AppIconButton(
                icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
            title: 'Note',
            actions: [
              AppIconButton(
                icon: Icons.edit_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)),
                ),
              ),
              AppIconButton(
                  icon: Icons.more_vert,
                  onTap: () => _openMoreMenu(context, note)),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title.isEmpty ? '(Untitled)' : note.title,
                      style: AppText.sora(size: 16, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _friendlyDate(note.updatedAt),
                      style:
                          AppText.inter(size: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.description.isEmpty
                            ? 'No description'
                            : note.description,
                        style: AppText.inter(size: 13, height: 1.6),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (preset != null)
                            AppChip(label: '${preset.emoji} ${preset.name}'),
                          if (note.isPinned) const AppChip(label: '📌 Pinned'),
                          if (note.isLocked) const AppChip(label: '🔒 Locked'),
                          if (note.reminderAt != null)
                            AppChip(
                                label:
                                    '⏰ ${DateFormat('MMM d, h:mm a').format(note.reminderAt!)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _friendlyDate(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    if (isToday) return 'Today at ${DateFormat('h:mm a').format(date)}';
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(date);
  }

  void _openMoreMenu(BuildContext context, Note note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(
                    note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                title: Text(note.isPinned ? 'Unpin note' : 'Pin note'),
                onTap: () {
                  context.read<NotesBloc>().add(TogglePinNote(note.id));
                  Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                leading: Icon(note.isLocked ? Icons.lock : Icons.lock_outline),
                title: Text(note.isLocked ? 'Unlock note' : 'Lock note'),
                onTap: () {
                  context.read<NotesBloc>().add(ToggleLockNote(note.id));
                  Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.red),
                title: const Text('Delete note',
                    style: TextStyle(color: AppColors.red)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(context, note);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text('This will permanently delete "${note.title}".'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<NotesBloc>().add(DeleteNote(note.id));
      Navigator.of(context).pop();
    }
  }
}
