import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design/design_system.dart';
import '../dev_dashboard/dev_dashboard_page.dart';

/// The initial welcome screen for Vexora.
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: VexoraColors.ambientGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glowing V Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: VexoraColors.accent.withOpacity(0.3),
                            blurRadius: 50,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            VexoraColors.brandGradient.createShader(bounds),
                        child: const Text(
                          'V',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'Inter',
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: VexoraSpacing.xl),
                    Text(
                      'VEXORA',
                      style: VexoraTypography.heading1(VexoraColors.textPrimary)
                          .copyWith(letterSpacing: 4),
                    ),
                    const SizedBox(height: VexoraSpacing.sm),
                    Text(
                      'Create. Edit. Inspire.',
                      style: VexoraTypography.bodyLarge(
                          VexoraColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.xl),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: VexoraButton(
                        label: 'Get Started',
                        variant: ButtonVariant.primary,
                        onPressed: () => GoRouter.of(context)
                            .go('/home'), // Route to main app
                      ),
                    ),
                    const SizedBox(height: VexoraSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: VexoraButton(
                        label: 'Continue with Google',
                        variant: ButtonVariant.secondary,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: VexoraSpacing.lg),
                    TextButton(
                      onPressed: () => GoRouter.of(context).go('/home'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Local Project',
                              style: VexoraTypography.body(
                                  VexoraColors.textSecondary)),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right,
                              color: VexoraColors.textSecondary, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: VexoraSpacing.md),
                    // ─── Developer Dashboard quick access ─────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const DevDashboardPage()),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C122C),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: const Color(0xFF7000FF).withOpacity(0.5),
                              width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7000FF).withOpacity(0.2),
                              blurRadius: 16,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.developer_mode_rounded,
                                color: Color(0xFF9E54FF), size: 16),
                            const SizedBox(width: 8),
                            Text('Developer Dashboard',
                                style: VexoraTypography.label(
                                    const Color(0xFF9E54FF))),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                color: Color(0xFF9E54FF), size: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: VexoraSpacing.xl),
              // Footer
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                child: Text(
                  'By continuing, you agree to our\nTerms of Service & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: VexoraTypography.caption(
                      VexoraColors.textSecondary.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: VexoraSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
