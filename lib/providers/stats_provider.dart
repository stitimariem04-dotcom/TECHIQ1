// ============================================================
// STATS PROVIDER - TECHIQ
// Fournit les statistiques et achievements à l'écran profil
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';
import '../services/storage_service.dart';

class StatsProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  List<QuizResult>  _results      = [];
  List<AchievementModel> _achievements = [];
  bool _isLoaded = false;

  List<QuizResult>       get results      => _results;
  List<AchievementModel> get achievements => _achievements;
  bool                   get isLoaded     => _isLoaded;

  /// Nombre total de quiz complétés
  int get totalQuizzes => _storage.getTotalQuizzes();

  /// Charge toutes les données depuis le stockage
  void loadStats() {
    _results = _storage.getResults();
    _achievements = _buildAchievements();
    _isLoaded = true;
    notifyListeners();
  }

  /// Score total cumulé sur tous les quiz
  int get totalScore => _results.fold(0, (sum, r) => sum + r.score);

  /// Meilleur pourcentage global atteint
  int get bestPercentage {
    if (_results.isEmpty) return 0;
    return _results.map((r) => r.percentage).reduce((a, b) => a > b ? a : b);
  }

  /// Retourne les statistiques par domaine
  Map<String, Map<String, dynamic>> get statsByDomain =>
      _storage.getStatsByDomain();

  /// Construit la liste des achievements avec leur état de déblocage
  List<AchievementModel> _buildAchievements() {
    final unlocked = _storage.getUnlockedAchievements();
    return AppConstants.achievements.map((data) {
      final isUnlocked = unlocked.contains(data['id']);
      return AchievementModel(
        id         : data['id'] as String,
        title      : data['title'] as String,
        description: data['description'] as String,
        domain     : data['domain'] as String,
        isUnlocked : isUnlocked,
      );
    }).toList();
  }

  /// Nombre d'achievements débloqués
  int get unlockedCount => _achievements.where((a) => a.isUnlocked).length;

  /// Recharge les statistiques (après un quiz par exemple)
  void refresh() => loadStats();
}
