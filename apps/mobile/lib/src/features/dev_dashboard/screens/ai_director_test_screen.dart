// ai_director_test_screen.dart

import 'package:flutter/material.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';
import '../demo_data.dart';
import '../widgets/json_viewer.dart';

class AiDirectorTestScreen extends StatefulWidget {
  const AiDirectorTestScreen({Key? key}) : super(key: key);

  @override
  State<AiDirectorTestScreen> createState() => _AiDirectorTestScreenState();
}

class _AiDirectorTestScreenState extends State<AiDirectorTestScreen>
    with TickerProviderStateMixin {
  static const _accent = Color(0xFF9E54FF);
  bool _isGenerating = false;
  bool _hasResult = false;
  int _currentOpIndex = -1;
  late AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<void> _generateBlueprint() async {
    setState(() {
      _isGenerating = true;
      _hasResult = false;
      _currentOpIndex = -1;
    });

    final ops = VexoraDemoData.editBlueprintResult['operations'] as List;
    for (int i = 0; i < ops.length; i++) {
      await Future.delayed(const Duration(milliseconds: 280));
      if (mounted) setState(() => _currentOpIndex = i);
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _isGenerating = false;
        _hasResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final blueprint = VexoraDemoData.editBlueprintResult;
    final ops = blueprint['operations'] as List;

    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: VexoraColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: _accent, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.movie_filter_rounded, color: _accent, size: 18),
          const SizedBox(width: 8),
          Text('AI Director',
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
            _buildHero(blueprint),
            const SizedBox(height: 24),
            _buildConfidenceBar(blueprint['overallConfidenceScore'] as double),
            const SizedBox(height: 24),
            _buildSectionLabel('Blueprint Operations'),
            const SizedBox(height: 10),
            ...List.generate(ops.length, (i) {
              final op = ops[i] as Map;
              final isVisible =
                  _currentOpIndex >= i || (!_isGenerating && !_hasResult);
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 350),
                opacity: isVisible ? 1.0 : 0.0,
                child: _buildOpCard(op, i),
              );
            }),
            const SizedBox(height: 24),
            _buildGenerateButton(),
            if (_hasResult) ...[
              const SizedBox(height: 24),
              _buildSectionLabel('Blueprint JSON Output'),
              const SizedBox(height: 10),
              VexoraJsonViewer(
                json: VexoraDemoData.prettyJson(
                    VexoraDemoData.editBlueprintResult),
                maxHeight: 400,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHero(Map<String, dynamic> bp) {
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _accent.withOpacity(0.4), width: 1.5),
            ),
            child: const Icon(Icons.movie_filter_rounded,
                color: _accent, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Edit Blueprint Generator',
                  style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
              const SizedBox(height: 4),
              Text('Transforms intent + intelligence into typed operations',
                  style: VexoraTypography.body(VexoraColors.textSecondary)),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          _buildMetaBadge('v${bp['blueprintVersion']}', Icons.tag_rounded),
          const SizedBox(width: 8),
          _buildMetaBadge('${(bp['operations'] as List).length} ops',
              Icons.list_alt_rounded),
          const SizedBox(width: 8),
          _buildMetaBadge(
              'ID: ${(bp['blueprintId'] as String).substring(0, 14)}...',
              Icons.fingerprint_rounded),
        ]),
      ]),
    );
  }

  Widget _buildMetaBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withOpacity(0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: _accent),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: _accent,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _buildConfidenceBar(double score) {
    final pct = (score * 100).toInt();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Overall Confidence',
              style: VexoraTypography.label(VexoraColors.textSecondary)),
          const Spacer(),
          Text('$pct%',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _accent)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score,
            backgroundColor: VexoraColors.border,
            valueColor: AlwaysStoppedAnimation(_accent),
            minHeight: 8,
          ),
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
              color: _accent, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(label, style: VexoraTypography.label(VexoraColors.textPrimary)),
    ]);
  }

  Widget _buildOpCard(Map op, int index) {
    final typeColors = {
      'cut': const Color(0xFFFF3B3B),
      'trim': const Color(0xFFFFB547),
      'transition': const Color(0xFF00E5FF),
      'zoom': const Color(0xFF9E54FF),
      'caption': const Color(0xFF00E676),
      'filter': const Color(0xFFFF6B9D),
      'audioGain': const Color(0xFF7000FF),
    };
    final type = op['type'] as String;
    final color = typeColors[type] ?? _accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text('${index + 1}',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(type.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: color)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(op['targetTrackId']?.toString() ?? 'global',
                    style: VexoraTypography.caption(VexoraColors.textSecondary),
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
            const SizedBox(height: 4),
            Text(_describeOp(op),
                style: VexoraTypography.body(VexoraColors.textSecondary)),
          ]),
        ),
        Text('${((op['confidence'] as double) * 100).toInt()}%',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color)),
      ]),
    );
  }

  String _describeOp(Map op) {
    switch (op['type'] as String) {
      case 'cut':
        return '${op['startMs']}ms → ${op['endMs']}ms';
      case 'trim':
        return 'clip ${op['clipId']} · ${op['newTrimStartMs']}–${op['newTrimEndMs']}ms';
      case 'transition':
        return '${op['transitionType']} · ${op['durationMs']}ms';
      case 'zoom':
        return '${op['zoomFactor']}x · ${op['zoomStartMs']}–${op['zoomEndMs']}ms';
      case 'caption':
        return '"${op['text']}"';
      case 'filter':
        return '${op['filterType']}';
      case 'audioGain':
        return '${op['gainDb']}dB gain';
      default:
        return op['operationId']?.toString() ?? '';
    }
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isGenerating ? null : _generateBlueprint,
        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
        label: Text(
            _isGenerating ? 'Generating Blueprint...' : 'Generate Blueprint',
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
}
