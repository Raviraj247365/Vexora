import 'package:flutter/material.dart';
import '../../design/design_system.dart';

/// A demo screen showcasing Vexora's reusable design system components.
///
/// Keep this page as a living playground for buttons, cards, glassmorphism,
/// typography, and motion tokens.
class StyleGuidePage extends StatelessWidget {
  const StyleGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design System Preview')),
      body: Container(
        decoration: BoxDecoration(gradient: VexoraColors.ambientGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(VexoraSpacing.lg),
            child: ListView(
              children: [
                Text('Vexora Design System', style: VexoraTypography.heading1(VexoraColors.textPrimary)),
                const SizedBox(height: VexoraSpacing.md),
                Text('A mobile-first screen to preview tokens and reusable widgets.',
                    style: VexoraTypography.body(VexoraColors.textSecondary)),
                const SizedBox(height: VexoraSpacing.xl),
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buttons', style: VexoraTypography.heading2(VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      Wrap(
                        spacing: VexoraSpacing.sm,
                        runSpacing: VexoraSpacing.sm,
                        children: [
                          VexoraButton(label: 'Primary', onPressed: () {}, variant: ButtonVariant.primary),
                          VexoraButton(label: 'Secondary', onPressed: () {}, variant: ButtonVariant.secondary),
                          VexoraButton(label: 'Ghost', onPressed: () {}, variant: ButtonVariant.ghost),
                        ],
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      Text('Cards', style: VexoraTypography.heading2(VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      VexoraCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Premium card', style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
                            const SizedBox(height: VexoraSpacing.xs),
                            Text('Cards are elevated containers for key content.',
                                style: VexoraTypography.body(VexoraColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      Text('Glassmorphism', style: VexoraTypography.heading2(VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      GlassContainer(
                        child: Text('Translucent surface with blur and border sheen.',
                            style: VexoraTypography.body(VexoraColors.textPrimary)),
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      Text('Loaders', style: VexoraTypography.heading2(VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      const VexoraLoadingIndicator(message: 'Design system loading...'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
