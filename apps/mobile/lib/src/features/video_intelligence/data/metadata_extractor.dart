import '../domain/beat_detection.dart';
import '../domain/face_detection.dart';
import '../domain/highlight_detection.dart';
import '../domain/intelligence_report.dart';
import '../domain/scene_detection.dart';
import '../domain/speech_detection.dart';
import 'beat_detector.dart';
import 'highlight_detector.dart';
import 'scene_detector.dart';
import 'speech_detector.dart';

/// metadata_extractor.dart
///
/// Abstract contract for metadata extraction in the Video Intelligence Layer.
/// Implementations may be local, cloud, or future hybrid workers.
abstract class MetadataExtractor {
  Future<List<SceneDetection>> extractScenes(String videoPath);

  Future<List<BeatDetection>> extractBeats(String videoPath);

  Future<List<SpeechDetection>> extractSpeechSegments(String videoPath);

  Future<List<FaceDetection>> extractFaces(String videoPath);

  Future<List<HighlightDetection>> extractHighlights(String videoPath);

  Future<IntelligenceReport> extractIntelligence({
    required String videoId,
    required String videoPath,
  }) async {
    final scenes = await extractScenes(videoPath);
    final beats = await extractBeats(videoPath);
    final speech = await extractSpeechSegments(videoPath);
    final faces = await extractFaces(videoPath);
    final highlights = await extractHighlights(videoPath);

    return IntelligenceReport(
      videoId: videoId,
      scenes: scenes,
      beats: beats,
      speech: speech,
      faces: faces,
      highlights: highlights,
    );
  }
}

/// Local metadata extractor implementation.
/// Uses deterministic, on-device detectors for scene, beat, speech, and highlight extraction.
/// Does not require AI models, cloud services, or timeline mutations.
class LocalMetadataExtractor extends MetadataExtractor {
  LocalMetadataExtractor();

  @override
  Future<List<SceneDetection>> extractScenes(String videoPath) async {
    return SceneDetector.detectScenes(videoPath);
  }

  @override
  Future<List<BeatDetection>> extractBeats(String videoPath) async {
    return BeatDetector.detectBeats(videoPath);
  }

  @override
  Future<List<SpeechDetection>> extractSpeechSegments(String videoPath) async {
    return SpeechDetector.detectSpeech(videoPath);
  }

  @override
  Future<List<FaceDetection>> extractFaces(String videoPath) async {
    // Face detection deferred to Phase 5
    return const [];
  }

  @override
  Future<List<HighlightDetection>> extractHighlights(String videoPath) async {
    // Extract component signals
    final scenes = await extractScenes(videoPath);
    final beats = await extractBeats(videoPath);
    final speech = await extractSpeechSegments(videoPath);

    // Composite highlight detection
    return HighlightDetector.detectHighlights(
      scenes: scenes,
      beats: beats,
      speechSegments: speech,
    );
  }
}

/// Cloud metadata extractor implementation.
/// This is a contract placeholder for future remote or cloud-backed metadata workflows.
class CloudMetadataExtractor extends MetadataExtractor {
  CloudMetadataExtractor();

  @override
  Future<List<SceneDetection>> extractScenes(String videoPath) async {
    return const [];
  }

  @override
  Future<List<BeatDetection>> extractBeats(String videoPath) async {
    return const [];
  }

  @override
  Future<List<SpeechDetection>> extractSpeechSegments(String videoPath) async {
    return const [];
  }

  @override
  Future<List<FaceDetection>> extractFaces(String videoPath) async {
    return const [];
  }

  @override
  Future<List<HighlightDetection>> extractHighlights(String videoPath) async {
    return const [];
  }
}
