import 'package:flutter/material.dart';
import '../../../style_engine/domain/transition_contract.dart';

class PreviewTransitionLayer extends StatelessWidget {
  final Widget currentClip;
  final Widget? previousClip;
  final VexoraTransition? transition;
  final double transitionProgress; // 0.0 to 1.0

  const PreviewTransitionLayer({
    Key? key,
    required this.currentClip,
    this.previousClip,
    this.transition,
    required this.transitionProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (previousClip == null ||
        transition == null ||
        transitionProgress <= 0.0 ||
        transitionProgress >= 1.0) {
      return currentClip;
    }

    if (transition!.id == 'tr_flash') {
      return Stack(
        fit: StackFit.expand,
        children: [
          currentClip,
          Opacity(
            opacity: 1.0 - transitionProgress,
            child: Container(color: Colors.white),
          ),
        ],
      );
    } else if (transition!.id == 'tr_whip_pan') {
      final offset = 1.0 - transitionProgress;
      return Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: Offset(-offset * MediaQuery.of(context).size.width, 0),
            child: previousClip!,
          ),
          Transform.translate(
            offset: Offset(
                (1.0 - transitionProgress) * MediaQuery.of(context).size.width,
                0),
            child: currentClip,
          ),
        ],
      );
    } else if (transition!.id == 'tr_dissolve') {
      return Stack(
        fit: StackFit.expand,
        children: [
          previousClip!,
          Opacity(
            opacity: transitionProgress,
            child: currentClip,
          ),
        ],
      );
    }

    // Default cut
    return currentClip;
  }
}
