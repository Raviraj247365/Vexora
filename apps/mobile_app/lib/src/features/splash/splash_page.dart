import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design/design_system.dart';

/// Simple splash page placeholder.
/// Keep this page lightweight: it should show branding and navigate to onboarding or home.
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: VexoraColors.ambientGradient),
        child: Center(
          child: GlassContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: VexoraSpacing.xl),
                Text('Vexora', style: VexoraTypography.heading1(VexoraColors.accent)),
                const SizedBox(height: VexoraSpacing.sm),
                Text(
                  'Creator-first video design system',
                  textAlign: TextAlign.center,
                  style: VexoraTypography.body(VexoraColors.textSecondary),
                ),
                const SizedBox(height: VexoraSpacing.xl),
                VexoraButton(
                  label: 'Continue',
                  variant: ButtonVariant.primary,
                  onPressed: () => GoRouter.of(context).go('/onboarding'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
