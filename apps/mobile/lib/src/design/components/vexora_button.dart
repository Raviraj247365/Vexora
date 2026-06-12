import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/spacing.dart';

/// Reusable button component for premium Vexora actions.
///
/// This button uses a consistent design token system and supports
/// primary, secondary, and ghost styles.
class VexoraButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final ButtonVariant variant;
  final bool enabled;

  const VexoraButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.variant = ButtonVariant.primary,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (variant == ButtonVariant.primary) {
      return Container(
        decoration: BoxDecoration(
          gradient: enabled ? VexoraColors.brandGradient : null,
          color: enabled ? null : VexoraColors.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: VexoraColors.accent.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: VexoraColors.textPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: enabled ? onPressed : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: VexoraSpacing.sm,
              horizontal: VexoraSpacing.lg,
            ),
            child: Text(label,
                style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
          ),
        ),
      );
    }

    // Default return for secondary and ghost
    return ElevatedButton(
      style: _buildButtonStyle(context, variant),
      onPressed: enabled ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: VexoraSpacing.sm,
          horizontal: VexoraSpacing.lg,
        ),
        child: Text(label,
            style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
      ),
    );
  }

  static ButtonStyle _buildButtonStyle(
      BuildContext context, ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: VexoraColors.surfaceAlt,
          foregroundColor: VexoraColors.textPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        );
      case ButtonVariant.ghost:
        return ElevatedButton.styleFrom(
          backgroundColor: VexoraColors.glass,
          foregroundColor: VexoraColors.accent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          shadowColor: Colors.transparent,
        );
      default:
        return ElevatedButton.styleFrom();
    }
  }
}

enum ButtonVariant { primary, secondary, ghost }
