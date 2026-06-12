import 'transition_contract.dart';

/// Central registry for managing the 30+ available transitions.
class TransitionRegistry {
  final Map<String, VexoraTransition> _transitions = {};

  static final TransitionRegistry _instance = TransitionRegistry._internal();

  factory TransitionRegistry() => _instance;

  TransitionRegistry._internal() {
    _registerBuiltInTransitions();
  }

  void registerTransition(VexoraTransition transition) {
    _transitions[transition.id] = transition;
  }

  VexoraTransition? getTransition(String id) {
    return _transitions[id];
  }

  List<VexoraTransition> getAllTransitions() {
    return _transitions.values.toList();
  }

  /// Registers a core set of transitions natively supported by Vexora.
  void _registerBuiltInTransitions() {
    registerTransition(CustomTransition(
      id: 'tr_cross_dissolve',
      name: 'Cross Dissolve',
      defaultDurationMs: 600,
      requiresOverlap: true,
      easingCurve: 'linear',
    ));
    registerTransition(CustomTransition(
      id: 'tr_whip_pan',
      name: 'Whip Pan Right',
      defaultDurationMs: 400,
      requiresOverlap: false,
      easingCurve: 'ease-out-cubic',
    ));
    registerTransition(CustomTransition(
      id: 'tr_zoom_blur',
      name: 'Zoom Blur In',
      defaultDurationMs: 500,
      requiresOverlap: true,
      easingCurve: 'ease-in-out',
    ));
    // Simulated placeholder for 27 more transitions...
  }
}
