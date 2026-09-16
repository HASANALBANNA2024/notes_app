import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/core/widgets/app_text.dart';
import 'package:notes_app/features/notes/model/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final int index;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasBadge = note.badgeText.isNotEmpty;
    final bool hasTargetTime = note.targetDateTime != null;
    final bool hasReminderTime = note.reminderDateTime != null;
    final bool hasFooter = hasBadge || hasTargetTime || hasReminderTime;

    // Label Dynamic Colors (Image Theme)
    final Color tagBackgroundColor = _getLabelBgColor(note.badgeText);
    final Color tagTextColor = _getLabelTextColor(note.badgeText);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB), // Image Grey Border
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Only Icons (Lock & Pinned)
            if (note.isLocked || note.isPinned)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (note.isLocked) ...[
                    Icon(Icons.lock, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                  ],
                  if (note.isPinned) ...[
                    Icon(
                      Icons.push_pin,
                      size: 14,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 2),
                    AppText(
                      'Pinned',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade700,
                    ),
                  ],
                ],
              ),

            if (note.isLocked || note.isPinned) const SizedBox(height: 6),

            // Title
            AppText(
              note.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
            const SizedBox(height: 6),

            // Content body
            AppText(
              note.isLocked ? '••••••••' : note.content,
              fontSize: 13,
              color: const Color(0xFF6B7280),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Footer Section: Priority Badge & Date/Time Badges
            if (hasFooter) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Label Badge (Left side)
                  if (hasBadge)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tagBackgroundColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        note.badgeText,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: tagTextColor,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),

                  // Schedule & Alarm Badges (Right side)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasTargetTime)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.event_note,
                                size: 12,
                                color: Color(0xFF4338CA),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  'MMM dd, hh:mm a',
                                ).format(note.targetDateTime!),
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4338CA),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (hasTargetTime && hasReminderTime)
                        const SizedBox(width: 6),

                      if (hasReminderTime)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.alarm,
                                size: 12,
                                color: Color(0xFF7E22CE),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  'MMM dd, hh:mm a',
                                ).format(note.reminderDateTime!),
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF7E22CE),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Label Colors Matching Image Theme
  Color _getLabelBgColor(String label) {
    switch (label.toLowerCase()) {
      case 'work':
        return const Color(0xFFE0E7FF);
      case 'personal':
        return const Color(0xFFD1FAE5);
      case 'ideas':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getLabelTextColor(String label) {
    switch (label.toLowerCase()) {
      case 'work':
        return const Color(0xFF4338CA);
      case 'personal':
        return const Color(0xFF047857);
      case 'ideas':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF374151);
    }
  }
}
