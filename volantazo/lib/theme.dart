import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF15151E);
  static const Color surface = Color(0xFF1F1F2B);
  static const Color surfaceHover = Color(0xFF282838);
  static const Color primary = Color(0xFFE10600);
  static const Color primaryHover = Color(0xFFFF1801);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8C8C8C);
  static const Color border = Color(0xFF2D2D3D);
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color danger = Color(0xFFDC3545);

  static ThemeData get theme {
    final textTheme = GoogleFonts.titilliumWebTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.titilliumWeb(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: textPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary,
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: const TextStyle(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
      ),
    );
  }
}
