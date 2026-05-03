// ============================================================
// WIDGETS DU QUIZ - TECHIQ
// TimerWidget    : Barre de décompte animée
// LivesWidget    : Affichage des coeurs de vie
// ProgressWidget : Barre de progression des questions
// AnswerCard     : Carte de réponse interactive
// ComboWidget    : Affichage du combo/streak
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';

// ==========================================================
// TIMER WIDGET - Barre circulaire de décompte
// ==========================================================
class TimerWidget extends StatelessWidget {
  final int timeLeft;
  final double progress; // 1.0 = plein, 0.0 = vide

  const TimerWidget({super.key, required this.timeLeft, required this.progress});

  Color get _timerColor {
    if (progress > 0.5) return AppColors.timerOk;
    if (progress > 0.25) return AppColors.timerWarn;
    return AppColors.timerCrit;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Cercle de fond
        SizedBox(
          width: 72,
          height: 72,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 4,
            color: _timerColor.withOpacity(0.15),
          ),
        ),
        // Cercle de progression
        SizedBox(
          width: 72,
          height: 72,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            color: _timerColor,
            strokeCap: StrokeCap.round,
          ),
        ),
        // Chiffre central
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$timeLeft',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: _timerColor,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'SEC',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _timerColor.withOpacity(0.7),
                fontSize: 9,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    ).animate(
      // Effet de pulsation dans les dernières secondes
      onPlay: (c) => c.repeat(),
    ).custom(
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: progress < 0.25 ? (1 + 0.04 * value) : 1.0,
          child: child,
        );
      },
    );
  }
}

// ==========================================================
// LIVES WIDGET - Affichage des coeurs de vie
// ==========================================================
class LivesWidget extends StatelessWidget {
  final int lives;
  final int maxLives;

  const LivesWidget({
    super.key,
    required this.lives,
    this.maxLives = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (index) {
        final isAlive = index < lives;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            isAlive ? Icons.favorite : Icons.favorite_border,
            color: isAlive ? AppColors.wrong : AppColors.wrong.withOpacity(0.3),
            size: 22,
          ).animate(
            target: isAlive ? 0 : 1,
          ).scale(
            duration: 300.ms,
            curve: Curves.elasticOut,
            begin: const Offset(1, 1),
            end: const Offset(0.7, 0.7),
          ),
        );
      }),
    );
  }
}

// ==========================================================
// PROGRESS WIDGET - Barre de progression linéaire
// ==========================================================
class ProgressWidget extends StatelessWidget {
  final double progress;      // 0.0 à 1.0
  final int current;
  final int total;

  const ProgressWidget({
    super.key,
    required this.progress,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question $current / $total',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '${(progress * 100).round()}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.sageGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.sageGreen.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(AppColors.sageGreen),
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// ANSWER CARD - Carte de réponse cliquable
// ==========================================================
class AnswerCard extends StatefulWidget {
  final String option;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool hasAnswered;
  final VoidCallback onTap;
  final int index;

  const AnswerCard({
    super.key,
    required this.option,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.hasAnswered,
    required this.onTap,
    required this.index,
  });

  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  // Lettres des options : A, B, C, D
  static const _letters = ['A', 'B', 'C', 'D'];

  // Détermine la couleur de la carte selon l'état
  Color _getCardColor() {
    if (!widget.hasAnswered) return AppColors.bgCard;

    if (widget.option == widget.correctAnswer) return AppColors.correct.withOpacity(0.2);
    if (widget.option == widget.selectedAnswer) return AppColors.wrong.withOpacity(0.2);
    return AppColors.bgCard;
  }

  Color _getBorderColor() {
    if (!widget.hasAnswered) return AppColors.sageGreen.withOpacity(0.25);

    if (widget.option == widget.correctAnswer) return AppColors.correct;
    if (widget.option == widget.selectedAnswer) return AppColors.wrong;
    return AppColors.sageGreen.withOpacity(0.1);
  }

  Color _getLetterColor() {
    if (!widget.hasAnswered) return AppColors.sageGreen;

    if (widget.option == widget.correctAnswer) return AppColors.correct;
    if (widget.option == widget.selectedAnswer) return AppColors.wrong;
    return AppColors.textHint;
  }

  IconData? _getTrailingIcon() {
    if (!widget.hasAnswered) return null;
    if (widget.option == widget.correctAnswer) return Icons.check_circle;
    if (widget.option == widget.selectedAnswer) return Icons.cancel;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = !widget.hasAnswered;

    return GestureDetector(
      onTap: isInteractive ? widget.onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _getCardColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _getBorderColor(), width: 1.5),
          boxShadow: widget.hasAnswered && widget.option == widget.correctAnswer
              ? AppColors.neonShadow(AppColors.correct, spread: 4)
              : [],
        ),
        child: Row(
          children: [
            // Lettre de l'option (A, B, C, D)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _getLetterColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _getLetterColor().withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  _letters[widget.index],
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _getLetterColor(),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Texte de la réponse
            Expanded(
              child: Text(
                widget.option,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Icône de résultat
            if (_getTrailingIcon() != null)
              Icon(
                _getTrailingIcon(),
                color: widget.option == widget.correctAnswer
                    ? AppColors.correct
                    : AppColors.wrong,
                size: 22,
              ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: 100 * widget.index))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}

// ==========================================================
// COMBO WIDGET - Affichage du streak de bonnes réponses
// ==========================================================
class ComboWidget extends StatelessWidget {
  final int combo;

  const ComboWidget({super.key, required this.combo});

  @override
  Widget build(BuildContext context) {
    if (combo < 2) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cream.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cream.withOpacity(0.5)),
        boxShadow: AppColors.neonShadow(AppColors.cream, spread: 3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, color: AppColors.cream, size: 16),
          const SizedBox(width: 4),
          Text(
            'COMBO x$combo',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.cream,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 300.ms, curve: Curves.elasticOut);
  }
}
