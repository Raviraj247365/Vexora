import 'dart:math';
import 'package:uuid/uuid.dart';

import '../creator_intent/creator_intent.dart';
import '../video_intelligence/domain/intelligence_report.dart';
import '../project_schema/project_schema.dart';
import '../timeline_engine/domain/timeline_operation.dart';
import 'ai_director_engine.dart';
import 'edit_blueprint.dart';

/// default_ai_director_engine.dart
///
/// Default (rule-based) implementation of AIDirectorEngine.
/// Converts creator intent and intelligence metadata into deterministic edit blueprints
/// using rules-based decision logic (no AI models required).
class DefaultAIDirectorEngine implements AIDirectorEngine {
  static const uuid = Uuid();

  const DefaultAIDirectorEngine();

  /// Generates an EditBlueprint from creator intent, intelligence metadata, and project schema.
  ///
  /// Algorithm:
  /// 1. Parse intent to determine editing goals and preferences
  /// 2. Analyze intelligence metadata (scenes, beats, speech, highlights)
  /// 3. Apply rule-based decision matrix to generate operations
  /// 4. Calculate composite confidence scores
  /// 5. Return EditBlueprint with typed operations
  @override
  EditBlueprint createBlueprint({
    required CreatorIntent intent,
    required IntelligenceReport intelligenceReport,
    required ProjectSchema projectSchema,
  }) {
    final operations = <TimelineOperation>[];
    final confidenceScores = <double>[];

    // 1. Generate TRIM/CUT operations from scenes
    final sceneOps = _generateSceneOperations(
      intelligenceReport.scenes,
      intent,
    );
    operations.addAll(sceneOps);
    confidenceScores.addAll(sceneOps.map((op) => op.confidence));

    // 2. Generate TRANSITION/ZOOM operations from beats
    final beatOps = _generateBeatOperations(
      intelligenceReport.beats,
      intent,
    );
    operations.addAll(beatOps);
    confidenceScores.addAll(beatOps.map((op) => op.confidence));

    // 3. Generate CAPTION operations from speech
    final speechOps = _generateSpeechOperations(
      intelligenceReport.speech,
      intent,
    );
    operations.addAll(speechOps);
    confidenceScores.addAll(speechOps.map((op) => op.confidence));

    // 4. Generate FILTER operations from highlights
    final highlightOps = _generateHighlightOperations(
      intelligenceReport.highlights,
      intent,
    );
    operations.addAll(highlightOps);
    confidenceScores.addAll(highlightOps.map((op) => op.confidence));

    // 5. Calculate overall blueprint confidence
    final overallConfidence = confidenceScores.isEmpty
        ? 0.0
        : confidenceScores.reduce((a, b) => a + b) / confidenceScores.length;

    // 6. Create and return blueprint
    final blueprintId = uuid.v4();
    return EditBlueprint(
      blueprintVersion: '1.0',
      blueprintId: blueprintId,
      overallConfidenceScore: overallConfidence,
      operations: operations,
    );
  }

  /// Generates TRIM/CUT operations based on detected scene boundaries.
  ///
  /// Rule: Each scene change becomes a potential CUT operation.
  /// Confidence is inherited from scene detection confidence.
  List<TimelineOperation> _generateSceneOperations(
    List<dynamic> scenes,
    CreatorIntent intent,
  ) {
    if (scenes.isEmpty) return [];

    final ops = <TimelineOperation>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Create a CUT operation at each scene boundary
    for (int i = 0; i < scenes.length; i++) {
      final scene = scenes[i];
      final opId = 'cut-scene-$i';

      // Extract confidence from scene (if available via reflection)
      double confidence = 0.75;
      try {
        if (scene.runtimeType.toString().contains('SceneDetection')) {
          confidence = (scene as dynamic).confidence ?? 0.75;
        }
      } catch (_) {}

      ops.add(CutOperation(
        operationId: opId,
        timestamp: timestamp,
        confidence: confidence,
        source: OperationSource.aiDirector,
        startMs: (scene as dynamic).sceneStart ?? 0,
        endMs: (scene as dynamic).sceneEnd ?? 1000,
      ));
    }

    return ops;
  }

