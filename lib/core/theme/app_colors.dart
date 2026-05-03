// ============================================================
// PALETTE DE COULEURS TECHIQ
// Couleurs principales + effets néon sur fond sombre
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Couleurs de base (palette officielle) ---
  static const Color sageGreen    = Color(0xFF809671); // Vert sauge principal
  static const Color lightSage    = Color(0xFFB3B792); // Vert sauge clair
  static const Color warmWhite    = Color(0xFFE5E0D8); // Blanc chaud
  static const Color cream        = Color(0xFFE5DEB8); // Crème dorée
  static const Color warmBrown    = Color(0xFF725C3A); // Brun chaud

  // --- Fond sombre (dark mode) ---
  static const Color bgDark       = Color(0xFF0B0E0A); // Fond principal très sombre
  static const Color bgCard       = Color(0xFF141A11); // Fond des cartes
  static const Color bgSurface    = Color(0xFF1C2418); // Surface secondaire

  // --- Effets néon / glow ---
  static const Color neonGreen    = Color(0xFF8FBC6A); // Néon vert principal
  static const Color neonCream    = Color(0xFFE8DFA0); // Néon crème
  static const Color neonBrown    = Color(0xFFB8925A); // Néon brun/or

  // --- États Quiz ---
  static const Color correct      = Color(0xFF6DBF67); // Réponse correcte
  static const Color wrong        = Color(0xFFBF4B4B); // Réponse incorrecte
  static const Color timerOk      = Color(0xFF809671); // Timer normal
  static const Color timerWarn    = Color(0xFFB8925A); // Timer alerte
  static const Color timerCrit    = Color(0xFFBF4B4B); // Timer critique

  // --- Textes ---
  static const Color textPrimary  = Color(0xFFE5E0D8); // Texte principal
  static const Color textSecond   = Color(0xFFB3B792); // Texte secondaire
  static const Color textHint     = Color(0xFF809671); // Texte hint

  // --- Thème Cyber Néon (défaut) ---
  static const Map<String, Color> cyberNeon = {
    'primary'   : sageGreen,
    'secondary' : lightSage,
    'accent'    : neonGreen,
    'glow'      : neonCream,
  };

  // --- Thème Hacker Green ---
  static const Map<String, Color> hackerGreen = {
    'primary'   : Color(0xFF39FF14), // Vert néon pur
    'secondary' : Color(0xFF00CC00),
    'accent'    : Color(0xFF00FF41),
    'glow'      : Color(0xFF66FF66),
  };

  // --- Thème Purple Tech ---
  static const Map<String, Color> purpleTech = {
    'primary'   : Color(0xFF9B59B6),
    'secondary' : Color(0xFFBB8FCE),
    'accent'    : Color(0xFFD7BDE2),
    'glow'      : Color(0xFFE8DAEF),
  };

  // --- Gradients principaux ---
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgDark, Color(0xFF0F1A0C), bgDark],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x22809671), Color(0x11B3B792)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sageGreen, lightSage],
  );

  // --- Génère un BoxShadow néon selon couleur ---
  static List<BoxShadow> neonShadow(Color color, {double spread = 8}) {
    return [
      BoxShadow(color: color.withOpacity(0.4), blurRadius: spread * 2, spreadRadius: spread / 2),
      BoxShadow(color: color.withOpacity(0.2), blurRadius: spread * 4, spreadRadius: spread),
    ];
  }
}
