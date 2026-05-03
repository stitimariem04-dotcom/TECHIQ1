// ============================================================
// SERVICE AUDIO - TECHIQ
// Gère les effets sonores du jeu (correct, faux, timer, etc.)
// Note : Les fichiers audio sont simulés - remplacez par vos assets
// ============================================================

class AudioService {
  // Singleton
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _isMuted = false;

  bool get isMuted => _isMuted;

  void toggleMute() => _isMuted = !_isMuted;

  // --- Effets sonores disponibles ---
  // Note: Pour activer l'audio réel, décommentez le code audioplayers
  // et ajoutez les fichiers .mp3 dans assets/audio/

  /// Son de bonne réponse
  Future<void> playCorrect() async {
    if (_isMuted) return;
    // final player = AudioPlayer();
    // await player.play(AssetSource('audio/correct.mp3'));
  }

  /// Son de mauvaise réponse
  Future<void> playWrong() async {
    if (_isMuted) return;
    // final player = AudioPlayer();
    // await player.play(AssetSource('audio/wrong.mp3'));
  }

  /// Son de clic sur une carte de domaine
  Future<void> playSelect() async {
    if (_isMuted) return;
    // final player = AudioPlayer();
    // await player.play(AssetSource('audio/select.mp3'));
  }

  /// Son de fin de partie (victoire)
  Future<void> playWin() async {
    if (_isMuted) return;
    // final player = AudioPlayer();
    // await player.play(AssetSource('audio/win.mp3'));
  }

  /// Son d'alerte timer (dernières secondes)
  Future<void> playTimerWarning() async {
    if (_isMuted) return;
    // final player = AudioPlayer();
    // await player.play(AssetSource('audio/tick.mp3'));
  }

  /// Son de combo
  Future<void> playCombo() async {
    if (_isMuted) return;
    // final player = AudioPlayer();
    // await player.play(AssetSource('audio/combo.mp3'));
  }
}
