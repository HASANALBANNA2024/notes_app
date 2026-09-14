import 'package:flutter/material.dart';

import '../app_theme.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final double padding;
  final double borderRadius;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconSize = 22.0,
    this.iconColor,
    this.backgroundColor,
    this.padding = 8.0,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Icon(icon, size: iconSize, color: iconColor ?? AppTheme.slate),
        ),
      ),
    );
  }
}
