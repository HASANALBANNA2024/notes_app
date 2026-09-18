import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF0EA5A0);
  static const Color background = Colors.white;
  static const Color textPrimary = Color(0xFF161B26);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color iconBackground = Color(0xFFF3F4F6);
  static const Color iconColor = Color(0xFF4B5563);
  static const Color dividerColor = Color(0xFFE5E7EB);

  static TextStyle font({
    double? fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
