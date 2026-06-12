import 'timeline_clip.dart';

/// transition.dart
///
/// Transition definition for the project schema timeline.
class TransitionItem implements TimelineItem {
  @override
  final String type = 'transition';
  final String id;
  final String transitionType;
  final int duration;

  const TransitionItem({
    required this.id,
    required this.transitionType,
    required this.duration,
  });

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'transitionType': transitionType,
        'duration': duration,
      };

  factory TransitionItem.fromJson(Map<String, dynamic> json) => TransitionItem(
        id: json['id'] as String,
        transitionType: json['transitionType'] as String,
        duration: json['duration'] as int,
      );
}
