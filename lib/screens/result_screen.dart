// ============================================================
// RESULT SCREEN - TECHIQ
// Affiche le résultat final du quiz :
// score, étoiles, pourcentage, message motivationnel
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../providers/quiz_provider.dart';
import '../providers/stats_provider.dart';
import '../widgets/shared_widgets.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    // Actualise les statistiques après le quiz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsProvider>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.read<QuizProvider>();
    final percentage = quiz.questions.isEmpty
        ? 0
        : ((quiz.correctAnswers / quiz.questions.length) * 100).round();
    final stars  = AppConstants.getStars(percentage);
    final message = AppConstants.getMotivationalMessage(percentage);
    final color  = percentage >= 70
        ? AppColors.correct
        : percentage >= 40
            ? AppColors.timerWarn
            : AppColors.wrong;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              children: [
                // ── Titre ───────────────────────────────
                Text(
                  'Résultat Final',
                  style: Theme.of(context).textTheme.displayMedium,
                ).animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 30),

                // ── Étoiles ──────────────────────────────
                _buildStars(context, stars),

                const SizedBox(height: 28),

                // ── Score circulaire ─────────────────────
                _buildScoreCircle(context, percentage, color),

                const SizedBox(height: 28),

                // ── Message motivationnel ────────────────
                GlassCard(
                  borderColor: color.withOpacity(0.4),
                  backgroundColor: color.withOpacity(0.08),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: color,
                          height: 1.4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ).animate(delay: 400.ms).fadeIn().scale(),

                const SizedBox(height: 24),

                // ── Statistiques détaillées ──────────────
                _buildStats(context, quiz, percentage),

                const SizedBox(height: 30),

                // ── Boutons d'action ─────────────────────
                _buildActionButtons(context, quiz),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Affichage des étoiles ────────────────────────────────
  Widget _buildStars(BuildContext context, int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final filled = index < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            color: filled ? AppColors.cream : AppColors.cream.withOpacity(0.2),
            size: 48,
          )
              .animate(delay: Duration(milliseconds: 200 + 150 * index))
              .scale(duration: 500.ms, curve: Curves.elasticOut)
              .fadeIn(duration: 300.ms),
        );
      }),
    );
  }

  // ── Cercle de score principal ────────────────────────────
  Widget _buildScoreCircle(
      BuildContext context, int percentage, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Anneau de fond
        SizedBox(
          width: 180,
          height: 180,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 12,
            color: color.withOpacity(0.1),
          ),
        ),
        // Anneau de valeur animé
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: percentage / 100),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOut,
          builder: (_, value, __) {
            return SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                color: color,
                strokeCap: StrokeCap.round,
              ),
            );
          },
        ),
        // Contenu central
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgCard,
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: percentage),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOut,
                builder: (_, value, __) => Text(
                  '$value%',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: color,
                        fontSize: 36,
                      ),
                ),
              ),
              Text(
                'Réussite',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
        // Halo lumineux
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppColors.neonShadow(color, spread: 8),
          ),
        ),
      ],
    ).animate(delay: 100.ms).fadeIn(duration: 600.ms);
  }

  // ── Statistiques détaillées ──────────────────────────────
  Widget _buildStats(BuildContext context, QuizProvider quiz, int percentage) {
    return GlassCard(
      child: Column(
        children: [
          const SectionTitle(title: 'Détails'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatMini(
                value: '${quiz.score}',
                label: 'Points',
                color: AppColors.sageGreen,
              ),
              StatMini(
                value: '${quiz.correctAnswers}/${quiz.questions.length}',
                label: 'Bonnes\nRéponses',
                color: AppColors.correct,
              ),
              StatMini(
                value: 'x${quiz.maxCombo}',
                label: 'Combo\nMax',
                color: AppColors.cream,
              ),
              StatMini(
                value: '${AppConstants.maxLives - quiz.lives}',
                label: 'Vies\nPerdues',
                color: AppColors.wrong,
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }

  // ── Boutons d'action ─────────────────────────────────────
  Widget _buildActionButtons(BuildContext context, QuizProvider quiz) {
    return Column(
      children: [
        // Bouton "Rejouer"
        SizedBox(
          width: double.infinity,
          child: NeonButton(
            label: 'Rejouer',
            icon: Icons.replay,
            onTap: () {
              // Remet à zéro et retourne au choix des modes
              quiz.reset();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
        const SizedBox(height: 12),
        // Bouton "Retour à l'accueil"
        SizedBox(
          width: double.infinity,
          child: NeonButton(
            label: 'Accueil',
            icon: Icons.home_outlined,
            isOutlined: true,
            onTap: () {
              quiz.reset();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      ],
    ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.3, end: 0);
  }
}
