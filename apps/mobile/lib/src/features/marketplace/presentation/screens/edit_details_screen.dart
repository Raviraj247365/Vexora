import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import 'package:vexora_mobile_app/src/design/components/cyber_ui_widgets.dart';
import '../../domain/marketplace_models.dart';

class EditDetailsScreen extends StatelessWidget {
  final MarketplaceItem item;

  const EditDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color thumbColor = Colors.grey;
    try {
      thumbColor =
          Color(int.parse(item.thumbnailColorHex.replaceFirst('#', '0xFF')));
    } catch (_) {}

    final style = item.dna.stylePack.style;

    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: VexoraColors.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [thumbColor.withOpacity(0.5), Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_outline,
                      size: 80, color: Colors.white54),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(VexoraSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Title and Creator
                Text(style.name, style: VexoraTypography.h2(Colors.white)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () =>
                      context.push('/marketplace/creator', extra: item.creator),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(int.parse(
                            item.creator.avatarUrl.replaceFirst('#', '0xFF'))),
                      ),
                      const SizedBox(width: 8),
                      Text(item.creator.username,
                          style: VexoraTypography.bodyLarge(Colors.white70)),
                      if (item.creator.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            color: Colors.blue, size: 16),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('USES', _formatNumber(item.metrics.uses)),
                    _buildStatColumn(
                        'SAVES', _formatNumber(item.metrics.saves)),
                    _buildStatColumn(
                        'VIEWS', _formatNumber(item.metrics.views)),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: VexoraColors.border),
                const SizedBox(height: 24),

                // DNA Breakdown
                Text('Edit DNA Breakdown',
                    style: VexoraTypography.h3(Colors.white)),
                const SizedBox(height: 16),

                CyberPanel(
                  title: 'EFFECTS',
                  borderColor: const Color(0xFF00E5FF),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    style.allowedEffects.isEmpty
                        ? 'None'
                        : style.allowedEffects.map((e) => e.name).join(', '),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                CyberPanel(
                  title: 'TRANSITIONS',
                  borderColor: const Color(0xFF00E676),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    style.allowedTransitions.isEmpty
                        ? 'Cut'
                        : style.allowedTransitions
                            .map((t) => t.name)
                            .join(', '),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                CyberPanel(
                  title: 'CAPTION STYLE',
                  borderColor: const Color(0xFFFF0055),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${style.defaultCaptionStyle.name} (${style.defaultCaptionStyle.fontFamily})',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                CyberPanel(
                  title: 'PACING',
                  borderColor: const Color(0xFFFFD700),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${style.pacingRules.cutsPerMinute} cuts/min',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 40),

                // Action Button
                CyberButton(
                  label: 'USE EDIT DNA',
                  icon: Icons.auto_awesome,
                  glowColor: thumbColor,
                  onPressed: () {
                    // Navigate to preview and show mock success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Applying ${style.name} to your footage...')),
                    );
                    context.push('/preview');
                  },
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}k';
    return number.toString();
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: VexoraTypography.h3(Colors.white)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
