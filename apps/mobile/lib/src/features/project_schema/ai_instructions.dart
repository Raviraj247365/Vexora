/// ai_instructions.dart
///
/// Immutable AI instruction metadata for a project schema.
class AIInstructions {
  final String originalPrompt;
  final String? styleReferenceId;
  final String engineVersion;
  final List<String> aiAppliedFilters;

  const AIInstructions({
    required this.originalPrompt,
    this.styleReferenceId,
    required this.engineVersion,
    this.aiAppliedFilters = const [],
  });

  Map<String, dynamic> toJson() => {
        'originalPrompt': originalPrompt,
        'styleReferenceId': styleReferenceId,
        'engineVersion': engineVersion,
        'aiAppliedFilters': aiAppliedFilters,
      };

  factory AIInstructions.fromJson(Map<String, dynamic> json) => AIInstructions(
        originalPrompt: json['originalPrompt'] as String,
        styleReferenceId: json['styleReferenceId'] as String?,
        engineVersion: json['engineVersion'] as String,
        aiAppliedFilters: (json['aiAppliedFilters'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );
}
