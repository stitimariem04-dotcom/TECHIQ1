// ============================================================
// SERVICE DE STOCKAGE LOCAL - TECHIQ
// Gère la persistance des données avec SharedPreferences
// Scores, achievements, statistiques - tout est sauvegardé ici
// ============================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  // Instance Singleton - une seule instance dans toute l'app
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  /// Initialise SharedPreferences - doit être appelé au démarrage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==========================================================
  // GESTION DES SCORES
  // ==========================================================

  /// Sauvegarde un résultat de quiz
  Future<void> saveResult(QuizResult result) async {
    final results = getResults();
    results.add(result);
    // Limite à 50 résultats pour éviter un stockage excessif
    if (results.length > 50) results.removeAt(0);
    final encoded = results.map((r) => jsonEncode(r.toJson())).toList();
    await _prefs.setStringList(AppConstants.prefBestScores, encoded);
  }

  /// Récupère tous les résultats sauvegardés
  List<QuizResult> getResults() {
    final raw = _prefs.getStringList(AppConstants.prefBestScores) ?? [];
    return raw
        .map((s) => QuizResult.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  /// Retourne le meilleur score pour un domaine donné
  int getBestScore(String domainId) {
    final results = getResults().where((r) => r.domainId == domainId);
    if (results.isEmpty) return 0;
    return results.map((r) => r.score).reduce((a, b) => a > b ? a : b);
  }

  /// Retourne le nombre total de quiz complétés
  int getTotalQuizzes() => _prefs.getInt(AppConstants.prefTotalQuizzes) ?? 0;

  /// Incrémente le compteur de quiz complétés
  Future<void> incrementQuizCount() async {
    await _prefs.setInt(AppConstants.prefTotalQuizzes, getTotalQuizzes() + 1);
  }

  // ==========================================================
  // GESTION DES ACHIEVEMENTS
  // ==========================================================

  /// Retourne les IDs des achievements débloqués
  List<String> getUnlockedAchievements() {
    return _prefs.getStringList(AppConstants.prefAchievements) ?? [];
  }

  /// Débloque un achievement par son ID
  Future<void> unlockAchievement(String id) async {
    final unlocked = getUnlockedAchievements();
    if (!unlocked.contains(id)) {
      unlocked.add(id);
      await _prefs.setStringList(AppConstants.prefAchievements, unlocked);
    }
  }

  /// Vérifie si un achievement est débloqué
  bool isAchievementUnlocked(String id) {
    return getUnlockedAchievements().contains(id);
  }

  // ==========================================================
  // GESTION DU THÈME
  // ==========================================================

  /// Sauvegarde le thème choisi
  Future<void> saveTheme(String themeId) async {
    await _prefs.setString(AppConstants.prefTheme, themeId);
  }

  /// Récupère le thème sauvegardé (défaut: 'cyber_neon')
  String getTheme() => _prefs.getString(AppConstants.prefTheme) ?? 'cyber_neon';

  // ==========================================================
  // STATISTIQUES RAPIDES
  // ==========================================================

  /// Compte le nombre de réponses rapides (< 5 secondes)
  int getFastAnswersCount() => _prefs.getInt(AppConstants.prefFastAnswers) ?? 0;

  /// Incrémente le compteur de réponses rapides
  Future<void> incrementFastAnswers() async {
    await _prefs.setInt(
        AppConstants.prefFastAnswers, getFastAnswersCount() + 1);
  }

  /// Calcule les statistiques globales par domaine
  Map<String, Map<String, dynamic>> getStatsByDomain() {
    final results = getResults();
    final Map<String, Map<String, dynamic>> stats = {};

    for (final r in results) {
      if (!stats.containsKey(r.domainId)) {
        stats[r.domainId] = {
          'quizCount'   : 0,
          'totalScore'  : 0,
          'bestScore'   : 0,
          'bestPercent' : 0,
        };
      }
      stats[r.domainId]!['quizCount']  = (stats[r.domainId]!['quizCount'] as int) + 1;
      stats[r.domainId]!['totalScore'] = (stats[r.domainId]!['totalScore'] as int) + r.score;
      if (r.score > (stats[r.domainId]!['bestScore'] as int)) {
        stats[r.domainId]!['bestScore']   = r.score;
        stats[r.domainId]!['bestPercent'] = r.percentage;
      }
    }
    return stats;
  }
}
