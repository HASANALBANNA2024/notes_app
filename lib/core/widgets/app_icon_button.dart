import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? size;
  final double? iconSize;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.size = 38,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.iconBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? AppTheme.iconColor,
        ),
      ),
    );
  }
}
