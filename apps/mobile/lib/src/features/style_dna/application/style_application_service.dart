import '../../creator_intent/creator_intent.dart';
import '../../creator_intent/creator_intent_engine.dart';
import '../../ai_director/ai_director_engine.dart';
import '../../ai_director/edit_blueprint.dart';
import '../../video_intelligence/domain/intelligence_report.dart';
import '../../project_schema/project_schema.dart';
import '../style_dna.dart';
import 'style_dna_mapper.dart';

/// style_application_service.dart
///
/// Orchestrates the application of a StyleDNA onto a new project.
/// This acts as the single entry point for styling a video edit deterministically,
/// ensuring the StyleDNA cleanly influences the CreatorIntent and AIDirector layers.
class StyleApplicationService {
  final CreatorIntentEngine intentEngine;
  final AIDirectorEngine directorEngine;
  final StyleDNAMapper mapper;

  const StyleApplicationService({
    required this.intentEngine,
    required this.directorEngine,
    required this.mapper,
  });

  /// Applies a StyleDNA to a natural language prompt and project context
  /// to deterministically generate an EditBlueprint that honors the style preferences.
  EditBlueprint applyStyle({
    required StyleDNA styleDNA,
    required String prompt,
    required IntelligenceReport intelligenceReport,
    required ProjectSchema projectSchema,
  }) {
    // 1. Convert StyleDNA into a StyleBiasMatrix
    final biasMatrix = mapper.mapToBias(styleDNA);

    // 2. Parse Intent with the preferred style included
    final intent = intentEngine.parseIntent(
      prompt,
      intelligenceReport: intelligenceReport,
      projectSchema: projectSchema,
      preferredStyle: styleDNA,
    );

    // 3. Generate Blueprint with biases applied
    final blueprint = directorEngine.createBlueprint(
      intent: intent,
      intelligenceReport: intelligenceReport,
      projectSchema: projectSchema,
      styleBiasMatrix: biasMatrix,
    );

    return blueprint;
  }
}
