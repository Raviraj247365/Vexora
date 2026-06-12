/// render_settings.dart
///
/// Immutable render settings for a project schema.
class RenderSettings {
  final String aspectRatio;
  final int fps;
  final int width;
  final int height;
  final String exportFormat;

  const RenderSettings({
    required this.aspectRatio,
    required this.fps,
    required this.width,
    required this.height,
    required this.exportFormat,
  });

  Map<String, dynamic> toJson() => {
        'aspectRatio': aspectRatio,
        'fps': fps,
        'resolution': {
          'width': width,
          'height': height,
        },
        'exportFormat': exportFormat,
      };

  factory RenderSettings.fromJson(Map<String, dynamic> json) => RenderSettings(
        aspectRatio: json['aspectRatio'] as String,
        fps: json['fps'] as int,
        width: json['resolution']['width'] as int,
        height: json['resolution']['height'] as int,
        exportFormat: json['exportFormat'] as String,
      );
}
