/// Defines an abstract visual or audio effect.
abstract class VexoraEffect {
  /// Unique identifier for the effect (e.g., 'fx_vhs_glitch').
  String get id;

  /// Human-readable name (e.g., 'VHS Glitch').
  String get name;

  /// The category of the effect (e.g., 'retro', 'color', 'distortion').
  String get category;

  /// A map of parameters this effect accepts.
  /// Key: Parameter name, Value: Parameter schema/default value.
  Map<String, dynamic> get defaultParameters;

  /// Serializes the effect data to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'parameters': defaultParameters,
    };
  }
}

/// A generic implementation of an effect loaded from a style pack.
class CustomEffect extends VexoraEffect {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final Map<String, dynamic> defaultParameters;

  CustomEffect({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultParameters,
  });

  factory CustomEffect.fromMap(Map<String, dynamic> map) {
    return CustomEffect(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'general',
      defaultParameters: Map<String, dynamic>.from(map['parameters'] ?? {}),
    );
  }
}
