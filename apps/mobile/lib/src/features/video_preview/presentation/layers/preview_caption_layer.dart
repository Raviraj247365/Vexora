import 'package:flutter/material.dart';
import '../../../style_engine/domain/caption_style.dart';

class PreviewCaptionLayer extends StatelessWidget {
  final CaptionStyle? captionStyle;
  final double timeMs;

  const PreviewCaptionLayer({
    Key? key,
    required this.captionStyle,
    required this.timeMs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (captionStyle == null) return const SizedBox.shrink();

    // Mock words showing over time
    final words = ['THIS', 'IS', 'A', 'MOCK', 'CAPTION', 'PREVIEW'];
    final wordIndex = ((timeMs / 1000).floor()) % words.length;
    String text = words[wordIndex];
    if (captionStyle!.uppercase) text = text.toUpperCase();

    // Parse colors safely
    Color primary = Colors.white;
    Color highlight = Colors.cyan;
    try {
      primary = Color(
          int.parse(captionStyle!.primaryColorHex.replaceFirst('#', '0xFF')));
      highlight = Color(
          int.parse(captionStyle!.highlightColorHex.replaceFirst('#', '0xFF')));
    } catch (_) {}

    Widget textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: captionStyle!.fontFamily,
        fontSize: captionStyle!.fontSize,
        fontWeight: FontWeight.bold,
        color: primary,
        shadows: [
          Shadow(color: highlight, blurRadius: 10, offset: const Offset(2, 2)),
        ],
      ),
      textAlign: TextAlign.center,
    );

    if (captionStyle!.animationType == 'pop') {
      final scale = 1.0 + (0.2 * (1.0 - ((timeMs % 1000) / 1000)));
      textWidget = Transform.scale(scale: scale, child: textWidget);
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: textWidget,
      ),
    );
  }
}
