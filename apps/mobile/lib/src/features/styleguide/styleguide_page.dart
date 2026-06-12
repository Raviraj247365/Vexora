import 'package:flutter/material.dart';
import '../../design/design_system.dart';

/// A demo screen showcasing Vexora's reusable design system components.
///
/// Keep this page as a living playground for buttons, cards, glassmorphism,
/// typography, and motion tokens.
class StyleGuidePage extends StatefulWidget {
  const StyleGuidePage({Key? key}) : super(key: key);

  @override
  State<StyleGuidePage> createState() => _StyleGuidePageState();
}

class _StyleGuidePageState extends State<StyleGuidePage> {
  bool _expanded = false;

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
                Text('Vexora Design System',
                    style: VexoraTypography.heading1(VexoraColors.textPrimary)),
                const SizedBox(height: VexoraSpacing.md),
                Text(
                    'A mobile-first screen to preview tokens and reusable widgets.',
                    style: VexoraTypography.body(VexoraColors.textSecondary)),
                const SizedBox(height: VexoraSpacing.xl),
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buttons',
                          style: VexoraTypography.heading2(
                              VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      Wrap(
                        spacing: VexoraSpacing.sm,
                        runSpacing: VexoraSpacing.sm,
                        children: [
                          VexoraButton(
                              label: 'Primary',
                              onPressed: () {},
                              variant: ButtonVariant.primary),
                          VexoraButton(
                              label: 'Secondary',
                              onPressed: () {},
                              variant: ButtonVariant.secondary),
                          VexoraButton(
                              label: 'Ghost',
                              onPressed: () {},
                              variant: ButtonVariant.ghost),
                        ],
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      Text('Cards',
                          style: VexoraTypography.heading2(
                              VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      VexoraCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Premium card',
                                style: VexoraTypography.bodyLarge(
                                    VexoraColors.textPrimary)),
                            const SizedBox(height: VexoraSpacing.xs),
                            Text(
                                'Cards are elevated containers for key content.',
                                style: VexoraTypography.body(
                                    VexoraColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      Text('Glassmorphism',
                          style: VexoraTypography.heading2(
                              VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      GlassContainer(
                        child: Text(
                            'Translucent surface with blur and border sheen.',
                            style: VexoraTypography.body(
                                VexoraColors.textPrimary)),
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      Text('Motion',
                          style: VexoraTypography.heading2(
                              VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      AnimatedContainer(
                        duration: VexoraAnimation.standard,
                        curve: VexoraAnimation.smooth,
                        padding: EdgeInsets.all(
                            _expanded ? VexoraSpacing.xl : VexoraSpacing.md),
                        decoration: BoxDecoration(
                          color: VexoraColors.surfaceAlt,
                          borderRadius:
                              BorderRadius.circular(_expanded ? 32 : 20),
                          border: Border.all(
                              color: VexoraColors.accent.withOpacity(0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Animated live card',
                                style: VexoraTypography.bodyLarge(
                                    VexoraColors.textPrimary)),
                            const SizedBox(height: VexoraSpacing.sm),
                            Text(
                              'Tap the button below to expand and observe smooth motion tokens in action.',
                              style: VexoraTypography.body(
                                  VexoraColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: VexoraSpacing.sm),
                      VexoraButton(
                        label: _expanded ? 'Contract' : 'Expand',
                        variant: ButtonVariant.secondary,
                        onPressed: () => setState(() => _expanded = !_expanded),
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      Text('Loaders',
                          style: VexoraTypography.heading2(
                              VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      const VexoraLoadingIndicator(
                          message: 'Design system loading...'),
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
