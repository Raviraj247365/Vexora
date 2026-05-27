import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design/design_system.dart';
import '../settings/theme_provider.dart';

/// Home screen placeholder. Organize UI by feature and keep this file focused on presentation.
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeCtrl = ref.read(themeModeProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: VexoraColors.ambientGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(VexoraSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Vexora Studio',
                        style: VexoraTypography.heading1(VexoraColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: VexoraSpacing.md),
                    VexoraButton(
                      label: themeMode == ThemeMode.dark ? 'Dark' : 'Light',
                      variant: ButtonVariant.secondary,
                      onPressed: themeCtrl.toggle,
                    ),
                  ],
                ),
                const SizedBox(height: VexoraSpacing.xl),
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Creator home', style: VexoraTypography.heading2(VexoraColors.textPrimary)),
                      const SizedBox(height: VexoraSpacing.sm),
                      Text(
                        'A premium home screen scaffold for future creator workflows.',
                        style: VexoraTypography.body(VexoraColors.textSecondary),
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      VexoraCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Upcoming feature', style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
                            const SizedBox(height: VexoraSpacing.xs),
                            Text(
                              'Video timeline, AI workflows, and project quick actions go here.',
                              style: VexoraTypography.body(VexoraColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: VexoraSpacing.lg),
                      const VexoraLoadingIndicator(message: 'Syncing presets...'),
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
