import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design/design_system.dart';
import '../dev_dashboard/dev_dashboard_page.dart';
import '../project_management/presentation/project_management_provider.dart';
import 'home_models.dart';
import 'home_widgets.dart';

/// Home screen for the Vexora creator experience.
///
/// This screen uses mock data only and is built with reusable feature widgets.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 720;

    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: Container(
        decoration: BoxDecoration(gradient: VexoraColors.ambientGradient),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: VexoraSpacing.lg, vertical: VexoraSpacing.md),
                sliver: SliverToBoxAdapter(child: _buildTopSection()),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(
                    child: const SizedBox(height: VexoraSpacing.lg)),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(child: _buildQuickAiSection()),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(
                    child: const SizedBox(height: VexoraSpacing.lg)),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(child: _buildProjectsSection()),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(
                    child: const SizedBox(height: VexoraSpacing.lg)),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(child: _buildTemplatesSection()),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(
                    child: const SizedBox(height: VexoraSpacing.lg)),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(child: _buildAiToolsSection(isWide)),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(
                    child: const SizedBox(height: VexoraSpacing.lg)),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VexoraSpacing.lg),
                sliver: SliverToBoxAdapter(child: _buildCommunitySection()),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 120)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: _selectedIndex,
        onChanged: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Future<void> _createProject() async {
    final project =
        await ref.read(projectManagementProvider.notifier).createProject();
    ref.read(activeProjectManagementProvider.notifier).setProject(project);
    if (mounted) context.push('/import');
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Developer Dashboard entry ─────────────────────────────────
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DevDashboardPage()),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(bottom: VexoraSpacing.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF1C122C), Color(0xFF12121A)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: Color(0xFF7000FF).withOpacity(0.5), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF7000FF).withOpacity(0.18),
                  blurRadius: 18,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Color(0xFF7000FF).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Color(0xFF7000FF).withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.developer_mode_rounded,
                      color: Color(0xFF9E54FF), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Developer Dashboard',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      Text('Visual Verification · All Features · Live Demo',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Color(0xFF9E9EA7))),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF9E54FF), size: 14),
              ],
            ),
          ),
        ),
        // ─── Original top section ──────────────────────────────────────
        Text('Good evening, creator',
            style: VexoraTypography.heading1(VexoraColors.textPrimary)),
        const SizedBox(height: VexoraSpacing.xs),
        Text(
          'Your studio is ready. Start a new reel or continue a project.',
          style: VexoraTypography.body(VexoraColors.textSecondary),
        ),
        const SizedBox(height: VexoraSpacing.lg),
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick create',
                  style: VexoraTypography.heading2(VexoraColors.textPrimary)),
              const SizedBox(height: VexoraSpacing.sm),
              Text('Jump into a new reel with one tap.',
                  style: VexoraTypography.body(VexoraColors.textSecondary)),
              const SizedBox(height: VexoraSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: VexoraButton(
                      label: 'Create Reel',
                      onPressed: _createProject,
                      variant: ButtonVariant.primary,
                    ),
                  ),
                  const SizedBox(width: VexoraSpacing.md),
                  Expanded(
                    child: VexoraButton(
                      label: 'Preview Engine',
                      onPressed: () => context.push('/preview'),
                      variant: ButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(width: VexoraSpacing.sm),
                  VexoraButton(
                    label: 'Explore Templates',
                    onPressed: () {},
                    variant: ButtonVariant.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(
            title: 'Quick AI', subtitle: 'Describe what you want to create'),
        const SizedBox(height: VexoraSpacing.md),
        const HomePromptBar(),
      ],
    );
  }

  Widget _buildProjectsSection() {
    final projectsAsync = ref.watch(projectManagementProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(
          title: 'Recent projects',
          subtitle: 'Continue where you left off',
          onViewAll: () => context.push('/projects'),
        ),
        const SizedBox(height: VexoraSpacing.md),
        SizedBox(
          height: 190,
          child: projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return Center(
                  child: Text('No recent projects. Create one!',
                      style: VexoraTypography.body(VexoraColors.textSecondary)),
                );
              }
              final recent = projects.take(8).toList();
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: recent.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: VexoraSpacing.sm),
                itemBuilder: (context, index) {
                  final project = recent[index];
                  return SizedBox(
                    width: 260,
                    child: HomeProjectCard(
                      project: project,
                      onTap: () async {
                        await ref
                            .read(projectManagementProvider.notifier)
                            .openProject(project.id);
                        if (context.mounted) context.push('/import');
                      },
                      onDelete: () {
                        ref
                            .read(projectManagementProvider.notifier)
                            .deleteProject(project.id);
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
                child: CircularProgressIndicator(color: VexoraColors.accent)),
            error: (err, stack) => Center(
                child: Text('Error: $err',
                    style: const TextStyle(color: Colors.red))),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(
            title: 'Trending templates',
            subtitle: 'Launch your next reel fast'),
        const SizedBox(height: VexoraSpacing.md),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: mockTemplates.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: VexoraSpacing.sm),
            itemBuilder: (context, index) =>
                HomeTemplateCard(template: mockTemplates[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildAiToolsSection(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(
            title: 'AI tools', subtitle: 'Creator tools powered by mock logic'),
        const SizedBox(height: VexoraSpacing.md),
        GridView.builder(
          itemCount: mockAiTools.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 3 : 1,
            crossAxisSpacing: VexoraSpacing.md,
            mainAxisSpacing: VexoraSpacing.md,
            childAspectRatio: isWide ? 3.2 : 2.8,
          ),
          itemBuilder: (context, index) =>
              HomeAiToolCard(tool: mockAiTools[index]),
        ),
      ],
    );
  }

  Widget _buildCommunitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(
            title: 'Community spotlight',
            subtitle: 'Trending edits by Vexora creators'),
        const SizedBox(height: VexoraSpacing.md),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, __) =>
                const SizedBox(width: VexoraSpacing.sm),
            itemBuilder: (context, index) {
              final titles = [
                'Cyberpunk Vibes',
                'Travel Vlog',
                'Fitness Promo'
              ];
              final creators = ['@neon_ninja', '@wanderlust', '@fit_guru'];
              return Container(
                width: 160,
                decoration: BoxDecoration(
                  color: VexoraColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VexoraColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: VexoraColors.accent.withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      child: const Center(
                          child: Icon(Icons.play_circle_fill,
                              color: VexoraColors.accentSoft, size: 40)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(titles[index],
                              style: VexoraTypography.body(
                                  VexoraColors.textPrimary)),
                          Text(creators[index],
                              style: VexoraTypography.caption(
                                  VexoraColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
