import '../creator_intent/creator_intent.dart';
import '../video_intelligence/domain/intelligence_report.dart';
import '../project_schema/project_schema.dart';
import 'edit_blueprint.dart';

/// ai_director_engine.dart
///
/// Contract for the AI Director Engine.
/// It converts creator intent, intelligence metadata, and project schema into an edit blueprint.
abstract class AIDirectorEngine {
  EditBlueprint createBlueprint({
    required CreatorIntent intent,
    required IntelligenceReport intelligenceReport,
    required ProjectSchema projectSchema,
  });
}
