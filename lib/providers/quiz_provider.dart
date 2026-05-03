// ============================================================
// QUIZ PROVIDER - TECHIQ
// Cerveau du quiz : gère les questions, le score, le timer,
// les vies et les combos. Utilise le pattern ChangeNotifier.
// ============================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';
import '../services/question_service.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';

// Énumération des états possibles du quiz
enum QuizState {
  idle,       // En attente (écran d'accueil)
  loading,    // Chargement des questions
  playing,    // Quiz en cours
  answered,   // Question répondue (affichage feedback)
  finished,   // Quiz terminé
  error,      // Erreur de chargement
}

class QuizProvider extends ChangeNotifier {
  // --- Services ---
  final QuestionService _questionService = QuestionService();
  final StorageService  _storageService  = StorageService();
  final AudioService    _audioService    = AudioService();

  // --- État interne ---
  QuizState _state = QuizState.idle;
  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _lives = AppConstants.maxLives;
  int _combo = 0;
  int _maxCombo = 0;
  int _correctAnswers = 0;
  int _timeLeft = AppConstants.timerNormal;
  String? _selectedAnswer;
  bool _isCorrect = false;
  String? _currentDomainId;
  String? _currentMode;
  Timer? _timer;

  // ==========================================================
  // GETTERS PUBLICS (accès en lecture seule depuis l'UI)
  // ==========================================================
  QuizState         get state           => _state;
  List<QuestionModel> get questions     => _questions;
  int               get currentIndex    => _currentIndex;
  int               get score           => _score;
  int               get lives           => _lives;
  int               get combo           => _combo;
  int               get maxCombo        => _maxCombo;
  int               get correctAnswers  => _correctAnswers;
  int               get timeLeft        => _timeLeft;
  String?           get selectedAnswer  => _selectedAnswer;
  bool              get isCorrect       => _isCorrect;
  String?           get currentDomainId => _currentDomainId;
  String?           get currentMode     => _currentMode;
  bool              get isLoading       => _state == QuizState.loading;
  bool              get isFinished      => _state == QuizState.finished;

  // La question actuelle (null si hors limites)
  QuestionModel? get currentQuestion =>
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;

  // Pourcentage de progression dans le quiz
  double get progress =>
      _questions.isEmpty ? 0 : (_currentIndex / _questions.length);

  // Pourcentage du timer
  double get timerProgress {
    final maxTime = _currentMode == AppConstants.modeTimed
        ? AppConstants.timerChallenge
        : AppConstants.timerNormal;
    return _timeLeft / maxTime;
  }

  // ==========================================================
  // DÉMARRAGE D'UN QUIZ
  // ==========================================================

  /// Lance un quiz pour un domaine et un mode donnés
  Future<void> startQuiz({
    required DomainModel domain,
    required String mode,
  }) async {
    _state = QuizState.loading;
    notifyListeners();

    _currentDomainId = domain.id;
    _currentMode = mode;

    // Détermine le nombre de questions selon le mode
    int count = _getQuestionCount(mode);

    try {
      _questions = await _questionService.loadQuestions(domain.jsonPath, count: count);

      if (_questions.isEmpty) {
        _state = QuizState.error;
        notifyListeners();
        return;
      }

      // Réinitialise tous les compteurs
      _currentIndex   = 0;
      _score          = 0;
      _lives          = AppConstants.maxLives;
      _combo          = 0;
      _maxCombo       = 0;
      _correctAnswers = 0;
      _selectedAnswer = null;

      _state = QuizState.playing;
      notifyListeners();

      // Démarre le timer de la première question
      _startTimer();
    } catch (e) {
      _state = QuizState.error;
      notifyListeners();
    }
  }

  /// Retourne le nombre de questions selon le mode de jeu
  int _getQuestionCount(String mode) {
    switch (mode) {
      case AppConstants.modeQuick:    return AppConstants.questionsQuick;
      case AppConstants.modeStandard: return AppConstants.questionsStandard;
      case AppConstants.modeTimed:    return AppConstants.questionsTimed;
      case AppConstants.modeSurvival: return 0; // Toutes les questions
      default:                        return AppConstants.questionsStandard;
    }
  }

  // ==========================================================
  // GESTION DES RÉPONSES
  // ==========================================================

  /// Appelé quand l'utilisateur sélectionne une réponse
  void selectAnswer(String answer) {
    // Ignore si déjà répondu
    if (_state == QuizState.answered) return;

    _timer?.cancel();
    _selectedAnswer = answer;
    _isCorrect = (answer == currentQuestion?.answer);

    // Calcul du bonus de temps
    final timeBonus = _isCorrect ? (_timeLeft * AppConstants.pointsTimeBonus) : 0;

    if (_isCorrect) {
      // Bonne réponse : score + combo
      _correctAnswers++;
      _combo++;
      if (_combo > _maxCombo) _maxCombo = _combo;

      final comboBonus = (_combo > 1) ? ((_combo - 1) * AppConstants.pointsComboBonus) : 0;
      _score += AppConstants.pointsCorrect + comboBonus + timeBonus;

      // Vérification réponse rapide (< 5s restantes sur 20s = répondu en < 5s)
      if (_timeLeft > 15) {
        _storageService.incrementFastAnswers();
      }

      // Sons
      if (_combo >= 3) {
        _audioService.playCombo();
      } else {
        _audioService.playCorrect();
      }
    } else {
      // Mauvaise réponse : perte de vie et reset du combo
      _combo = 0;
      _lives--;
      _audioService.playWrong();
    }

    _state = QuizState.answered;
    notifyListeners();
  }

