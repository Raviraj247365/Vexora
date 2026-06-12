/// project_management_test.dart
///
/// Unit tests for project lifecycle, persistence, and metadata.

import 'package:flutter_test/flutter_test.dart';

import 'package:vexora_mobile_app/src/features/project_management/data/project_persistence.dart';
import 'package:vexora_mobile_app/src/features/project_management/data/project_repository.dart';
import 'package:vexora_mobile_app/src/features/project_management/domain/project_model.dart';
import 'package:vexora_mobile_app/src/features/project_schema/asset.dart';
import 'package:vexora_mobile_app/src/features/project_schema/project_schema.dart';

void main() {
  late InMemoryProjectPersistence persistence;
  late ProjectRepository repository;

  setUp(() {
    persistence = InMemoryProjectPersistence();
    repository = ProjectRepository(persistence: persistence);
  });

  group('ProjectRepository', () {
    test('creates a project with default title', () async {
      final project = await repository.createProject();

      expect(project.title, 'New Vexora Project');
      expect(project.id, isNotEmpty);
      expect(project.lastOpenedAt, isNotNull);
    });

    test('creates a project with custom title', () async {
      final project =
          await repository.createProject(title: 'Gym Reel Draft');

      expect(project.title, 'Gym Reel Draft');
    });

    test('renames a project and updates updatedAt', () async {
      final created = await repository.createProject(title: 'Original');
      final renamed = await repository.renameProject(created.id, 'Renamed');

      expect(renamed.title, 'Renamed');
      expect(renamed.updatedAt.isAfter(created.updatedAt), isTrue);
    });

    test('throws when renaming missing project', () async {
      expect(
        () => repository.renameProject('missing-id', 'Nope'),
        throwsA(isA<ProjectNotFoundException>()),
      );
    });

    test('deletes a project', () async {
      final project = await repository.createProject();
      await repository.deleteProject(project.id);

      final loaded = await repository.getProjectById(project.id);
      expect(loaded, isNull);
    });

    test('duplicates a project with new id and copy suffix', () async {
      final original = await repository.createProject(title: 'Source Edit');
      final duplicate = await repository.duplicateProject(original.id);

      expect(duplicate.id, isNot(original.id));
      expect(duplicate.title, 'Source Edit (Copy)');
      expect(duplicate.schema.projectId, isNot(original.schema.projectId));
    });

    test('returns recent projects sorted by activity', () async {
      final first = await repository.createProject(title: 'First');
      await Future<void>.delayed(const Duration(milliseconds: 5));
      final second = await repository.createProject(title: 'Second');
      await repository.touchProject(first.id);

      final recent = await repository.getRecentProjects(limit: 10);

      expect(recent.first.id, first.id);
      expect(recent.map((p) => p.id), contains(second.id));
    });

    test('getRecentProjects respects limit', () async {
      await repository.createProject(title: 'A');
      await repository.createProject(title: 'B');
      await repository.createProject(title: 'C');

      final recent = await repository.getRecentProjects(limit: 2);
      expect(recent.length, 2);
    });

    test('saveProject persists schema updates', () async {
      final project = await repository.createProject(title: 'Draft');
      final schema = project.schema;
      final withAsset = project.withSchema(
        ProjectSchema(
          schemaVersion: schema.schemaVersion,
          projectId: schema.projectId,
          metadata: schema.metadata,
          renderSettings: schema.renderSettings,
          assets: const [
            Asset(
              id: 'asset-1',
              type: 'video',
              sourceUrl: '/tmp/video.mp4',
              duration: 5000,
            ),
          ],
          timeline: schema.timeline,
          aiInstructions: schema.aiInstructions,
          history: schema.history,
        ),
      );

      final saved = await repository.saveProject(withAsset);
      final loaded = await repository.getProjectById(project.id);

      expect(saved.assetCount, 1);
      expect(loaded?.assetCount, 1);
    });
  });

  group('ProjectModel', () {
    test('serializes and reconstructs with lastOpenedAt', () {
      final project = ProjectModel.create(
        projectId: 'proj-1',
        title: 'Test',
      );

      final json = project.toJson();
      final reconstructed = ProjectModel.fromJson(json);

      expect(reconstructed.id, 'proj-1');
      expect(reconstructed.title, 'Test');
      expect(reconstructed.lastOpenedAt, isNotNull);
    });

    test('computes zero progress without assets', () {
      final empty = ProjectModel.create(projectId: 'p1');
      expect(empty.progress, 0.0);
    });

    test('renamed updates title without changing id', () {
      final project = ProjectModel.create(projectId: 'p1', title: 'Old');
      final renamed = project.renamed('New Title');

      expect(renamed.id, 'p1');
      expect(renamed.title, 'New Title');
    });

    test('duplicated creates independent copy', () {
      final project = ProjectModel.create(projectId: 'p1', title: 'Base');
      final copy = project.duplicated(newProjectId: 'p2');

      expect(copy.id, 'p2');
      expect(copy.title, 'Base (Copy)');
    });
  });

  group('InMemoryProjectPersistence', () {
    test('loads all saved projects', () async {
      final project = ProjectModel.create(projectId: 'x', title: 'X');
      await persistence.save(project);

      final all = await persistence.loadAll();
      expect(all.length, 1);
      expect(all.first.id, 'x');
    });
  });
}
