import 'face_detection.dart';
import 'beat_detection.dart';
import 'highlight_detection.dart';
import 'scene_detection.dart';
import 'speech_detection.dart';

/// intelligence_report.dart
///
/// Central metadata source for the Video Intelligence Layer.
/// This report contains analysis outcomes and is the only output from the layer.
class IntelligenceReport {
  final String videoId;
  final List<SceneDetection> scenes;
  final List<BeatDetection> beats;
  final List<FaceDetection> faces;
  final List<SpeechDetection> speech;
  final List<HighlightDetection> highlights;

  const IntelligenceReport({
    required this.videoId,
    this.scenes = const [],
    this.beats = const [],
    this.faces = const [],
    this.speech = const [],
    this.highlights = const [],
  });

  Map<String, dynamic> toJson() => {
        'videoId': videoId,
        'scenes': scenes.map((scene) => scene.toJson()).toList(),
        'beats': beats.map((beat) => beat.toJson()).toList(),
        'faces': faces.map((face) => face.toJson()).toList(),
        'speech': speech.map((segment) => segment.toJson()).toList(),
        'highlights':
            highlights.map((highlight) => highlight.toJson()).toList(),
      };

  factory IntelligenceReport.fromJson(Map<String, dynamic> json) =>
      IntelligenceReport(
        videoId: json['videoId'] as String,
        scenes: (json['scenes'] as List<dynamic>?)
                ?.map((item) =>
                    SceneDetection.fromJson(item as Map<String, dynamic>))
                .toList() ??
            const [],
        beats: (json['beats'] as List<dynamic>?)
                ?.map((item) =>
                    BeatDetection.fromJson(item as Map<String, dynamic>))
                .toList() ??
            const [],
        faces: (json['faces'] as List<dynamic>?)
                ?.map((item) =>
                    FaceDetection.fromJson(item as Map<String, dynamic>))
                .toList() ??
            const [],
        speech: (json['speech'] as List<dynamic>?)
                ?.map((item) =>
                    SpeechDetection.fromJson(item as Map<String, dynamic>))
                .toList() ??
            const [],
        highlights: (json['highlights'] as List<dynamic>?)
                ?.map((item) =>
                    HighlightDetection.fromJson(item as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