  // ==========================================================
  // NAVIGATION ENTRE QUESTIONS
  // ==========================================================

  /// Passe à la question suivante ou termine le quiz
  void nextQuestion() {
    // Vérifie les conditions de fin de partie
    if (_shouldEndGame()) {
      _endQuiz();
      return;
    }

    _currentIndex++;
    _selectedAnswer = null;
    _state = QuizState.playing;
    notifyListeners();

    _startTimer();
  }

  /// Vérifie si le quiz doit se terminer
  bool _shouldEndGame() {
    // Plus de vies : fin en mode survie ou normal
    if (_currentMode == AppConstants.modeSurvival && _lives <= 0) return true;
    if (_lives <= 0) return true;

    // Dernière question atteinte
    if (_currentIndex >= _questions.length - 1) return true;

    return false;
  }

  /// Termine le quiz et sauvegarde le résultat
  Future<void> _endQuiz() async {
    _timer?.cancel();
    _state = QuizState.finished;

    // Sauvegarde du résultat dans le stockage local
    final result = QuizResult(
      domainId      : _currentDomainId ?? 'unknown',
      gameMode      : _currentMode ?? 'standard',
      score         : _score,
      totalQuestions: _questions.length,
      correctAnswers: _correctAnswers,
      maxCombo      : _maxCombo,
      playedAt      : DateTime.now(),
    );

    await _storageService.saveResult(result);
    await _storageService.incrementQuizCount();

    // Vérification et déblocage des achievements
    await _checkAchievements(result);

    _audioService.playWin();
    notifyListeners();
  }

  // ==========================================================
  // TIMER
  // ==========================================================

  /// Démarre le décompte du timer pour la question actuelle
  void _startTimer() {
    final maxTime = _currentMode == AppConstants.modeTimed
        ? AppConstants.timerChallenge
        : AppConstants.timerNormal;

    _timeLeft = maxTime;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeLeft--;

      // Alerte sonore dans les 5 dernières secondes
      if (_timeLeft == 5) _audioService.playTimerWarning();

      if (_timeLeft <= 0) {
        // Temps écoulé = réponse manquée
        timer.cancel();
        selectAnswer('__timeout__'); // Réponse invalide = faux
      }

      notifyListeners();
    });
  }

  // ==========================================================
  // ACHIEVEMENTS
  // ==========================================================

  Future<void> _checkAchievements(QuizResult result) async {
    final totalQuizzes = _storageService.getTotalQuizzes();
    final fastAnswers  = _storageService.getFastAnswersCount();
    final stats        = _storageService.getStatsByDomain();

    // Quiz Champion : 10 quiz complétés
    if (totalQuizzes >= 10) {
      await _storageService.unlockAchievement('quiz_champion');
    }

    // Fast Thinker : 10 réponses rapides
    if (fastAnswers >= 10) {
      await _storageService.unlockAchievement('fast_thinker');
    }

    // Achievements par domaine (3 quiz parfaits)
    final domainStats = stats[result.domainId];
    if (domainStats != null) {
      final perfectCount = _storageService
          .getResults()
          .where((r) => r.domainId == result.domainId && r.percentage == 100)
          .length;

      if (perfectCount >= 3) {
        switch (result.domainId) {
          case 'iot':          await _storageService.unlockAchievement('iot_king');          break;
          case 'linux':        await _storageService.unlockAchievement('linux_expert');      break;
          case 'python':       await _storageService.unlockAchievement('python_master');     break;
          case 'cybersecurity':await _storageService.unlockAchievement('cyber_guardian');    break;
        }
      }
    }

    // AI Visionary : 100% en survie (IA)
    if (result.domainId == 'ai' &&
        result.gameMode == AppConstants.modeSurvival &&
        result.percentage == 100) {
      await _storageService.unlockAchievement('ai_visionary');
    }
  }

  // ==========================================================
  // RÉINITIALISATION
  // ==========================================================

  /// Remet le provider à l'état initial
  void reset() {
    _timer?.cancel();
    _state          = QuizState.idle;
    _questions      = [];
    _currentIndex   = 0;
    _score          = 0;
    _lives          = AppConstants.maxLives;
    _combo          = 0;
    _maxCombo       = 0;
    _correctAnswers = 0;
    _timeLeft       = AppConstants.timerNormal;
    _selectedAnswer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
