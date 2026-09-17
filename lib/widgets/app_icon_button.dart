import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool active;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.active = false,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipColor = isDark ? AppColors.chipBgDark : AppColors.chipBg;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final iconColor = active
        ? AppColors.accent
        : (isDark ? AppColors.textDark : AppColors.text);
    final background = active ? AppColors.accent.withOpacity(0.15) : chipColor;

    final button = Material(
      color: background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: active ? null : Border.all(color: borderColor),
          ),
          child: Icon(icon, size: size * 0.5, color: iconColor),
        ),
      ),
    );

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
