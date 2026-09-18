import 'package:flutter/material.dart';

import '../../core/widgets/app_icon_button.dart';
import '../../core/widgets/app_theme.dart';

class NoteBottomToolbar extends StatelessWidget {
  final bool isPinned;
  final bool isLocked;
  final bool isFavorite;
  final VoidCallback onPinTap;
  final VoidCallback onLockTap;
  final VoidCallback onFavoriteTap;

  const NoteBottomToolbar({
    super.key,
    required this.isPinned,
    required this.isLocked,
    required this.isFavorite,
    required this.onPinTap,
    required this.onLockTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /// Favorite Icon
          AppIconButton(
            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
            iconColor: isFavorite ? Colors.red : null,
            onTap: onFavoriteTap,
          ),
          const SizedBox(width: 10),

          /// Pin Button
          AppIconButton(
            icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            iconColor: isPinned ? AppTheme.primary : null,
            onTap: onPinTap,
          ),
          const SizedBox(width: 10),

          /// Lock Button
          AppIconButton(
            icon: isLocked ? Icons.lock : Icons.lock_outline,
            iconColor: isLocked ? AppTheme.primary : null,
            onTap: onLockTap,
          ),
        ],
      ),
    );
  }
}
