import 'package:uuid/uuid.dart';

import '../domain/project_model.dart';
import 'project_persistence.dart';

/// project_repository.dart
///
/// Domain repository for project lifecycle operations.
/// Delegates storage to [ProjectPersistence] and keeps sorting logic centralized.
class ProjectRepository {
  final ProjectPersistence _persistence;
  static const _uuid = Uuid();

  ProjectRepository({required ProjectPersistence persistence})
      : _persistence = persistence;

  Future<List<ProjectModel>> getAllProjects() async {
    final projects = await _persistence.loadAll();
    return _sortByRecent(projects);
  }

  Future<List<ProjectModel>> getRecentProjects({int limit = 10}) async {
    final projects = await getAllProjects();
    if (projects.length <= limit) return projects;
    return projects.sublist(0, limit);
  }

  Future<ProjectModel?> getProjectById(String projectId) =>
      _persistence.loadById(projectId);

  Future<ProjectModel> createProject({
    String title = 'New Vexora Project',
    String? authorId,
  }) async {
    final project = ProjectModel.create(
      projectId: _uuid.v4(),
      title: title,
      authorId: authorId,
    );
    await _persistence.save(project);
    return project;
  }

  Future<ProjectModel> renameProject(String projectId, String newTitle) async {
    final existing = await _requireProject(projectId);
    final renamed = existing.renamed(newTitle.trim());
    await _persistence.save(renamed);
    return renamed;
  }

  Future<void> deleteProject(String projectId) =>
      _persistence.delete(projectId);

  Future<ProjectModel> duplicateProject(String projectId) async {
    final existing = await _requireProject(projectId);
    final duplicate = existing.duplicated(newProjectId: _uuid.v4());
    await _persistence.save(duplicate);
    return duplicate;
  }

  Future<ProjectModel> saveProject(ProjectModel project) async {
    final saved = project.withSchema(project.schema);
    await _persistence.save(saved);
    return saved;
  }

  Future<ProjectModel> touchProject(String projectId) async {
    final existing = await _requireProject(projectId);
    final touched = existing.touch();
    await _persistence.save(touched);
    return touched;
  }

  Future<ProjectModel> _requireProject(String projectId) async {
    final project = await _persistence.loadById(projectId);
    if (project == null) {
      throw ProjectNotFoundException(projectId);
    }
    return project;
  }

  List<ProjectModel> _sortByRecent(List<ProjectModel> projects) {
    final sorted = List<ProjectModel>.from(projects);
    sorted.sort(
      (a, b) => b.recentActivityAt.compareTo(a.recentActivityAt),
    );
    return sorted;
  }
}

/// Thrown when a project id does not exist in persistence.
class ProjectNotFoundException implements Exception {
  final String projectId;
  const ProjectNotFoundException(this.projectId);

  @override
  String toString() => 'ProjectNotFoundException: $projectId';
}
