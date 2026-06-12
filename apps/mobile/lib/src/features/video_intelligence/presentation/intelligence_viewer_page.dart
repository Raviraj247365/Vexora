import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import 'package:vexora_mobile_app/src/design/components/cyber_ui_widgets.dart';
import 'package:vexora_mobile_app/src/core/mock/mock_data_generators.dart';

class IntelligenceViewerPage extends StatelessWidget {
  const IntelligenceViewerPage({Key? key}) : super(key: key);

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
        title: Text('Intelligence Viewer',
            style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(VexoraSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Video Intelligence Layer',
                  style: VexoraTypography.heading2(VexoraColors.textPrimary)),
              const SizedBox(height: VexoraSpacing.xs),
              Text('Raw analysis from your imported media.',
                  style: VexoraTypography.body(VexoraColors.textSecondary)),
              const SizedBox(height: VexoraSpacing.xl),
              CyberPanel(
                title: 'SCENE DETECTION',
                borderColor: const Color(0xFF00E5FF),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: VexoraSpacing.md),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF00E5FF).withOpacity(0.3)),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.movie_filter,
                                color: Color(0xFF00E5FF)),
                            const SizedBox(height: 4),
                            Text('Scene ${index + 1}',
                                style: const TextStyle(
                                    color: Color(0xFF00E5FF),
                                    fontSize: 10,
                                    fontFamily: 'Inter')),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: VexoraSpacing.lg),
              CyberPanel(
                title: 'BEAT DETECTION & WAVEFORM',
                borderColor: const Color(0xFF00E676),
                child: SizedBox(
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: MockDataGenerators.generateWaveform(40).map((v) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          height: 80 * v,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676)
                                .withOpacity(v > 0.8 ? 1.0 : 0.3),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(2)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: VexoraSpacing.lg),
              CyberPanel(
                title: 'SPEECH & HIGHLIGHTS',
                borderColor: const Color(0xFF9E54FF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MockDataGenerators.generateTags(5)
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF9E54FF).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFF9E54FF)
                                          .withOpacity(0.4)),
                                ),
                                child: Text(t,
                                    style: const TextStyle(
                                        color: Color(0xFF9E54FF),
                                        fontSize: 11)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: VexoraSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: VexoraColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '"This was the most amazing sunset we\'ve ever seen on this trip..."',
                        style: VexoraTypography.body(VexoraColors.textSecondary)
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: VexoraSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: CyberButton(
                  label: 'CONTINUE TO AI DIRECTOR',
                  icon: Icons.psychology,
                  glowColor: const Color(0xFF7000FF),
                  onPressed: () => context.push('/ai-playground'),
                ),
              ),
              const SizedBox(height: VexoraSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
