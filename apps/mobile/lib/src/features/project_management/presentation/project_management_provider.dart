import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../project_schema/project_schema.dart';
import '../data/project_persistence.dart';
import '../data/project_repository.dart';
import '../domain/project_model.dart';

final projectPersistenceProvider = Provider<ProjectPersistence>((ref) {
  return FileProjectPersistence();
});

final projectManagementRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(persistence: ref.watch(projectPersistenceProvider));
});

/// Manages the project library with auto-save for the active project.
class ProjectManagementNotifier extends AsyncNotifier<List<ProjectModel>> {
  Timer? _autoSaveTimer;
  static const _autoSaveDelay = Duration(seconds: 2);

  @override
  Future<List<ProjectModel>> build() async {
    ref.onDispose(() => _autoSaveTimer?.cancel());
    return ref.read(projectManagementRepositoryProvider).getAllProjects();
  }

  ProjectRepository get _repo => ref.read(projectManagementRepositoryProvider);

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repo.getAllProjects);
  }

  Future<ProjectModel> createProject({String title = 'New Vexora Project'}) async {
    final project = await _repo.createProject(title: title);
    await refresh();
    return project;
  }

  Future<ProjectModel> renameProject(String projectId, String newTitle) async {
    final project = await _repo.renameProject(projectId, newTitle);
    await refresh();
    _syncActiveProject(project);
    return project;
  }

  Future<void> deleteProject(String projectId) async {
    await _repo.deleteProject(projectId);
    final active = ref.read(activeProjectManagementProvider);
    if (active?.id == projectId) {
      ref.read(activeProjectManagementProvider.notifier).closeProject();
    }
    await refresh();
  }

  Future<ProjectModel> duplicateProject(String projectId) async {
    final project = await _repo.duplicateProject(projectId);
    await refresh();
    return project;
  }

  Future<ProjectModel> openProject(String projectId) async {
    final project = await _repo.touchProject(projectId);
    ref.read(activeProjectManagementProvider.notifier).setProject(project);
    await refresh();
    return project;
  }

  /// Persists immediately (used by explicit save actions).
  Future<ProjectModel> saveProject(ProjectModel project) async {
    final saved = await _repo.saveProject(project);
    await refresh();
    _syncActiveProject(saved);
    return saved;
  }

  /// Debounced auto-save for in-progress edits.
  void scheduleAutoSave(ProjectModel project) {
    _autoSaveTimer?.cancel();
    ref.read(activeProjectManagementProvider.notifier).setProject(project);
    _autoSaveTimer = Timer(_autoSaveDelay, () async {
      await _repo.saveProject(project);
      await refresh();
    });
  }

  void _syncActiveProject(ProjectModel project) {
    final active = ref.read(activeProjectManagementProvider);
    if (active?.id == project.id) {
      ref.read(activeProjectManagementProvider.notifier).setProject(project);
    }
  }
}

final projectManagementProvider =
    AsyncNotifierProvider<ProjectManagementNotifier, List<ProjectModel>>(
  ProjectManagementNotifier.new,
);

/// Tracks the currently open project in the editor flow.
class ActiveProjectManagementNotifier extends Notifier<ProjectModel?> {
  @override
  ProjectModel? build() => null;

  void setProject(ProjectModel project) {
    state = project;
  }

  void updateSchema(ProjectSchema schema) {
    if (state == null) return;
    state = state!.withSchema(schema);
    ref.read(projectManagementProvider.notifier).scheduleAutoSave(state!);
  }

  Future<void> saveNow() async {
    if (state == null) return;
    final saved =
        await ref.read(projectManagementProvider.notifier).saveProject(state!);
    state = saved;
  }

  void closeProject() {
    state = null;
  }
}

final activeProjectManagementProvider =
    NotifierProvider<ActiveProjectManagementNotifier, ProjectModel?>(
  ActiveProjectManagementNotifier.new,
);

/// Backward-compatible alias for existing imports.
final projectsProvider = projectManagementProvider;

/// Backward-compatible alias for existing imports.
final activeProjectProvider = activeProjectManagementProvider;

/// Legacy repository provider — delegates to project management stack.
final projectRepositoryProvider = projectManagementRepositoryProvider;
