/// Core domain model definitions for the video editor feature.
///
/// These models represent the video import asset, trim segment,
/// and project state in a feature-oriented, clean architecture style.
class VideoTrim {
  /// Trim start relative to the imported video timeline.
  final Duration start;

  /// Trim end relative to the imported video timeline.
  final Duration end;

  const VideoTrim({required this.start, required this.end});

  /// Trim segment is valid when the end point is strictly after the start.
  bool get isValid => start >= Duration.zero && end > start;

  VideoTrim copyWith({Duration? start, Duration? end}) {
    return VideoTrim(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  VideoTrim clamp(Duration maximumDuration) {
    final clampedStart = start < Duration.zero ? Duration.zero : start;
    final clampedEnd = end > maximumDuration ? maximumDuration : end;
    return VideoTrim(start: clampedStart, end: clampedEnd);
  }
}

class VideoSource {
  /// Local filesystem path to the imported video asset.
  final String path;

  /// Full duration of the imported video.
  final Duration duration;

  const VideoSource({required this.path, required this.duration});
}

class VideoTimeline {
  /// Ordered segments in the current video timeline.
  final List<VideoTrim> segments;

  const VideoTimeline({this.segments = const []});

  bool get hasSegments => segments.isNotEmpty;

  VideoTimeline copyWith({List<VideoTrim>? segments}) {
    return VideoTimeline(segments: segments ?? this.segments);
  }
}

class VideoProject {
  /// Currently imported video source.
  final VideoSource source;

  /// Selected trim segment for preview and export.
  final VideoTrim trim;

  /// Timeline model for future multi-segment support.
  final VideoTimeline timeline;

  /// Optional placeholder export path from the current export pipeline.
  final String? exportedPath;

  const VideoProject({
    required this.source,
    required this.trim,
    this.timeline = const VideoTimeline(),
    this.exportedPath,
  });

  bool get hasSource => source.path.isNotEmpty;

  bool get canExport => trim.isValid;

  VideoProject copyWith(
      {VideoTrim? trim, VideoTimeline? timeline, String? exportedPath}) {
    return VideoProject(
      source: source,
      trim: trim ?? this.trim,
      timeline: timeline ?? this.timeline,
      exportedPath: exportedPath ?? this.exportedPath,
    );
  }
}
