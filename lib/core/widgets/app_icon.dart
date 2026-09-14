import 'package:flutter/material.dart';

import '../app_theme.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final double borderRadius;

  const AppIcon({
    super.key,
    required this.icon,
    this.size = 64.0,
    this.iconSize = 36.0,
    this.iconColor,
    this.backgroundColor,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.mossTint,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: iconColor ?? AppTheme.moss),
      ),
    );
  }
}
