import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import 'package:vexora_mobile_app/src/design/components/cyber_ui_widgets.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isComplete = true;
          });
        }
      });

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: VexoraColors.textSecondary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(VexoraSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isComplete) ...[
                const Icon(Icons.autorenew,
                    color: VexoraColors.accentSoft, size: 80),
                const SizedBox(height: VexoraSpacing.xl),
                Text('Rendering Project...',
                    style: VexoraTypography.heading2(VexoraColors.textPrimary)),
                const SizedBox(height: VexoraSpacing.md),
                LinearProgressIndicator(
                  value: _progressController.value,
                  backgroundColor: VexoraColors.surfaceAlt,
                  valueColor: const AlwaysStoppedAnimation(VexoraColors.accent),
                  minHeight: 8,
                ),
                const SizedBox(height: VexoraSpacing.sm),
                Text('${(_progressController.value * 100).toInt()}%',
                    style: VexoraTypography.body(VexoraColors.accentSoft)),
              ] else ...[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676).withOpacity(0.1),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF00E676), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E676).withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check,
                      color: Color(0xFF00E676), size: 50),
                ),
                const SizedBox(height: VexoraSpacing.xl),
                Text('Export Complete!',
                    style: VexoraTypography.heading1(VexoraColors.textPrimary)),
                const SizedBox(height: VexoraSpacing.sm),
                Text('Your video has been saved to gallery.',
                    style: VexoraTypography.body(VexoraColors.textSecondary)),
                const SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                      child: CyberButton(
                        label: 'SHARE TO TIKTOK',
                        icon: Icons.share,
                        glowColor: const Color(0xFF00E5FF),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: VexoraSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/home'),
                        child: const Text('BACK TO DASHBOARD'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: VexoraColors.textPrimary,
                          padding: const EdgeInsets.symmetric(
                              vertical: VexoraSpacing.md),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
