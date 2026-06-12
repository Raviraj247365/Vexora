// pipeline_flow.dart
//
// Visual pipeline flow widget showing the complete Vexora AI processing chain.
// Video Intelligence → Creator Intent → AI Director → Timeline Engine → Style DNA

import 'package:flutter/material.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';

class PipelineFlowWidget extends StatelessWidget {
  final int activeStep; // 0-4, -1 for none

  const PipelineFlowWidget({Key? key, this.activeStep = -1}) : super(key: key);

  static const List<_PipelineStep> _steps = [
    _PipelineStep(
      label: 'Video Intelligence',
      icon: Icons.video_settings_rounded,
      color: Color(0xFF00E5FF),
    ),
    _PipelineStep(
      label: 'Creator Intent',
      icon: Icons.auto_fix_high_rounded,
      color: Color(0xFF7000FF),
    ),
    _PipelineStep(
      label: 'AI Director',
      icon: Icons.movie_filter_rounded,
      color: Color(0xFF9E54FF),
    ),
    _PipelineStep(
      label: 'Timeline Engine',
      icon: Icons.timeline_rounded,
      color: Color(0xFF00E676),
    ),
    _PipelineStep(
      label: 'Style DNA',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFFFFB547),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12121A), Color(0xFF0A0A0E)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_tree_rounded,
                  color: Color(0xFF9E54FF), size: 16),
              const SizedBox(width: 8),
              Text('AI Pipeline Flow',
                  style: VexoraTypography.label(VexoraColors.textPrimary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: VexoraColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: VexoraColors.success.withOpacity(0.3)),
                ),
                child: Text('5 STAGES',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: VexoraColors.success,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._buildSteps(),
        ],
      ),
    );
  }

  List<Widget> _buildSteps() {
    final widgets = <Widget>[];
    for (int i = 0; i < _steps.length; i++) {
      final step = _steps[i];
      final isActive = i == activeStep;
      final isCompleted = i < activeStep;

      widgets.add(_StepTile(
        step: step,
        index: i,
        isActive: isActive,
        isCompleted: isCompleted,
      ));

      if (i < _steps.length - 1) {
        widgets.add(_buildConnector(step.color, isCompleted));
      }
    }
    return widgets;
  }

  Widget _buildConnector(Color color, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: 2,
        height: 28,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isCompleted
                ? [color, color.withOpacity(0.4)]
                : [VexoraColors.border, VexoraColors.border],
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final _PipelineStep step;
  final int index;
  final bool isActive;
  final bool isCompleted;

  const _StepTile({
    required this.step,
    required this.index,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? step.color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? step.color.withOpacity(0.4) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? step.color.withOpacity(0.2)
                  : isActive
                      ? step.color.withOpacity(0.15)
                      : VexoraColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isCompleted || isActive ? step.color : VexoraColors.border,
                width: 1.5,
              ),
            ),
            child: isCompleted
                ? Icon(Icons.check_rounded, color: step.color, size: 18)
                : Icon(step.icon,
                    color: isActive ? step.color : VexoraColors.textSecondary,
                    size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              step.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? step.color
                    : isCompleted
                        ? VexoraColors.textPrimary
                        : VexoraColors.textSecondary,
              ),
            ),
          ),
          if (isActive)
            _PulsingDot(color: step.color)
          else if (isCompleted)
            Text('Done',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: step.color,
                )),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _PipelineStep {
  final String label;
  final IconData icon;
  final Color color;

  const _PipelineStep({
    required this.label,
    required this.icon,
    required this.color,
  });
}
