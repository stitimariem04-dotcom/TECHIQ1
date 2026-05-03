// ============================================================
// HOME SCREEN - TECHIQ
// Écran principal avec sélection des domaines informatiques
// Chaque carte représente un domaine, avec animation au survol
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/models.dart';
import '../providers/theme_provider.dart';
import '../services/audio_service.dart';
import '../widgets/shared_widgets.dart';
import 'mode_selection_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _audioService = AudioService();

  // Construit la liste des domaines depuis les constantes
  late final List<DomainModel> _domains = AppConstants.domains
      .map((d) => DomainModel.fromMap(d))
      .toList();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();

    return Scaffold(
      body: GradientBackground(
        gradient: themeProvider.themeGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, themeProvider),
              Expanded(
                child: _buildDomainGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── En-tête de l'écran ──────────────────────────────────
  Widget _buildHeader(BuildContext context, AppThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Logo + Titre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TechIQ',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: themeProvider.primaryColor,
                    shadows: [
                      Shadow(
                        color: themeProvider.primaryColor.withOpacity(0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Choisissez votre domaine',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0),

          // Bouton Profil
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: themeProvider.primaryColor.withOpacity(0.4)),
                color: AppColors.bgCard,
                boxShadow: AppColors.neonShadow(
                    themeProvider.primaryColor, spread: 3),
              ),
              child: Icon(Icons.person_outline,
                  color: themeProvider.primaryColor, size: 22),
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  // ── Grille des domaines ─────────────────────────────────
  Widget _buildDomainGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.88,
      ),
      itemCount: _domains.length,
      itemBuilder: (context, index) {
        return _DomainCard(
          domain: _domains[index],
          index: index,
          onTap: () => _onDomainSelected(context, _domains[index]),
        );
      },
    );
  }

  // ── Navigation vers la sélection de mode ───────────────
  void _onDomainSelected(BuildContext context, DomainModel domain) {
    _audioService.playSelect();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ModeSelectionScreen(domain: domain),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// DOMAIN CARD - Carte individuelle de domaine
// ──────────────────────────────────────────────────────────
class _DomainCard extends StatefulWidget {
  final DomainModel domain;
  final int index;
  final VoidCallback onTap;

  const _DomainCard({
    required this.domain,
    required this.index,
    required this.onTap,
  });

  @override
  State<_DomainCard> createState() => _DomainCardState();
}

class _DomainCardState extends State<_DomainCard> {
  bool _isHovered = false;

  // Icône selon le domaine
  IconData _getDomainIcon(String id) {
    switch (id) {
      case 'iot':          return Icons.wifi_tethering;
      case 'flutter':      return Icons.flutter_dash;
      case 'ai':           return Icons.smart_toy_outlined;
      case 'cybersecurity':return Icons.security;
      case 'web':          return Icons.language;
      case 'python':       return Icons.code;
      case 'linux':        return Icons.terminal;
      default:             return Icons.computer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.domain.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) {
        setState(() => _isHovered = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 0.96 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(_isHovered ? 0.7 : 0.3),
            width: 1.5,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.12),
              AppColors.bgCard.withOpacity(0.8),
            ],
          ),
          boxShadow: _isHovered
              ? AppColors.neonShadow(color, spread: 6)
              : [
                  BoxShadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 10,
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône du domaine
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                  boxShadow: AppColors.neonShadow(color, spread: 2),
                ),
                child: Icon(
                  _getDomainIcon(widget.domain.id),
                  color: color,
                  size: 26,
                ),
              ),

              const Spacer(),

              // Nom du domaine
              Text(
                widget.domain.label,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Sous-titre
              Text(
                widget.domain.subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color.withOpacity(0.8),
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),

              // Bouton "Commencer"
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Text(
                  'Commencer',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 80 * widget.index))
        .fadeIn(duration: 500.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 500.ms,
          curve: Curves.easeOut,
        );
  }
}
