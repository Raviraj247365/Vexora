// creator_intent_test_screen.dart

import 'package:flutter/material.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';
import '../demo_data.dart';
import '../widgets/json_viewer.dart';

class CreatorIntentTestScreen extends StatefulWidget {
  const CreatorIntentTestScreen({Key? key}) : super(key: key);

  @override
  State<CreatorIntentTestScreen> createState() =>
      _CreatorIntentTestScreenState();
}

class _CreatorIntentTestScreenState extends State<CreatorIntentTestScreen> {
  static const _accent = Color(0xFF7000FF);
  static const _accentSoft = Color(0xFF9E54FF);

  final TextEditingController _promptCtrl = TextEditingController(
    text:
        'Make this feel like a cinematic travel vlog — fast-paced, energetic, with emotional peaks during the sunset shots.',
  );

  bool _isGenerating = false;
  bool _hasResult = false;
  Map<String, dynamic>? _result;

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  Future<void> _generateIntent() async {
    setState(() {
      _isGenerating = true;
      _hasResult = false;
      _result = null;
    });
    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) {
      setState(() {
        _isGenerating = false;
        _hasResult = true;
        _result = VexoraDemoData.creatorIntentResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: VexoraColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: _accentSoft, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.auto_fix_high_rounded, color: _accentSoft, size: 18),
          const SizedBox(width: 8),
          Text('Creator Intent',
              style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
        ]),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: VexoraColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 24),
            _buildSectionLabel('Prompt Input'),
            const SizedBox(height: 10),
            _buildPromptField(),
            const SizedBox(height: 20),
            _buildExampleChips(),
            const SizedBox(height: 24),
            _buildGenerateButton(),
            if (_isGenerating) ...[
              const SizedBox(height: 20),
              _buildLoadingState(),
            ],
            if (_hasResult && _result != null) ...[
              const SizedBox(height: 24),
              _buildResultCards(_result!),
              const SizedBox(height: 20),
              _buildSectionLabel('Intent JSON Output'),
              const SizedBox(height: 10),
              VexoraJsonViewer(
                json: VexoraDemoData.prettyJson(_result!),
                maxHeight: 360,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_accent.withOpacity(0.15), VexoraColors.surfaceAlt],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(color: _accent.withOpacity(0.4), width: 1.5),
          ),
          child: const Icon(Icons.auto_fix_high_rounded,
              color: _accentSoft, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Natural Language Parsing',
                style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Parses creator prompts into structured intent signals',
                style: VexoraTypography.body(VexoraColors.textSecondary)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(children: [
      Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
              color: _accentSoft, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(label, style: VexoraTypography.label(VexoraColors.textPrimary)),
    ]);
  }

  Widget _buildPromptField() {
    return Container(
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _promptCtrl,
        maxLines: 4,
        style: VexoraTypography.body(VexoraColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Describe the style you want...',
          hintStyle: VexoraTypography.body(VexoraColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildExampleChips() {
    const examples = [
      'Cinematic travel vlog',
      'High-energy sports reel',
      'Calm meditation video',
      'Dramatic documentary',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: examples
          .map((e) => GestureDetector(
                onTap: () => _promptCtrl.text = e,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: _accent.withOpacity(0.25), width: 1),
                  ),
                  child: Text(e,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: _accentSoft,
                          fontWeight: FontWeight.w500)),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isGenerating ? null : _generateIntent,
        icon: const Icon(Icons.psychology_rounded, size: 20),
        label: Text(_isGenerating ? 'Parsing Intent...' : 'Generate Intent',
            style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _accent.withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withOpacity(0.25)),
      ),
      child: Row(children: [
        SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: _accentSoft)),
        const SizedBox(width: 14),
        Text('Parsing natural language · building intent model...',
            style: VexoraTypography.body(_accentSoft)),
      ]),
    );
  }

  Widget _buildResultCards(Map<String, dynamic> result) {
    final signals = result['parsedSignals'] as Map;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionLabel('Parsed Signals'),
      const SizedBox(height: 12),
      _buildSignalGrid(signals),
      const SizedBox(height: 14),
      _buildKeywordsRow(result['keywords'] as List),
    ]);
  }

  Widget _buildSignalGrid(Map signals) {
    final items = [
      ['Pace', signals['paceTarget'].toString()],
      ['Energy', '${((signals['energyLevel'] as double) * 100).toInt()}%'],
      ['Arc', signals['emotionalArc'].toString()],
      ['Color', signals['colorGrade'].toString()],
      [
        'Beat Sync',
        '${((signals['beatSyncStrength'] as double) * 100).toInt()}%'
      ],
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.4,
      children: items
          .map((item) => Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: VexoraColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _accent.withOpacity(0.2)),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item[1],
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _accentSoft),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text(item[0],
                          style: VexoraTypography.caption(
                              VexoraColors.textSecondary),
                          textAlign: TextAlign.center),
                    ]),
              ))
          .toList(),
    );
  }

  Widget _buildKeywordsRow(List keywords) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: keywords
          .map((k) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: VexoraColors.success.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: VexoraColors.success.withOpacity(0.25)),
                ),
                child: Text('#${k.toString()}',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: VexoraColors.success,
                        fontWeight: FontWeight.w500)),
              ))
          .toList(),
    );
  }
}
