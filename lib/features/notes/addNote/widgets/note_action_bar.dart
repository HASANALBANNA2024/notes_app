import 'package:flutter/material.dart';

class NoteActionBar extends StatelessWidget {
  final VoidCallback onScheduleTap;
  final VoidCallback onReminderTap;
  final VoidCallback? onColorTap;
  final VoidCallback? onLabelTap;
  final VoidCallback? onPinTap;
  final VoidCallback? onLockTap;
  final VoidCallback? onMoreTap;

  final DateTime? selectedSchedule;
  final DateTime? selectedReminder;
  final bool isPinned;
  final bool isLocked;
  final bool hasLabel;
  final bool hasColor;

  const NoteActionBar({
    super.key,
    required this.onScheduleTap,
    required this.onReminderTap,
    this.onColorTap,
    this.onLabelTap,
    this.onPinTap,
    this.onLockTap,
    this.onMoreTap,
    this.selectedSchedule,
    this.selectedReminder,
    this.isPinned = false,
    this.isLocked = false,
    this.hasLabel = false,
    this.hasColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          label: "Label",
          outlineIcon: Icons.label_outline,
          activeIcon: Icons.label,
          isSelected: hasLabel,
          activeColor: Colors.orange,
          bgColor: Colors.orange.shade50,
          onTap: onLabelTap,
        ),
        _buildActionButton(
          label: "Schedule",
          outlineIcon: Icons.calendar_today_outlined,
          activeIcon: Icons.calendar_today,
          isSelected: selectedSchedule != null,
          activeColor: Colors.blue,
          bgColor: Colors.blue.shade50,
          onTap: onScheduleTap,
        ),
        _buildActionButton(
          label: "Alarm",
          outlineIcon: Icons.alarm_outlined,
          activeIcon: Icons.alarm,
          isSelected: selectedReminder != null,
          activeColor: Colors.purple,
          bgColor: Colors.purple.shade50,
          onTap: onReminderTap,
        ),
        _buildActionButton(
          label: isPinned ? "Pinned" : "Pin",
          outlineIcon: Icons.push_pin_outlined,
          activeIcon: Icons.push_pin,
          isSelected: isPinned,
          activeColor: Colors.red,
          bgColor: Colors.red.shade50,
          onTap: onPinTap,
        ),
        _buildActionButton(
          label: isLocked ? "Locked" : "Lock",
          outlineIcon: Icons.lock_outline,
          activeIcon: Icons.lock,
          isSelected: isLocked,
          activeColor: Colors.amber,
          bgColor: Colors.amber.shade50,
          onTap: onLockTap,
        ),
        _buildActionButton(
          label: "More Options",
          outlineIcon: Icons.more_vert,
          activeIcon: Icons.more_vert,
          isSelected: false,
          activeColor: Colors.grey,
          bgColor: Colors.grey.shade100,
          onTap: onMoreTap,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData outlineIcon,
    required IconData activeIcon,
    required bool isSelected,
    required Color activeColor,
    required Color bgColor,
    required VoidCallback? onTap,
  }) {
    return Tooltip(
      message: label,
      preferBelow: false,
      verticalOffset: 20,
      decoration: BoxDecoration(
        color: activeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withOpacity(0.2) : bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Icon(
            isSelected ? activeIcon : outlineIcon,
            color: isSelected ? activeColor : activeColor.withOpacity(0.8),
            size: isSelected ? 20 : 18,
          ),
        ),
      ),
    );
  }
}
