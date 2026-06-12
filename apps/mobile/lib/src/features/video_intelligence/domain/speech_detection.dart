/// speech_detection.dart
///
/// Domain model for a speech segment detected in a source video.
/// This model can represent both spoken sections and silence sections,
/// depending on the `isSpeech` flag.
class SpeechDetection {
  final int speechStart;
  final int speechEnd;
  final bool isSpeech;
  final double confidence;

  const SpeechDetection({
    required this.speechStart,
    required this.speechEnd,
    this.isSpeech = true,
    this.confidence = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'speechStart': speechStart,
        'speechEnd': speechEnd,
        'isSpeech': isSpeech,
        'confidence': confidence,
      };

  factory SpeechDetection.fromJson(Map<String, dynamic> json) =>
      SpeechDetection(
        speechStart: json['speechStart'] as int,
        speechEnd: json['speechEnd'] as int,
        isSpeech: json['isSpeech'] as bool? ?? true,
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      );
}
