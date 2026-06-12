/// scene_detection.dart
///
/// Domain model for a detected scene in a source video.
/// This metadata is intended for AI editing helpers and analysis views only.
class SceneDetection {
  final int sceneStart;
  final int sceneEnd;
  final String transitionType;
  final double confidence;

  const SceneDetection({
    required this.sceneStart,
    required this.sceneEnd,
    this.transitionType = 'hard_cut',
    this.confidence = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'sceneStart': sceneStart,
        'sceneEnd': sceneEnd,
        'transitionType': transitionType,
        'confidence': confidence,
      };

  factory SceneDetection.fromJson(Map<String, dynamic> json) => SceneDetection(
        sceneStart: json['sceneStart'] as int,
        sceneEnd: json['sceneEnd'] as int,
        transitionType: json['transitionType'] as String? ?? 'hard_cut',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      );
}
