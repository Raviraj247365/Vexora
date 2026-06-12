/// face_detection.dart
///
/// Domain model for a detected face position in a source video.
/// This metadata is intended for future auto-zoom, smart crop, and vertical
/// conversion helpers, but this layer never modifies video content.
class FaceDetection {
  final double faceCenterX;
  final double faceCenterY;
  final double boxWidth;
  final double boxHeight;
  final double confidence;

  const FaceDetection({
    required this.faceCenterX,
    required this.faceCenterY,
    this.boxWidth = 0.0,
    this.boxHeight = 0.0,
    this.confidence = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'faceCenterX': faceCenterX,
        'faceCenterY': faceCenterY,
        'boxWidth': boxWidth,
        'boxHeight': boxHeight,
        'confidence': confidence,
      };

  factory FaceDetection.fromJson(Map<String, dynamic> json) => FaceDetection(
        faceCenterX: (json['faceCenterX'] as num).toDouble(),
        faceCenterY: (json['faceCenterY'] as num).toDouble(),
        boxWidth: (json['boxWidth'] as num?)?.toDouble() ?? 0.0,
        boxHeight: (json['boxHeight'] as num?)?.toDouble() ?? 0.0,
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      );
}
