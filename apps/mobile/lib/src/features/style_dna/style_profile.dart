import 'style_dna.dart';

/// style_profile.dart
///
/// Public creator style listing for the future Creator Marketplace.
/// A profile wraps [StyleDNA] with social metadata and categorization.
enum StyleCategory {
  fitness,
  gaming,
  travel,
  cinematic,
  cars,
  anime,
  motivation,
  luxury,
  business;

  String get label {
    switch (this) {
      case StyleCategory.fitness:
        return 'Fitness';
      case StyleCategory.gaming:
        return 'Gaming';
      case StyleCategory.travel:
        return 'Travel';
      case StyleCategory.cinematic:
        return 'Cinematic';
      case StyleCategory.cars:
        return 'Cars';
      case StyleCategory.anime:
        return 'Anime';
      case StyleCategory.motivation:
        return 'Motivation';
      case StyleCategory.luxury:
        return 'Luxury';
      case StyleCategory.business:
        return 'Business';
    }
  }

  static StyleCategory fromString(String value) {
    final normalized = value.trim().toLowerCase();
    return StyleCategory.values.firstWhere(
      (category) =>
          category.name == normalized ||
          category.label.toLowerCase() == normalized,
      orElse: () => StyleCategory.cinematic,
    );
  }
}

class StyleProfile {
  final String styleId;
  final String creatorId;
  final String creatorName;
  final String styleName;
  final StyleCategory category;
  final int likes;
  final int copies;
  final int followers;
  final String createdAt;
  final StyleDNA styleDNA;

  const StyleProfile({
    required this.styleId,
    required this.creatorId,
    required this.creatorName,
    required this.styleName,
    required this.category,
    this.likes = 0,
    this.copies = 0,
    this.followers = 0,
    required this.createdAt,
    required this.styleDNA,
  });

  Map<String, dynamic> toJson() => {
        'styleId': styleId,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'styleName': styleName,
        'category': category.label,
        'likes': likes,
        'copies': copies,
        'followers': followers,
        'createdAt': createdAt,
        'styleDNA': styleDNA.toJson(),
      };

  factory StyleProfile.fromJson(Map<String, dynamic> json) => StyleProfile(
        styleId: json['styleId'] as String,
        creatorId: json['creatorId'] as String,
        creatorName: json['creatorName'] as String,
        styleName: json['styleName'] as String,
        category: StyleCategory.fromString(json['category'] as String),
        likes: json['likes'] as int? ?? 0,
        copies: json['copies'] as int? ?? 0,
        followers: json['followers'] as int? ?? 0,
        createdAt: json['createdAt'] as String,
        styleDNA: StyleDNA.fromJson(json['styleDNA'] as Map<String, dynamic>),
      );

  StyleProfile copyWith({
    String? styleId,
    String? creatorId,
    String? creatorName,
    String? styleName,
    StyleCategory? category,
    int? likes,
    int? copies,
    int? followers,
    String? createdAt,
    StyleDNA? styleDNA,
  }) =>
      StyleProfile(
        styleId: styleId ?? this.styleId,
        creatorId: creatorId ?? this.creatorId,
        creatorName: creatorName ?? this.creatorName,
        styleName: styleName ?? this.styleName,
        category: category ?? this.category,
        likes: likes ?? this.likes,
        copies: copies ?? this.copies,
        followers: followers ?? this.followers,
        createdAt: createdAt ?? this.createdAt,
        styleDNA: styleDNA ?? this.styleDNA,
      );
}
