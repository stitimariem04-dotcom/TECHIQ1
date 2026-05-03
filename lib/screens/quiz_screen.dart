// ============================================================
// QUIZ SCREEN - TECHIQ
// Écran de jeu principal : questions, timer, vies, combo, score
// Affiche les questions et gère les transitions entre elles
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/quiz_provider.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/quiz_widgets.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _showExplanation = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quiz, _) {
        // Navigation automatique vers l'écran de résultat
        if (quiz.isFinished) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const ResultScreen(),
                  transitionDuration: const Duration(milliseconds: 600),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            }
          });
        }

        if (quiz.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.sageGreen),
            ),
          );
        }

        if (quiz.state == QuizState.error) {
          return _buildErrorScreen(context, quiz);
        }

        return Scaffold(
          body: GradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context, quiz),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildProgressSection(quiz),
                          const SizedBox(height: 20),
                          _buildQuestionCard(context, quiz),
                          const SizedBox(height: 20),
                          _buildAnswerOptions(context, quiz),
                          if (quiz.state == QuizState.answered) ...[
                            const SizedBox(height: 12),
                            _buildExplanationSection(context, quiz),
                            const SizedBox(height: 20),
                            _buildNextButton(context, quiz),
                          ],
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Barre supérieure (score, vies, timer, combo) ─────────
  Widget _buildTopBar(BuildContext context, QuizProvider quiz) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          // Bouton retour
          GestureDetector(
            onTap: () => _showQuitDialog(context, quiz),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.sageGreen.withOpacity(0.3)),
                color: AppColors.bgCard,
              ),
              child: const Icon(Icons.close,
                  color: AppColors.sageGreen, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          // Score
          Expanded(
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('SCORE', style: Theme.of(context).textTheme.labelMedium),
                      Text(
                        '${quiz.score}',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.sageGreen,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  // Vies
                  LivesWidget(lives: quiz.lives),
                  // Combo
                  ComboWidget(combo: quiz.combo),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Timer
          TimerWidget(
            timeLeft: quiz.timeLeft,
            progress: quiz.timerProgress,
          ),
        ],
      ),
    );
  }

  // ── Barre de progression des questions ──────────────────
  Widget _buildProgressSection(QuizProvider quiz) {
    return ProgressWidget(
      progress: quiz.progress,
      current: quiz.currentIndex + 1,
      total: quiz.questions.length,
    );
  }

  // ── Carte de la question ─────────────────────────────────
  Widget _buildQuestionCard(BuildContext context, QuizProvider quiz) {
    final question = quiz.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    return GlassCard(
      padding: const EdgeInsets.all(22),
      borderColor: AppColors.sageGreen.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Numéro de question
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.sageGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.sageGreen.withOpacity(0.3)),
            ),
            child: Text(
              'Q.${quiz.currentIndex + 1}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.sageGreen,
                  ),
            ),
          ),
          const SizedBox(height: 14),
          // Énoncé de la question
          Text(
            question.question,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              height: 1.4,
            ),
          ),
        ],
      ),
    )
        .animate(key: ValueKey(quiz.currentIndex))
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.1, end: 0, duration: 400.ms);
  }

  // ── Options de réponse ───────────────────────────────────
  Widget _buildAnswerOptions(BuildContext context, QuizProvider quiz) {
    final question = quiz.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    return Column(
      key: ValueKey('options_${quiz.currentIndex}'),
      children: question.options.asMap().entries.map((entry) {
        return AnswerCard(
          option        : entry.value,
          selectedAnswer: quiz.selectedAnswer,
          correctAnswer : question.answer,
          hasAnswered   : quiz.state == QuizState.answered,
          index         : entry.key,
          onTap         : () => quiz.selectAnswer(entry.value),
        );
      }).toList(),
    );
  }

  // ── Explication après réponse ────────────────────────────
  Widget _buildExplanationSection(BuildContext context, QuizProvider quiz) {
    final question = quiz.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    final isCorrect = quiz.isCorrect;
    final color = isCorrect ? AppColors.correct : AppColors.wrong;

    return GlassCard(
      borderColor: color.withOpacity(0.5),
      backgroundColor: color.withOpacity(0.08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.info_outline,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Excellent !' : 'Bonne réponse :',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                      ),
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: 2),
                  Text(
                    question.answer,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.correct,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  question.explanation,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0);
  }

  // ── Bouton suivant ───────────────────────────────────────
  Widget _buildNextButton(BuildContext context, QuizProvider quiz) {
    return SizedBox(
      width: double.infinity,
      child: NeonButton(
        label: quiz.currentIndex >= quiz.questions.length - 1
            ? 'Voir les Résultats'
            : 'Question Suivante',
        icon: quiz.currentIndex >= quiz.questions.length - 1
            ? Icons.emoji_events
            : Icons.arrow_forward,
        onTap: () {
          setState(() => _showExplanation = false);
          quiz.nextQuestion();
        },
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0);
  }

  // ── Écran d'erreur ───────────────────────────────────────
  Widget _buildErrorScreen(BuildContext context, QuizProvider quiz) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.wrong, size: 60),
            const SizedBox(height: 20),
            Text(
              'Erreur de chargement',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Impossible de charger les questions.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            NeonButton(
              label: 'Retour',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialogue de confirmation pour quitter ────────────────
  void _showQuitDialog(BuildContext context, QuizProvider quiz) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: AppColors.sageGreen.withOpacity(0.3)),
        ),
        title: Text(
          'Quitter le Quiz',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text(
          'Votre progression sera perdue. Etes-vous sûr ?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Continuer',
              style: TextStyle(color: AppColors.sageGreen),
            ),
          ),
          TextButton(
            onPressed: () {
              quiz.reset();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              'Quitter',
              style: TextStyle(color: AppColors.wrong),
            ),
          ),
        ],
      ),
    );
  }
}
