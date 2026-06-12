import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../data/preview_controller.dart';
import 'preview_renderer.dart';

class PreviewPlayer extends StatefulWidget {
  final PreviewController controller;

  const PreviewPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  State<PreviewPlayer> createState() => _PreviewPlayerState();
}

class _PreviewPlayerState extends State<PreviewPlayer>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      // Assuming 60fps, elapsed time isn't perfectly what we want for delta,
      // but we can compute delta easily by storing last elapsed.
      // For simplicity, we'll just add 16.6ms if playing.
      if (widget.controller.isPlaying) {
        widget.controller.updateTime(16.6); // approx 60fps delta
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            PreviewRenderer(controller: widget.controller),
            if (!widget.controller.isPlaying)
              Container(
                color: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.play_circle_fill,
                      color: Colors.white70, size: 64),
                  onPressed: widget.controller.play,
                ),
              ),
          ],
        );
      },
    );
  }
}
