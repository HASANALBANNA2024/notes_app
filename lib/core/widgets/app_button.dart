import 'package:flutter/material.dart';

import '../app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double width;
  final double height;
  final bool isLoading;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = AppTheme.moss,
    this.textColor = AppTheme.surface,
    this.borderColor,
    this.width = double.infinity,
    this.height = 48,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isOutlined
                ? BorderSide(color: borderColor ?? AppTheme.moss, width: 1.5)
                : BorderSide.none,
          ),
        ),
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppTheme.surface,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isOutlined
                      ? (borderColor ?? AppTheme.moss)
                      : textColor,
                ),
              ),
      ),
    );
  }
}
