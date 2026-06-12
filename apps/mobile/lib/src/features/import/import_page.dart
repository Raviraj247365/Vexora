import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import 'package:vexora_mobile_app/src/design/components/cyber_ui_widgets.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({Key? key}) : super(key: key);

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  bool _isImporting = false;

  void _startImport() async {
    setState(() => _isImporting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isImporting = false);
      context.push('/intelligence');
    }
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
        title: Text('Import Media',
            style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(VexoraSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60),
                decoration: BoxDecoration(
                  color: VexoraColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: VexoraColors.accent.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: VexoraColors.accent.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        size: 64, color: VexoraColors.accentSoft),
                    const SizedBox(height: VexoraSpacing.md),
                    Text('Tap to select media',
                        style: VexoraTypography.heading2(
                            VexoraColors.textPrimary)),
                    const SizedBox(height: VexoraSpacing.sm),
                    Text('or drop files here',
                        style:
                            VexoraTypography.body(VexoraColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: VexoraSpacing.xl),
              if (_isImporting)
                Column(
                  children: [
                    const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(VexoraColors.accent)),
                    const SizedBox(height: VexoraSpacing.md),
                    Text('Importing & Analyzing...',
                        style: VexoraTypography.body(VexoraColors.accentSoft)),
                  ],
                )
              else
                CyberButton(
                  label: 'SIMULATE IMPORT',
                  icon: Icons.auto_awesome,
                  onPressed: _startImport,
                ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
