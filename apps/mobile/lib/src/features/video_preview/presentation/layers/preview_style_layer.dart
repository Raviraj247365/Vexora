import 'package:flutter/material.dart';
import '../../../style_engine/domain/style_pack.dart';
import 'preview_effect_layer.dart';
import 'preview_transition_layer.dart';
import 'preview_caption_layer.dart';

class PreviewStyleLayer extends StatelessWidget {
  final Widget currentClip;
  final Widget? previousClip;
  final StylePack? activeStyle;
  final double timeMs;
  final double transitionProgress;

  const PreviewStyleLayer({
    Key? key,
    required this.currentClip,
    this.previousClip,
    this.activeStyle,
    required this.timeMs,
    required this.transitionProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activeStyle == null) {
      return Stack(
        fit: StackFit.expand,
        children: [currentClip],
      );
    }

    final editStyle = activeStyle!.style;

    Widget layer = currentClip;

    // 1. Apply Transition if active
    if (transitionProgress > 0 && editStyle.allowedTransitions.isNotEmpty) {
      layer = PreviewTransitionLayer(
        currentClip: currentClip,
        previousClip: previousClip,
        transition: editStyle.allowedTransitions.first,
        transitionProgress: transitionProgress,
      );
    }

    // 2. Apply Effects
    layer = PreviewEffectLayer(
      child: layer,
      activeEffects: editStyle.allowedEffects,
      timeMs: timeMs,
    );

    // 3. Overlay Captions
    return Stack(
      fit: StackFit.expand,
      children: [
        layer,
        PreviewCaptionLayer(
          captionStyle: editStyle.defaultCaptionStyle,
          timeMs: timeMs,
        ),
      ],
    );
  }
}
