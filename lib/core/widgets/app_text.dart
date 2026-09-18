import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final VoidCallback? onTap;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    required this.textAlign,
    this.maxLines,
    this.overflow,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: AppTheme.font(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? AppTheme.textPrimary),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: textWidget,
      );
    }
    return textWidget;
  }
}
