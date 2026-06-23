import '../style_dna/style_dna.dart';

/// creator_intent.dart
///
/// Pure domain model for creator intent parsing.
/// This layer does not perform AI inference, networking, or timeline editing.
class CreatorIntent {
  final String prompt;
  final String category;
  final String style;
  final List<String> keywords;
  final StyleDNA? preferredStyle;

  const CreatorIntent({
    required this.prompt,
    required this.category,
    required this.style,
    this.keywords = const [],
    this.preferredStyle,
  });

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'category': category,
        'style': style,
        'keywords': keywords,
        if (preferredStyle != null) 'preferredStyle': preferredStyle!.toJson(),
      };

  factory CreatorIntent.fromJson(Map<String, dynamic> json) => CreatorIntent(
        prompt: json['prompt'] as String,
        category: json['category'] as String,
        style: json['style'] as String,
        keywords:
            (json['keywords'] as List<dynamic>?)?.cast<String>() ?? const [],
        preferredStyle: json['preferredStyle'] != null
            ? StyleDNA.fromJson(json['preferredStyle'] as Map<String, dynamic>)
            : null,
      );
}
