/// Defines an abstract transition between two clips.
abstract class VexoraTransition {
  /// Unique identifier for the transition (e.g., 'tr_cross_dissolve').
  String get id;

  /// Human-readable name.
  String get name;

  /// Recommended duration in milliseconds.
  int get defaultDurationMs;

  /// Whether this transition requires the clips to overlap.
  bool get requiresOverlap;

  /// Easing curve representation (e.g., 'ease-in-out').
  String get easingCurve;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'defaultDurationMs': defaultDurationMs,
      'requiresOverlap': requiresOverlap,
      'easingCurve': easingCurve,
    };
  }
}

/// A generic implementation of a transition loaded from a style pack.
class CustomTransition extends VexoraTransition {
  @override
  final String id;
  @override
  final String name;
  @override
  final int defaultDurationMs;
  @override
  final bool requiresOverlap;
  @override
  final String easingCurve;

  CustomTransition({
    required this.id,
    required this.name,
    this.defaultDurationMs = 500,
    this.requiresOverlap = true,
    this.easingCurve = 'linear',
  });

  factory CustomTransition.fromMap(Map<String, dynamic> map) {
    return CustomTransition(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      defaultDurationMs: map['defaultDurationMs'] ?? 500,
      requiresOverlap: map['requiresOverlap'] ?? true,
      easingCurve: map['easingCurve'] ?? 'linear',
    );
  }
}
