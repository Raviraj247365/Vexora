import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';

/// Reusable card component for elevated content panels.
///
/// Use this for feature cards, summary panels, or placeholders.
class VexoraCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;

  const VexoraCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(VexoraSpacing.md),
    this.borderRadius = 24,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? VexoraColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: VexoraColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: VexoraColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
