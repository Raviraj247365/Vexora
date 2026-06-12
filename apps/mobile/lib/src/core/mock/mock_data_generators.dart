import 'dart:math';

/// Generates mock data for visual UI tests.
class MockDataGenerators {
  static final _random = Random();

  /// Generates a list of random values representing an audio waveform.
  static List<double> generateWaveform(int count,
      {double min = 0.1, double max = 1.0}) {
    return List.generate(
        count, (_) => min + _random.nextDouble() * (max - min));
  }

  /// Generates a list of random scene durations in milliseconds.
  static List<int> generateSceneDurations(int count,
      {int minMs = 2000, int maxMs = 8000}) {
    return List.generate(count, (_) => minMs + _random.nextInt(maxMs - minMs));
  }

  /// Randomly generates mock tags.
  static List<String> generateTags(int count) {
    const availableTags = [
      'Action',
      'Dialogue',
      'Silent',
      'B-Roll',
      'Establishing',
      'Close-up',
      'Fast Paced',
      'Vlog'
    ];
    final shuffled = List.of(availableTags)..shuffle();
    return shuffled.take(count).toList();
  }
}
