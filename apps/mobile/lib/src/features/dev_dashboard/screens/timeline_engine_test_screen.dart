// timeline_engine_test_screen.dart

import 'package:flutter/material.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';
import '../demo_data.dart';
import '../widgets/json_viewer.dart';

class TimelineEngineTestScreen extends StatefulWidget {
  const TimelineEngineTestScreen({Key? key}) : super(key: key);

  @override
  State<TimelineEngineTestScreen> createState() =>
      _TimelineEngineTestScreenState();
}

class _TimelineEngineTestScreenState extends State<TimelineEngineTestScreen>
    with SingleTickerProviderStateMixin {
  static const _accent = Color(0xFF00E676);
  bool _isExecuting = false;
  bool _hasResult = false;
  late AnimationController _progressCtrl;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _progressAnim =
        CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  Future<void> _executeTimeline() async {
    setState(() {
      _isExecuting = true;
      _hasResult = false;
    });
    _progressCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 1900));
    if (mounted) {
      setState(() {
        _isExecuting = false;
        _hasResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = VexoraDemoData.timelineEngineResult;
    final timeline = result['timeline'] as Map;
    final tracks = timeline['tracks'] as List;

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
          const Icon(Icons.timeline_rounded, color: _accent, size: 18),
          const SizedBox(width: 8),
          Text('Timeline Engine',
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
            _buildHero(result),
            const SizedBox(height: 24),
            _buildExecutionStats(result),
            const SizedBox(height: 24),
            _buildSectionLabel('Visual Timeline'),
            const SizedBox(height: 12),
            _buildTimeline(tracks, timeline['totalDurationMs'] as int),
            const SizedBox(height: 24),
            _buildValidation(result['validationResult'] as Map),
            const SizedBox(height: 24),
            _buildExecuteButton(),
            if (_isExecuting) ...[
              const SizedBox(height: 20),
              _buildProgressBar(),
            ],
            if (_hasResult) ...[
              const SizedBox(height: 24),
              _buildSectionLabel('Execution Result JSON'),
              const SizedBox(height: 10),
              VexoraJsonViewer(
                json: VexoraDemoData.prettyJson(
                    VexoraDemoData.timelineEngineResult),
                maxHeight: 400,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHero(Map result) {
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
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: _accent.withOpacity(0.4), width: 1.5),
          ),
          child: const Icon(Icons.timeline_rounded, color: _accent, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Blueprint Execution Engine',
                style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
            const SizedBox(height: 4),
            Text(
                'Applies typed operations to the project timeline in ${result['executionTimeMs']}ms',
                style: VexoraTypography.body(VexoraColors.textSecondary)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildExecutionStats(Map result) {
    final stats = [
      ['Total Ops', '${result['totalOperations']}', Icons.list_rounded],
      ['Applied', '${result['appliedOperations']}', Icons.check_circle_rounded],
      ['Failed', '${result['failedOperations']}', Icons.error_rounded],
      ['Time', '${result['executionTimeMs']}ms', Icons.timer_rounded],
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: stats.map((s) {
        final color = s[0] == 'Failed'
            ? (s[1] == '0' ? _accent : VexoraColors.error)
            : _accent;
        return Container(
          decoration: BoxDecoration(
            color: VexoraColors.surfaceAlt,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(s[2] as IconData, color: color, size: 18),
            const SizedBox(height: 6),
            Text(s[1] as String,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color)),
            const SizedBox(height: 2),
            Text(s[0] as String,
                style: VexoraTypography.caption(VexoraColors.textSecondary),
                textAlign: TextAlign.center),
          ]),
        );
      }).toList(),
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

  Widget _buildTimeline(List tracks, int totalMs) {
    const trackColors = [
      Color(0xFF00E5FF),
      Color(0xFF9E54FF),
      Color(0xFFFFB547),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Column(
        children: List.generate(tracks.length, (ti) {
          final track = tracks[ti] as Map;
          final clips = track['clips'] as List;
          final color = trackColors[ti % trackColors.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                width: 60,
                child: Text((track['type'] as String).toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: color)),
              ),
              Expanded(
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: VexoraColors.surface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Stack(
                    children: clips.map<Widget>((clip) {
                      final cMap = clip as Map;
                      final start = cMap['startMs'] as int;
                      final end = cMap.containsKey('endMs')
                          ? cMap['endMs'] as int
                          : totalMs;
                      final left = start / totalMs;
                      final width = (end - start) / totalMs;
                      return Positioned(
                        left: left * double.infinity,
                        top: 2,
                        bottom: 2,
                        child: FractionallySizedBox(
                          widthFactor: width,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: color.withOpacity(0.6)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ]),
          );
        }),
      ),
    );
  }

  Widget _buildValidation(Map validation) {
    final isValid = validation['isValid'] as bool;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isValid
            ? _accent.withOpacity(0.06)
            : VexoraColors.error.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isValid
                ? _accent.withOpacity(0.3)
                : VexoraColors.error.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(isValid ? Icons.verified_rounded : Icons.warning_rounded,
            color: isValid ? _accent : VexoraColors.error, size: 22),
        const SizedBox(width: 12),
        Text(
            isValid
                ? 'Timeline validation passed — no errors or warnings'
                : 'Validation issues detected',
            style: VexoraTypography.bodyLarge(
                isValid ? _accent : VexoraColors.error)),
      ]),
    );
  }

  Widget _buildExecuteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isExecuting ? null : _executeTimeline,
        icon: const Icon(Icons.play_circle_filled_rounded, size: 20),
        label: Text(_isExecuting ? 'Executing...' : 'Run Timeline Execution',
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

  Widget _buildProgressBar() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: _accent)),
        const SizedBox(width: 12),
        Text('Applying 7 operations to timeline...',
            style: VexoraTypography.body(_accent)),
      ]),
      const SizedBox(height: 10),
      AnimatedBuilder(
        animation: _progressAnim,
        builder: (_, __) => ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progressAnim.value,
            backgroundColor: VexoraColors.border,
            valueColor: AlwaysStoppedAnimation(_accent),
            minHeight: 6,
          ),
        ),
      ),
    ]);
  }
}
