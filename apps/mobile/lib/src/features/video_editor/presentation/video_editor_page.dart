import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import 'package:vexora_mobile_app/src/design/components/cyber_ui_widgets.dart';

class VideoEditorPage extends StatelessWidget {
  const VideoEditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine layout
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: VexoraColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close,
              color: VexoraColors.textSecondary, size: 20),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.movie_creation,
                color: VexoraColors.accent, size: 18),
            const SizedBox(width: 8),
            Text('Project: Neon Nights',
                style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Color(0xFF7000FF)),
            onPressed: () {},
            tooltip: 'AI Assistant',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CyberButton(
              label: 'EXPORT',
              glowColor: const Color(0xFF00E676),
              onPressed: () => context.push('/export'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isWide ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Video Preview (Top)
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.play_circle_fill,
                      color: VexoraColors.accentSoft, size: 64),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4)),
                      child: const Text('1080x1920 • 60fps',
                          style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Toolbar
        Container(
          height: 48,
          color: VexoraColors.surfaceAlt,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: const Icon(Icons.undo,
                      size: 18, color: VexoraColors.textSecondary),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.redo,
                      size: 18, color: VexoraColors.textSecondary),
                  onPressed: () {}),
              Container(width: 1, height: 24, color: VexoraColors.border),
              IconButton(
                  icon: const Icon(Icons.content_cut,
                      size: 18, color: VexoraColors.textPrimary),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.copy,
                      size: 18, color: VexoraColors.textPrimary),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 18, color: VexoraColors.textPrimary),
                  onPressed: () {}),
            ],
          ),
        ),

        // Timeline Area (Bottom)
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(VexoraSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('00:00:14:02',
                        style: TextStyle(
                            color: VexoraColors.accentSoft,
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const Icon(Icons.zoom_out_map,
                        color: VexoraColors.textSecondary, size: 16),
                  ],
                ),
                const SizedBox(height: VexoraSpacing.md),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MockTimelineTrack(
                            label: 'V1',
                            color: Color(0xFF00E5FF),
                            itemLength: 4),
                        MockTimelineTrack(
                            label: 'A1',
                            color: Color(0xFF00E676),
                            itemLength: 4),
                        MockTimelineTrack(
                            label: 'T1',
                            color: Color(0xFF9E54FF),
                            itemLength: 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Panel: Layers / Properties
        Container(
          width: 300,
          color: VexoraColors.surfaceAlt,
          padding: const EdgeInsets.all(VexoraSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Properties',
                  style: VexoraTypography.label(VexoraColors.textPrimary)),
              const SizedBox(height: VexoraSpacing.md),
              CyberPanel(
                title: 'TRANSFORM',
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Scale',
                              style: VexoraTypography.caption(
                                  VexoraColors.textSecondary)),
                          Text('100%',
                              style: VexoraTypography.body(
                                  VexoraColors.textPrimary))
                        ]),
                    Slider(
                        value: 1.0,
                        onChanged: (v) {},
                        activeColor: VexoraColors.accent),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Center: Preview & Timeline
        Expanded(
          child: _buildMobileLayout(),
        ),
      ],
    );
  }
}
