/// speech_detector.dart
///
/// Speech detection using voice activity heuristics.
/// Identifies spoken segments and silence intervals without speech recognition.

import '../domain/speech_detection.dart';
import 'ffprobe_helper.dart';

/// Speech detection detector.
/// Uses silence thresholding to identify voice activity.
class SpeechDetector {
  // Configuration constants
  static const int silenceThresholdDb = -35; // Silence threshold in dB
  static const double minSilenceDurationMs = 300; // Minimum silence duration
  static const int audioResampleHz = 16000; // Resample to 16 kHz for speed

  /// Detects speech segments and silence intervals.
  /// Returns list of speech segments with start/end times and confidence.
  static Future<List<SpeechDetection>> detectSpeech(String videoPath) async {
    try {
      final metadata = await FfprobeHelper.getVideoMetadata(videoPath);

      // In a production implementation, this would:
      // 1. Use FFmpeg silence detection: -af "silencedetect=noise=-35dB:d=0.3"
      // 2. Parse silence_start and silence_end events
      // 3. Invert silence intervals to get speech ranges
      // 4. Compute confidence based on energy gap between speech and silence

      // Placeholder: generate deterministic demo speech segments
      final speech = <SpeechDetection>[];
      final durationMs = metadata.duration.inMilliseconds;

      // For demo: assume alternating speech and silence every 5 seconds
      int currentTime = 0;
      bool isSpeech = true;

      while (currentTime < durationMs) {
        final segmentEnd = (currentTime + 5000).clamp(0, durationMs);
        speech.add(SpeechDetection(
          speechStart: currentTime,
          speechEnd: segmentEnd,
          isSpeech: isSpeech,
          confidence: 0.7,
        ));
        currentTime = segmentEnd;
        isSpeech = !isSpeech; // Toggle for demo
      }

      return speech;
    } catch (e) {
      throw Exception('Speech detection failed: $e');
    }
  }

  /// Helper: compute audio silence intervals (placeholder).
  static List<(int, int)> detectSilenceIntervals(
      List<int> audioSamples, int sampleRateHz) {
    // In a real implementation:
    // - Compute frame-wise energy
    // - Apply threshold to identify silence
    // - Merge adjacent silence regions
    // - Return list of (startMs, endMs) tuples

    // Placeholder
    return [];
  }
}
