/// asset.dart
///
/// Immutable representation of a project asset.
class Asset {
  final String id;
  final String type;
  final String sourceUrl;
  final String? proxyUrl;
  final int duration;

  const Asset({
    required this.id,
    required this.type,
    required this.sourceUrl,
    this.proxyUrl,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'sourceUrl': sourceUrl,
        'proxyUrl': proxyUrl,
        'duration': duration,
      };

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: json['id'] as String,
        type: json['type'] as String,
        sourceUrl: json['sourceUrl'] as String,
        proxyUrl: json['proxyUrl'] as String?,
        duration: json['duration'] as int,
      );
}
