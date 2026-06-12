import '../project_schema/project_schema.dart';
import '../video_intelligence/domain/intelligence_report.dart';
import 'creator_intent.dart';

/// creator_intent_engine.dart
///
/// Contract for the Creator Intent Engine.
/// It converts natural language prompts into a structured `CreatorIntent`.
///
/// The engine may optionally use available intelligence metadata and project
/// context to produce a richer structured intent representation.
abstract class CreatorIntentEngine {
  CreatorIntent parseIntent(
    String prompt, {
    IntelligenceReport? intelligenceReport,
    ProjectSchema? projectSchema,
  });
}
