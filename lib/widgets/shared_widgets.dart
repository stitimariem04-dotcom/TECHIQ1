// ============================================================
// WIDGETS RÉUTILISABLES - TECHIQ
// GlassCard : carte glassmorphism avec effet de verre
// NeonButton : bouton avec effet néon lumineux
// GradientBackground : fond animé de l'application
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';

// ==========================================================
// GLASS CARD - Effet glassmorphism (verre dépoli)
// ==========================================================
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
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
        decoration: BoxDecoration(
          // Fond semi-transparent (effet verre)
          color: backgroundColor ?? AppColors.bgCard.withOpacity(0.7),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? AppColors.sageGreen.withOpacity(0.3),
            width: 1,
          ),
          // Ombre douce pour la profondeur
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

// ==========================================================
// NEON BUTTON - Bouton avec effet lumineux néon
// ==========================================================
class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final double? width;
  final IconData? icon;
  final bool isOutlined;

  const NeonButton({
    super.key,
    required this.label,
    this.onTap,
    this.color,
    this.width,
    this.icon,
    this.isOutlined = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.sageGreen;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          // Fond plein ou transparent selon le style
          color: widget.isOutlined ? Colors.transparent : color.withOpacity(_isPressed ? 0.8 : 1.0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: 1.5),
          // Effet néon : ombre colorée
          boxShadow: _isPressed ? [] : [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 15, spreadRadius: 2),
            BoxShadow(color: color.withOpacity(0.2), blurRadius: 30, spreadRadius: 5),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.isOutlined ? color : AppColors.bgDark, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: widget.isOutlined ? color : AppColors.bgDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// GRADIENT BACKGROUND - Fond animé de l'application
// ==========================================================
class GradientBackground extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;

  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.bgGradient,
      ),
      child: child,
    );
  }
}

// ==========================================================
// STAT MINI - Petite carte de statistique
// ==========================================================
class StatMini extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;

  const StatMini({
    super.key,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.sageGreen;
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(color: c),
        ).animate().fadeIn().scale(),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ==========================================================
// SECTION TITLE - Titre de section avec ligne décorative
// ==========================================================
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.sageGreen,
            borderRadius: BorderRadius.circular(2),
            boxShadow: AppColors.neonShadow(AppColors.sageGreen),
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}
