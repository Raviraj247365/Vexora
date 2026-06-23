import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

/// Analytics Dashboard — Phase 6 placeholder with premium layout.
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: VexoraColors.background,
            floating: true,
            snap: true,
            elevation: 0,
            leadingWidth: 0,
            leading: const SizedBox.shrink(),
            title: const Text(
              'Analytics',
              style: TextStyle(
                color: VexoraColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(VexoraSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stat cards row
                Row(
                  children: [
                    _StatCard(
                        label: 'Total Views',
                        value: '124.3K',
                        icon: Icons.visibility_outlined,
                        color: VexoraColors.primary),
                    const SizedBox(width: VexoraSpacing.sm),
                    _StatCard(
                        label: 'Projects',
                        value: '18',
                        icon: Icons.folder_outlined,
                        color: VexoraColors.accent),
                  ],
                ),
                const SizedBox(height: VexoraSpacing.sm),
                Row(
                  children: [
                    _StatCard(
                        label: 'Exports',
                        value: '42',
                        icon: Icons.upload_outlined,
                        color: VexoraColors.success),
                    const SizedBox(width: VexoraSpacing.sm),
                    _StatCard(
                        label: 'Style Copies',
                        value: '893',
                        icon: Icons.auto_awesome,
                        color: VexoraColors.warning),
                  ],
                ),
                const SizedBox(height: VexoraSpacing.lg),
                // Chart placeholder
                GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Views this week',
                          style: VexoraTypography.title),
                      const SizedBox(height: VexoraSpacing.md),
                      _MiniChart(),
                    ],
                  ),
                ),
                const SizedBox(height: VexoraSpacing.lg),
                // AI Director performance
                GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Director Performance',
                          style: VexoraTypography.title),
                      const SizedBox(height: VexoraSpacing.md),
                      _PerformanceRow(
                          label: 'Style Accuracy', value: 0.92),
                      _PerformanceRow(
                          label: 'Beat Sync Score', value: 0.78),
                      _PerformanceRow(
                          label: 'Cut Consistency', value: 0.85),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(VexoraSpacing.md),
        decoration: BoxDecoration(
          color: VexoraColors.surfaceElevated,
          borderRadius: VexoraRadius.lgBorder,
          border: Border.all(color: VexoraColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: VexoraRadius.mdBorder,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: VexoraSpacing.sm),
            Text(value,
                style: const TextStyle(
                  color: VexoraColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 2),
            Text(label, style: VexoraTypography.caption),
          ],
        ),
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  final _values = const [0.4, 0.65, 0.5, 0.8, 0.7, 0.9, 0.75];

  const _MiniChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_values.length, (i) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration:
                        Duration(milliseconds: 300 + i * 80),
                    height: 72 * _values[i],
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          VexoraColors.primary,
                          VexoraColors.primary.withOpacity(0.4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  final String label;
  final double value;

  const _PerformanceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: VexoraSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: VexoraTypography.body),
              Text('${(value * 100).round()}%',
                  style: VexoraTypography.bodyStrong.copyWith(
                    color: VexoraColors.primary,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: VexoraRadius.smBorder,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 4,
              backgroundColor: VexoraColors.surface,
              valueColor:
                  const AlwaysStoppedAnimation(VexoraColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
