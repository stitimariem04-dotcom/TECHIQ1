// ============================================================
// SPLASH SCREEN - TECHIQ
// Écran de démarrage avec animation du logo et du titre
// Transition automatique vers l'écran principal
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../widgets/shared_widgets.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    // Animation de pulsation pour l'effet néon
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Navigation automatique après 3 secondes
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo animé ────────────────────────────
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (_, child) {
                    return Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: AppColors.sageGreen.withOpacity(
                              0.5 + 0.5 * _glowController.value),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.sageGreen.withOpacity(
                                0.2 + 0.3 * _glowController.value),
                            blurRadius: 30 + 20 * _glowController.value,
                            spreadRadius: 5 + 5 * _glowController.value,
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.bgCard,
                            AppColors.sageGreen.withOpacity(0.15),
                          ],
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: const Icon(
                    Icons.memory_rounded,
                    size: 64,
                    color: AppColors.sageGreen,
                  ),
                )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.elasticOut)
                    .fadeIn(duration: 600.ms),

                const SizedBox(height: 40),

                // ── Titre TechIQ ──────────────────────────
                Text(
                  'TechIQ',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.textPrimary,
                    shadows: [
                      Shadow(
                        color: AppColors.sageGreen.withOpacity(0.6),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, duration: 600.ms),

                const SizedBox(height: 12),

                // ── Tagline ───────────────────────────────
                Text(
                  'Maîtrisez l\'informatique',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightSage,
                    letterSpacing: 2,
                  ),
                )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 600.ms),

                const SizedBox(height: 80),

                // ── Indicateur de chargement ──────────────
                Column(
                  children: [
                    SizedBox(
                      width: 120,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.sageGreen.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation(AppColors.sageGreen),
                        minHeight: 3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Initialisation...',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                )
                    .animate(delay: 800.ms)
                    .fadeIn(duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
