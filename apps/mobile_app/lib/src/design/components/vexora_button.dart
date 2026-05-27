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
    final buttonStyle = _buildButtonStyle(context);

    return ElevatedButton(
      style: buttonStyle,
      onPressed: enabled ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: VexoraSpacing.sm,
          horizontal: VexoraSpacing.lg,
        ),
        child: Text(label, style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
      ),
    );
  }

  ButtonStyle _buildButtonStyle(BuildContext context) {
    switch (variant) {
      case ButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: VexoraColors.surfaceAlt,
          foregroundColor: VexoraColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        );
      case ButtonVariant.ghost:
        return ElevatedButton.styleFrom(
          backgroundColor: VexoraColors.glass,
          foregroundColor: VexoraColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          shadowColor: Colors.transparent,
        );
      default:
        return ElevatedButton.styleFrom(
          backgroundColor: VexoraColors.accent,
          foregroundColor: VexoraColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          shadowColor: VexoraColors.shadow,
        );
    }
  }
}

enum ButtonVariant { primary, secondary, ghost }
