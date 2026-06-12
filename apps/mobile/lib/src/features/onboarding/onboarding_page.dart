import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design/design_system.dart';

/// Onboarding placeholder screen.
/// Keep onboarding as a small, self-contained feature folder so it can grow independently.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: VexoraColors.ambientGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(VexoraSpacing.lg),
            child: Column(
              children: [
                Text('Welcome to Vexora',
                    style: VexoraTypography.heading1(VexoraColors.textPrimary)),
                const SizedBox(height: VexoraSpacing.md),
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Designed for creators who want sleek, premium video tools.',
                        style:
                            VexoraTypography.body(VexoraColors.textSecondary),
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      const Text(
                        'Future screens will include smart trimming, scene controls, and motion tools.',
                        style: TextStyle(color: VexoraColors.textSecondary),
                      ),
                      const SizedBox(height: VexoraSpacing.xl),
                      VexoraButton(
                        label: 'Get started',
                        variant: ButtonVariant.primary,
                        onPressed: () => GoRouter.of(context).go('/home'),
                      ),
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
