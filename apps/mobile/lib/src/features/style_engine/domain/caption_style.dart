/// Defines the styling rules for auto-generated captions.
class CaptionStyle {
  final String id;
  final String name;
  final String fontFamily;
  final double fontSize;
  final String primaryColorHex;
  final String highlightColorHex;
  final String animationType; // e.g., 'pop', 'fade', 'typewriter'
  final bool uppercase;

  const CaptionStyle({
    required this.id,
    required this.name,
    required this.fontFamily,
    required this.fontSize,
    required this.primaryColorHex,
    required this.highlightColorHex,
    required this.animationType,
    required this.uppercase,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'primaryColorHex': primaryColorHex,
      'highlightColorHex': highlightColorHex,
      'animationType': animationType,
      'uppercase': uppercase,
    };
  }

  factory CaptionStyle.fromMap(Map<String, dynamic> map) {
    return CaptionStyle(
      id: map['id'] ?? 'default_caption',
      name: map['name'] ?? 'Default Caption',
      fontFamily: map['fontFamily'] ?? 'Inter',
      fontSize: (map['fontSize'] ?? 24.0).toDouble(),
      primaryColorHex: map['primaryColorHex'] ?? '#FFFFFF',
      highlightColorHex: map['highlightColorHex'] ?? '#00E5FF',
      animationType: map['animationType'] ?? 'pop',
      uppercase: map['uppercase'] ?? true,
    );
  }
}
