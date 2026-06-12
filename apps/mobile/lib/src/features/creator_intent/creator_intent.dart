/// creator_intent.dart
///
/// Pure domain model for creator intent parsing.
/// This layer does not perform AI inference, networking, or timeline editing.
class CreatorIntent {
  final String prompt;
  final String category;
  final String style;
  final List<String> keywords;

  const CreatorIntent({
    required this.prompt,
    required this.category,
    required this.style,
    this.keywords = const [],
  });

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'category': category,
        'style': style,
        'keywords': keywords,
      };

  factory CreatorIntent.fromJson(Map<String, dynamic> json) => CreatorIntent(
        prompt: json['prompt'] as String,
        category: json['category'] as String,
        style: json['style'] as String,
        keywords:
            (json['keywords'] as List<dynamic>?)?.cast<String>() ?? const [],
      );
}
