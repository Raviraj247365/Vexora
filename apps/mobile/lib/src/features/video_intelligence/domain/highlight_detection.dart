/// highlight_detection.dart
///
/// Domain model for a detected highlight moment in a source video.
/// A highlight may be used to identify exciting motion peaks, beat drops,
/// or speech emphasis during analysis.
class HighlightDetection {
  final double score;
  final int timestamp;
  final String reason;

  const HighlightDetection({
    required this.score,
    required this.timestamp,
    this.reason = 'highlight',
  });

  Map<String, dynamic> toJson() => {
        'score': score,
        'timestamp': timestamp,
        'reason': reason,
      };

  factory HighlightDetection.fromJson(Map<String, dynamic> json) =>
      HighlightDetection(
        score: (json['score'] as num).toDouble(),
        timestamp: json['timestamp'] as int,
        reason: json['reason'] as String? ?? 'highlight',
      );
}
