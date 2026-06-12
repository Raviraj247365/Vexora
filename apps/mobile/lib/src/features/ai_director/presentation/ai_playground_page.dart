import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import 'package:vexora_mobile_app/src/design/components/cyber_ui_widgets.dart';
import 'package:vexora_mobile_app/src/features/dev_dashboard/demo_data.dart';
import 'package:vexora_mobile_app/src/features/dev_dashboard/widgets/json_viewer.dart';

class AiPlaygroundPage extends StatefulWidget {
  const AiPlaygroundPage({Key? key}) : super(key: key);

  @override
  State<AiPlaygroundPage> createState() => _AiPlaygroundPageState();
}

class _AiPlaygroundPageState extends State<AiPlaygroundPage> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  bool _hasResult = false;

  void _generate() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _hasResult = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _hasResult = true;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

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
        title: Text('AI Director Playground',
            style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(VexoraSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tell the AI what to build',
                  style: VexoraTypography.heading2(VexoraColors.textPrimary)),
              const SizedBox(height: VexoraSpacing.md),

              // Prompt Input
              Container(
                decoration: BoxDecoration(
                  color: VexoraColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: VexoraColors.accent.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: VexoraColors.accent.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promptController,
                        style: VexoraTypography.body(VexoraColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: "Make a high-energy montage...",
                          hintStyle:
                              VexoraTypography.body(VexoraColors.textSecondary),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _generate(),
                      ),
                    ),
                    IconButton(
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                      VexoraColors.accent)))
                          : const Icon(Icons.send, color: VexoraColors.accent),
                      onPressed: _isGenerating ? null : _generate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: VexoraSpacing.xl),

              if (_hasResult) ...[
                CyberPanel(
                  title: 'CREATOR INTENT (Parsed)',
                  borderColor: const Color(0xFF7000FF),
                  child: VexoraJsonViewer(
                    json: VexoraDemoData.prettyJson(
                        VexoraDemoData.creatorIntentResult),
                    maxHeight: 200,
                  ),
                ),
                const SizedBox(height: VexoraSpacing.lg),
                CyberPanel(
                  title: 'AI BLUEPRINT',
                  borderColor: const Color(0xFF9E54FF),
                  child: VexoraJsonViewer(
                    json: VexoraDemoData.prettyJson(
                        VexoraDemoData.editBlueprintResult),
                    maxHeight: 250,
                  ),
                ),
                const SizedBox(height: VexoraSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: CyberButton(
                    label: 'APPLY BLUEPRINT TO TIMELINE',
                    icon: Icons.movie_filter,
                    glowColor: const Color(0xFF00E676),
                    onPressed: () => context.push('/editor'),
                  ),
                ),
                const SizedBox(height: VexoraSpacing.xl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
