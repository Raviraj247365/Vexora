/// highlight_detector.dart
///
/// Highlight detection using composite scoring of scene changes, beats, and speech.
/// Produces salient edit points for video composition.

import '../domain/highlight_detection.dart';
import '../domain/scene_detection.dart';
import '../domain/beat_detection.dart';
import '../domain/speech_detection.dart';

/// Highlight detection detector.
/// Combines scene, beat, and speech signals to identify edit-worthy moments.
class HighlightDetector {
  // Weighting constants for composite score
  static const double sceneWeight = 0.35;
  static const double beatWeight = 0.35;
  static const double speechWeight = 0.30;

  // Aggregation window
  static const int highlightWindowMs = 2000;
  static const double minHighlightScore = 0.50;

  /// Detects highlights by combining scene, beat, and speech signals.
  /// Returns list of highlight regions with composite scores.
  static List<HighlightDetection> detectHighlights({
    required List<SceneDetection> scenes,
    required List<BeatDetection> beats,
    required List<SpeechDetection> speechSegments,
  }) {
    final highlights = <HighlightDetection>[];

    // Collect all candidate timestamps with their normalized scores
    final candidates = <int, (double score, String reason)>{};

    // Scene contributions: scene boundaries get high priority
    for (final scene in scenes) {
      final sceneScore = scene.confidence * sceneWeight;
      candidates[scene.sceneStart] = (
        sceneScore,
        'scene_change',
      );
    }

    // Beat contributions: beat peaks for rhythmic emphasis
    for (final beat in beats) {
      final beatScore = beat.confidence * beatWeight;
      if (candidates.containsKey(beat.beatTimestamp)) {
        final (existing, _) = candidates[beat.beatTimestamp]!;
        candidates[beat.beatTimestamp] = (existing + beatScore, 'beat_peak');
      } else {
        candidates[beat.beatTimestamp] = (beatScore, 'beat_peak');
      }
    }

    // Speech contributions: speech onsets and strong segments
    for (final speech in speechSegments) {
      if (speech.isSpeech) {
        final speechScore = speech.confidence * speechWeight;
        if (candidates.containsKey(speech.speechStart)) {
          final (existing, _) = candidates[speech.speechStart]!;
          candidates[speech.speechStart] = (
            (existing + speechScore).clamp(0.0, 1.0),
            'speech_onset',
          );
        } else {
          candidates[speech.speechStart] = (speechScore, 'speech_onset');
        }
      }
    }

    // Aggregate nearby candidates into highlight regions
    if (candidates.isEmpty) {
      return highlights;
    }

    final sortedTimes = candidates.keys.toList()..sort();
    var currentCluster = <int>[];
    var currentScores = <double>[];
    var currentReasons = <String>[];

    for (final time in sortedTimes) {
      if (currentCluster.isNotEmpty &&
          time - currentCluster.last > highlightWindowMs) {
        // Finalize current cluster
        final compositeScore = currentScores.isEmpty
            ? 0.0
            : currentScores.reduce((a, b) => a + b).clamp(0.0, 1.0);

        if (compositeScore >= minHighlightScore) {
          final startTime = currentCluster.first;
          final reason =
              currentReasons.isNotEmpty ? currentReasons[0] : 'composite';
          highlights.add(HighlightDetection(
            score: compositeScore.clamp(0.0, 1.0),
            timestamp: startTime,
            reason: reason,
          ));
        }

        // Start new cluster
        currentCluster = [time];
        final (score, reason) = candidates[time]!;
        currentScores = [score];
        currentReasons = [reason];
      } else {
        currentCluster.add(time);
        final (score, reason) = candidates[time]!;
        currentScores.add(score);
        currentReasons.add(reason);
      }
    }

    // Finalize last cluster
    if (currentCluster.isNotEmpty) {
      final compositeScore = currentScores.isEmpty
          ? 0.0
          : currentScores.reduce((a, b) => a + b).clamp(0.0, 1.0);

      if (compositeScore >= minHighlightScore) {
        final startTime = currentCluster.first;
        final reason =
            currentReasons.isNotEmpty ? currentReasons[0] : 'composite';
        highlights.add(HighlightDetection(
          score: compositeScore.clamp(0.0, 1.0),
          timestamp: startTime,
          reason: reason,
        ));
      }
    }

    return highlights;
  }
}
