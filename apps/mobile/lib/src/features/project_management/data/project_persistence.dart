import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/project_model.dart';
import '../../project_schema/project_schema.dart';

/// project_persistence.dart
///
/// Persistence contract for project management data.
/// Implementations handle JSON serialization to a storage backend.
abstract class ProjectPersistence {
  Future<List<ProjectModel>> loadAll();
  Future<ProjectModel?> loadById(String projectId);
  Future<void> save(ProjectModel project);
  Future<void> delete(String projectId);
}

/// File-based persistence using the app documents directory.
class FileProjectPersistence implements ProjectPersistence {
  static const String _directoryName = 'vexora_projects';

  Future<Directory> _projectsDirectory() async {
    final docDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${docDir.path}/$_directoryName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  File _fileFor(String projectId, Directory dir) =>
      File('${dir.path}/$projectId.json');

  @override
  Future<List<ProjectModel>> loadAll() async {
    final dir = await _projectsDirectory();
    final projects = <ProjectModel>[];

    await for (final entity in dir.list()) {
      if (entity is! File || !entity.path.endsWith('.json')) continue;
      try {
        final json = jsonDecode(await entity.readAsString());
        projects.add(_decodeProject(json));
      } catch (_) {
        // Skip corrupted files.
      }
    }

    return projects;
  }

  @override
  Future<ProjectModel?> loadById(String projectId) async {
    final dir = await _projectsDirectory();
    final file = _fileFor(projectId, dir);
    if (!await file.exists()) return null;

    try {
      final json = jsonDecode(await file.readAsString());
      return _decodeProject(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(ProjectModel project) async {
    final dir = await _projectsDirectory();
    final file = _fileFor(project.id, dir);
    await file.writeAsString(jsonEncode(project.toJson()));
  }

  @override
  Future<void> delete(String projectId) async {
    final dir = await _projectsDirectory();
    final file = _fileFor(projectId, dir);
    if (await file.exists()) {
      await file.delete();
    }
  }

  ProjectModel _decodeProject(dynamic json) {
    final map = json as Map<String, dynamic>;
    if (map.containsKey('schema')) {
      return ProjectModel.fromJson(map);
    }
    // Backward compatibility: legacy files stored bare ProjectSchema JSON.
    return ProjectModel.fromSchema(ProjectSchema.fromJson(map));
  }
}

/// In-memory persistence for unit tests and dev tooling.
class InMemoryProjectPersistence implements ProjectPersistence {
  final Map<String, ProjectModel> _store = {};

  @override
  Future<void> delete(String projectId) async {
    _store.remove(projectId);
  }

  @override
  Future<ProjectModel?> loadById(String projectId) async =>
      _store[projectId];

  @override
  Future<List<ProjectModel>> loadAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<void> save(ProjectModel project) async {
    _store[project.id] = project;
  }
}
