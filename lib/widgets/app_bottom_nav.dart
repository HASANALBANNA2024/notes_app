import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBottomNavItem {
  final IconData icon;
  final String label;
  const AppBottomNavItem(this.icon, this.label);
}

class AppBottomNav extends StatelessWidget {
  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMuted;

    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final active = i == currentIndex;
          final color = active ? AppColors.accent : muted;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 20, color: color),
                  const SizedBox(height: 4),
                  Text(item.label,
                      style: AppText.inter(
                          size: 10, weight: FontWeight.w600, color: color)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
