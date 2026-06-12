import '../timeline_engine/domain/timeline_operation.dart';

/// edit_blueprint.dart
///
/// Contract model for AI Director output.
///
/// The AI Director emits a typed list of timeline operations that are intended
/// to be consumed directly by the Timeline Execution Engine.
class EditBlueprint {
  final String blueprintVersion;
  final String blueprintId;
  final double overallConfidenceScore;
  final List<TimelineOperation> operations;

  const EditBlueprint({
    required this.blueprintVersion,
    required this.blueprintId,
    required this.overallConfidenceScore,
    this.operations = const [],
  });

  Map<String, dynamic> toJson() => {
        'blueprintVersion': blueprintVersion,
        'blueprintId': blueprintId,
        'overallConfidenceScore': overallConfidenceScore,
        'operations': operations.map((op) => op.toJson()).toList(),
      };

  factory EditBlueprint.fromJson(Map<String, dynamic> json) => EditBlueprint(
        blueprintVersion: json['blueprintVersion'] as String,
        blueprintId: json['blueprintId'] as String,
        overallConfidenceScore:
            (json['overallConfidenceScore'] as num).toDouble(),
        operations: (json['operations'] as List<dynamic>?)
                ?.map((item) =>
                    TimelineOperation.fromJson(item as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
