/// beat_detection.dart
///
/// Domain model for a detected beat timestamp in a source video.
/// The Video Intelligence Layer uses beat metadata to surface music rhythm peaks,
/// drops, and other timing cues without modifying the underlying video.
class BeatDetection {
  final int beatTimestamp;
  final String beatType;
  final double confidence;

  const BeatDetection({
    required this.beatTimestamp,
    this.beatType = 'beat',
    this.confidence = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'beatTimestamp': beatTimestamp,
        'beatType': beatType,
        'confidence': confidence,
      };

  factory BeatDetection.fromJson(Map<String, dynamic> json) => BeatDetection(
        beatTimestamp: json['beatTimestamp'] as int,
        beatType: json['beatType'] as String? ?? 'beat',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      );
}
