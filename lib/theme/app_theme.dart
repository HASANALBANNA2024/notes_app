import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens lifted straight from the approved Android mockup
class AppColors {
  AppColors._();

  static const bg = Color(0xFFEEF1F6);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1E2A4A);
  static const primary2 = Color(0xFF33456F);
  static const accent = Color(0xFF0EA5A0);
  static const amber = Color(0xFFE8A33D);
  static const red = Color(0xFFD6455B);
  static const green = Color(0xFF2FA66A);
  static const blue = Color(0xFF2F6FE0);
  static const text = Color(0xFF161B26);
  static const textMuted = Color(0xFF6B7280);
  static const border = Color(0xFFE3E6EC);
  static const chipBg = Color(0xFFF3F4F7);

  // Dark-mode counterparts
  static const bgDark = Color(0xFF11141C);
  static const surfaceDark = Color(0xFF1B1F2A);
  static const textDark = Color(0xFFEDEFF3);
  static const textMutedDark = Color(0xFF9AA1AE);
  static const borderDark = Color(0xFF2A2F3B);
  static const chipBgDark = Color(0xFF262B37);
}

const double kCardRadius = 14;

class LabelBadgeStyle {
  final Color background;
  final Color foreground;
  const LabelBadgeStyle(this.background, this.foreground);
}

const Map<String, LabelBadgeStyle> kLabelBadgeStyles = {
  'Work': LabelBadgeStyle(Color(0xFFE4EEFF), AppColors.blue),
  'Personal': LabelBadgeStyle(Color(0xFFE3F7EC), AppColors.green),
  'Shopping': LabelBadgeStyle(Color(0xFFFFF1DE), AppColors.amber),
  'Learning': LabelBadgeStyle(Color(0xFFE1F5F4), AppColors.accent),
  'Favorites': LabelBadgeStyle(Color(0xFFFDE7EA), AppColors.red),
};

class AppText {
  AppText._();

  static TextStyle sora({
    required double size,
    FontWeight weight = FontWeight.w600,
    Color? color,
    double? letterSpacing,
  }) =>
      GoogleFonts.sora(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle inter({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );
}

/// Dynamic Theme Builder Class
class AppTheme {
  AppTheme._();

  static ThemeData buildTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? AppColors.bgDark : AppColors.bg;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final text = isDark ? AppColors.textDark : AppColors.text;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: brightness,
        surface: surface,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ).apply(bodyColor: text, displayColor: text),
      dividerColor: isDark ? AppColors.borderDark : AppColors.border,
    );
  }
}
