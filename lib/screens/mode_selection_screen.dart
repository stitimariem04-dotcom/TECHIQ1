// ============================================================
// MODE SELECTION SCREEN - TECHIQ
// Permet à l'utilisateur de choisir le mode de jeu :
// Quiz Rapide, Standard, Survie ou Défi Chronométré
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/models.dart';
import '../providers/quiz_provider.dart';
import '../widgets/shared_widgets.dart';
import 'quiz_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  final DomainModel domain;

  const ModeSelectionScreen({super.key, required this.domain});

  // Métadonnées des modes de jeu
  static const List<Map<String, dynamic>> _modes = [
    {
      'id'         : AppConstants.modeQuick,
      'label'      : 'Quiz Rapide',
      'description': '5 questions pour s\'échauffer',
      'icon'       : Icons.flash_on,
      'color'      : 0xFF809671,
      'questions'  : '5 questions',
      'timer'      : '20 sec / question',
    },
    {
      'id'         : AppConstants.modeStandard,
      'label'      : 'Quiz Standard',
      'description': '10 questions pour tester vos connaissances',
      'icon'       : Icons.quiz,
      'color'      : 0xFFB3B792,
      'questions'  : '10 questions',
      'timer'      : '20 sec / question',
    },
    {
      'id'         : AppConstants.modeSurvival,
      'label'      : 'Mode Survie',
      'description': 'Une erreur et c\'est terminé',
      'icon'       : Icons.favorite,
      'color'      : 0xFFBF4B4B,
      'questions'  : 'Illimite',
      'timer'      : '20 sec / question',
    },
    {
      'id'         : AppConstants.modeTimed,
      'label'      : 'Defi Chronometré',
      'description': 'Repondez vite, le temps presse',
      'icon'       : Icons.timer,
      'color'      : 0xFF725C3A,
      'questions'  : '10 questions',
      'timer'      : '15 sec / question',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildDomainBadge(context),
              const SizedBox(height: 8),
              Expanded(child: _buildModeList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.sageGreen.withOpacity(0.3)),
                color: AppColors.bgCard,
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.sageGreen, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Choisir le mode',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDomainBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderColor: domain.color.withOpacity(0.4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: domain.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: domain.color.withOpacity(0.4)),
                boxShadow: AppColors.neonShadow(domain.color, spread: 3),
              ),
              child: Icon(Icons.memory_rounded, color: domain.color, size: 24),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(domain.label,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: domain.color,
                        )),
                Text(domain.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.1, end: 0),
    );
  }

  Widget _buildModeList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: _modes.length,
      itemBuilder: (context, index) {
        final mode = _modes[index];
        return _ModeCard(
          mode: mode,
          index: index,
          onTap: () => _startQuiz(context, mode['id'] as String),
        );
      },
    );
  }

  void _startQuiz(BuildContext context, String modeId) {
    final quizProvider = context.read<QuizProvider>();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const QuizScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    // Lance le quiz après la navigation
    quizProvider.startQuiz(domain: domain, mode: modeId);
  }
}

// ──────────────────────────────────────────────────────────
// MODE CARD - Carte individuelle de mode de jeu
// ──────────────────────────────────────────────────────────
class _ModeCard extends StatefulWidget {
  final Map<String, dynamic> mode;
  final int index;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.index,
    required this.onTap,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.mode['color'] as int);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 14),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: color.withOpacity(_pressed ? 0.8 : 0.3), width: 1.5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), AppColors.bgCard],
          ),
          boxShadow: _pressed ? AppColors.neonShadow(color, spread: 4) : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // Icône du mode
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(widget.mode['icon'] as IconData,
                    color: color, size: 24),
              ),
              const SizedBox(width: 16),
              // Infos du mode
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mode['label'] as String,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.mode['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    // Tags questions / timer
                    Row(
                      children: [
                        _tag(context, Icons.quiz_outlined,
                            widget.mode['questions'] as String, color),
                        const SizedBox(width: 8),
                        _tag(context, Icons.timer_outlined,
                            widget.mode['timer'] as String, color),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: color.withOpacity(0.6), size: 16),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * widget.index))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0, duration: 400.ms);
  }

  Widget _tag(
      BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color.withOpacity(0.8)),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color.withOpacity(0.9),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}
