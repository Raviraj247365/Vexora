/// blueprint_style_hints.dart
///
/// Immutable hints attached to an EditBlueprint derived from StyleDNA.
/// It provides styling guidance to the TimelineEngine without breaking
/// serialization or execution contracts.
class BlueprintStyleHints {
  final String pace;
  final String transitionStyle;
  final String zoomStyle;
  final String captionStyle;
  final bool beatSync;

  const BlueprintStyleHints({
    required this.pace,
    required this.transitionStyle,
    required this.zoomStyle,
    required this.captionStyle,
    required this.beatSync,
  });

  Map<String, dynamic> toJson() => {
        'pace': pace,
        'transitionStyle': transitionStyle,
        'zoomStyle': zoomStyle,
        'captionStyle': captionStyle,
        'beatSync': beatSync,
      };

  factory BlueprintStyleHints.fromJson(Map<String, dynamic> json) =>
      BlueprintStyleHints(
        pace: json['pace'] as String,
        transitionStyle: json['transitionStyle'] as String,
        zoomStyle: json['zoomStyle'] as String,
        captionStyle: json['captionStyle'] as String,
        beatSync: json['beatSync'] as bool,
      );
}
