// ============================================================
// SERVICE DE QUESTIONS - TECHIQ
// Charge et mélange les questions depuis les fichiers JSON locaux
// ============================================================

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class QuestionService {
  // Singleton
  static final QuestionService _instance = QuestionService._internal();
  factory QuestionService() => _instance;
  QuestionService._internal();

  // Cache en mémoire pour éviter de relire le fichier à chaque fois
  final Map<String, List<QuestionModel>> _cache = {};

  /// Charge les questions d'un domaine depuis son fichier JSON
  /// [jsonPath] = chemin du fichier (ex: 'assets/questions/iot.json')
  /// [count]    = nombre de questions à retourner (0 = toutes)
  Future<List<QuestionModel>> loadQuestions(String jsonPath, {int count = 0}) async {
    // Vérification du cache
    if (!_cache.containsKey(jsonPath)) {
      try {
        // Lecture du fichier JSON depuis les assets Flutter
        final String rawJson = await rootBundle.loadString(jsonPath);
        final List<dynamic> jsonList = jsonDecode(rawJson) as List;

        // Conversion en liste de QuestionModel
        _cache[jsonPath] = jsonList
            .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // En cas d'erreur de lecture, retourner une liste vide
        return [];
      }
    }

    // Copie et mélange aléatoire des questions
    final questions = List<QuestionModel>.from(_cache[jsonPath]!);
    questions.shuffle();

    // Retourne le nombre demandé ou toutes les questions
    if (count > 0 && count < questions.length) {
      return questions.sublist(0, count);
    }
    return questions;
  }

  /// Vide le cache (utile pour les tests)
  void clearCache() => _cache.clear();
}
