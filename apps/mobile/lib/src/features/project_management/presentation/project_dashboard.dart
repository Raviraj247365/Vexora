import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design_system/design_system.dart';
import '../domain/project_model.dart';
import 'project_management_provider.dart';

/// Project Dashboard — Phase 6C redesign.
/// Premium Notion/Canva-style project library.
class ProjectDashboard extends ConsumerStatefulWidget {
  const ProjectDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends ConsumerState<ProjectDashboard> {
  bool _isGridView = true;
  String _filter = 'All';
  final List<String> _filters = ['All', 'Draft', 'Processing', 'Published'];

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectManagementProvider);

    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            backgroundColor: VexoraColors.background,
            floating: true,
            snap: true,
            elevation: 0,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            title: const Text('Projects',
                style: TextStyle(
                  color: VexoraColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                )),
            actions: [
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_list_outlined : Icons.grid_view,
                  color: VexoraColors.textSecondary,
                ),
                onPressed: () => setState(() => _isGridView = !_isGridView),
              ),
              const SizedBox(width: VexoraSpacing.sm),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _buildFilterBar(),
            ),
          ),
        ],
        body: projectsAsync.when(
          loading: () => _buildSkeletonGrid(),
          error: (e, _) => Center(
            child: Text('Error: $e', style: VexoraTypography.body),
          ),
          data: (projects) {
            final filtered = _filter == 'All'
                ? projects
                : projects
                    .where((p) {
                      final st = _derivedStatus(p.progress);
                      return st.toLowerCase() == _filter.toLowerCase();
                    })
                    .toList();

            if (filtered.isEmpty) {
              return EmptyState(
                icon: Icons.folder_open_outlined,
                title: 'No projects yet',
                subtitle:
                    'Tap the button below to create your first AI-powered video.',
                actionLabel: 'Create Project',
                onAction: () => _createProject(context, ref),
              );
            }

            if (_isGridView) {
              return _buildGrid(context, ref, filtered);
            }
            return _buildList(context, ref, filtered);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createProject(context, ref),
        backgroundColor: VexoraColors.primary,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Project',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: VexoraSpacing.lg, vertical: VexoraSpacing.xs),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: VexoraSpacing.xs),
        itemBuilder: (context, i) {
          final isSelected = _filters[i] == _filter;
          return GestureDetector(
            onTap: () => setState(() => _filter = _filters[i]),
            child: AnimatedContainer(
              duration: VexoraAnimations.fast,
              padding: const EdgeInsets.symmetric(
                  horizontal: VexoraSpacing.md, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? VexoraColors.primary
                    : VexoraColors.surfaceElevated,
                borderRadius: VexoraRadius.xxlBorder,
                border: Border.all(
                  color: isSelected
                      ? VexoraColors.primary
                      : VexoraColors.border,
                ),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : VexoraColors.textSecondary,
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(
      BuildContext context, WidgetRef ref, List<ProjectModel> projects) {
    return GridView.builder(
      padding: const EdgeInsets.all(VexoraSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
        crossAxisSpacing: VexoraSpacing.sm,
        mainAxisSpacing: VexoraSpacing.sm,
        childAspectRatio: 0.82,
      ),
      itemCount: projects.length,
      itemBuilder: (context, i) {
        final p = projects[i];
        return ProjectCard(
          title: p.title,
          duration: '${p.clipCount} clips',
          status: _derivedStatus(p.progress),
          onTap: () => _openProject(context, ref, p),
        );
      },
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<ProjectModel> projects) {
    return ListView.separated(
      padding: const EdgeInsets.all(VexoraSpacing.lg),
      itemCount: projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: VexoraSpacing.sm),
      itemBuilder: (context, i) {
        final p = projects[i];
        return _ProjectListRow(
          project: p,
          onOpen: () => _openProject(context, ref, p),
          onRename: () => _renameProject(context, ref, p),
          onDuplicate: () => _duplicateProject(context, ref, p),
          onDelete: () => _deleteProject(context, ref, p),
        );
      },
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(VexoraSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: VexoraSpacing.sm,
        mainAxisSpacing: VexoraSpacing.sm,
        childAspectRatio: 0.82,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const LoadingSkeleton(height: 200),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────

  String _derivedStatus(double progress) {
    if (progress >= 1.0) return 'Published';
    if (progress >= 0.5) return 'Processing';
    return 'Draft';
  }

  // ─── Actions ────────────────────────────────────────────────────────

  Future<void> _createProject(BuildContext context, WidgetRef ref) async {
    final project =
        await ref.read(projectManagementProvider.notifier).createProject();
    ref.read(activeProjectManagementProvider.notifier).setProject(project);
    if (context.mounted) context.push('/import');
  }

  Future<void> _openProject(
      BuildContext context, WidgetRef ref, ProjectModel project) async {
    await ref
        .read(projectManagementProvider.notifier)
        .openProject(project.id);
    if (context.mounted) context.push('/import');
  }

  Future<void> _renameProject(
      BuildContext context, WidgetRef ref, ProjectModel project) async {
    final controller = TextEditingController(text: project.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VexoraColors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: VexoraRadius.lgBorder),
        title: const Text('Rename project',
            style: TextStyle(
                color: VexoraColors.textPrimary,
                fontWeight: FontWeight.w600)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: VexoraColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Project name',
            hintStyle: TextStyle(color: VexoraColors.textTertiary),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: VexoraColors.textSecondary))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Save',
                  style: TextStyle(color: VexoraColors.primary))),
        ],
      ),
    );
    if (newTitle == null || newTitle.isEmpty || newTitle == project.title) {
      return;
    }
    await ref
        .read(projectManagementProvider.notifier)
        .renameProject(project.id, newTitle);
  }

  Future<void> _duplicateProject(
      BuildContext context, WidgetRef ref, ProjectModel project) async {
    await ref
        .read(projectManagementProvider.notifier)
        .duplicateProject(project.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Duplicated "${project.title}"',
              style: const TextStyle(color: VexoraColors.textPrimary)),
          backgroundColor: VexoraColors.surfaceElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: VexoraRadius.mdBorder),
        ),
      );
    }
  }

  Future<void> _deleteProject(
      BuildContext context, WidgetRef ref, ProjectModel project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VexoraColors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: VexoraRadius.lgBorder),
        title: const Text('Delete project?',
            style: TextStyle(
                color: VexoraColors.textPrimary,
                fontWeight: FontWeight.w600)),
        content: Text(
          '"${project.title}" will be permanently removed.',
          style: const TextStyle(color: VexoraColors.textSecondary),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel',
                  style: TextStyle(color: VexoraColors.textSecondary))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: VexoraColors.error))),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(projectManagementProvider.notifier)
          .deleteProject(project.id);
    }
  }
}

