import 'edit_style.dart';

/// Global registry managing unlimited community and native styles.
class StyleRegistry {
  final Map<String, EditStyle> _styles = {};

  static final StyleRegistry _instance = StyleRegistry._internal();

  factory StyleRegistry() => _instance;

  StyleRegistry._internal() {
    // Built-in styles will be registered here.
  }

  /// Registers a new style into the engine.
  void registerStyle(EditStyle style) {
    _styles[style.id] = style;
  }

  /// Retrieves a style by its ID.
  EditStyle? getStyle(String id) {
    return _styles[id];
  }

  /// Returns all currently loaded styles.
  List<EditStyle> getAllStyles() {
    return _styles.values.toList();
  }

  /// Removes a style from the registry.
  void removeStyle(String id) {
    _styles.remove(id);
  }
}
