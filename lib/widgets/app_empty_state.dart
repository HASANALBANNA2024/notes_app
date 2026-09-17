import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.text;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMuted;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(opacity: 0.4, child: Icon(icon, size: 48, color: mutedColor)),
          const SizedBox(height: 10),
          Text(title,
              style: AppText.sora(
                  size: 15, weight: FontWeight.w700, color: textColor)),
          const SizedBox(height: 4),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: AppText.inter(size: 12, color: mutedColor)),
        ],
      ),
    );
  }
}
