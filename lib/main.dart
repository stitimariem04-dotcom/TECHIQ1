// ============================================================
// MAIN.DART - POINT D'ENTRÉE DE TECHIQ
// Configure les providers, le thème et démarre l'application
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/quiz_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/stats_provider.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  // Assure l'initialisation des plugins Flutter avant runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Force le mode portrait (application mobile uniquement)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Personnalise la barre de statut du système
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0B0E0A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Initialise le stockage local (SharedPreferences)
  await StorageService().init();

  runApp(const TechIQApp());
}

class TechIQApp extends StatelessWidget {
  const TechIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider : injection de tous les providers dans l'arbre de widgets
    return MultiProvider(
      providers: [
        // Provider du quiz (logique principale)
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        // Provider du thème visuel
        ChangeNotifierProvider(create: (_) => AppThemeProvider()..loadTheme()),
        // Provider des statistiques et achievements
        ChangeNotifierProvider(create: (_) => StatsProvider()),
      ],
      child: Consumer<AppThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'TechIQ',
            debugShowCheckedModeBanner: false, // Cache le bandeau debug
            theme: AppTheme.darkTheme,
            // L'application démarre toujours sur le SplashScreen
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
