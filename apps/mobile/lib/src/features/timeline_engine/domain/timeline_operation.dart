/// timeline_operation.dart
///
/// Core domain contract for all operations processed by the Timeline Execution Engine.
///
/// Architecture notes:
/// - Every operation that enters the engine must satisfy [TimelineOperation].
/// - Operations are immutable value objects � the engine never mutates them.
/// - [operationId], [timestamp], [confidence], and [source] are mandatory on every op.
/// - Concrete subtypes carry operation-specific parameters via sealed classes.
///
/// Do NOT add rendering or AI logic here. This is pure domain data.

/// Enumerates every supported operation type.
/// New operations must be added here before being handled by the executor.
enum TimelineOperationType {
  cut,
  trim,
  split,
  zoom,
  caption,
  transition,
  filter,
  audioGain,
}

/// The source that produced this operation (AI, user, regeneration, etc.).
enum OperationSource {
  /// Produced by the AI Director engine.
  aiDirector,

  /// Manually triggered by the user in the UI.
  user,

  /// Produced during a regeneration pass.
  regeneration,

  /// Produced during an undo/redo replay.
  replay,
}

/// Base contract for every operation in the engine.
///
/// All subtypes are immutable. The executor will pattern-match on [type].
abstract class TimelineOperation {
  /// Globally unique identifier for this operation instance.
  final String operationId;

  /// UTC timestamp (milliseconds since epoch) when this operation was created.
  final int timestamp;

  /// Confidence score in the range [0.0, 1.0].
  /// User-generated ops should use 1.0. AI ops carry a model confidence score.
  final double confidence;

  /// Who or what produced this operation.
  final OperationSource source;

  /// The target track id this operation applies to (nullable for global ops).
  final String? targetTrackId;

  const TimelineOperation({
    required this.operationId,
    required this.timestamp,
    required this.confidence,
    required this.source,
    this.targetTrackId,
  });

  /// Discriminator used by the executor to dispatch to the correct handler.
  TimelineOperationType get type;

  /// Serializes the operation to JSON for blueprint interchange.
  Map<String, dynamic> toJson();

  /// Deserializes a timeline operation from JSON.
  static TimelineOperation fromJson(Map<String, dynamic> json) {
    final type = TimelineOperationType.values.firstWhere(
      (value) => value.name == json['type'] as String,
      orElse: () =>
          throw ArgumentError('Unsupported operation type: ${json['type']}'),
    );

    final source = OperationSource.values.firstWhere(
      (value) => value.name == json['source'] as String,
      orElse: () => throw ArgumentError(
          'Unsupported operation source: ${json['source']}'),
    );

    final targetTrackId = json['targetTrackId'] as String?;

    switch (type) {
      case TimelineOperationType.cut:
        return CutOperation(
          operationId: json['operationId'] as String,
          timestamp: json['timestamp'] as int,
          confidence: (json['confidence'] as num).toDouble(),
          source: source,
          targetTrackId: targetTrackId,
          startMs: json['startMs'] as int,
          endMs: json['endMs'] as int,
        );
      case TimelineOperationType.trim:
        return TrimOperation(
          operationId: json['operationId'] as String,
          timestamp: json['timestamp'] as int,
          confidence: (json['confidence'] as num).toDouble(),
          source: source,
          targetTrackId: targetTrackId,
          clipId: json['clipId'] as String,
          newTrimStartMs: json['newTrimStartMs'] as int,
          newTrimEndMs: json['newTrimEndMs'] as int,
        );
      case TimelineOperationType.split:
        return SplitOperation(
          operationId: json['operationId'] as String,
          timestamp: json['timestamp'] as int,
          confidence: (json['confidence'] as num).toDouble(),
          source: source,
          targetTrackId: targetTrackId,
          clipId: json['clipId'] as String,
          splitPointMs: json['splitPointMs'] as int,
        );
      case TimelineOperationType.zoom:
        return ZoomOperation(
          operationId: json['operationId'] as String,
          timestamp: json['timestamp'] as int,
          confidence: (json['confidence'] as num).toDouble(),
          source: source,
          targetTrackId: targetTrackId,
          clipId: json['clipId'] as String,
          zoomFactor: (json['zoomFactor'] as num).toDouble(),
          zoomStartMs: json['zoomStartMs'] as int,
          zoomEndMs: json['zoomEndMs'] as int,
        );
      case TimelineOperationType.caption:
        return CaptionOperation(
          operationId: json['operationId'] as String,
          timestamp: json['timestamp'] as int,
          confidence: (json['confidence'] as num).toDouble(),
          source: source,
          targetTrackId: targetTrackId,
          captionId: json['captionId'] as String,
          text: json['text'] as String,
          captionStartMs: json['captionStartMs'] as int,
          captionEndMs: json['captionEndMs'] as int,
          stylePreset: json['stylePreset'] as String,
        );
      case TimelineOperationType.transition:
        return TransitionOperation(
          operationId: json['operationId'] as String,
          timestamp: json['timestamp'] as int,
          confidence: (json['confidence'] as num).toDouble(),
          source: source,
          targetTrackId: targetTrackId,
          beforeClipId: json['beforeClipId'] as String,
          afterClipId: json['afterClipId'] as String,
          transitionType: json['transitionType'] as String,
          durationMs: json['durationMs'] as int,
        );
      case TimelineOperationType.filter:
        return FilterOperation(
          operationId: json['operationId'] as String,
          timestamp: json['timestamp'] as int,
          confidence: (json['confidence'] as num).toDouble(),
          source: source,
          targetTrackId: targetTrackId,
          clipId: json['clipId'] as String,
          filterType: json['filterType'] as String,
          params: Map<String, dynamic>.from(json['params'] as Map),
        );
      case TimelineOperationType.audioGain:
        return AudioGainOperation(
          operationId: json['operationId'] as String,
          timestamp: json['timestamp'] as int,
          confidence: (json['confidence'] as num).toDouble(),
          source: source,
          targetTrackId: targetTrackId,
          targetId: json['targetId'] as String,
          gainDb: (json['gainDb'] as num).toDouble(),
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Concrete Operation Types
// ---------------------------------------------------------------------------

/// Removes a segment of the timeline between [startMs] and [endMs].
class CutOperation extends TimelineOperation {
  final int startMs;
  final int endMs;

  const CutOperation({
    required super.operationId,
    required super.timestamp,
    required super.confidence,
    required super.source,
    super.targetTrackId,
    required this.startMs,
    required this.endMs,
  });

  @override
  TimelineOperationType get type => TimelineOperationType.cut;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
        'startMs': startMs,
        'endMs': endMs,
      };
}

/// Adjusts the in/out trim points of a specific clip.
class TrimOperation extends TimelineOperation {
  final String clipId;
  final int newTrimStartMs;
  final int newTrimEndMs;

  const TrimOperation({
    required super.operationId,
    required super.timestamp,
    required super.confidence,
    required super.source,
    super.targetTrackId,
    required this.clipId,
    required this.newTrimStartMs,
    required this.newTrimEndMs,
  });

  @override
  TimelineOperationType get type => TimelineOperationType.trim;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
        'clipId': clipId,
        'newTrimStartMs': newTrimStartMs,
        'newTrimEndMs': newTrimEndMs,
      };
}

/// Splits a clip into two at the given [splitPointMs].
class SplitOperation extends TimelineOperation {
  final String clipId;
  final int splitPointMs;

  const SplitOperation({
    required super.operationId,
    required super.timestamp,
    required super.confidence,
    required super.source,
    super.targetTrackId,
    required this.clipId,
    required this.splitPointMs,
  });

  @override
  TimelineOperationType get type => TimelineOperationType.split;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
        'clipId': clipId,
        'splitPointMs': splitPointMs,
      };
}

/// Applies a zoom effect to a clip region on the timeline.
class ZoomOperation extends TimelineOperation {
  final String clipId;
  final double zoomFactor;

