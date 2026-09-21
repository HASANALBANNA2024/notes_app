import 'package:flutter/material.dart';
import 'package:notes_app/core/database/note_model.dart';
import '../../../core/widgets/app_theme.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;

  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors
          .transparent, /// Background transparent so outer container color shows
      margin: EdgeInsets.zero, /// Extra margin removed to fix border offset
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                note.title.isEmpty ? 'Untitled Note' : note.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                if (note.isFavorite)
                  const Icon(
                    Icons.favorite,
                    size: 16,
                    color: Colors.red,
                  ),
                if (note.isPinned) ...[
                  const SizedBox(
                    width: 6,
                  ),
                  const Icon(Icons.push_pin, size: 16, color: AppTheme.primary),
                ],
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              note.createdAt.length >= 10
                  ? note.createdAt.substring(0, 10)
                  : note.createdAt,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
