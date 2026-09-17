import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_top_bar.dart';
import 'note_view_screen.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Reminders'),
      body: BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) => previous.allNotes != current.allNotes,
        builder: (context, state) {
          final reminders = state.allNotes.where((n) => n.reminderAt != null).toList()
            ..sort((a, b) => a.reminderAt!.compareTo(b.reminderAt!));

          if (reminders.isEmpty) {
            return Center(
              child: Text('No reminders set', style: AppText.inter(size: 13, color: AppColors.textMuted)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final note = reminders[index];
              final isPast = note.reminderAt!.isBefore(DateTime.now());
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => NoteViewScreen(noteId: note.id)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.alarm, size: 18, color: isPast ? AppColors.textMuted : AppColors.amber),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note.title.isEmpty ? '(Untitled)' : note.title,
                                style: AppText.sora(size: 13.5, weight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(DateFormat('MMM d, yyyy • h:mm a').format(note.reminderAt!),
                                style: AppText.inter(size: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
