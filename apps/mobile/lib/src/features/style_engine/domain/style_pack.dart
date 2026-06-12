import 'dart:convert';
import 'edit_style.dart';

/// A wrapper for an EditStyle that makes it suitable for the marketplace.
class StylePack {
  final String version;
  final String author;
  final String previewUrl;
  final EditStyle style;

  const StylePack({
    required this.version,
    required this.author,
    required this.previewUrl,
    required this.style,
  });

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'author': author,
      'previewUrl': previewUrl,
      'style': style.toMap(),
    };
  }

  factory StylePack.fromMap(Map<String, dynamic> map) {
    return StylePack(
      version: map['version'] ?? '1.0.0',
      author: map['author'] ?? 'Vexora Creator',
      previewUrl: map['previewUrl'] ?? '',
      style: EditStyle.fromMap(map['style'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory StylePack.fromJson(String source) =>
      StylePack.fromMap(json.decode(source));
}
