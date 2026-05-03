// ============================================================
// PROFILE SCREEN - TECHIQ
// Statistiques du joueur, meilleurs scores par domaine,
// achievements débloqués et sélection du thème
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/models.dart';
import '../providers/stats_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Charge les stats au démarrage de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsProvider>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Consumer<StatsProvider>(
            builder: (context, stats, _) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(context)),
                  SliverToBoxAdapter(child: _buildGlobalStats(context, stats)),
                  SliverToBoxAdapter(child: _buildDomainStats(context, stats)),
                  SliverToBoxAdapter(child: _buildAchievements(context, stats)),
                  SliverToBoxAdapter(child: _buildThemeSection(context)),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ── En-tête ──────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
          Text('Mon Profil',
              style: Theme.of(context).textTheme.displaySmall),
        ],
      ),
    );
  }

  // ── Statistiques globales ────────────────────────────────
  Widget _buildGlobalStats(BuildContext context, StatsProvider stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Vue d\'ensemble'),
          const SizedBox(height: 16),
          GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatMini(
                  value: '${stats.totalQuizzes}',
                  label: 'Quiz\nComplétés',
                  color: AppColors.sageGreen,
                ),
                StatMini(
                  value: '${stats.totalScore}',
                  label: 'Score\nTotal',
                  color: AppColors.cream,
                ),
                StatMini(
                  value: '${stats.bestPercentage}%',
                  label: 'Meilleur\nScore',
                  color: AppColors.correct,
                ),
                StatMini(
                  value: '${stats.unlockedCount}/${AppConstants.achievements.length}',
                  label: 'Badges\nObtentus',
                  color: AppColors.warmBrown,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  // ── Statistiques par domaine ─────────────────────────────
  Widget _buildDomainStats(BuildContext context, StatsProvider stats) {
    final domainStats = stats.statsByDomain;
    final domains = AppConstants.domains
        .map((d) => DomainModel.fromMap(d))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Par Domaine'),
          const SizedBox(height: 16),
          ...domains.asMap().entries.map((entry) {
            final domain = entry.value;
            final ds = domainStats[domain.id];
            final bestPct = ds != null ? (ds['bestPercent'] as int) : 0;
            final count   = ds != null ? (ds['quizCount'] as int)   : 0;

            return GlassCard(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              borderColor: domain.color.withOpacity(0.3),
              child: Row(
                children: [
                  // Icône domaine
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: domain.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: domain.color.withOpacity(0.3)),
                    ),
                    child: Icon(Icons.memory_rounded,
                        color: domain.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Infos domaine
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(domain.label,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: bestPct / 100,
                          backgroundColor:
                              domain.color.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation(domain.color),
                          minHeight: 4,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Stats
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$bestPct%',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                color: domain.color, fontSize: 16),
                      ),
                      Text('$count quiz',
                          style:
                              Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ],
              ),
            ).animate(
                delay: Duration(
                    milliseconds: 100 + 60 * entry.key));
          }),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  // ── Achievements / Badges ────────────────────────────────
  Widget _buildAchievements(BuildContext context, StatsProvider stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Achievements'),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: stats.achievements.length,
            itemBuilder: (context, index) {
              final achievement = stats.achievements[index];
              return _AchievementCard(achievement: achievement, index: index);
            },
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  // ── Sélection du thème ───────────────────────────────────
  Widget _buildThemeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Thèmes'),
          const SizedBox(height: 16),
          Consumer<AppThemeProvider>(
            builder: (context, themeProvider, _) {
              return Row(
                children: AppThemeProvider.availableThemes.map((theme) {
                  final isSelected =
                      themeProvider.currentThemeId == theme['id'];
                  final color = Color(theme['color'] as int);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => themeProvider.setTheme(theme['id'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : color.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                          color: color.withOpacity(
                              isSelected ? 0.15 : 0.05),
                          boxShadow: isSelected
                              ? AppColors.neonShadow(color, spread: 3)
                              : [],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                boxShadow:
                                    AppColors.neonShadow(color, spread: 2),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              theme['label'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? color
                                        : AppColors.textSecond,
                                    fontSize: 9,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// ACHIEVEMENT CARD - Carte d'un badge/achievement
// ──────────────────────────────────────────────────────────
class _AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final int index;

  const _AchievementCard({required this.achievement, required this.index});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.isUnlocked;
    final color = unlocked ? AppColors.cream : AppColors.textHint;

    return GlassCard(
      borderColor: unlocked
          ? AppColors.cream.withOpacity(0.5)
          : AppColors.sageGreen.withOpacity(0.15),
      backgroundColor: unlocked
          ? AppColors.cream.withOpacity(0.08)
          : AppColors.bgCard,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            unlocked ? Icons.military_tech : Icons.lock_outline,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                        fontSize: 10,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  unlocked ? 'Débloqué' : achievement.description,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 9,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 80 * index)).fadeIn().scale();
  }
}

// Extension pour GlassCard avec margin
extension GlassCardMargin on GlassCard {
  Widget withMargin(EdgeInsetsGeometry margin) {
    return Padding(padding: margin, child: this);
  }
}

// GlassCard avec support margin (version étendue)
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.borderColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.bgCard.withOpacity(0.7),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? AppColors.sageGreen.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.sageGreen.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}
