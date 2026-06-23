import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_system.dart';
import '../project_management/presentation/project_management_provider.dart';

/// Premium AI-native Home Dashboard — Phase 6C
/// Replaces the old developer-style home with a Linear/Notion-inspired layout.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: VexoraAnimations.slow,
    );
    _heroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: VexoraAnimations.smoothCurve),
    );
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _heroController, curve: VexoraAnimations.smoothCurve),
    );
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  Future<void> _createProject() async {
    final project =
        await ref.read(projectManagementProvider.notifier).createProject();
    ref.read(activeProjectManagementProvider.notifier).setProject(project);
    if (mounted) context.push('/import');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeroHeader()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: VexoraSpacing.lg, vertical: VexoraSpacing.md),
            sliver: SliverToBoxAdapter(child: _buildQuickActions()),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildSectionHeader(
              'Recent Projects',
              'Continue where you left off',
              onViewAll: () => context.go('/projects'),
            )),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: VexoraSpacing.lg, vertical: VexoraSpacing.sm),
            sliver: SliverToBoxAdapter(child: _buildRecentProjects()),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildSectionHeader(
              'AI Insights',
              'Recommendations from your AI Director',
            )),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: VexoraSpacing.lg, vertical: VexoraSpacing.sm),
            sliver: SliverToBoxAdapter(child: _buildAiInsights()),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildSectionHeader(
              'Trending Styles',
              'Most copied in the last 24 hours',
              onViewAll: () => context.go('/marketplace'),
            )),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: VexoraSpacing.lg, vertical: VexoraSpacing.sm),
            sliver: SliverToBoxAdapter(child: _buildTrendingStyles()),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ─────────────────────────────── Hero ───────────────────────────────

  Widget _buildHeroHeader() {
    return FadeTransition(
      opacity: _heroFade,
      child: SlideTransition(
        position: _heroSlide,
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + VexoraSpacing.lg,
            left: VexoraSpacing.lg,
            right: VexoraSpacing.lg,
            bottom: VexoraSpacing.lg,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                VexoraColors.primary.withOpacity(0.08),
                VexoraColors.background,
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: VexoraTypography.caption.copyWith(
                        color: VexoraColors.primary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your AI Studio',
                      style: VexoraTypography.display,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Create, edit, and publish with AI-powered precision.',
                      style: VexoraTypography.body,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: VexoraSpacing.md),
              // Avatar / status indicator
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [VexoraColors.primary, VexoraColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: VexoraShadows.glowPrimary,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'GOOD MORNING';
    if (hour < 18) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }

  // ─────────────────────────────── Quick Actions ───────────────────────────

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        label: 'New Project',
        icon: Icons.add_circle_outline,
        gradient: [VexoraColors.primary, const Color(0xFF9F7AFF)],
        onTap: _createProject,
      ),
      _QuickAction(
        label: 'Apply Style',
        icon: Icons.auto_awesome,
        gradient: [VexoraColors.accent, const Color(0xFF0099CC)],
        onTap: () => context.push('/ai-playground'),
      ),
      _QuickAction(
        label: 'Analyze Video',
        icon: Icons.analytics_outlined,
        gradient: [VexoraColors.success, const Color(0xFF00B36B)],
        onTap: () => context.push('/intelligence'),
      ),
      _QuickAction(
        label: 'Export',
        icon: Icons.upload_outlined,
        gradient: [VexoraColors.warning, const Color(0xFFE0A030)],
        onTap: () => context.push('/export'),
      ),
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: VexoraSpacing.sm),
            child: _QuickActionTile(action: a),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────── Recent Projects ───────────────────────────

  Widget _buildRecentProjects() {
    final projectsAsync = ref.watch(projectManagementProvider);
    return SizedBox(
      height: 175,
      child: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return EmptyState(
              icon: Icons.video_library_outlined,
              title: 'No projects yet',
              subtitle: 'Start by creating your first AI-powered video.',
              actionLabel: 'Create Project',
              onAction: _createProject,
            );
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: projects.length.clamp(0, 8),
            separatorBuilder: (_, __) =>
                const SizedBox(width: VexoraSpacing.sm),
            itemBuilder: (context, index) {
              final project = projects[index];
              return SizedBox(
                width: 200,
                child: ProjectCard(
                  title: project.title,
                  duration: '—',
                  status: 'Draft',
                  onTap: () async {
                    await ref
                        .read(projectManagementProvider.notifier)
                        .openProject(project.id);
                    if (mounted) context.push('/import');
                  },
                ),
              );
            },
          );
        },
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: VexoraSpacing.sm),
          itemBuilder: (_, __) => const SizedBox(
            width: 200,
            child: LoadingSkeleton(height: 175),
          ),
        ),
        error: (e, _) => Center(
          child: Text('Error loading projects',
              style: VexoraTypography.body),
        ),
      ),
    );
  }

  // ─────────────────────────────── AI Insights ───────────────────────────

  Widget _buildAiInsights() {
    final insights = [
      _Insight(
        icon: Icons.lightbulb_outline,
        title: 'Style DNA Active',
        subtitle: 'Your editing pattern prefers fast cuts (avg 1.2s).',
        color: VexoraColors.primary,
      ),
      _Insight(
        icon: Icons.trending_up,
        title: 'Peak Engagement',
        subtitle: 'Your audience is most active at 7–9 PM.',
        color: VexoraColors.success,
      ),
      _Insight(
        icon: Icons.music_note_outlined,
        title: 'Beat Sync Ready',
        subtitle: 'Import audio to enable automatic beat-sync cuts.',
        color: VexoraColors.accent,
      ),
    ];

    return Column(
      children: insights.map((i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: VexoraSpacing.sm),
          child: GlassPanel(
            padding: const EdgeInsets.all(VexoraSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: i.color.withOpacity(0.12),
                    borderRadius: VexoraRadius.mdBorder,
                  ),
                  child: Icon(i.icon, color: i.color, size: 18),
                ),
                const SizedBox(width: VexoraSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(i.title, style: VexoraTypography.bodyStrong),
                      const SizedBox(height: 2),
                      Text(i.subtitle, style: VexoraTypography.caption),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: VexoraColors.textTertiary, size: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────── Trending Styles ───────────────────────────

  Widget _buildTrendingStyles() {
    final styles = [
      _TrendStyle('Cinematic Dark', '@nova_cuts', 0.9, VexoraColors.primary, 2341),
      _TrendStyle('Lofi Beats', '@chill.ai', 0.45, VexoraColors.accent, 1892),
      _TrendStyle('Energy Rush', '@hyper_edit', 0.85, VexoraColors.warning, 3104),
      _TrendStyle('Minimal White', '@clean.cuts', 0.3, VexoraColors.success, 987),
    ];

    return SizedBox(
      height: 195,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: styles.length,
        separatorBuilder: (_, __) => const SizedBox(width: VexoraSpacing.sm),
        itemBuilder: (context, i) {
          final s = styles[i];
          return SizedBox(
            width: 160,
            child: StyleCard(
              name: s.name,
              creator: s.creator,
              category: 'Trending',
              energy: s.energy,
              copyCount: s.copies,
              accentColor: s.color,
              onTap: () => context.go('/marketplace'),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────── Helpers ───────────────────────────

  Widget _buildSectionHeader(String title, String subtitle,
      {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: VexoraSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: VexoraTypography.title),
                const SizedBox(height: 2),
                Text(subtitle, style: VexoraTypography.caption),
              ],
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'View all',
                style: VexoraTypography.caption.copyWith(
                  color: VexoraColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Quick Action Tile ───────────────────────────

class _QuickAction {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}

class _QuickActionTile extends StatefulWidget {
  final _QuickAction action;
  const _QuickActionTile({required this.action});

  @override
  State<_QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<_QuickActionTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.action.onTap,
        child: AnimatedContainer(
          duration: VexoraAnimations.fast,
          padding: const EdgeInsets.symmetric(
            vertical: VexoraSpacing.md,
            horizontal: VexoraSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _hovered
                ? VexoraColors.surfaceHighlight
                : VexoraColors.surfaceElevated,
            borderRadius: VexoraRadius.lgBorder,
            border: Border.all(
              color: _hovered
                  ? widget.action.gradient[0].withOpacity(0.4)
                  : VexoraColors.border,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.action.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: VexoraRadius.mdBorder,
                ),
                child: Icon(widget.action.icon,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(height: VexoraSpacing.xs + 2),
              Text(
                widget.action.label,
                style: VexoraTypography.caption
                    .copyWith(color: VexoraColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────── Data models ───────────────────────────

class _Insight {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _Insight({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _TrendStyle {
  final String name;
  final String creator;
  final double energy;
  final Color color;
  final int copies;
  const _TrendStyle(
      this.name, this.creator, this.energy, this.color, this.copies);
}
