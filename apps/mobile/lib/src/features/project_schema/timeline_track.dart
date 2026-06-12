import 'timeline_clip.dart';
import 'transition.dart';

/// timeline_track.dart
///
/// Track and timeline definitions for the project schema.
class Track {
  final String id;
  final List<TimelineItem> items;

  const Track({
    required this.id,
    this.items = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((item) => item.toJson()).toList(),
      };

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>?)?.map((e) {
            final itemJson = e as Map<String, dynamic>;
            if (itemJson['type'] == 'transition') {
              return TransitionItem.fromJson(itemJson);
            }
            return ClipItem.fromJson(itemJson);
          }).toList() ??
          const [],
    );
  }
}

class Timeline {
  final List<Track> videoTracks;
  final List<Track> audioTracks;
  final List<Caption> captions;

  const Timeline({
    this.videoTracks = const [],
    this.audioTracks = const [],
    this.captions = const [],
  });

  Map<String, dynamic> toJson() => {
        'videoTracks': videoTracks.map((track) => track.toJson()).toList(),
        'audioTracks': audioTracks.map((track) => track.toJson()).toList(),
        'captions': captions.map((caption) => caption.toJson()).toList(),
      };

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        videoTracks: (json['videoTracks'] as List<dynamic>?)
                ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        audioTracks: (json['audioTracks'] as List<dynamic>?)
                ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        captions: (json['captions'] as List<dynamic>?)
                ?.map((e) => Caption.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
