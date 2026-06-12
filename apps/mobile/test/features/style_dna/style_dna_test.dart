/// style_dna_test.dart
///
/// Test suite for the Style DNA Engine models and extractor.

import 'package:flutter_test/flutter_test.dart';

import 'package:vexora_mobile_app/src/features/project_schema/ai_instructions.dart';
import 'package:vexora_mobile_app/src/features/project_schema/project_schema.dart';
import 'package:vexora_mobile_app/src/features/project_schema/render_settings.dart';
import 'package:vexora_mobile_app/src/features/project_schema/timeline_clip.dart';
import 'package:vexora_mobile_app/src/features/project_schema/timeline_track.dart';
import 'package:vexora_mobile_app/src/features/project_schema/transition.dart';
import 'package:vexora_mobile_app/src/features/style_dna/style_dna.dart';
import 'package:vexora_mobile_app/src/features/style_dna/style_extractor.dart';
import 'package:vexora_mobile_app/src/features/style_dna/style_metrics.dart';
import 'package:vexora_mobile_app/src/features/style_dna/style_profile.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/beat_detection.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/highlight_detection.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/intelligence_report.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/scene_detection.dart';

void main() {
  group('StyleMetrics', () {
    test('serializes and reconstructs correctly', () {
      const metrics = StyleMetrics(
        averageCutDuration: 0.8,
        transitionFrequency: 0.25,
        zoomFrequency: 0.1,
        captionDensity: 4.0,
        beatSyncScore: 75.0,
        motionIntensity: 82.0,
        sceneChangeFrequency: 1.2,
        energyScore: 91.0,
      );

      final reconstructed = StyleMetrics.fromJson(metrics.toJson());
      expect(reconstructed.averageCutDuration, 0.8);
      expect(reconstructed.energyScore, 91.0);
    });

    test('copyWith overrides selected fields', () {
      const metrics = StyleMetrics(
        averageCutDuration: 0.8,
        transitionFrequency: 0.25,
        zoomFrequency: 0.1,
        captionDensity: 4.0,
        beatSyncScore: 75.0,
        motionIntensity: 82.0,
        sceneChangeFrequency: 1.2,
        energyScore: 91.0,
      );

      final updated = metrics.copyWith(energyScore: 95.0);
      expect(updated.energyScore, 95.0);
      expect(updated.averageCutDuration, 0.8);
    });
  });

  group('StyleDNA', () {
    test('serializes and reconstructs correctly', () {
      const styleDNA = StyleDNA(
        styleId: 'fitness_v1',
        name: 'Alex Fitness',
        energyScore: 92,
        pace: 'frenetic',
        averageCutInterval: 0.8,
        transitionStyle: 'whip_pan',
        zoomStyle: 'snap_zoom',
        captionStyle: 'kinetic',
        beatSync: true,
        motionIntensity: 88,
        creatorId: 'creator_001',
        metrics: StyleMetrics(
          averageCutDuration: 0.8,
          transitionFrequency: 0.25,
          zoomFrequency: 0.1,
          captionDensity: 4.0,
          beatSyncScore: 75.0,
          motionIntensity: 88.0,
          sceneChangeFrequency: 1.2,
          energyScore: 92.0,
        ),
      );

      final reconstructed = StyleDNA.fromJson(styleDNA.toJson());
      expect(reconstructed.styleId, 'fitness_v1');
      expect(reconstructed.beatSync, isTrue);
      expect(reconstructed.metrics.energyScore, 92.0);
    });

    test('copyWith overrides selected fields', () {
      const styleDNA = StyleDNA(
        styleId: 'fitness_v1',
        name: 'Alex Fitness',
        energyScore: 92,
        pace: 'frenetic',
        averageCutInterval: 0.8,
        transitionStyle: 'whip_pan',
        zoomStyle: 'snap_zoom',
        captionStyle: 'kinetic',
        beatSync: true,
        motionIntensity: 88,
        creatorId: 'creator_001',
        metrics: StyleMetrics(
          averageCutDuration: 0.8,
          transitionFrequency: 0.25,
          zoomFrequency: 0.1,
          captionDensity: 4.0,
          beatSyncScore: 75.0,
          motionIntensity: 88.0,
          sceneChangeFrequency: 1.2,
          energyScore: 92.0,
        ),
      );

      final updated = styleDNA.copyWith(name: 'Updated Fitness');
      expect(updated.name, 'Updated Fitness');
      expect(updated.styleId, 'fitness_v1');
    });
  });

  group('StyleProfile', () {
    test('serializes category labels and nested style DNA', () {
      const styleDNA = StyleDNA(
        styleId: 'fitness_v1',
        name: 'Alex Fitness',
        energyScore: 92,
        pace: 'frenetic',
        averageCutInterval: 0.8,
        transitionStyle: 'whip_pan',
        zoomStyle: 'snap_zoom',
        captionStyle: 'kinetic',
        beatSync: true,
        motionIntensity: 88,
        creatorId: 'creator_001',
        metrics: StyleMetrics(
          averageCutDuration: 0.8,
          transitionFrequency: 0.25,
          zoomFrequency: 0.1,
          captionDensity: 4.0,
          beatSyncScore: 75.0,
          motionIntensity: 88.0,
          sceneChangeFrequency: 1.2,
          energyScore: 92.0,
        ),
      );

      const profile = StyleProfile(
        styleId: 'fitness_v1',
        creatorId: 'creator_001',
        creatorName: 'Alex',
        styleName: 'Alex Fitness',
        category: StyleCategory.fitness,
        likes: 120,
        copies: 45,
        followers: 3000,
        createdAt: '2026-06-11T10:00:00Z',
        styleDNA: styleDNA,
      );

      final json = profile.toJson();
      final reconstructed = StyleProfile.fromJson(json);

      expect(json['category'], 'Fitness');
      expect(reconstructed.category, StyleCategory.fitness);
      expect(reconstructed.styleDNA.name, 'Alex Fitness');
    });
  });

  group('StyleExtractor', () {
    test('extracts frenetic fitness style from fast-cut project', () {
      final project = _buildFitnessProject();
      final report = _buildFitnessReport();

      const extractor = StyleExtractor();
      final styleDNA = extractor.extract(
        intelligenceReport: report,
        projectSchema: project,
        styleId: 'fitness_v1',
        name: 'Alex Fitness',
        creatorId: 'creator_001',
      );

      expect(styleDNA.styleId, 'fitness_v1');
      expect(styleDNA.pace, 'frenetic');
      expect(styleDNA.transitionStyle, 'whip_pan');
      expect(styleDNA.captionStyle, 'kinetic');
      expect(styleDNA.zoomStyle, 'snap_zoom');
      expect(styleDNA.beatSync, isTrue);
      expect(styleDNA.energyScore, greaterThan(70));
      expect(styleDNA.averageCutInterval, lessThan(1.0));
    });

    test('produces deterministic output for identical inputs', () {
      final project = _buildFitnessProject();
      final report = _buildFitnessReport();
      const extractor = StyleExtractor();

      final first = extractor.extract(
        intelligenceReport: report,
        projectSchema: project,
        styleId: 'fitness_v1',
        name: 'Alex Fitness',
        creatorId: 'creator_001',
      );
      final second = extractor.extract(
        intelligenceReport: report,
        projectSchema: project,
        styleId: 'fitness_v1',
        name: 'Alex Fitness',
        creatorId: 'creator_001',
      );

      expect(first.toJson(), second.toJson());
    });

    test('buildProfile wraps extracted style DNA for marketplace use', () {
      final project = _buildFitnessProject();
      final report = _buildFitnessReport();
      const extractor = StyleExtractor();

      final styleDNA = extractor.extract(
        intelligenceReport: report,
        projectSchema: project,
        styleId: 'fitness_v1',
        name: 'Alex Fitness',
        creatorId: 'creator_001',
      );

      final profile = extractor.buildProfile(
        styleDNA: styleDNA,
        creatorName: 'Alex',
        category: StyleCategory.fitness,
        likes: 10,
        copies: 2,
        followers: 100,
        createdAt: '2026-06-11T10:00:00Z',
      );

      expect(profile.creatorName, 'Alex');
      expect(profile.category, StyleCategory.fitness);
      expect(profile.styleDNA.styleId, 'fitness_v1');
    });

    test('handles empty timeline with zeroed metrics', () {
      final project = _buildEmptyProject();
      final report = IntelligenceReport(videoId: 'empty_video');

      const extractor = StyleExtractor();
      final styleDNA = extractor.extract(
        intelligenceReport: report,
        projectSchema: project,
      );

      expect(styleDNA.metrics.beatSyncScore, 0);
      expect(styleDNA.beatSync, isFalse);
      expect(styleDNA.captionStyle, 'none');
      expect(styleDNA.transitionStyle, 'hard_cut');
    });
  });
}

