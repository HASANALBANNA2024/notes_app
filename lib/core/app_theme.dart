import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ================= COLORS =================
  static const Color paper = Color(0xFFEEF0EA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1C231D);
  static const Color inkSoft = Color(0xFF57604F);
  static const Color inkFaint = Color(0xFF8B9385);
  static const Color line = Color(0xFFE1E4DA);

  // Status Colors & Tints
  static const Color moss = Color(0xFF33553F);
  static const Color mossDeep = Color(0xFF213A2A);
  static const Color mossTint = Color(0xFFE1EAE3);
  static const Color amber = Color(0xFFC07423);
  static const Color amberTint = Color(0xFFF8E8D2);
  static const Color teal = Color(0xFF2A6B77);
  static const Color tealTint = Color(0xFFDDEEF0);
  static const Color slate = Color(0xFF6B6F72);
  static const Color slateTint = Color(0xFFE9EAE6);
  static const Color brick = Color(0xFFAE4630);
  static const Color brickTint = Color(0xFFF5DED6);

  /// ================= LIGHT THEME DATA =================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: moss,
        secondary: teal,
        surface: surface,
        error: brick,
        onPrimary: Colors.white,
        onSurface: ink,
      ),

      /// Text Theme with Google Fonts (Manrope)
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.manrope(
          fontSize: 38,
          fontWeight: FontWeight.w800,
          color: ink,
          letterSpacing: -0.6,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: ink,
          letterSpacing: -0.2,
        ),
        titleLarge: GoogleFonts.manrope(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: inkSoft,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: inkSoft,
        ),
        bodySmall: GoogleFonts.manrope(
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          color: inkFaint,
        ),
      ),

      /// Input Decoration (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.manrope(color: inkFaint, fontSize: 13),
        labelStyle: GoogleFonts.manrope(
          color: inkSoft,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: moss, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brick, width: 1.5),
        ),
      ),

      /// Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: moss,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