// ─────────────────────────────── List Row ─────────────────────────────────

class _ProjectListRow extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onOpen;
  final VoidCallback onRename;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const _ProjectListRow({
    required this.project,
    required this.onOpen,
    required this.onRename,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  State<_ProjectListRow> createState() => _ProjectListRowState();
}

class _ProjectListRowState extends State<_ProjectListRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onOpen,
        child: AnimatedContainer(
          duration: VexoraAnimations.fast,
          padding: const EdgeInsets.all(VexoraSpacing.md),
          decoration: BoxDecoration(
            color: _hovered
                ? VexoraColors.surfaceHighlight
                : VexoraColors.surfaceElevated,
            borderRadius: VexoraRadius.lgBorder,
            border: Border.all(
              color: _hovered
                  ? VexoraColors.primary.withOpacity(0.3)
                  : VexoraColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: VexoraColors.primary.withOpacity(0.12),
                  borderRadius: VexoraRadius.mdBorder,
                ),
                child: const Icon(Icons.movie_creation_outlined,
                    color: VexoraColors.primary, size: 20),
              ),
              const SizedBox(width: VexoraSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.project.title,
                        style: VexoraTypography.bodyStrong),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.project.clipCount} clips · '
                      '${(widget.project.progress * 100).round()}% complete',
                      style: VexoraTypography.caption,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: VexoraRadius.smBorder,
                      child: LinearProgressIndicator(
                        value: widget.project.progress,
                        minHeight: 3,
                        backgroundColor: VexoraColors.surface,
                        valueColor: const AlwaysStoppedAnimation(
                            VexoraColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: VexoraColors.textTertiary, size: 20),
                color: VexoraColors.surfaceElevated,
                shape: RoundedRectangleBorder(
                    borderRadius: VexoraRadius.lgBorder),
                onSelected: (v) {
                  if (v == 'rename') widget.onRename();
                  if (v == 'duplicate') widget.onDuplicate();
                  if (v == 'delete') widget.onDelete();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 'rename',
                      child: Text('Rename',
                          style:
                              TextStyle(color: VexoraColors.textPrimary))),
                  const PopupMenuItem(
                      value: 'duplicate',
                      child: Text('Duplicate',
                          style:
                              TextStyle(color: VexoraColors.textPrimary))),
                  const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete',
                          style: TextStyle(color: VexoraColors.error))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