ProjectSchema _buildFitnessProject() {
  return ProjectSchema(
    schemaVersion: '1.0',
    projectId: 'project_fitness_001',
    metadata: const Metadata(
      title: 'Alex Fitness',
      authorId: 'creator_001',
      createdAt: '2026-06-11T10:00:00Z',
      updatedAt: '2026-06-11T10:05:00Z',
    ),
    renderSettings: const RenderSettings(
      aspectRatio: '9:16',
      fps: 30,
      width: 1080,
      height: 1920,
      exportFormat: 'mp4',
    ),
    timeline: Timeline(
      videoTracks: [
        Track(
          id: 'track-v1',
          items: [
            const ClipItem(
              id: 'clip-1',
              assetId: 'asset-1',
              timelineStartTime: 0,
              trim: TrimRange(start: 0, end: 800),
              speed: 1.0,
              volume: 0.0,
              filters: [
                Filter(type: 'snap_zoom', params: {'strength': 1.5})
              ],
            ),
            const TransitionItem(
              id: 'trans-1',
              transitionType: 'whip_pan',
              duration: 200,
            ),
            const ClipItem(
              id: 'clip-2',
              assetId: 'asset-1',
              timelineStartTime: 800,
              trim: TrimRange(start: 800, end: 1600),
              speed: 1.0,
              volume: 0.0,
            ),
            const TransitionItem(
              id: 'trans-2',
              transitionType: 'whip_pan',
              duration: 200,
            ),
            const ClipItem(
              id: 'clip-3',
              assetId: 'asset-1',
              timelineStartTime: 1600,
              trim: TrimRange(start: 1600, end: 2400),
              speed: 1.0,
              volume: 0.0,
              filters: [
                Filter(type: 'snap_zoom', params: {'strength': 1.3})
              ],
            ),
          ],
        ),
      ],
      captions: const [
        Caption(
          id: 'cap-1',
          text: 'NEW PR',
          startTime: 100,
          endTime: 700,
          preset: 'hormozi_bold',
          x: 0.5,
          y: 0.8,
        ),
        Caption(
          id: 'cap-2',
          text: 'LETS GO',
          startTime: 900,
          endTime: 1500,
          preset: 'kinetic',
          x: 0.5,
          y: 0.75,
        ),
      ],
    ),
    aiInstructions: const AIInstructions(
      originalPrompt: 'Make this a hype gym reel',
      styleReferenceId: 'fitness_v1',
      engineVersion: 'v1.0',
      aiAppliedFilters: const ['StyleDNA'],
    ),
  );
}

IntelligenceReport _buildFitnessReport() {
  return IntelligenceReport(
    videoId: 'asset-1',
    scenes: const [
      SceneDetection(sceneStart: 0, sceneEnd: 800, confidence: 0.9),
      SceneDetection(sceneStart: 800, sceneEnd: 1600, confidence: 0.88),
      SceneDetection(sceneStart: 1600, sceneEnd: 2400, confidence: 0.87),
    ],
    beats: const [
      BeatDetection(beatTimestamp: 800, confidence: 0.9),
      BeatDetection(beatTimestamp: 1600, confidence: 0.88),
    ],
    highlights: const [
      HighlightDetection(timestamp: 400, score: 0.92),
      HighlightDetection(timestamp: 1200, score: 0.88),
      HighlightDetection(timestamp: 2000, score: 0.9),
    ],
  );
}

ProjectSchema _buildEmptyProject() {
  return ProjectSchema(
    schemaVersion: '1.0',
    projectId: 'project_empty',
    metadata: const Metadata(
      title: 'Empty Project',
      createdAt: '2026-06-11T10:00:00Z',
      updatedAt: '2026-06-11T10:00:00Z',
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
  );
}
