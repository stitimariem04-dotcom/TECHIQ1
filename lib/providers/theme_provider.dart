// ============================================================
// THEME PROVIDER - TECHIQ
// Gère le thème visuel actif (Cyber Néon, Hacker Green, Purple Tech)
// ============================================================

import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/storage_service.dart';

class AppThemeProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  String _currentThemeId = 'cyber_neon';
  String get currentThemeId => _currentThemeId;

  /// Charge le thème sauvegardé depuis le stockage local
  void loadTheme() {
    _currentThemeId = _storage.getTheme();
    notifyListeners();
  }

  /// Change et sauvegarde le thème
  Future<void> setTheme(String themeId) async {
    _currentThemeId = themeId;
    await _storage.saveTheme(themeId);
    notifyListeners();
  }

  /// Retourne la couleur primaire du thème actif
  Color get primaryColor {
    switch (_currentThemeId) {
      case 'hacker_green': return AppColors.hackerGreen['primary']!;
      case 'purple_tech':  return AppColors.purpleTech['primary']!;
      default:             return AppColors.cyberNeon['primary']!;
    }
  }

  /// Retourne la couleur d'accentuation du thème actif
  Color get accentColor {
    switch (_currentThemeId) {
      case 'hacker_green': return AppColors.hackerGreen['accent']!;
      case 'purple_tech':  return AppColors.purpleTech['accent']!;
      default:             return AppColors.cyberNeon['accent']!;
    }
  }

  /// Retourne le dégradé du thème actif
  LinearGradient get themeGradient {
    switch (_currentThemeId) {
      case 'hacker_green':
        return const LinearGradient(
          colors: [Color(0xFF001A00), Color(0xFF003300)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'purple_tech':
        return const LinearGradient(
          colors: [Color(0xFF0D001A), Color(0xFF1A0033)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return AppColors.bgGradient;
    }
  }

  /// Liste des thèmes disponibles avec leurs métadonnées
  static const List<Map<String, dynamic>> availableThemes = [
    {
      'id'         : 'cyber_neon',
      'label'      : 'Cyber Néon',
      'description': 'Vert sauge sur fond sombre',
      'color'      : 0xFF809671,
    },
    {
      'id'         : 'hacker_green',
      'label'      : 'Hacker Green',
      'description': 'Style terminal vert intense',
      'color'      : 0xFF39FF14,
    },
    {
      'id'         : 'purple_tech',
      'label'      : 'Purple Tech',
      'description': 'Violet futuriste élégant',
      'color'      : 0xFF9B59B6,
    },
  ];
}
