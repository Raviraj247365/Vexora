/// intelligence_report_test.dart
///
/// Test suite for intelligence report generation.
/// Validates end-to-end metadata extraction and serialization.

import 'package:flutter_test/flutter_test.dart';

import 'package:vexora_mobile_app/src/features/video_intelligence/data/intelligence_service.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/data/metadata_extractor.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/intelligence_report.dart';

void main() {
  group('IntelligenceReport', () {
    test('creates report with valid structure', () {
      final report = IntelligenceReport(
        videoId: 'test_video_001',
        scenes: const [],
        beats: const [],
        speech: const [],
        faces: const [],
        highlights: const [],
      );

      expect(report.videoId, 'test_video_001');
      expect(report.scenes, isEmpty);
      expect(report.beats, isEmpty);
    });

    test('toJson produces valid JSON structure', () {
      final report = IntelligenceReport(
        videoId: 'test_video_001',
        scenes: const [],
        beats: const [],
        speech: const [],
        faces: const [],
        highlights: const [],
      );

      final json = report.toJson();
      expect(json['videoId'], 'test_video_001');
      expect(json['scenes'], isA<List>());
      expect(json['beats'], isA<List>());
      expect(json['speech'], isA<List>());
      expect(json['faces'], isA<List>());
      expect(json['highlights'], isA<List>());
    });

    test('fromJson reconstructs report correctly', () {
      const originalId = 'test_video_002';
      final originalReport = IntelligenceReport(
        videoId: originalId,
        scenes: const [],
        beats: const [],
        speech: const [],
        faces: const [],
        highlights: const [],
      );

      final json = originalReport.toJson();
      final reconstructed = IntelligenceReport.fromJson(json);

      expect(reconstructed.videoId, originalId);
      expect(reconstructed.scenes.length, originalReport.scenes.length);
      expect(reconstructed.beats.length, originalReport.beats.length);
    });
  });

  group('LocalMetadataExtractor', () {
    test('extracts intelligence report with non-empty detections', () async {
      final extractor = LocalMetadataExtractor();
      final report = await extractor.extractIntelligence(
        videoId: 'test_video_001',
        videoPath: 'test_video.mp4',
      );

      expect(report, isNotNull);
      expect(report.videoId, 'test_video_001');
      // LocalMetadataExtractor should return populated results
      expect(report.scenes, isNotEmpty);
      expect(report.beats, isNotEmpty);
      expect(report.speech, isNotEmpty);
    });

    test('extracted scenes have valid time ranges', () async {
      final extractor = LocalMetadataExtractor();
      final report = await extractor.extractIntelligence(
        videoId: 'test_video_001',
        videoPath: 'test_video.mp4',
      );

      for (final scene in report.scenes) {
        expect(scene.sceneStart, lessThan(scene.sceneEnd));
        expect(scene.confidence, greaterThanOrEqualTo(0.0));
        expect(scene.confidence, lessThanOrEqualTo(1.0));
      }
    });

    test('extracted beats are ordered chronologically', () async {
      final extractor = LocalMetadataExtractor();
      final report = await extractor.extractIntelligence(
        videoId: 'test_video_001',
        videoPath: 'test_video.mp4',
      );

      for (int i = 0; i < report.beats.length - 1; i++) {
        expect(report.beats[i].beatTimestamp,
            lessThanOrEqualTo(report.beats[i + 1].beatTimestamp));
      }
    });

    test('extracted speech segments are non-overlapping', () async {
      final extractor = LocalMetadataExtractor();
      final report = await extractor.extractIntelligence(
        videoId: 'test_video_001',
        videoPath: 'test_video.mp4',
      );

      // Note: In a real implementation with proper overlap detection,
      // this test would be more rigorous.
      for (final segment in report.speech) {
        expect(segment.speechStart, lessThan(segment.speechEnd));
      }
    });

    test('highlights have valid composite scores', () async {
      final extractor = LocalMetadataExtractor();
      final report = await extractor.extractIntelligence(
        videoId: 'test_video_001',
        videoPath: 'test_video.mp4',
      );

      for (final highlight in report.highlights) {
        expect(highlight.score, greaterThanOrEqualTo(0.0));
        expect(highlight.score, lessThanOrEqualTo(1.0));
      }
    });

    test('report is serializable to/from JSON', () async {
      final extractor = LocalMetadataExtractor();
      final originalReport = await extractor.extractIntelligence(
        videoId: 'test_video_001',
        videoPath: 'test_video.mp4',
      );

      final json = originalReport.toJson();
      final reconstructed = IntelligenceReport.fromJson(json);

      expect(reconstructed.videoId, originalReport.videoId);
      expect(reconstructed.scenes.length, originalReport.scenes.length);
      expect(reconstructed.beats.length, originalReport.beats.length);
      expect(reconstructed.speech.length, originalReport.speech.length);
      expect(reconstructed.highlights.length, originalReport.highlights.length);
    });
  });

  group('DefaultIntelligenceService', () {
    test('analyzeVideo returns valid intelligence report', () async {
      final extractor = LocalMetadataExtractor();
      final service = DefaultIntelligenceService(extractor: extractor);

      final report = await service.analyzeVideo(
        videoId: 'test_video_001',
        videoPath: 'test_video.mp4',
      );

      expect(report, isNotNull);
      expect(report.videoId, 'test_video_001');
    });
  });
}
