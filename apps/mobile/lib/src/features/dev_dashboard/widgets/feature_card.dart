// feature_card.dart
//
// Glassmorphism feature card for the Vexora Developer Dashboard.
// Shows status badge, summary text, and a "Test →" button.

import 'package:flutter/material.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';

enum FeatureStatus { active, partial, pending }

class FeatureCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final FeatureStatus status;
  final String statusLabel;
  final List<String> stats;
  final VoidCallback onTest;

  const FeatureCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.status,
    required this.statusLabel,
    required this.stats,
    required this.onTest,
  }) : super(key: key);

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _statusColor {
    switch (widget.status) {
      case FeatureStatus.active:
        return VexoraColors.success;
      case FeatureStatus.partial:
        return VexoraColors.warning;
      case FeatureStatus.pending:
        return VexoraColors.textSecondary;
    }
  }

  String get _statusDot {
    switch (widget.status) {
      case FeatureStatus.active:
        return '● ACTIVE';
      case FeatureStatus.partial:
        return '◑ PARTIAL';
      case FeatureStatus.pending:
        return '○ PENDING';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: VexoraColors.surfaceAlt,
              border: Border.all(
                color: _hovered
                    ? widget.accentColor.withOpacity(0.5)
                    : VexoraColors.border,
                width: 1.2,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.accentColor.withOpacity(0.18),
                        blurRadius: 24,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  Text(widget.subtitle,
                      style: VexoraTypography.body(VexoraColors.textSecondary)),
                  const SizedBox(height: 16),
                  _buildStats(),
                  const SizedBox(height: 16),
                  _buildTestButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: widget.accentColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.accentColor.withOpacity(0.3), width: 1),
          ),
          child: Icon(widget.icon, color: widget.accentColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
              const SizedBox(height: 2),
              Text(
                _statusDot,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: _statusColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: widget.stats
          .map((stat) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: widget.accentColor.withOpacity(0.2), width: 1),
                ),
                child: Text(stat,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: widget.accentColor,
                    )),
              ))
          .toList(),
    );
  }

  Widget _buildTestButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.onTest,
        icon: const Icon(Icons.play_arrow_rounded, size: 16),
        label: Text('Open Test Screen',
            style: VexoraTypography.label(Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.accentColor.withOpacity(0.18),
          foregroundColor: widget.accentColor,
          elevation: 0,
          side:
              BorderSide(color: widget.accentColor.withOpacity(0.35), width: 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
