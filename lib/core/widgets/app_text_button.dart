import 'package:flutter/material.dart';

import '../app_theme.dart';

/// forgot password and sign up and login purpose
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = AppTheme.moss,
    this.fontSize = 12.5,
    this.fontWeight = FontWeight.w800,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ),
    );
  }
}
