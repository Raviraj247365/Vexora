import 'timeline_track.dart';

/// history_entry.dart
///
/// Immutable history checkpoint for a project schema.
class HistoryEntry {
  final String checkpointId;
  final String timestamp;
  final String description;
  final Timeline timelineSnapshot;

  const HistoryEntry({
    required this.checkpointId,
    required this.timestamp,
    required this.description,
    required this.timelineSnapshot,
  });

  Map<String, dynamic> toJson() => {
        'checkpointId': checkpointId,
        'timestamp': timestamp,
        'description': description,
        'timelineSnapshot': timelineSnapshot.toJson(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        checkpointId: json['checkpointId'] as String,
        timestamp: json['timestamp'] as String,
        description: json['description'] as String,
        timelineSnapshot:
            Timeline.fromJson(json['timelineSnapshot'] as Map<String, dynamic>),
      );
}
