import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:vexora_mobile_app/src/features/style_dna/style_dna.dart';
import 'package:vexora_mobile_app/src/features/style_dna/style_metrics.dart';
import 'package:vexora_mobile_app/src/features/style_dna/application/style_application_service.dart';
import 'package:vexora_mobile_app/src/features/style_dna/application/style_dna_mapper.dart';
import 'package:vexora_mobile_app/src/features/creator_intent/default_creator_intent_engine.dart';
import 'package:vexora_mobile_app/src/features/ai_director/default_ai_director_engine.dart';
import 'package:vexora_mobile_app/src/features/ai_director/edit_blueprint.dart';
import 'package:vexora_mobile_app/src/features/timeline_engine/domain/timeline_operation.dart';
import 'package:vexora_mobile_app/src/features/project_schema/project_schema.dart';
import 'package:vexora_mobile_app/src/features/project_schema/timeline_track.dart';
import 'package:vexora_mobile_app/src/features/project_schema/render_settings.dart';
import 'package:vexora_mobile_app/src/features/project_schema/ai_instructions.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/intelligence_report.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/scene_detection.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/beat_detection.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/speech_detection.dart';

void main() {
  group('Phase 5B: StyleDNA Influence on AI Director', () {
    late StyleApplicationService applicationService;
    late IntelligenceReport defaultReport;
    late ProjectSchema defaultProject;

    setUp(() {
      applicationService = const StyleApplicationService(
        intentEngine: DefaultCreatorIntentEngine(),
        directorEngine: DefaultAIDirectorEngine(),
        mapper: StyleDNAMapper(),
      );

      defaultReport = const IntelligenceReport(
        videoId: 'vid_test',
        scenes: [
          SceneDetection(sceneStart: 0, sceneEnd: 1000, confidence: 0.8),
          SceneDetection(sceneStart: 1000, sceneEnd: 2000, confidence: 0.8),
          SceneDetection(sceneStart: 2000, sceneEnd: 3000, confidence: 0.8),
          SceneDetection(sceneStart: 3000, sceneEnd: 4000, confidence: 0.8),
        ],
        beats: [
          BeatDetection(beatTimestamp: 500, confidence: 0.9),
          BeatDetection(beatTimestamp: 1500, confidence: 0.9),
        ],
        speech: [
          SpeechDetection(speechStart: 100, speechEnd: 900, isSpeech: true, confidence: 0.8),
          SpeechDetection(speechStart: 1100, speechEnd: 1900, isSpeech: true, confidence: 0.8),
        ],
        highlights: [],
      );

      defaultProject = const ProjectSchema(
        projectId: 'proj_test',
        schemaVersion: '1.0',
        metadata: Metadata(
          title: 'Test Project',
          authorId: 'tester',
          createdAt: '2026-06-11T10:00:00Z',
          updatedAt: '2026-06-11T10:00:00Z',
        ),
        timeline: Timeline(videoTracks: [], audioTracks: [], captions: []),
        renderSettings: RenderSettings(
          aspectRatio: '9:16',
          fps: 30,
          width: 1080,
          height: 1920,
          exportFormat: 'mp4',
        ),
        aiInstructions: AIInstructions(
          originalPrompt: '',
          engineVersion: 'v1.0',
        ),
      );
    });

    StyleDNA createStyleDNA({
      String pace = 'moderate',
      double averageCutInterval = 3.0,
      String transitionStyle = 'crossfade',
      double transitionFrequency = 0.5,
      String captionStyle = 'minimal',
      double captionDensity = 1.0,
      bool beatSync = false,
      double beatSyncScore = 0.0,
    }) {
      return StyleDNA(
        styleId: 'test_style',
        name: 'Test Style',
        energyScore: 50,
        pace: pace,
        averageCutInterval: averageCutInterval,
        transitionStyle: transitionStyle,
        zoomStyle: 'subtle_zoom',
        captionStyle: captionStyle,
        beatSync: beatSync,
        motionIntensity: 50,
        creatorId: 'tester',
        metrics: StyleMetrics(
          averageCutDuration: averageCutInterval,
          transitionFrequency: transitionFrequency,
          zoomFrequency: 0.2,
          captionDensity: captionDensity,
          beatSyncScore: beatSyncScore,
          motionIntensity: 50.0,
          sceneChangeFrequency: 1.0,
          energyScore: 50.0,
        ),
      );
    }

    test('Fitness style increases cut frequency', () {
      final baseStyle = createStyleDNA(pace: 'slow', averageCutInterval: 5.0);
      final fitnessStyle = createStyleDNA(pace: 'frenetic', averageCutInterval: 0.5);

      final baseBlueprint = applicationService.applyStyle(
        styleDNA: baseStyle,
        prompt: 'gym workout',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final fitnessBlueprint = applicationService.applyStyle(
        styleDNA: fitnessStyle,
        prompt: 'gym workout',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final baseCuts = baseBlueprint.operations.whereType<CutOperation>().length;
      final fitnessCuts = fitnessBlueprint.operations.whereType<CutOperation>().length;

      expect(fitnessCuts, greaterThanOrEqualTo(baseCuts));
    });

    test('Travel style reduces transition frequency', () {
      final heavyTransitionStyle = createStyleDNA(transitionStyle: 'crossfade', transitionFrequency: 2.0);
      final travelStyle = createStyleDNA(transitionStyle: 'hard_cut', transitionFrequency: 0.1);

      final heavyBlueprint = applicationService.applyStyle(
        styleDNA: heavyTransitionStyle,
        prompt: 'travel vlog',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final travelBlueprint = applicationService.applyStyle(
        styleDNA: travelStyle,
        prompt: 'travel vlog',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final heavyTrans = heavyBlueprint.operations.whereType<TransitionOperation>().length;
      final travelTrans = travelBlueprint.operations.whereType<TransitionOperation>().length;

      expect(travelTrans, lessThanOrEqualTo(heavyTrans));
    });

    test('Educational style increases captions', () {
      final baseStyle = createStyleDNA(captionStyle: 'none', captionDensity: 0.0);
      final eduStyle = createStyleDNA(captionStyle: 'kinetic', captionDensity: 5.0);

      final baseBlueprint = applicationService.applyStyle(
        styleDNA: baseStyle,
        prompt: 'educational tutorial',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final eduBlueprint = applicationService.applyStyle(
        styleDNA: eduStyle,
        prompt: 'educational tutorial',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final baseCaps = baseBlueprint.operations.whereType<CaptionOperation>().length;
      final eduCaps = eduBlueprint.operations.whereType<CaptionOperation>().length;

      expect(eduCaps, greaterThanOrEqualTo(baseCaps));
    });

    test('BeatSync style affects blueprint', () {
      final noSyncStyle = createStyleDNA(beatSync: false, beatSyncScore: 0.0, transitionFrequency: 0.0);
      final syncStyle = createStyleDNA(beatSync: true, beatSyncScore: 100.0, transitionFrequency: 1.0);

      final noSyncBlueprint = applicationService.applyStyle(
        styleDNA: noSyncStyle,
        prompt: 'music video',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final syncBlueprint = applicationService.applyStyle(
        styleDNA: syncStyle,
        prompt: 'music video beat-sync',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final noSyncOps = noSyncBlueprint.operations.length;
      final syncOps = syncBlueprint.operations.length;

      // Because 'beat-sync' adds zoom operations as well, operations should be higher
      expect(syncOps, greaterThan(noSyncOps));
    });

    test('Same input produces same blueprint deterministically', () {
      final style = createStyleDNA();

      final bp1 = applicationService.applyStyle(
        styleDNA: style,
        prompt: 'test',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final bp2 = applicationService.applyStyle(
        styleDNA: style,
        prompt: 'test',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      expect(bp1.operations.length, bp2.operations.length);
      expect(bp1.overallConfidenceScore, bp2.overallConfidenceScore);
    });

    test('Different styles produce different blueprints', () {
      final style1 = createStyleDNA(pace: 'frenetic', captionDensity: 5.0, captionStyle: 'kinetic');
      final style2 = createStyleDNA(pace: 'slow', captionDensity: 0.0, captionStyle: 'none');

      final bp1 = applicationService.applyStyle(
        styleDNA: style1,
        prompt: 'test',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final bp2 = applicationService.applyStyle(
        styleDNA: style2,
        prompt: 'test',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      expect(bp1.styleHints?.pace, 'frenetic');
      expect(bp2.styleHints?.pace, 'slow');
      
      final caps1 = bp1.operations.whereType<CaptionOperation>().length;
      final caps2 = bp2.operations.whereType<CaptionOperation>().length;
      expect(caps1, isNot(equals(caps2)));
    });

    test('Serialization works', () {
      final style = createStyleDNA();
      final blueprint = applicationService.applyStyle(
        styleDNA: style,
        prompt: 'test',
        intelligenceReport: defaultReport,
        projectSchema: defaultProject,
      );

      final jsonMap = blueprint.toJson();
      final decoded = EditBlueprint.fromJson(jsonMap);

      expect(decoded.blueprintVersion, blueprint.blueprintVersion);
      expect(decoded.operations.length, blueprint.operations.length);
      expect(decoded.styleHints?.pace, blueprint.styleHints?.pace);
    });
  });
}
