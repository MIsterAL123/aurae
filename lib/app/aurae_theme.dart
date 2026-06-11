import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AuraeColors {
  static const background = Color(0xFFFEF8F7);
  static const surface = Color(0xFFFFFCFB);
  static const surfaceContainer = Color(0xFFF2EDEC);
  static const ink = Color(0xFF1D1B1B);
  static const muted = Color(0xFF675C59);
  static const outline = Color(0xFFD1C3C0);
  static const rose = Color(0xFFF4D1C7);
  static const terracotta = Color(0xFFC86E5D);
  static const sage = Color(0xFFD8E7D3);
  static const espresso = Color(0xFF221A18);
}

abstract final class AuraeTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AuraeColors.background,
      colorScheme: const ColorScheme.light(
        primary: AuraeColors.ink,
        onPrimary: Colors.white,
        secondary: AuraeColors.terracotta,
        onSecondary: Colors.white,
        surface: AuraeColors.surface,
        onSurface: AuraeColors.ink,
        outline: AuraeColors.outline,
        error: Color(0xFFBA1A1A),
      ),
    );

    final bodyTheme = GoogleFonts.beVietnamProTextTheme(base.textTheme);
    final textTheme = bodyTheme.copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 48,
        height: 1.16,
        fontWeight: FontWeight.w700,
        color: AuraeColors.ink,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: AuraeColors.ink,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 26,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: AuraeColors.ink,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AuraeColors.ink,
      ),
      bodyLarge: GoogleFonts.beVietnamPro(
        fontSize: 16,
        height: 1.5,
        color: AuraeColors.ink,
      ),
      bodyMedium: GoogleFonts.beVietnamPro(
        fontSize: 14,
        height: 1.45,
        color: AuraeColors.ink,
      ),
      labelLarge: GoogleFonts.beVietnamPro(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: .4,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AuraeColors.background,
        foregroundColor: AuraeColors.ink,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AuraeColors.ink,
          fontSize: 25,
          fontWeight: FontWeight.w600,
          letterSpacing: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AuraeColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AuraeColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AuraeColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AuraeColors.ink, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: AuraeColors.ink,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AuraeColors.surfaceContainer,
        selectedColor: AuraeColors.rose,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AuraeColors.surface.withValues(alpha: .96),
        elevation: 12,
        indicatorColor: AuraeColors.rose,
        height: 76,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
      ),
      dividerColor: AuraeColors.outline.withValues(alpha: .6),
    );
  }
}
