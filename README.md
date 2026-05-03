# TechIQ - Plateforme Gamifiée de Quiz Informatique

## Présentation du Projet

TechIQ est une application mobile Flutter complète, fonctionnant entièrement hors ligne (100% offline), dédiée aux quiz de culture informatique. L'interface est futuriste, sombre et gaming, avec des effets néon et glassmorphism.

---

## Architecture du Projet

```
techiq/
├── pubspec.yaml                        # Configuration, dépendances, assets
│
├── assets/
│   └── questions/                      # Fichiers JSON des quiz par domaine
│       ├── iot.json                    # 22 questions IoT
│       ├── flutter.json                # 22 questions Flutter/Dart
│       ├── ai.json                     # 22 questions Intelligence Artificielle
│       ├── cybersecurity.json          # 22 questions Cybersécurité
│       ├── web.json                    # 22 questions Développement Web
│       ├── python.json                 # 22 questions Python
│       └── linux.json                  # 22 questions Linux
│
└── lib/
    ├── main.dart                       # Point d'entrée, MultiProvider
    │
    ├── core/
    │   ├── theme/
    │   │   ├── app_colors.dart         # Palette, gradients, effets néon
    │   │   └── app_theme.dart          # ThemeData Material complet
    │   └── constants/
    │       └── app_constants.dart      # Domaines, modes, achievements, messages
    │
    ├── models/
    │   └── models.dart                 # QuestionModel, DomainModel, QuizResult, AchievementModel
    │
    ├── providers/
    │   ├── quiz_provider.dart          # Logique principale du quiz (timer, score, vies, combo)
    │   ├── theme_provider.dart         # Gestion des 3 thèmes visuels
    │   └── stats_provider.dart         # Statistiques et achievements
    │
    ├── services/
    │   ├── storage_service.dart        # Persistance locale (SharedPreferences)
    │   ├── question_service.dart       # Chargement et cache des JSON
    │   └── audio_service.dart          # Effets sonores (audioplayers)
    │
    ├── screens/
    │   ├── splash_screen.dart          # Écran de démarrage animé
    │   ├── home_screen.dart            # Grille des domaines
    │   ├── mode_selection_screen.dart  # Sélection du mode de jeu
    │   ├── quiz_screen.dart            # Écran de jeu principal
    │   ├── result_screen.dart          # Résultats et statistiques finales
    │   └── profile_screen.dart         # Profil, stats, achievements, thèmes
    │
    └── widgets/
        ├── shared_widgets.dart         # GlassCard, NeonButton, GradientBackground, StatMini
        └── quiz_widgets.dart           # TimerWidget, LivesWidget, AnswerCard, ComboWidget
```

---

## Palette de Couleurs

| Couleur            | Hex       | Usage                              |
|--------------------|-----------|------------------------------------|
| Vert Sauge         | #809671   | Couleur principale, néon accent    |
| Sauge Clair        | #B3B792   | Texte secondaire, sous-titres      |
| Blanc Chaud        | #E5E0D8   | Texte principal                    |
| Crème Dorée        | #E5DEB8   | Combo, étoiles, highlights         |
| Brun Chaud         | #725C3A   | Mode Défi, accents secondaires     |
| Fond Sombre        | #0B0E0A   | Arrière-plan principal             |
| Fond Carte         | #141A11   | Cartes glassmorphism               |
| Correct            | #6DBF67   | Bonne réponse                      |
| Incorrect          | #BF4B4B   | Mauvaise réponse, vies perdues     |

---

## Thèmes Visuels

### Cyber Néon (par défaut)
Palette vert sauge, ambiance futuriste sobre sur fond très sombre.

