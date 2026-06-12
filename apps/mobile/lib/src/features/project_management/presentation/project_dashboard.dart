import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design/design_system.dart';
import '../domain/project_model.dart';
import 'project_management_provider.dart';

/// project_dashboard.dart
///
/// Full project library screen: create, rename, delete, duplicate,
/// and open recent projects.
class ProjectDashboard extends ConsumerWidget {
  const ProjectDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectManagementProvider);

    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: VexoraColors.textSecondary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Projects',
            style: VexoraTypography.heading2(VexoraColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: VexoraColors.accent),
            onPressed: () =>
                ref.read(projectManagementProvider.notifier).refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createProject(context, ref),
        backgroundColor: VexoraColors.accent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('New Project',
            style: VexoraTypography.label(Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: VexoraColors.ambientGradient),
        child: projectsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: VexoraColors.accent),
          ),
          error: (err, _) => Center(
            child: Text('Failed to load projects: $err',
                style: VexoraTypography.body(Colors.redAccent)),
          ),
          data: (projects) {
            if (projects.isEmpty) {
              return _EmptyProjects(onCreate: () => _createProject(context, ref));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(VexoraSpacing.lg),
              itemCount: projects.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: VexoraSpacing.sm),
              itemBuilder: (context, index) {
                final project = projects[index];
                return _ProjectListTile(
                  project: project,
                  onOpen: () => _openProject(context, ref, project),
                  onRename: () => _renameProject(context, ref, project),
                  onDuplicate: () => _duplicateProject(context, ref, project),
                  onDelete: () => _deleteProject(context, ref, project),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _createProject(BuildContext context, WidgetRef ref) async {
    final project =
        await ref.read(projectManagementProvider.notifier).createProject();
    ref.read(activeProjectManagementProvider.notifier).setProject(project);
    if (context.mounted) context.push('/import');
  }

  Future<void> _openProject(
    BuildContext context,
    WidgetRef ref,
    ProjectModel project,
  ) async {
    await ref.read(projectManagementProvider.notifier).openProject(project.id);
    if (context.mounted) context.push('/import');
  }

  Future<void> _renameProject(
    BuildContext context,
    WidgetRef ref,
    ProjectModel project,
  ) async {
    final controller = TextEditingController(text: project.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VexoraColors.surface,
        title: Text('Rename project',
            style: VexoraTypography.heading2(VexoraColors.textPrimary)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: VexoraTypography.body(VexoraColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Project name',
            hintStyle: VexoraTypography.body(VexoraColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: VexoraTypography.label(VexoraColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text('Save',
                style: VexoraTypography.label(VexoraColors.accent)),
          ),
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
    BuildContext context,
    WidgetRef ref,
    ProjectModel project,
  ) async {
    await ref
        .read(projectManagementProvider.notifier)
        .duplicateProject(project.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Duplicated "${project.title}"',
              style: VexoraTypography.body(VexoraColors.textPrimary)),
          backgroundColor: VexoraColors.surfaceAlt,
        ),
      );
    }
  }

  Future<void> _deleteProject(
    BuildContext context,
    WidgetRef ref,
    ProjectModel project,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VexoraColors.surface,
        title: Text('Delete project?',
            style: VexoraTypography.heading2(VexoraColors.textPrimary)),
        content: Text(
          '“${project.title}” will be permanently removed.',
          style: VexoraTypography.body(VexoraColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: VexoraTypography.label(VexoraColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: VexoraTypography.label(Colors.redAccent)),
          ),
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

class _EmptyProjects extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyProjects({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VexoraSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_outlined,
                size: 64, color: VexoraColors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: VexoraSpacing.md),
            Text('No projects yet',
                style: VexoraTypography.heading2(VexoraColors.textPrimary)),
            const SizedBox(height: VexoraSpacing.sm),
            Text(
              'Create your first reel to get started.',
              textAlign: TextAlign.center,
              style: VexoraTypography.body(VexoraColors.textSecondary),
            ),
            const SizedBox(height: VexoraSpacing.lg),
            VexoraButton(
              label: 'Create Project',
              onPressed: onCreate,
              variant: ButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectListTile extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onOpen;
  final VoidCallback onRename;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const _ProjectListTile({
    required this.project,
    required this.onOpen,
    required this.onRename,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return VexoraCard(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(VexoraSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: VexoraColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.movie_creation_outlined,
                    color: VexoraColors.accent),
              ),
              const SizedBox(width: VexoraSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title,
                        style: VexoraTypography.bodyLarge(
                            VexoraColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(
                      '${project.assetCount} assets · ${project.clipCount} clips · '
                      '${(project.progress * 100).round()}% complete',
                      style: VexoraTypography.caption(
                          VexoraColors.textSecondary),
                    ),
                    const SizedBox(height: VexoraSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: project.progress,
                        minHeight: 4,
                        backgroundColor: VexoraColors.surfaceAlt,
                        valueColor: const AlwaysStoppedAnimation(
                            VexoraColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: VexoraColors.textSecondary),
                color: VexoraColors.surface,
                onSelected: (value) {
                  switch (value) {
                    case 'rename':
                      onRename();
                    case 'duplicate':
                      onDuplicate();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'rename',
                    child: Text('Rename',
                        style: VexoraTypography.body(
                            VexoraColors.textPrimary)),
                  ),
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Text('Duplicate',
                        style: VexoraTypography.body(
                            VexoraColors.textPrimary)),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete',
                        style: VexoraTypography.body(Colors.redAccent)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
