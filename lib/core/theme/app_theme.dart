// ============================================================
// THÈME MATERIAL DARK - TECHIQ
// Configuration complète du thème visuel de l'application
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // Police principale : Orbitron pour le style gaming/futuriste
  // Police secondaire : Rajdhani pour le texte courant
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: 4,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      ),
      displaySmall: GoogleFonts.orbitron(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 1.5,
      ),
      headlineLarge: GoogleFonts.rajdhani(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.rajdhani(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.rajdhani(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.rajdhani(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecond,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.orbitron(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 1.2,
      ),
      labelMedium: GoogleFonts.rajdhani(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecond,
        letterSpacing: 0.8,
      ),
    );
  }

  // Thème principal sombre
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.sageGreen,
        secondary: AppColors.lightSage,
        tertiary: AppColors.cream,
        surface: AppColors.bgCard,
        error: AppColors.wrong,
        onPrimary: AppColors.bgDark,
        onSecondary: AppColors.bgDark,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: AppColors.sageGreen),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.sageGreen.withOpacity(0.3), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sageGreen,
          foregroundColor: AppColors.bgDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.sageGreen),
      dividerTheme: DividerThemeData(color: AppColors.sageGreen.withOpacity(0.2), thickness: 1),
    );
  }
}