### Hacker Green
Vert intense pur (#39FF14), style terminal Unix/hacker, très contrasté.

### Purple Tech
Violet élégant (#9B59B6), style tech premium et moderne.

---

## Domaines et Contenus Quiz

| Domaine             | Questions | Couleur      |
|---------------------|-----------|--------------|
| IoT                 | 22        | Vert Sauge   |
| Flutter             | 22        | Bleu Ciel    |
| Intelligence Art.   | 22        | Sauge Clair  |
| Cybersécurité       | 22        | Rouge        |
| Développement Web   | 22        | Brun Chaud   |
| Python              | 22        | Crème Dorée  |
| Linux               | 22        | Blanc Chaud  |

---

## Modes de Jeu

| Mode               | Questions | Timer       | Particularité                    |
|--------------------|-----------|-------------|----------------------------------|
| Quiz Rapide        | 5         | 20 sec/Q    | Idéal pour s'échauffer           |
| Quiz Standard      | 10        | 20 sec/Q    | Expérience de quiz classique     |
| Mode Survie        | Toutes    | 20 sec/Q    | 1 erreur = fin de partie         |
| Défi Chronométré   | 10        | 15 sec/Q    | Timer réduit, pression maximale  |

---

## Système de Score

```
Bonne réponse         : +100 points
Bonus de temps        : +(secondes_restantes × 10) points  
Bonus combo (x2)      : +50 points de bonus supplémentaires
Bonus combo (x3)      : +100 points de bonus supplémentaires
Combo (xN)            : +((N-1) × 50) points de bonus
```

---

## Achievements (Badges)

| Badge              | Condition                                      |
|--------------------|------------------------------------------------|
| Roi de l'IoT       | 3 quiz IoT avec 100%                           |
| Expert Linux       | 3 quiz Linux avec 100%                         |
| Maître Python      | 3 quiz Python avec 100%                        |
| Champion du Quiz   | 10 quiz complétés (tous domaines)              |
| Penseur Rapide     | 10 réponses en moins de 5 secondes             |
| Gardien Cyber      | 3 quiz Cybersécurité sans erreur               |
| Visionnaire IA     | 100% en Mode Survie (domaine IA)               |

---

## Polices Utilisées

- **Orbitron** : Titres, scores, labels gaming (Google Fonts)
- **Rajdhani** : Corps de texte, descriptions, boutons (Google Fonts)

---

## Packages Utilisés

```yaml
provider: ^6.1.1          # Gestion d'état réactive
shared_preferences: ^2.2.2 # Stockage local persistant  
flutter_animate: ^4.5.0    # Animations fluides et chainables
lottie: ^3.1.0             # Animations Lottie JSON
audioplayers: ^5.2.1       # Effets sonores
google_fonts: ^6.2.1       # Polices Orbitron + Rajdhani
flutter_svg: ^2.0.9        # Support SVG pour les icônes
```

---

## Instructions de Démarrage

### 1. Cloner et configurer

```bash
# Créer le projet Flutter
flutter create techiq
cd techiq

# Copier tous les fichiers de ce projet
# Remplacer pubspec.yaml et lib/ par les fichiers fournis
# Placer les JSON dans assets/questions/
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Lancer l'application

```bash
flutter run
```

---

## Ajouter les Sons (Optionnel)

Créez le dossier `assets/audio/` et ajoutez :
- `correct.mp3` : Son de bonne réponse
- `wrong.mp3` : Son de mauvaise réponse  
- `combo.mp3` : Son de combo
- `select.mp3` : Son de sélection de domaine
- `win.mp3` : Son de fin de partie
- `tick.mp3` : Alerte timer

Puis décommentez les lignes correspondantes dans `audio_service.dart` et ajoutez dans `pubspec.yaml` :

```yaml
assets:
  - assets/audio/correct.mp3
  - assets/audio/wrong.mp3
  # ... etc
```

---

## Fonctionnalités Techniques

- **100% Offline** : Aucun backend, aucune connexion réseau requise
- **Cache JSON** : Les questions sont chargées une fois puis mises en cache mémoire
- **Persistance locale** : SharedPreferences pour les scores, achievements et thèmes
- **Pattern Provider** : Architecture réactive ChangeNotifier + Consumer
- **Animations** : flutter_animate pour les transitions et effets visuels
- **Responsive** : Layout adaptatif mobile portrait
- **Mode sombre** : Interface entièrement en dark mode
