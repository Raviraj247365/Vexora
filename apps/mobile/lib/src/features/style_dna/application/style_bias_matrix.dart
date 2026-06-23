/// style_bias_matrix.dart
///
/// Immutable representation of deterministic editing biases derived from StyleDNA.
/// It scales AI Director heuristics (e.g., cut confidence, zoom likelihood).
class StyleBiasMatrix {
  final double cutAggressiveness; // e.g., 1.5 for fast pace
  final double beatPriority;      // e.g., 2.0 for high beat sync
  final double transitionFrequency;
  final double zoomFrequency;
  final double captionDensity;
  final double motionPreference;
  final double energyBias;

  const StyleBiasMatrix({
    this.cutAggressiveness = 1.0,
    this.beatPriority = 1.0,
    this.transitionFrequency = 1.0,
    this.zoomFrequency = 1.0,
    this.captionDensity = 1.0,
    this.motionPreference = 1.0,
    this.energyBias = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'cutAggressiveness': cutAggressiveness,
        'beatPriority': beatPriority,
        'transitionFrequency': transitionFrequency,
        'zoomFrequency': zoomFrequency,
        'captionDensity': captionDensity,
        'motionPreference': motionPreference,
        'energyBias': energyBias,
      };

  factory StyleBiasMatrix.fromJson(Map<String, dynamic> json) =>
      StyleBiasMatrix(
        cutAggressiveness: (json['cutAggressiveness'] as num?)?.toDouble() ?? 1.0,
        beatPriority: (json['beatPriority'] as num?)?.toDouble() ?? 1.0,
        transitionFrequency: (json['transitionFrequency'] as num?)?.toDouble() ?? 1.0,
        zoomFrequency: (json['zoomFrequency'] as num?)?.toDouble() ?? 1.0,
        captionDensity: (json['captionDensity'] as num?)?.toDouble() ?? 1.0,
        motionPreference: (json['motionPreference'] as num?)?.toDouble() ?? 1.0,
        energyBias: (json['energyBias'] as num?)?.toDouble() ?? 1.0,
      );

  StyleBiasMatrix copyWith({
    double? cutAggressiveness,
    double? beatPriority,
    double? transitionFrequency,
    double? zoomFrequency,
    double? captionDensity,
    double? motionPreference,
    double? energyBias,
  }) =>
      StyleBiasMatrix(
        cutAggressiveness: cutAggressiveness ?? this.cutAggressiveness,
        beatPriority: beatPriority ?? this.beatPriority,
        transitionFrequency: transitionFrequency ?? this.transitionFrequency,
        zoomFrequency: zoomFrequency ?? this.zoomFrequency,
        captionDensity: captionDensity ?? this.captionDensity,
        motionPreference: motionPreference ?? this.motionPreference,
        energyBias: energyBias ?? this.energyBias,
      );
}
