import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../models/note.dart';
import '../models/note_colors.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';
import 'app_chip.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final bool compact;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.compact = false,
  });

  String _relativeDate() {
    final now = DateTime.now();
    final date = note.updatedAt;
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;

    if (isToday) return 'Today ${DateFormat('h:mm a').format(date)}';
    if (isYesterday) return 'Yesterday';
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.text;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMuted;
    final badge = note.label != null ? kLabelBadgeStyles[note.label!] : null;
    final customColor =
        (note.colorValue != null && note.colorValue != kNoNoteColor)
            ? Color(note.colorValue!)
            : null;

    return AppCard(
      onTap: onTap,
      onLongPress: () => context.read<NotesBloc>().add(TogglePinNote(note.id)),
      backgroundColor: customColor,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!compact)
                Text(note.displayId,
                    style: AppText.inter(
                        size: 10, weight: FontWeight.w700, color: mutedColor)),
              const Spacer(),
              if (note.isPinned)
                Icon(Icons.push_pin, size: 13, color: mutedColor),
              if (note.isLocked) ...[
                const SizedBox(width: 4),
                Icon(Icons.lock_outline, size: 13, color: mutedColor),
              ],
            ],
          ),
          SizedBox(height: compact ? 2 : 4),
          Text(
            note.title.isEmpty ? '(Untitled)' : note.title,
            style: AppText.sora(
                size: 14, weight: FontWeight.w600, color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            note.description.isEmpty ? 'No description' : note.description,
            style: AppText.inter(size: 12.5, color: mutedColor, height: 1.4),
            maxLines: compact ? 3 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Text(_relativeDate(),
                  style: AppText.inter(size: 11, color: mutedColor)),
              if (badge != null)
                AppChip(
                    label: note.label!,
                    background: badge.background,
                    foreground: badge.foreground),
            ],
          ),
        ],
      ),
    );
  }
}
