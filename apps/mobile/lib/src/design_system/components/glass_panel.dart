import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';

/// A frosted glass surface panel, inspired by Arc Browser / iOS.
/// Use as the base for cards, panels, and overlays.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? tint;

  const GlassPanel({
    Key? key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderColor,
    this.borderRadius,
    this.blur = 12,
    this.tint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? VexoraRadius.lgBorder,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: (tint ?? VexoraColors.surfaceElevated).withOpacity(0.7),
            borderRadius: borderRadius ?? VexoraRadius.lgBorder,
            border: Border.all(
              color: borderColor ?? VexoraColors.border,
              width: 1,
            ),
          ),
          padding: padding ?? const EdgeInsets.all(VexoraSpacing.md),
          child: child,
        ),
      ),
    );
  }
}
