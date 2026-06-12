import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import 'package:vexora_mobile_app/src/design/components/cyber_ui_widgets.dart';

import '../data/preview_controller.dart';
import '../data/mock_styles_repository.dart';
import 'preview_player.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late PreviewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PreviewController();
    // Default style
    _controller.applyStylePack(MockStylesRepository.cyberpunkStyle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: VexoraColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: VexoraColors.textSecondary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Preview Composition',
            style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top: Video Preview
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(VexoraSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VexoraColors.border),
                  boxShadow: [
                    BoxShadow(
                        color: VexoraColors.accent.withOpacity(0.1),
                        blurRadius: 20),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: PreviewPlayer(controller: _controller),
              ),
            ),

            // Middle: Right Panel stats (Active Effects/Transitions) embedded horizontally for mobile
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                final style = _controller.activeStylePack?.style;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: VexoraSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: CyberPanel(
                          title: 'ACTIVE EFFECTS',
                          borderColor: const Color(0xFF00E5FF),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            style?.allowedEffects
                                    .map((e) => e.name)
                                    .join(', ') ??
                                'None',
                            style: const TextStyle(
                                color: Color(0xFF00E5FF), fontSize: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CyberPanel(
                          title: 'ACTIVE TRANSITION',
                          borderColor: const Color(0xFF00E676),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            style?.allowedTransitions
                                    .map((t) => t.name)
                                    .join(', ') ??
                                'Cut',
                            style: const TextStyle(
                                color: Color(0xFF00E676), fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: VexoraSpacing.md),

            // Bottom: Timeline & Controls
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(VexoraSpacing.md),
                color: VexoraColors.surfaceAlt,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListenableBuilder(
                          listenable: _controller,
                          builder: (context, _) {
                            return IconButton(
                              icon: Icon(
                                  _controller.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: VexoraColors.accent,
                                  size: 32),
                              onPressed: () {
                                if (_controller.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: ListenableBuilder(
                            listenable: _controller,
                            builder: (context, _) {
                              return Slider(
                                value: _controller.currentTimeMs,
                                min: 0,
                                max: _controller.totalDurationMs,
                                activeColor: VexoraColors.accent,
                                onChanged: _controller.seek,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: VexoraSpacing.md),

                    Text('Select Style Pack',
                        style:
                            VexoraTypography.label(VexoraColors.textSecondary)),
                    const SizedBox(height: VexoraSpacing.sm),

                    // Style Selector
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: MockStylesRepository.allMocks.map((pack) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ListenableBuilder(
                              listenable: _controller,
                              builder: (context, _) {
                                final isActive =
                                    _controller.activeStylePack?.style.id ==
                                        pack.style.id;
                                return OutlinedButton(
                                  onPressed: () =>
                                      _controller.applyStylePack(pack),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isActive
                                        ? VexoraColors.background
                                        : VexoraColors.textPrimary,
                                    backgroundColor: isActive
                                        ? VexoraColors.accent
                                        : Colors.transparent,
                                    side: BorderSide(
                                        color: isActive
                                            ? VexoraColors.accent
                                            : VexoraColors.border),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  child: Text(pack.style.name),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: CyberButton(
                        label: 'APPLY AI BLUEPRINT',
                        icon: Icons.auto_awesome,
                        glowColor: const Color(0xFF7000FF),
                        onPressed: _controller.applyBlueprint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
