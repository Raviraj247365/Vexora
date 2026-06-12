/// style_metrics.dart
///
/// Quantitative editing-style measurements derived from a finished project.
/// This model is independent from the Timeline Execution Engine and carries
/// only aggregated statistics — never raw timeline operations.
class StyleMetrics {
  /// Average duration of timeline cuts in seconds.
  final double averageCutDuration;

  /// Transitions per second of finished timeline duration.
  final double transitionFrequency;

  /// Zoom-like effects per second of finished timeline duration.
  final double zoomFrequency;

  /// Captions per minute of finished timeline duration.
  final double captionDensity;

  /// Beat synchronization score in the range [0.0, 100.0].
  final double beatSyncScore;

  /// Motion intensity score in the range [0.0, 100.0].
  final double motionIntensity;

  /// Scene or cut changes per second of finished timeline duration.
  final double sceneChangeFrequency;

  /// Composite energy score in the range [0.0, 100.0].
  final double energyScore;

  const StyleMetrics({
    required this.averageCutDuration,
    required this.transitionFrequency,
    required this.zoomFrequency,
    required this.captionDensity,
    required this.beatSyncScore,
    required this.motionIntensity,
    required this.sceneChangeFrequency,
    required this.energyScore,
  });

  Map<String, dynamic> toJson() => {
        'averageCutDuration': averageCutDuration,
        'transitionFrequency': transitionFrequency,
        'zoomFrequency': zoomFrequency,
        'captionDensity': captionDensity,
        'beatSyncScore': beatSyncScore,
        'motionIntensity': motionIntensity,
        'sceneChangeFrequency': sceneChangeFrequency,
        'energyScore': energyScore,
      };

  factory StyleMetrics.fromJson(Map<String, dynamic> json) => StyleMetrics(
        averageCutDuration: (json['averageCutDuration'] as num).toDouble(),
        transitionFrequency: (json['transitionFrequency'] as num).toDouble(),
        zoomFrequency: (json['zoomFrequency'] as num).toDouble(),
        captionDensity: (json['captionDensity'] as num).toDouble(),
        beatSyncScore: (json['beatSyncScore'] as num).toDouble(),
        motionIntensity: (json['motionIntensity'] as num).toDouble(),
        sceneChangeFrequency: (json['sceneChangeFrequency'] as num).toDouble(),
        energyScore: (json['energyScore'] as num).toDouble(),
      );

  StyleMetrics copyWith({
    double? averageCutDuration,
    double? transitionFrequency,
    double? zoomFrequency,
    double? captionDensity,
    double? beatSyncScore,
    double? motionIntensity,
    double? sceneChangeFrequency,
    double? energyScore,
  }) =>
      StyleMetrics(
        averageCutDuration: averageCutDuration ?? this.averageCutDuration,
        transitionFrequency: transitionFrequency ?? this.transitionFrequency,
        zoomFrequency: zoomFrequency ?? this.zoomFrequency,
        captionDensity: captionDensity ?? this.captionDensity,
        beatSyncScore: beatSyncScore ?? this.beatSyncScore,
        motionIntensity: motionIntensity ?? this.motionIntensity,
        sceneChangeFrequency: sceneChangeFrequency ?? this.sceneChangeFrequency,
        energyScore: energyScore ?? this.energyScore,
      );
}
