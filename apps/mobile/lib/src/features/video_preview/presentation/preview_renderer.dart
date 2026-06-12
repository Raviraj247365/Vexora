import 'package:flutter/material.dart';
import '../data/preview_controller.dart';
import 'layers/preview_style_layer.dart';

class PreviewRenderer extends StatelessWidget {
  final PreviewController controller;

  const PreviewRenderer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeMs = controller.currentTimeMs;
    final starts = controller.clipStartTimesMs;

    // Determine current clip index
    int clipIndex = 0;
    for (int i = 0; i < starts.length; i++) {
      if (timeMs >= starts[i]) clipIndex = i;
    }

    // Create mock colored clips
    final colors = [
      Colors.blueGrey[900]!,
      Colors.deepPurple[900]!,
      Colors.teal[900]!
    ];
    final currentClip = Container(
      color: colors[clipIndex % colors.length],
      child: Center(
        child: Text('CLIP ${clipIndex + 1}',
            style: const TextStyle(
                color: Colors.white24,
                fontSize: 40,
                fontWeight: FontWeight.bold)),
      ),
    );

    Widget? previousClip;
    double transitionProgress = 0.0;

    // Simulate a transition if we are in the first 500ms of a new clip (excluding clip 0)
    if (clipIndex > 0) {
      final elapsedInClip = timeMs - starts[clipIndex];
      final transitionDuration =
          controller.activeStylePack?.style.allowedTransitions.isNotEmpty ==
                  true
              ? controller.activeStylePack!.style.allowedTransitions.first
                  .defaultDurationMs
                  .toDouble()
              : 500.0;

      if (elapsedInClip < transitionDuration) {
        previousClip = Container(
          color: colors[(clipIndex - 1) % colors.length],
          child: Center(
            child: Text('CLIP $clipIndex',
                style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
          ),
        );
        transitionProgress = elapsedInClip / transitionDuration;
      }
    }

    return PreviewStyleLayer(
      currentClip: currentClip,
      previousClip: previousClip,
      activeStyle: controller.activeStylePack,
      timeMs: timeMs,
      transitionProgress: transitionProgress,
    );
  }
}
