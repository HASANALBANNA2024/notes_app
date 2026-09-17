import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppTextFieldStyle { title, body, plain }

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final AppTextFieldStyle style;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;

  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.style = AppTextFieldStyle.plain,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.autofocus = false,
    this.onChanged,
    this.textCapitalization = TextCapitalization.sentences,
  });

  TextStyle _textStyle(bool isDark) {
    final color = isDark ? AppColors.textDark : AppColors.text;
    switch (style) {
      case AppTextFieldStyle.title:
        return AppText.inter(size: 18, weight: FontWeight.w700, color: color);
      case AppTextFieldStyle.body:
        return AppText.inter(
            size: 14, weight: FontWeight.w400, color: color, height: 1.5);
      case AppTextFieldStyle.plain:
        return AppText.inter(size: 14, color: color);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMuted;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      style: _textStyle(isDark),
      textCapitalization: textCapitalization,
      maxLines: expands ? null : maxLines,
      minLines: expands ? null : minLines,
      expands: expands,
      textAlignVertical: expands ? TextAlignVertical.top : null,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.inter(
            size: style == AppTextFieldStyle.title ? 18 : 14,
            color: mutedColor),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
