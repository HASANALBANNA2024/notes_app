import 'package:flutter/material.dart';

import '../app_theme.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? letterSpacing;
  final double? height;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.letterSpacing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSize ?? 14.0,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? AppTheme.slate,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }
}
