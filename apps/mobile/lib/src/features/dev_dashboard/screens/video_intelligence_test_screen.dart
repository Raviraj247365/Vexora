// video_intelligence_test_screen.dart
//
// Interactive test screen for the Video Intelligence feature.
// Shows demo IntelligenceReport data, triggers mock analysis, and displays JSON output.

import 'package:flutter/material.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';
import '../demo_data.dart';
import '../widgets/json_viewer.dart';

class VideoIntelligenceTestScreen extends StatefulWidget {
  const VideoIntelligenceTestScreen({Key? key}) : super(key: key);

  @override
  State<VideoIntelligenceTestScreen> createState() =>
      _VideoIntelligenceTestScreenState();
}

class _VideoIntelligenceTestScreenState
    extends State<VideoIntelligenceTestScreen> with TickerProviderStateMixin {
  static const _accent = Color(0xFF00E5FF);
  bool _isAnalysing = false;
  bool _hasResult = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _runAnalysis() async {
    setState(() {
      _isAnalysing = true;
      _hasResult = false;
    });
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      setState(() {
        _isAnalysing = false;
        _hasResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = VexoraDemoData.videoIntelligenceReport;
    final scenes = report['scenes'] as List;
    final beats = report['beats'] as List;
    final faces = report['faces'] as List;
    final speech = report['speech'] as List;
    final highlights = report['highlights'] as List;

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.video_settings_rounded, color: _accent, size: 18),
            const SizedBox(width: 8),
            Text('Video Intelligence',
                style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
          ],
        ),
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
            _buildHeroBanner(),
            const SizedBox(height: 24),
            _buildStatRow([
              _Stat('Scenes', '${scenes.length}', Icons.photo_library_rounded),
              _Stat('Beats', '${beats.length}', Icons.music_note_rounded),
              _Stat('Faces', '${faces.length}', Icons.face_rounded),
            ]),
            const SizedBox(height: 12),
            _buildStatRow([
              _Stat('Speech', '${speech.length}', Icons.mic_rounded),
              _Stat('Highlights', '${highlights.length}', Icons.star_rounded),
              _Stat('Video ID', 'demo_001', Icons.fingerprint_rounded),
            ]),
            const SizedBox(height: 24),
            _buildSectionLabel('Scene Detections'),
            const SizedBox(height: 10),
            ...scenes.map((s) => _buildSceneChip(s as Map)).toList(),
            const SizedBox(height: 20),
            _buildSectionLabel('Beat Timeline'),
            const SizedBox(height: 10),
            _buildBeatRow(beats),
            const SizedBox(height: 20),
            _buildSectionLabel('Speech Segments'),
            const SizedBox(height: 10),
            ...speech.map((s) => _buildSpeechChip(s as Map)).toList(),
            const SizedBox(height: 28),
            _buildRunButton(),
            if (_isAnalysing) ...[
              const SizedBox(height: 20),
              _buildAnalysingIndicator(),
            ],
            if (_hasResult) ...[
              const SizedBox(height: 20),
              _buildSectionLabel('Intelligence Report JSON'),
              const SizedBox(height: 10),
              VexoraJsonViewer(
                json: VexoraDemoData.prettyJson(
                    VexoraDemoData.videoIntelligenceReport),
                maxHeight: 380,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accent.withOpacity(0.15),
            VexoraColors.surfaceAlt,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _accent.withOpacity(0.4), width: 1.5),
            ),
            child: const Icon(Icons.video_settings_rounded,
                color: _accent, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Frame-Level Analysis',
                    style:
                        VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
                const SizedBox(height: 4),
                Text(
                    'Scene detection · Beat sync · Face recognition · Speech · Highlights',
                    style: VexoraTypography.body(VexoraColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(List<_Stat> stats) {
    return Row(
      children: stats
          .map((s) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: VexoraColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: VexoraColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(s.icon, color: _accent, size: 18),
                      const SizedBox(height: 6),
                      Text(s.value,
                          style: VexoraTypography.bodyLarge(
                              VexoraColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(s.label,
                          style: VexoraTypography.caption(
                              VexoraColors.textSecondary),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 14,
            color: _accent,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: VexoraTypography.label(VexoraColors.textPrimary)),
      ],
    );
  }

  Widget _buildSceneChip(Map scene) {
    final conf = ((scene['confidence'] as double) * 100).toStringAsFixed(0);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.photo_rounded, color: _accent, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scene['label'] as String,
                    style:
                        VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
                Text('${scene['startMs']}ms → ${scene['endMs']}ms',
                    style:
                        VexoraTypography.caption(VexoraColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$conf%',
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _accent)),
          ),
        ],
      ),
    );
  }

  Widget _buildBeatRow(List beats) {
    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: beats.length,
        itemBuilder: (_, i) {
          final b = beats[i] as Map;
          final strength = b['strength'] as double;
          return Container(
            width: 56,
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 28,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 16,
                      height: 40 * strength,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [_accent, _accent.withOpacity(0.3)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${b['bpm']?.toInt()}',
                    style: VexoraTypography.caption(VexoraColors.textSecondary),
                    textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpeechChip(Map seg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.mic_rounded, color: _accent, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text('"${seg['transcript']}"',
                style: VexoraTypography.body(VexoraColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildRunButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isAnalysing ? null : _runAnalysis,
        icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
        label: Text(_isAnalysing ? 'Analysing...' : 'Run Analysis',
            style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: VexoraColors.background,
          disabledBackgroundColor: _accent.withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildAnalysingIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Opacity(
        opacity: _pulseAnim.value,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child:
                    CircularProgressIndicator(strokeWidth: 2, color: _accent),
              ),
              const SizedBox(width: 14),
              Text('Scanning frames · detecting beats · analysing faces...',
                  style: VexoraTypography.body(_accent)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat {
  final String label;
  final String value;
  final IconData icon;
  const _Stat(this.label, this.value, this.icon);
}
