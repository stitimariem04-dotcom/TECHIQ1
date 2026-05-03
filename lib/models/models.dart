// ============================================================
// MODÈLES DE DONNÉES - TECHIQ
// Classes représentant les entités métier de l'application
// ============================================================

import 'package:flutter/material.dart';

// --- Modèle d'une Question de Quiz ---
class QuestionModel {
  final String question;       // Énoncé de la question
  final List<String> options;  // 4 choix de réponse
  final String answer;         // Bonne réponse
  final String explanation;    // Explication courte de la réponse

  const QuestionModel({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  /// Crée un QuestionModel depuis un Map JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question   : json['question'] as String,
      options    : List<String>.from(json['options'] as List),
      answer     : json['answer'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

// --- Modèle d'un Domaine informatique ---
class DomainModel {
  final String id;        // Identifiant unique (ex: 'iot')
  final String label;     // Nom affiché (ex: 'IoT')
  final String subtitle;  // Sous-titre descriptif
  final String jsonPath;  // Chemin du fichier JSON des questions
  final Color color;      // Couleur d'accent du domaine

  const DomainModel({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.jsonPath,
    required this.color,
  });

  /// Crée un DomainModel depuis la constante Map
  factory DomainModel.fromMap(Map<String, dynamic> map) {
    return DomainModel(
      id      : map['id'] as String,
      label   : map['label'] as String,
      subtitle: map['subtitle'] as String,
      jsonPath: map['jsonPath'] as String,
      color   : Color(map['color'] as int),
    );
  }
}

// --- Modèle du Résultat d'un Quiz ---
class QuizResult {
  final String domainId;      // Domaine joué
  final String gameMode;      // Mode de jeu
  final int score;            // Score total en points
  final int totalQuestions;   // Nombre de questions posées
  final int correctAnswers;   // Nombre de bonnes réponses
  final int maxCombo;         // Combo maximum atteint
  final DateTime playedAt;    // Date et heure du quiz

  const QuizResult({
    required this.domainId,
    required this.gameMode,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.maxCombo,
    required this.playedAt,
  });

  /// Calcule le pourcentage de réussite
  int get percentage => totalQuestions == 0
      ? 0
      : ((correctAnswers / totalQuestions) * 100).round();

  /// Convertit en Map pour la sérialisation JSON
  Map<String, dynamic> toJson() => {
    'domainId'      : domainId,
    'gameMode'      : gameMode,
    'score'         : score,
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'maxCombo'      : maxCombo,
    'playedAt'      : playedAt.toIso8601String(),
  };

  /// Crée depuis un Map JSON
  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      domainId      : json['domainId'] as String,
      gameMode      : json['gameMode'] as String,
      score         : json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      maxCombo      : json['maxCombo'] as int,
      playedAt      : DateTime.parse(json['playedAt'] as String),
    );
  }
}

// --- Modèle d'un Achievement (Badge) ---
class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String domain;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.domain,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  AchievementModel copyWith({bool? isUnlocked, DateTime? unlockedAt}) {
    return AchievementModel(
      id          : id,
      title       : title,
      description : description,
      domain      : domain,
      isUnlocked  : isUnlocked ?? this.isUnlocked,
      unlockedAt  : unlockedAt ?? this.unlockedAt,
    );
  }
}
