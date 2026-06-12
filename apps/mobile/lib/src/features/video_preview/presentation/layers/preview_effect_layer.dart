import 'package:flutter/material.dart';
import '../../../style_engine/domain/effect_contract.dart';
import 'dart:ui';

class PreviewEffectLayer extends StatelessWidget {
  final Widget child;
  final List<VexoraEffect> activeEffects;
  final double timeMs;

  const PreviewEffectLayer({
    Key? key,
    required this.child,
    required this.activeEffects,
    required this.timeMs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget current = child;

    for (var effect in activeEffects) {
      if (effect.id == 'fx_glow') {
        current = Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.5),
                blurRadius: 20 + (10 * (timeMs % 1000) / 1000), // Pulse effect
                spreadRadius: 5,
              ),
            ],
          ),
          child: current,
        );
      } else if (effect.id == 'fx_shake') {
        final offsetX = (timeMs % 100 < 50) ? 2.0 : -2.0;
        final offsetY = (timeMs % 150 < 75) ? 2.0 : -2.0;
        current = Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: current,
        );
      } else if (effect.id == 'fx_scale') {
        // Beat pulse every 500ms
        final scale = 1.0 + (0.05 * (1.0 - ((timeMs % 500) / 500)));
        current = Transform.scale(
          scale: scale,
          child: current,
        );
      } else if (effect.id == 'fx_blur') {
        current = ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: current,
        );
      }
      // Add implementations for Zoom, Fade, Opacity, Rotation if needed
    }

    return current;
  }
}
