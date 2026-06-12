import 'effect_contract.dart';

/// Central registry for managing the 50+ available effects.
class EffectRegistry {
  final Map<String, VexoraEffect> _effects = {};

  static final EffectRegistry _instance = EffectRegistry._internal();

  factory EffectRegistry() => _instance;

  EffectRegistry._internal() {
    _registerBuiltInEffects();
  }

  void registerEffect(VexoraEffect effect) {
    _effects[effect.id] = effect;
  }

  VexoraEffect? getEffect(String id) {
    return _effects[id];
  }

  List<VexoraEffect> getAllEffects() {
    return _effects.values.toList();
  }

  /// Registers a core set of effects natively supported by Vexora.
  void _registerBuiltInEffects() {
    registerEffect(CustomEffect(
      id: 'fx_vhs_glitch',
      name: 'VHS Glitch',
      category: 'retro',
      defaultParameters: {'intensity': 0.8, 'scanlines': true},
    ));
    registerEffect(CustomEffect(
      id: 'fx_chromatic_aberration',
      name: 'Chromatic Aberration',
      category: 'distortion',
      defaultParameters: {'offset': 0.05, 'angle': 45.0},
    ));
    registerEffect(CustomEffect(
      id: 'fx_lens_flare',
      name: 'Cinematic Lens Flare',
      category: 'light',
      defaultParameters: {'brightness': 1.2, 'color': '#FFAA00'},
    ));
    registerEffect(CustomEffect(
      id: 'fx_film_grain',
      name: 'Film Grain 35mm',
      category: 'texture',
      defaultParameters: {'opacity': 0.3, 'size': 1.5},
    ));
    // Simulated placeholder for 46 more effects...
  }
}
