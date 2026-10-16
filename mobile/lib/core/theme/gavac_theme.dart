import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gavac_colors.dart';

class GavacTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: GavacColors.primary,
      scaffoldBackgroundColor: GavacColors.background,
      colorScheme: const ColorScheme.light(
        primary: GavacColors.primary,
        secondary: GavacColors.accent,
        surface: GavacColors.surface,
        error: GavacColors.dangerText,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: GavacColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: GavacColors.textPrimary),
          headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: GavacColors.textPrimary),
          titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: GavacColors.textPrimary),
          bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: GavacColors.textPrimary),
          bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: GavacColors.textSecondary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GavacColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GavacColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GavacColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GavacColors.primary, width: 2),
        ),
      ),
    );
  }
}
