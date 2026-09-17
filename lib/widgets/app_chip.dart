import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppChip extends StatelessWidget {
  final String label;
  final Color? background;
  final Color? foreground;
  final VoidCallback? onDeleted;

  const AppChip({
    super.key,
    required this.label,
    this.background,
    this.foreground,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = background ?? (isDark ? AppColors.chipBgDark : AppColors.chipBg);
    final fg =
        foreground ?? (isDark ? AppColors.textMutedDark : AppColors.textMuted);

    return Container(
      padding: EdgeInsets.only(
          left: 10, right: onDeleted != null ? 4 : 10, top: 5, bottom: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style:
                  AppText.inter(size: 11, weight: FontWeight.w700, color: fg)),
          if (onDeleted != null) ...[
            const SizedBox(width: 2),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(Icons.close, size: 14, color: fg),
            ),
          ],
        ],
      ),
    );
  }
}