  /// Start time (ms) within the clip's timeline position where zoom begins.
  final int zoomStartMs;

  /// End time (ms) within the clip's timeline position where zoom ends.
  final int zoomEndMs;

  const ZoomOperation({
    required super.operationId,
    required super.timestamp,
    required super.confidence,
    required super.source,
    super.targetTrackId,
    required this.clipId,
    required this.zoomFactor,
    required this.zoomStartMs,
    required this.zoomEndMs,
  });

  @override
  TimelineOperationType get type => TimelineOperationType.zoom;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
        'clipId': clipId,
        'zoomFactor': zoomFactor,
        'zoomStartMs': zoomStartMs,
        'zoomEndMs': zoomEndMs,
      };
}

/// Inserts a caption at a specific position on the timeline.
class CaptionOperation extends TimelineOperation {
  final String captionId;
  final String text;
  final int captionStartMs;
  final int captionEndMs;
  final String stylePreset;

  const CaptionOperation({
    required super.operationId,
    required super.timestamp,
    required super.confidence,
    required super.source,
    super.targetTrackId,
    required this.captionId,
    required this.text,
    required this.captionStartMs,
    required this.captionEndMs,
    required this.stylePreset,
  });

  @override
  TimelineOperationType get type => TimelineOperationType.caption;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
        'captionId': captionId,
        'text': text,
        'captionStartMs': captionStartMs,
        'captionEndMs': captionEndMs,
        'stylePreset': stylePreset,
      };
}

/// Inserts a transition between two clips.
class TransitionOperation extends TimelineOperation {
  final String beforeClipId;
  final String afterClipId;
  final String transitionType;
  final int durationMs;

  const TransitionOperation({
    required super.operationId,
    required super.timestamp,
    required super.confidence,
    required super.source,
    super.targetTrackId,
    required this.beforeClipId,
    required this.afterClipId,
    required this.transitionType,
    required this.durationMs,
  });

  @override
  TimelineOperationType get type => TimelineOperationType.transition;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
        'beforeClipId': beforeClipId,
        'afterClipId': afterClipId,
        'transitionType': transitionType,
        'durationMs': durationMs,
      };
}

/// Applies a visual filter to a specific clip.
class FilterOperation extends TimelineOperation {
  final String clipId;
  final String filterType;
  final Map<String, dynamic> params;

  const FilterOperation({
    required super.operationId,
    required super.timestamp,
    required super.confidence,
    required super.source,
    super.targetTrackId,
    required this.clipId,
    required this.filterType,
    required this.params,
  });

  @override
  TimelineOperationType get type => TimelineOperationType.filter;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
        'clipId': clipId,
        'filterType': filterType,
        'params': params,
      };
}

/// Adjusts the audio gain for a clip or an audio track.
class AudioGainOperation extends TimelineOperation {
  final String targetId; // clipId or audioTrackId
  final double gainDb; // Gain in decibels (e.g. -6.0 to +6.0)

  const AudioGainOperation({
    required super.operationId,
    required super.timestamp,
    required super.confidence,
    required super.source,
    super.targetTrackId,
    required this.targetId,
    required this.gainDb,
  });

  @override
  TimelineOperationType get type => TimelineOperationType.audioGain;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
        'targetId': targetId,
        'gainDb': gainDb,
      };
}
