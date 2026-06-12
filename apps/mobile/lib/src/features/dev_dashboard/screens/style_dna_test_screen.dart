// style_dna_test_screen.dart

import 'package:flutter/material.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';
import '../demo_data.dart';
import '../widgets/json_viewer.dart';

class StyleDnaTestScreen extends StatefulWidget {
  const StyleDnaTestScreen({Key? key}) : super(key: key);

  @override
  State<StyleDnaTestScreen> createState() => _StyleDnaTestScreenState();
}

class _StyleDnaTestScreenState extends State<StyleDnaTestScreen>
    with TickerProviderStateMixin {
  static const _accent = Color(0xFFFFB547);
  bool _isExtracting = false;
  bool _hasResult = false;
  late AnimationController _rotateCtrl;
  late AnimationController _fillCtrl;
  late List<Animation<double>> _barAnims;

  final List<String> _metricKeys = [
    'energyScore',
    'beatSyncScore',
    'motionIntensity',
    'transitionFrequency',
    'zoomFrequency',
    'captionDensity',
  ];

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fillCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _barAnims = _metricKeys
        .map((_) => CurvedAnimation(parent: _fillCtrl, curve: Curves.easeOut))
        .toList();
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _fillCtrl.dispose();
    super.dispose();
  }

  Future<void> _extractStyleDna() async {
    setState(() {
      _isExtracting = true;
      _hasResult = false;
    });
    _rotateCtrl.repeat();
    await Future.delayed(const Duration(milliseconds: 2000));
    _rotateCtrl.stop();
    _fillCtrl.forward(from: 0);
    if (mounted) {
      setState(() {
        _isExtracting = false;
        _hasResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dna = VexoraDemoData.styleDnaResult;
    final metrics = dna['metrics'] as Map;

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
          const Icon(Icons.auto_awesome_rounded, color: _accent, size: 18),
          const SizedBox(width: 8),
          Text('Style DNA',
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
            _buildHero(dna),
            const SizedBox(height: 24),
            _buildDnaProfileCard(dna),
            const SizedBox(height: 24),
            _buildSectionLabel('Style Metrics'),
            const SizedBox(height: 12),
            _buildMetricBars(metrics),
            const SizedBox(height: 20),
            _buildTagsRow(dna['tags'] as List),
            const SizedBox(height: 24),
            _buildExtractButton(),
            if (_isExtracting) ...[
              const SizedBox(height: 20),
              _buildExtractingState(),
            ],
            if (_hasResult) ...[
              const SizedBox(height: 24),
              _buildSectionLabel('Style DNA JSON Output'),
              const SizedBox(height: 10),
              VexoraJsonViewer(
                json: VexoraDemoData.prettyJson(VexoraDemoData.styleDnaResult),
                maxHeight: 420,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHero(Map dna) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_accent.withOpacity(0.12), VexoraColors.surfaceAlt],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: Row(children: [
        AnimatedBuilder(
          animation: _rotateCtrl,
          builder: (_, child) => Transform.rotate(
            angle: _rotateCtrl.value * 2 * 3.14159,
            child: child,
          ),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _accent.withOpacity(0.4), width: 1.5),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: _accent, size: 26),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(dna['name'] as String,
                style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
            const SizedBox(height: 4),
            Text(
                'Reusable creator editing personality extracted from finished edits',
                style: VexoraTypography.body(VexoraColors.textSecondary)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildDnaProfileCard(Map dna) {
    final props = [
      ['Energy Score', '${dna['energyScore']}', Icons.bolt_rounded],
      ['Pace', dna['pace'].toString(), Icons.speed_rounded],
      ['Avg Cut', '${dna['averageCutInterval']}s', Icons.content_cut_rounded],
      [
        'Transition',
        dna['transitionStyle'].toString(),
        Icons.switch_right_rounded
      ],
      ['Zoom Style', dna['zoomStyle'].toString(), Icons.zoom_in_rounded],
      [
        'Beat Sync',
        dna['beatSync'] == true ? 'ON' : 'OFF',
        Icons.music_note_rounded
      ],
      ['Motion', '${dna['motionIntensity']}', Icons.animation_rounded],
      ['Caption', dna['captionStyle'].toString(), Icons.closed_caption_rounded],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.person_rounded, color: _accent, size: 16),
            const SizedBox(width: 6),
            Text(
                'DNA Profile · ${(dna['styleId'] as String).substring(0, 16)}...',
                style: VexoraTypography.caption(VexoraColors.textSecondary)),
          ]),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
            children: props
                .map((p) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _accent.withOpacity(0.15)),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(p[2] as IconData, color: _accent, size: 14),
                            const SizedBox(height: 4),
                            Text(p[1] as String,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _accent),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                            const SizedBox(height: 2),
                            Text(p[0] as String,
                                style: VexoraTypography.caption(
                                    VexoraColors.textSecondary),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                          ]),
                    ))
                .toList(),
          ),
        ],
      ),
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

  Widget _buildMetricBars(Map metrics) {
    final displayMap = {
      'energyScore': ('Energy Score', metrics['energyScore'] as double, 100.0),
      'beatSyncScore': ('Beat Sync', metrics['beatSyncScore'] as double, 100.0),
      'motionIntensity': (
        'Motion Intensity',
        metrics['motionIntensity'] as double,
        100.0
      ),
      'transitionFrequency': (
        'Transition Freq',
        (metrics['transitionFrequency'] as double) * 100,
        100.0
      ),
      'zoomFrequency': (
        'Zoom Frequency',
        (metrics['zoomFrequency'] as double) * 100,
        100.0
      ),
      'captionDensity': (
        'Caption Density',
        metrics['captionDensity'] as double,
        10.0
      ),
    };

    return Column(
      children: List.generate(_metricKeys.length, (i) {
        final key = _metricKeys[i];
        final entry = displayMap[key]!;
        final value = entry.$2;
        final max = entry.$3;
        final fraction = (value / max).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(entry.$1,
                  style: VexoraTypography.caption(VexoraColors.textSecondary)),
              const Spacer(),
              Text(value.toStringAsFixed(1),
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _accent)),
            ]),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AnimatedBuilder(
                animation: _barAnims[i],
                builder: (_, __) => LinearProgressIndicator(
                  value: _hasResult ? _barAnims[i].value * fraction : fraction,
                  backgroundColor: VexoraColors.border,
                  valueColor: AlwaysStoppedAnimation(_accent.withOpacity(0.8)),
                  minHeight: 6,
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }

  Widget _buildTagsRow(List tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map((t) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withOpacity(0.25)),
                ),
                child: Text(t.toString(),
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: _accent,
                        fontWeight: FontWeight.w500)),
              ))
          .toList(),
    );
  }

  Widget _buildExtractButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isExtracting ? null : _extractStyleDna,
        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
        label: Text(_isExtracting ? 'Extracting DNA...' : 'Extract Style DNA',
            style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: VexoraColors.background,
          disabledBackgroundColor: _accent.withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildExtractingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withOpacity(0.25)),
      ),
      child: Row(children: [
        SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: _accent)),
        const SizedBox(width: 14),
        Text('Analysing editing patterns · building style model...',
            style: VexoraTypography.body(_accent)),
      ]),
    );
  }
}
