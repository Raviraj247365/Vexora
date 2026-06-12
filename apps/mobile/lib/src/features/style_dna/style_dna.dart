import 'style_metrics.dart';

/// style_dna.dart
///
/// Immutable representation of a reusable creator editing personality.
/// Style DNA is extracted from a finished edit and can be applied to
/// different footage through downstream intent and director layers.
class StyleDNA {
  final String styleId;
  final String name;
  final int energyScore;
  final String pace;
  final double averageCutInterval;
  final String transitionStyle;
  final String zoomStyle;
  final String captionStyle;
  final bool beatSync;
  final int motionIntensity;
  final String creatorId;
  final StyleMetrics metrics;

  const StyleDNA({
    required this.styleId,
    required this.name,
    required this.energyScore,
    required this.pace,
    required this.averageCutInterval,
    required this.transitionStyle,
    required this.zoomStyle,
    required this.captionStyle,
    required this.beatSync,
    required this.motionIntensity,
    required this.creatorId,
    required this.metrics,
  });

  Map<String, dynamic> toJson() => {
        'styleId': styleId,
        'name': name,
        'energyScore': energyScore,
        'pace': pace,
        'averageCutInterval': averageCutInterval,
        'transitionStyle': transitionStyle,
        'zoomStyle': zoomStyle,
        'captionStyle': captionStyle,
        'beatSync': beatSync,
        'motionIntensity': motionIntensity,
        'creatorId': creatorId,
        'metrics': metrics.toJson(),
      };

  factory StyleDNA.fromJson(Map<String, dynamic> json) => StyleDNA(
        styleId: json['styleId'] as String,
        name: json['name'] as String,
        energyScore: json['energyScore'] as int,
        pace: json['pace'] as String,
        averageCutInterval: (json['averageCutInterval'] as num).toDouble(),
        transitionStyle: json['transitionStyle'] as String,
        zoomStyle: json['zoomStyle'] as String,
        captionStyle: json['captionStyle'] as String,
        beatSync: json['beatSync'] as bool,
        motionIntensity: json['motionIntensity'] as int,
        creatorId: json['creatorId'] as String,
        metrics: StyleMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
      );

  StyleDNA copyWith({
    String? styleId,
    String? name,
    int? energyScore,
    String? pace,
    double? averageCutInterval,
    String? transitionStyle,
    String? zoomStyle,
    String? captionStyle,
    bool? beatSync,
    int? motionIntensity,
    String? creatorId,
    StyleMetrics? metrics,
  }) =>
      StyleDNA(
        styleId: styleId ?? this.styleId,
        name: name ?? this.name,
        energyScore: energyScore ?? this.energyScore,
        pace: pace ?? this.pace,
        averageCutInterval: averageCutInterval ?? this.averageCutInterval,
        transitionStyle: transitionStyle ?? this.transitionStyle,
        zoomStyle: zoomStyle ?? this.zoomStyle,
        captionStyle: captionStyle ?? this.captionStyle,
        beatSync: beatSync ?? this.beatSync,
        motionIntensity: motionIntensity ?? this.motionIntensity,
        creatorId: creatorId ?? this.creatorId,
        metrics: metrics ?? this.metrics,
      );
}
