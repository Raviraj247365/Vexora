import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';

/// Glassmorphism container for premium translucent surfaces.
///
/// The blur and semi-transparent surface create depth without heavy visuals.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const GlassContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(VexoraSpacing.md),
    this.borderRadius = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: VexoraColors.glass,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: VexoraColors.textSecondary.withOpacity(0.12)),
          ),
          child: child,
        ),
      ),
    );
  }
}
