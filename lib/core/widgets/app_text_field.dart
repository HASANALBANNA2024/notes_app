import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? hintColor;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.hintColor,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: AppTheme.font(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: textColor ?? AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTheme.font(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: hintColor ?? AppTheme.textSecondary,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
