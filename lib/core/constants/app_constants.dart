// ============================================================
// CONSTANTES GLOBALES - TECHIQ
// Toutes les valeurs fixes utilisées dans l'application
// ============================================================

class AppConstants {
  AppConstants._();

  // --- Nom de l'application ---
  static const String appName = 'TechIQ';
  static const String appTagline = 'Maîtrisez l\'informatique';

  // --- Durées des timers (en secondes) ---
  static const int timerNormal    = 20; // Temps normal par question
  static const int timerChallenge = 15; // Temps en mode Défi Chronométré

  // --- Modes de jeu ---
  static const String modeQuick    = 'quick';
  static const String modeStandard = 'standard';
  static const String modeSurvival = 'survival';
  static const String modeTimed    = 'timed';

  // --- Nombre de questions par mode ---
  static const int questionsQuick    = 5;
  static const int questionsStandard = 10;
  static const int questionsSurvival = 999; // Illimité (stoppé sur erreur)
  static const int questionsTimed    = 10;

  // --- Système de vies ---
  static const int maxLives = 3;

  // --- Points ---
  static const int pointsCorrect    = 100;
  static const int pointsComboBonus = 50;  // Bonus par combo supplémentaire
  static const int pointsTimeBonus  = 10;  // Bonus par seconde restante

  // --- Domaines disponibles ---
  static const List<Map<String, dynamic>> domains = [
    {
      'id'         : 'iot',
      'label'      : 'IoT',
      'subtitle'   : 'Internet des Objets',
      'icon'       : 'assets/icons/iot.svg',
      'jsonPath'   : 'assets/questions/iot.json',
      'color'      : 0xFF809671,
    },
    {
      'id'         : 'flutter',
      'label'      : 'Flutter',
      'subtitle'   : 'Développement Mobile',
      'icon'       : 'assets/icons/flutter.svg',
      'jsonPath'   : 'assets/questions/flutter.json',
      'color'      : 0xFF54C5F8,
    },
    {
      'id'         : 'ai',
      'label'      : 'Intelligence Artificielle',
      'subtitle'   : 'Machine Learning & IA',
      'icon'       : 'assets/icons/ai.svg',
      'jsonPath'   : 'assets/questions/ai.json',
      'color'      : 0xFFB3B792,
    },
    {
      'id'         : 'cybersecurity',
      'label'      : 'Cybersécurité',
      'subtitle'   : 'Sécurité & Cryptographie',
      'icon'       : 'assets/icons/cyber.svg',
      'jsonPath'   : 'assets/questions/cybersecurity.json',
      'color'      : 0xFFBF4B4B,
    },
    {
      'id'         : 'web',
      'label'      : 'Développement Web',
      'subtitle'   : 'HTML, CSS, JS & Frameworks',
      'icon'       : 'assets/icons/web.svg',
      'jsonPath'   : 'assets/questions/web.json',
      'color'      : 0xFF725C3A,
    },
    {
      'id'         : 'python',
      'label'      : 'Python',
      'subtitle'   : 'Programmation & Scripts',
      'icon'       : 'assets/icons/python.svg',
      'jsonPath'   : 'assets/questions/python.json',
      'color'      : 0xFFE5DEB8,
    },
    {
      'id'         : 'linux',
      'label'      : 'Linux',
      'subtitle'   : 'Système & Administration',
      'icon'       : 'assets/icons/linux.svg',
      'jsonPath'   : 'assets/questions/linux.json',
      'color'      : 0xFFE5E0D8,
    },
  ];

  // --- Achievements (badges) ---
  static const List<Map<String, dynamic>> achievements = [
    {
      'id'          : 'iot_king',
      'title'       : 'Roi de l\'IoT',
      'description' : 'Terminez 3 quiz IoT avec un score parfait',
      'domain'      : 'iot',
      'requiredScore': 100,
      'requiredCount': 3,
    },
    {
      'id'          : 'linux_expert',
      'title'       : 'Expert Linux',
      'description' : 'Terminez 3 quiz Linux avec un score parfait',
      'domain'      : 'linux',
      'requiredScore': 100,
      'requiredCount': 3,
    },
    {
      'id'          : 'python_master',
      'title'       : 'Maître Python',
      'description' : 'Terminez 3 quiz Python avec un score parfait',
      'domain'      : 'python',
      'requiredScore': 100,
      'requiredCount': 3,
    },
    {
      'id'          : 'quiz_champion',
      'title'       : 'Champion du Quiz',
      'description' : 'Complétez 10 quiz au total',
      'domain'      : 'all',
      'requiredScore': 0,
      'requiredCount': 10,
    },
    {
      'id'          : 'fast_thinker',
      'title'       : 'Penseur Rapide',
      'description' : 'Répondez en moins de 5 secondes 10 fois',
      'domain'      : 'all',
      'requiredScore': 0,
      'requiredCount': 10,
    },
    {
      'id'          : 'cyber_guardian',
      'title'       : 'Gardien Cyber',
      'description' : 'Complétez 3 quiz Cybersécurité sans erreur',
      'domain'      : 'cybersecurity',
      'requiredScore': 100,
      'requiredCount': 3,
    },
    {
      'id'          : 'ai_visionary',
      'title'       : 'Visionnaire IA',
      'description' : 'Obtenez 100% en mode Survie (IA)',
      'domain'      : 'ai',
      'requiredScore': 100,
      'requiredCount': 1,
    },
  ];

  // --- Clés SharedPreferences ---
  static const String prefBestScores    = 'best_scores';
  static const String prefTotalQuizzes  = 'total_quizzes';
  static const String prefAchievements  = 'achievements';
  static const String prefTheme         = 'theme';
  static const String prefFastAnswers   = 'fast_answers';

  // --- Messages motivationnels par score ---
  static String getMotivationalMessage(int percentage) {
    if (percentage == 100) return 'Perfection absolue ! Vous êtes un génie !';
    if (percentage >= 80)  return 'Excellent travail ! Continuez comme ça !';
    if (percentage >= 60)  return 'Bonne performance ! Encore un effort !';
    if (percentage >= 40)  return 'Pas mal, mais vous pouvez faire mieux !';
    return 'Ne vous découragez pas, réessayez !';
  }

  // --- Nombre d'étoiles selon le score ---
  static int getStars(int percentage) {
    if (percentage == 100) return 3;
    if (percentage >= 70)  return 2;
    if (percentage >= 40)  return 1;
    return 0;
  }
}
