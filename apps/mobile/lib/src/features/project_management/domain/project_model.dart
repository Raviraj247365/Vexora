import '../../project_schema/project_schema.dart';
import '../../project_schema/render_settings.dart';
import '../../project_schema/ai_instructions.dart';
import '../../project_schema/timeline_track.dart';
import '../../project_schema/timeline_clip.dart';

/// project_model.dart
///
/// Management-layer wrapper around [ProjectSchema] with computed metadata
/// used by the dashboard, recent-projects feed, and auto-save pipeline.
class ProjectModel {
  final ProjectSchema schema;
  final DateTime? lastOpenedAt;

  const ProjectModel({
    required this.schema,
    this.lastOpenedAt,
  });

  String get id => schema.projectId;
  String get title => schema.metadata.title;
  String? get authorId => schema.metadata.authorId;
  DateTime get createdAt => DateTime.parse(schema.metadata.createdAt);
  DateTime get updatedAt => DateTime.parse(schema.metadata.updatedAt);

  /// Rough completion estimate based on assets and timeline content.
  double get progress {
    if (schema.assets.isEmpty) return 0.0;
    final clipCount = schema.timeline.videoTracks
        .expand((track) => track.items)
        .where((item) => item is ClipItem)
        .length;
    if (clipCount == 0) return 0.25;
    if (schema.history.isNotEmpty) return 1.0;
    return (0.4 + (clipCount * 0.15)).clamp(0.0, 0.95);
  }

  int get assetCount => schema.assets.length;

  int get clipCount => schema.timeline.videoTracks
      .expand((track) => track.items)
      .where((item) => item is ClipItem)
      .length;

  /// Sort key for recent-projects ordering.
  DateTime get recentActivityAt => lastOpenedAt ?? updatedAt;

  Map<String, dynamic> toJson() => {
        'lastOpenedAt': lastOpenedAt?.toIso8601String(),
        'schema': schema.toJson(),
      };

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        schema: ProjectSchema.fromJson(json['schema'] as Map<String, dynamic>),
        lastOpenedAt: json['lastOpenedAt'] != null
            ? DateTime.parse(json['lastOpenedAt'] as String)
            : null,
      );

  ProjectModel copyWith({
    ProjectSchema? schema,
    DateTime? lastOpenedAt,
  }) =>
      ProjectModel(
        schema: schema ?? this.schema,
        lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      );

  /// Creates a blank project with default render settings.
  factory ProjectModel.create({
    required String projectId,
    String title = 'New Vexora Project',
    String? authorId,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    return ProjectModel(
      schema: ProjectSchema(
        schemaVersion: '1.0',
        projectId: projectId,
        metadata: Metadata(
          title: title,
          authorId: authorId,
          createdAt: now,
          updatedAt: now,
        ),
        renderSettings: const RenderSettings(
          aspectRatio: '9:16',
          fps: 30,
          width: 1080,
          height: 1920,
          exportFormat: 'mp4',
        ),
        timeline: const Timeline(),
        aiInstructions: const AIInstructions(
          originalPrompt: '',
          engineVersion: 'v1.0',
        ),
      ),
      lastOpenedAt: DateTime.now().toUtc(),
    );
  }

  factory ProjectModel.fromSchema(ProjectSchema schema) =>
      ProjectModel(schema: schema);

  /// Returns a copy with an updated title and refreshed [updatedAt].
  ProjectModel renamed(String newTitle) {
    final now = DateTime.now().toUtc().toIso8601String();
    return copyWith(
      schema: ProjectSchema(
        schemaVersion: schema.schemaVersion,
        projectId: schema.projectId,
        metadata: Metadata(
          title: newTitle,
          authorId: schema.metadata.authorId,
          createdAt: schema.metadata.createdAt,
          updatedAt: now,
        ),
        renderSettings: schema.renderSettings,
        assets: schema.assets,
        timeline: schema.timeline,
        aiInstructions: schema.aiInstructions,
        history: schema.history,
      ),
    );
  }

  /// Returns a deep copy with a new id and "(Copy)" suffix on the title.
  ProjectModel duplicated({required String newProjectId}) {
    final now = DateTime.now().toUtc().toIso8601String();
    return ProjectModel(
      schema: ProjectSchema(
        schemaVersion: schema.schemaVersion,
        projectId: newProjectId,
        metadata: Metadata(
          title: '${schema.metadata.title} (Copy)',
          authorId: schema.metadata.authorId,
          createdAt: now,
          updatedAt: now,
        ),
        renderSettings: schema.renderSettings,
        assets: List.from(schema.assets),
        timeline: Timeline.fromJson(schema.timeline.toJson()),
        aiInstructions: schema.aiInstructions,
        history: List.from(schema.history),
      ),
      lastOpenedAt: DateTime.now().toUtc(),
    );
  }

  /// Marks the project as recently opened.
  ProjectModel touch() => copyWith(lastOpenedAt: DateTime.now().toUtc());

  /// Returns a copy with an updated schema and refreshed [updatedAt].
  ProjectModel withSchema(ProjectSchema updatedSchema) {
    final now = DateTime.now().toUtc().toIso8601String();
    return copyWith(
      schema: ProjectSchema(
        schemaVersion: updatedSchema.schemaVersion,
        projectId: updatedSchema.projectId,
        metadata: Metadata(
          title: updatedSchema.metadata.title,
          authorId: updatedSchema.metadata.authorId,
          createdAt: updatedSchema.metadata.createdAt,
          updatedAt: now,
        ),
        renderSettings: updatedSchema.renderSettings,
        assets: updatedSchema.assets,
        timeline: updatedSchema.timeline,
        aiInstructions: updatedSchema.aiInstructions,
        history: updatedSchema.history,
      ),
    );
  }
}
