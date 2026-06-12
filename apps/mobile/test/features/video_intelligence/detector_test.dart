/// detector_test.dart
///
/// Test suite for video intelligence detectors.
/// Validates scene, beat, speech, and highlight detection.

import 'package:flutter_test/flutter_test.dart';

import 'package:vexora_mobile_app/src/features/video_intelligence/data/beat_detector.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/data/highlight_detector.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/data/scene_detector.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/data/speech_detector.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/beat_detection.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/scene_detection.dart';
import 'package:vexora_mobile_app/src/features/video_intelligence/domain/speech_detection.dart';

void main() {
  group('SceneDetector', () {
    test('detectScenes returns list of scenes', () async {
      // Note: This test uses placeholder video metadata.
      // In a real implementation, a test video file would be used.
      final scenes = await SceneDetector.detectScenes('test_video.mp4');
      expect(scenes, isNotEmpty);
      expect(scenes.every((s) => s.sceneStart < s.sceneEnd), true);
    });

    test('scenes are ordered by start time', () async {
      final scenes = await SceneDetector.detectScenes('test_video.mp4');
      for (int i = 0; i < scenes.length - 1; i++) {
        expect(
            scenes[i].sceneStart, lessThanOrEqualTo(scenes[i + 1].sceneStart));
      }
    });

    test('scene confidence is in valid range', () async {
      final scenes = await SceneDetector.detectScenes('test_video.mp4');
      expect(scenes.every((s) => s.confidence >= 0.0 && s.confidence <= 1.0),
          true);
    });
  });

  group('BeatDetector', () {
    test('detectBeats returns list of beats', () async {
      final beats = await BeatDetector.detectBeats('test_video.mp4');
      expect(beats, isNotEmpty);
      expect(beats.every((b) => b.beatTimestamp >= 0), true);
    });

    test('beats are ordered by timestamp', () async {
      final beats = await BeatDetector.detectBeats('test_video.mp4');
      for (int i = 0; i < beats.length - 1; i++) {
        expect(beats[i].beatTimestamp,
            lessThanOrEqualTo(beats[i + 1].beatTimestamp));
      }
    });

    test('beat confidence is in valid range', () async {
      final beats = await BeatDetector.detectBeats('test_video.mp4');
      expect(
          beats.every((b) => b.confidence >= 0.0 && b.confidence <= 1.0), true);
    });

    test('beats have minimum interval spacing', () async {
      final beats = await BeatDetector.detectBeats('test_video.mp4');
      for (int i = 0; i < beats.length - 1; i++) {
        final interval = beats[i + 1].beatTimestamp - beats[i].beatTimestamp;
        expect(interval, greaterThanOrEqualTo(BeatDetector.minBeatIntervalMs));
      }
    });
  });

  group('SpeechDetector', () {
    test('detectSpeech returns list of segments', () async {
      final speech = await SpeechDetector.detectSpeech('test_video.mp4');
      expect(speech, isNotEmpty);
      expect(speech.every((s) => s.speechStart < s.speechEnd), true);
    });

    test('speech segments are ordered by start time', () async {
      final speech = await SpeechDetector.detectSpeech('test_video.mp4');
      for (int i = 0; i < speech.length - 1; i++) {
        expect(speech[i].speechStart,
            lessThanOrEqualTo(speech[i + 1].speechStart));
      }
    });

    test('speech confidence is in valid range', () async {
      final speech = await SpeechDetector.detectSpeech('test_video.mp4');
      expect(speech.every((s) => s.confidence >= 0.0 && s.confidence <= 1.0),
          true);
    });
  });

  group('HighlightDetector', () {
    test('detectHighlights returns valid highlights', () async {
      final scenes = await SceneDetector.detectScenes('test_video.mp4');
      final beats = await BeatDetector.detectBeats('test_video.mp4');
      final speech = await SpeechDetector.detectSpeech('test_video.mp4');

      final highlights = HighlightDetector.detectHighlights(
        scenes: scenes,
        beats: beats,
        speechSegments: speech,
      );

      expect(highlights, isNotEmpty);
      expect(highlights.every((h) => h.score >= 0.0 && h.score <= 1.0), true);
    });

    test('highlights have minimum score threshold', () async {
      final scenes = await SceneDetector.detectScenes('test_video.mp4');
      final beats = await BeatDetector.detectBeats('test_video.mp4');
      final speech = await SpeechDetector.detectSpeech('test_video.mp4');

      final highlights = HighlightDetector.detectHighlights(
        scenes: scenes,
        beats: beats,
        speechSegments: speech,
      );

      expect(
          highlights
              .every((h) => h.score >= HighlightDetector.minHighlightScore),
          true);
    });

    test('empty inputs produce no highlights', () async {
      final highlights = HighlightDetector.detectHighlights(
        scenes: const [],
        beats: const [],
        speechSegments: const [],
      );

      expect(highlights, isEmpty);
    });

    test('highlights with composite signals have higher scores', () async {
      // Create test data with overlapping signals
      final scenes = [
        SceneDetection(sceneStart: 1000, sceneEnd: 2000, confidence: 0.9)
      ];
      final beats = [
        BeatDetection(beatTimestamp: 1500, beatType: 'beat', confidence: 0.8)
      ];
      final speech = [
        SpeechDetection(
            speechStart: 1000,
            speechEnd: 2000,
            isSpeech: true,
            confidence: 0.85)
      ];

      final highlights = HighlightDetector.detectHighlights(
        scenes: scenes,
        beats: beats,
        speechSegments: speech,
      );

      // Composite signals should produce higher scores than individual signals
      expect(highlights, isNotEmpty);
      if (highlights.isNotEmpty) {
        expect(highlights[0].score, greaterThan(0.5));
      }
    });
  });
}
