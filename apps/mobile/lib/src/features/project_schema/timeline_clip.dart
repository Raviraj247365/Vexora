/// timeline_clip.dart
///
/// Clip and caption definitions for the project schema timeline.
abstract class TimelineItem {
  String get type;
  Map<String, dynamic> toJson();
}

class TrimRange {
  final int start;
  final int end;

  const TrimRange({
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
      };

  factory TrimRange.fromJson(Map<String, dynamic> json) => TrimRange(
        start: json['start'] as int,
        end: json['end'] as int,
      );
}

class Filter {
  final String type;
  final Map<String, dynamic> params;

  const Filter({
    required this.type,
    this.params = const {},
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'params': params,
      };

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        type: json['type'] as String,
        params: json['params'] as Map<String, dynamic>? ?? const {},
      );
}

class ClipItem implements TimelineItem {
  @override
  final String type = 'clip';
  final String id;
  final String assetId;
  final int timelineStartTime;
  final TrimRange trim;
  final double speed;
  final double volume;
  final List<Filter> filters;

  const ClipItem({
    required this.id,
    required this.assetId,
    required this.timelineStartTime,
    required this.trim,
    required this.speed,
    required this.volume,
    this.filters = const [],
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'assetId': assetId,
        'timelineStartTime': timelineStartTime,
        'trim': trim.toJson(),
        'speed': speed,
        'volume': volume,
        'filters': filters.map((f) => f.toJson()).toList(),
      };

  factory ClipItem.fromJson(Map<String, dynamic> json) => ClipItem(
        id: json['id'] as String,
        assetId: json['assetId'] as String,
        timelineStartTime: json['timelineStartTime'] as int,
        trim: TrimRange.fromJson(json['trim'] as Map<String, dynamic>),
        speed: (json['speed'] as num).toDouble(),
        volume: (json['volume'] as num).toDouble(),
        filters: (json['filters'] as List<dynamic>?)
                ?.map((e) => Filter.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

class Caption {
  final String id;
  final String text;
  final int startTime;
  final int endTime;
  final String preset;
  final double x;
  final double y;

  const Caption({
    required this.id,
    required this.text,
    required this.startTime,
    required this.endTime,
    required this.preset,
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'startTime': startTime,
        'endTime': endTime,
        'style': {
          'preset': preset,
          'position': {'x': x, 'y': y},
        },
      };

  factory Caption.fromJson(Map<String, dynamic> json) => Caption(
        id: json['id'] as String,
        text: json['text'] as String,
        startTime: json['startTime'] as int,
        endTime: json['endTime'] as int,
        preset: json['style']['preset'] as String,
        x: (json['style']['position']['x'] as num).toDouble(),
        y: (json['style']['position']['y'] as num).toDouble(),
      );
}
