import 'effect_contract.dart';
import 'transition_contract.dart';
import 'caption_style.dart';

/// Defines pacing intensity constraints.
class PacingRules {
  final double cutsPerMinute;
  final double beatMatchingIntensity; // 0.0 to 1.0

  const PacingRules({
    required this.cutsPerMinute,
    required this.beatMatchingIntensity,
  });

  Map<String, dynamic> toMap() => {
        'cutsPerMinute': cutsPerMinute,
        'beatMatchingIntensity': beatMatchingIntensity,
      };

  factory PacingRules.fromMap(Map<String, dynamic> map) {
    return PacingRules(
      cutsPerMinute: (map['cutsPerMinute'] ?? 20.0).toDouble(),
      beatMatchingIntensity: (map['beatMatchingIntensity'] ?? 0.8).toDouble(),
    );
  }
}

/// Defines a comprehensive edit style encompassing all visual decisions.
class EditStyle {
  final String id;
  final String name;
  final String description;
  final List<VexoraEffect> allowedEffects;
  final List<VexoraTransition> allowedTransitions;
  final CaptionStyle defaultCaptionStyle;
  final PacingRules pacingRules;
  final String? lutReference; // Path or ID to a Look-Up Table for color grading

  const EditStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.allowedEffects,
    required this.allowedTransitions,
    required this.defaultCaptionStyle,
    required this.pacingRules,
    this.lutReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'allowedEffects': allowedEffects.map((e) => e.toMap()).toList(),
      'allowedTransitions': allowedTransitions.map((t) => t.toMap()).toList(),
      'defaultCaptionStyle': defaultCaptionStyle.toMap(),
      'pacingRules': pacingRules.toMap(),
      'lutReference': lutReference,
    };
  }

  factory EditStyle.fromMap(Map<String, dynamic> map) {
    return EditStyle(
      id: map['id'] ?? 'default_style',
      name: map['name'] ?? 'Default Style',
      description: map['description'] ?? '',
      allowedEffects: (map['allowedEffects'] as List<dynamic>? ?? [])
          .map((e) => CustomEffect.fromMap(e as Map<String, dynamic>))
          .toList(),
      allowedTransitions: (map['allowedTransitions'] as List<dynamic>? ?? [])
          .map((t) => CustomTransition.fromMap(t as Map<String, dynamic>))
          .toList(),
      defaultCaptionStyle:
          CaptionStyle.fromMap(map['defaultCaptionStyle'] ?? {}),
      pacingRules: PacingRules.fromMap(map['pacingRules'] ?? {}),
      lutReference: map['lutReference'],
    );
  }
}
