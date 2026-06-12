import 'asset.dart';
import 'timeline_track.dart';
import 'render_settings.dart';
import 'ai_instructions.dart';
import 'history_entry.dart';

/// project_schema.dart
///
/// Immutable representation of the Universal Project Schema.
class Metadata {
  final String title;
  final String? authorId;
  final String createdAt;
  final String updatedAt;

  const Metadata({
    required this.title,
    this.authorId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'authorId': authorId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        title: json['title'] as String,
        authorId: json['authorId'] as String?,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );
}

class ProjectSchema {
  final String schemaVersion;
  final String projectId;
  final Metadata metadata;
  final RenderSettings renderSettings;
  final List<Asset> assets;
  final Timeline timeline;
  final AIInstructions aiInstructions;
  final List<HistoryEntry> history;

  const ProjectSchema({
    required this.schemaVersion,
    required this.projectId,
    required this.metadata,
    required this.renderSettings,
    this.assets = const [],
    required this.timeline,
    required this.aiInstructions,
    this.history = const [],
  });

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'projectId': projectId,
        'metadata': metadata.toJson(),
        'renderSettings': renderSettings.toJson(),
        'assets': assets.map((asset) => asset.toJson()).toList(),
        'timeline': timeline.toJson(),
        'aiInstructions': aiInstructions.toJson(),
        'history': history.map((entry) => entry.toJson()).toList(),
      };

  factory ProjectSchema.fromJson(Map<String, dynamic> json) => ProjectSchema(
        schemaVersion: json['schemaVersion'] as String,
        projectId: json['projectId'] as String,
        metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
        renderSettings: RenderSettings.fromJson(
            json['renderSettings'] as Map<String, dynamic>),
        assets: (json['assets'] as List<dynamic>?)
                ?.map((e) => Asset.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        timeline: Timeline.fromJson(json['timeline'] as Map<String, dynamic>),
        aiInstructions: AIInstructions.fromJson(
            json['aiInstructions'] as Map<String, dynamic>),
        history: (json['history'] as List<dynamic>?)
                ?.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