  /// Generates TRANSITION/ZOOM operations based on detected beats.
  ///
  /// Rule: Each beat peak becomes a TRANSITION operation if intent includes 'transition'.
  /// Confidence is inherited from beat detection confidence.
  List<TimelineOperation> _generateBeatOperations(
    List<dynamic> beats,
    CreatorIntent intent,
  ) {
    if (beats.isEmpty) return [];

    final ops = <TimelineOperation>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final wantTransition = intent.keywords.contains('transition');
    final wantZoom = intent.keywords.contains('zoom') ||
        intent.keywords.contains('beat-sync');

    for (int i = 0; i < beats.length; i++) {
      final beat = beats[i];

      // Extract confidence and timestamp from beat
      double confidence = 0.7;
      int beatTime = 0;
      try {
        if (beat.runtimeType.toString().contains('BeatDetection')) {
          confidence = (beat as dynamic).confidence ?? 0.7;
          beatTime = (beat as dynamic).beatTimestamp ?? 0;
        }
      } catch (_) {}

      // Generate TRANSITION operation
      if (wantTransition) {
        ops.add(TransitionOperation(
          operationId: 'trans-beat-$i',
          timestamp: timestamp,
          confidence: confidence * 0.9,
          source: OperationSource.aiDirector,
          beforeClipId: 'clip-${max(0, i - 1)}',
          afterClipId: 'clip-$i',
          transitionType: 'crossfade',
          durationMs: 300,
        ));
      }

      // Generate ZOOM operation
      if (wantZoom) {
        ops.add(ZoomOperation(
          operationId: 'zoom-beat-$i',
          timestamp: timestamp,
          confidence: confidence,
          source: OperationSource.aiDirector,
          clipId: 'clip-$i',
          zoomFactor: 1.2,
          zoomStartMs: beatTime,
          zoomEndMs: beatTime + 500,
        ));
      }
    }

    return ops;
  }

  /// Generates CAPTION operations based on detected speech segments.
  ///
  /// Rule: Speech onset becomes a CAPTION operation if intent includes 'caption' or 'text'.
  /// Confidence is inherited from speech detection confidence.
  List<TimelineOperation> _generateSpeechOperations(
    List<dynamic> speechSegments,
    CreatorIntent intent,
  ) {
    if (speechSegments.isEmpty) return [];

    final ops = <TimelineOperation>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final wantCaption =
        intent.keywords.contains('caption') || intent.keywords.contains('text');

    if (!wantCaption) return [];

    for (int i = 0; i < speechSegments.length; i++) {
      final segment = speechSegments[i];

      // Extract confidence and time range from segment
      double confidence = 0.65;
      int startMs = 0;
      int endMs = 1000;
      bool isSpeech = true;
      try {
        if (segment.runtimeType.toString().contains('SpeechDetection')) {
          confidence = (segment as dynamic).confidence ?? 0.65;
          startMs = (segment as dynamic).speechStart ?? 0;
          endMs = (segment as dynamic).speechEnd ?? 1000;
          isSpeech = (segment as dynamic).isSpeech ?? true;
        }
      } catch (_) {}

      // Only add captions for actual speech (not silence)
      if (isSpeech) {
        ops.add(CaptionOperation(
          operationId: 'cap-speech-$i',
          timestamp: timestamp,
          confidence: confidence,
          source: OperationSource.aiDirector,
          captionId: 'caption-speech-$i',
          text: '[Speech detected]',
          captionStartMs: startMs,
          captionEndMs: endMs,
          stylePreset: 'default',
        ));
      }
    }

    return ops;
  }

  /// Generates FILTER operations based on detected highlights.
  ///
  /// Rule: Each highlight becomes a FILTER operation to emphasize the moment.
  /// Confidence is composite of highlight score and intent alignment.
  List<TimelineOperation> _generateHighlightOperations(
    List<dynamic> highlights,
    CreatorIntent intent,
  ) {
    if (highlights.isEmpty) return [];

    final ops = <TimelineOperation>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final wantEffect = intent.keywords.contains('effect') ||
        intent.keywords.contains('filter') ||
        intent.keywords.contains('highlight');

    if (!wantEffect) return [];

    for (int i = 0; i < highlights.length; i++) {
      final highlight = highlights[i];

      // Extract score and timestamp from highlight
      double score = 0.5;
      int highlightTime = 0;
      try {
        if (highlight.runtimeType.toString().contains('HighlightDetection')) {
          score = (highlight as dynamic).score ?? 0.5;
          highlightTime = (highlight as dynamic).timestamp ?? 0;
        }
      } catch (_) {}

      // Only generate filters for high-confidence highlights
      if (score >= 0.6) {
        ops.add(FilterOperation(
          operationId: 'filter-highlight-$i',
          timestamp: timestamp,
          confidence: score,
          source: OperationSource.aiDirector,
          clipId: 'clip-$i',
          filterType: 'emphasis',
          params: {
            'intensity': (score * 100).toStringAsFixed(0),
            'timestampMs': highlightTime,
          },
        ));
      }
    }

    return ops;
  }
}
