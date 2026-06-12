import '../project_schema/project_schema.dart';
import '../project_schema/timeline_clip.dart';
import '../project_schema/transition.dart';
import '../video_intelligence/domain/beat_detection.dart';
import '../video_intelligence/domain/intelligence_report.dart';
import 'style_dna.dart';
import 'style_metrics.dart';
import 'style_profile.dart';

/// style_extractor.dart
///
/// Deterministic extractor that transforms a finished edit plus intelligence
/// metadata into reusable [StyleDNA]. No AI models, rendering, or timeline
/// mutations are performed.
class StyleExtractor {
  static const int _beatSyncToleranceMs = 150;
  static const double _beatSyncThreshold = 55.0;

  const StyleExtractor();

  /// Extracts [StyleDNA] from intelligence metadata and a finished project schema.
  StyleDNA extract({
    required IntelligenceReport intelligenceReport,
    required ProjectSchema projectSchema,
    String? styleId,
    String? name,
    String? creatorId,
  }) {
    final clips = _collectClips(projectSchema);
    final transitions = _collectTransitions(projectSchema);
    final captions = projectSchema.timeline.captions;

    final timelineDurationMs = _timelineDurationMs(clips, transitions);
    final timelineDurationSec =
        timelineDurationMs > 0 ? timelineDurationMs / 1000.0 : 1.0;

    final cutDurationsSec = _clipDurationsSec(clips);
    final averageCutDuration = cutDurationsSec.isEmpty
        ? timelineDurationSec
        : cutDurationsSec.reduce((a, b) => a + b) / cutDurationsSec.length;

    final transitionFrequency = transitions.length / timelineDurationSec;
    final zoomFrequency = _zoomFrequency(clips, timelineDurationSec);
    final captionDensity = captions.length / (timelineDurationSec / 60.0);

    final cutBoundariesMs = _cutBoundariesMs(clips);
    final beatSyncScore =
        _beatSyncScore(cutBoundariesMs, intelligenceReport.beats);
    final sceneChangeFrequency = _sceneChangeFrequency(
      intelligenceReport,
      clips.length,
      timelineDurationSec,
    );
    final motionIntensity = _motionIntensity(
      intelligenceReport,
      averageCutDuration,
      sceneChangeFrequency,
    );
    final energyScore = _energyScore(
      averageCutDuration: averageCutDuration,
      transitionFrequency: transitionFrequency,
      zoomFrequency: zoomFrequency,
      captionDensity: captionDensity,
      beatSyncScore: beatSyncScore,
      motionIntensity: motionIntensity,
      sceneChangeFrequency: sceneChangeFrequency,
    );

    final metrics = StyleMetrics(
      averageCutDuration: _round(averageCutDuration, 3),
      transitionFrequency: _round(transitionFrequency, 4),
      zoomFrequency: _round(zoomFrequency, 4),
      captionDensity: _round(captionDensity, 3),
      beatSyncScore: _round(beatSyncScore, 2),
      motionIntensity: _round(motionIntensity, 2),
      sceneChangeFrequency: _round(sceneChangeFrequency, 4),
      energyScore: _round(energyScore, 2),
    );

    final resolvedStyleId = styleId ?? 'style_${projectSchema.projectId}';
    final resolvedName = name ?? projectSchema.metadata.title;
    final resolvedCreatorId =
        creatorId ?? projectSchema.metadata.authorId ?? 'unknown_creator';

    return StyleDNA(
      styleId: resolvedStyleId,
      name: resolvedName,
      energyScore: energyScore.round().clamp(0, 100),
      pace: _paceFromCutInterval(averageCutDuration),
      averageCutInterval: _round(averageCutDuration, 2),
      transitionStyle: _dominantTransitionStyle(transitions),
      zoomStyle: _zoomStyle(clips, zoomFrequency),
      captionStyle: _dominantCaptionStyle(captions),
      beatSync: beatSyncScore >= _beatSyncThreshold,
      motionIntensity: motionIntensity.round().clamp(0, 100),
      creatorId: resolvedCreatorId,
      metrics: metrics,
    );
  }

  /// Builds a marketplace-ready [StyleProfile] from extracted style DNA.
  StyleProfile buildProfile({
    required StyleDNA styleDNA,
    required String creatorName,
    required StyleCategory category,
    int likes = 0,
    int copies = 0,
    int followers = 0,
    String? createdAt,
  }) =>
      StyleProfile(
        styleId: styleDNA.styleId,
        creatorId: styleDNA.creatorId,
        creatorName: creatorName,
        styleName: styleDNA.name,
        category: category,
        likes: likes,
        copies: copies,
        followers: followers,
        createdAt: createdAt ?? DateTime.now().toUtc().toIso8601String(),
        styleDNA: styleDNA,
      );

  List<ClipItem> _collectClips(ProjectSchema projectSchema) {
    final clips = <ClipItem>[];
    for (final track in projectSchema.timeline.videoTracks) {
      for (final item in track.items) {
        if (item is ClipItem) {
          clips.add(item);
        }
      }
    }
    clips.sort((a, b) => a.timelineStartTime.compareTo(b.timelineStartTime));
    return clips;
  }

  List<TransitionItem> _collectTransitions(ProjectSchema projectSchema) {
    final transitions = <TransitionItem>[];
    for (final track in projectSchema.timeline.videoTracks) {
      for (final item in track.items) {
        if (item is TransitionItem) {
          transitions.add(item);
        }
      }
    }
    return transitions;
  }

  int _timelineDurationMs(
      List<ClipItem> clips, List<TransitionItem> transitions) {
    if (clips.isEmpty) {
      return 0;
    }

    var maxEnd = 0;
    for (final clip in clips) {
      final clipDurationMs =
          ((clip.trim.end - clip.trim.start) / clip.speed).round();
      final clipEnd = clip.timelineStartTime + clipDurationMs;
      if (clipEnd > maxEnd) {
        maxEnd = clipEnd;
      }
    }

    for (final transition in transitions) {
      maxEnd += transition.duration;
    }

    return maxEnd;
  }

  List<double> _clipDurationsSec(List<ClipItem> clips) {
    return clips
        .map(
            (clip) => ((clip.trim.end - clip.trim.start) / clip.speed) / 1000.0)
        .where((duration) => duration > 0)
        .toList();
  }

  List<int> _cutBoundariesMs(List<ClipItem> clips) {
    if (clips.length <= 1) {
      return const [];
    }
    return clips.skip(1).map((clip) => clip.timelineStartTime).toList();
  }

  double _zoomFrequency(List<ClipItem> clips, double timelineDurationSec) {
    final zoomCount = clips
        .expand((clip) => clip.filters)
        .where((filter) => _isZoomFilter(filter.type))
        .length;
    return zoomCount / timelineDurationSec;
  }

  bool _isZoomFilter(String filterType) {
    final normalized = filterType.toLowerCase();
    return normalized.contains('zoom') || normalized == 'snap_zoom';
  }

  double _beatSyncScore(List<int> cutBoundariesMs, List<BeatDetection> beats) {
    if (cutBoundariesMs.isEmpty || beats.isEmpty) {
      return 0;
    }

    var matched = 0;
    for (final boundary in cutBoundariesMs) {
      for (final beat in beats) {
        if ((boundary - beat.beatTimestamp).abs() <= _beatSyncToleranceMs) {
          matched++;
          break;
        }
      }
    }

    return (matched / cutBoundariesMs.length) * 100.0;
  }

  double _sceneChangeFrequency(
    IntelligenceReport report,
    int clipCount,
    double timelineDurationSec,
  ) {
    if (report.scenes.isNotEmpty) {
      return report.scenes.length / timelineDurationSec;
    }
    return clipCount / timelineDurationSec;
  }

  double _motionIntensity(
    IntelligenceReport report,
    double averageCutDuration,
    double sceneChangeFrequency,
  ) {
    final highlightScore = report.highlights.isEmpty
        ? 0.0
        : report.highlights.map((h) => h.score).reduce((a, b) => a + b) /
            report.highlights.length;

    final pacingScore = (1.2 / averageCutDuration).clamp(0.0, 1.0);
    final sceneScore = (sceneChangeFrequency / 2.0).clamp(0.0, 1.0);

    return ((highlightScore * 0.45) +
            (pacingScore * 0.35) +
            (sceneScore * 0.20)) *
        100.0;
  }

  double _energyScore({
    required double averageCutDuration,
    required double transitionFrequency,
    required double zoomFrequency,
    required double captionDensity,
    required double beatSyncScore,
    required double motionIntensity,
    required double sceneChangeFrequency,
  }) {
    final pacing = (1.5 / averageCutDuration).clamp(0.0, 1.0);
    final transitions = (transitionFrequency / 0.5).clamp(0.0, 1.0);
    final zoom = (zoomFrequency / 0.4).clamp(0.0, 1.0);
    final captions = (captionDensity / 8.0).clamp(0.0, 1.0);
    final beatSync = beatSyncScore / 100.0;
    final motion = motionIntensity / 100.0;
    final scenes = (sceneChangeFrequency / 1.5).clamp(0.0, 1.0);

    return ((pacing * 0.22) +
            (transitions * 0.14) +
            (zoom * 0.12) +
            (captions * 0.10) +
            (beatSync * 0.16) +
            (motion * 0.16) +
            (scenes * 0.10)) *
        100.0;
  }

  String _paceFromCutInterval(double averageCutDurationSec) {
    if (averageCutDurationSec < 1.0) {
      return 'frenetic';
    }
    if (averageCutDurationSec < 2.0) {
      return 'fast';
    }
    if (averageCutDurationSec < 4.0) {
      return 'moderate';
    }
    return 'slow';
  }

  String _dominantTransitionStyle(List<TransitionItem> transitions) {
    if (transitions.isEmpty) {
      return 'hard_cut';
    }

    final counts = <String, int>{};
    for (final transition in transitions) {
      counts.update(transition.transitionType, (value) => value + 1,
          ifAbsent: () => 1);
    }

    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  String _zoomStyle(List<ClipItem> clips, double zoomFrequency) {
    if (zoomFrequency <= 0) {
      return 'none';
    }

    final zoomFilters = clips
        .expand((clip) => clip.filters)
        .where((filter) => _isZoomFilter(filter.type))
        .map((filter) => filter.type.toLowerCase())
        .toList();

    if (zoomFilters.any((type) => type.contains('snap'))) {
      return 'snap_zoom';
    }
    if (zoomFilters
        .any((type) => type.contains('slow') || type.contains('ken'))) {
      return 'slow_zoom';
    }
    return zoomFrequency >= 0.25 ? 'snap_zoom' : 'subtle_zoom';
  }

  String _dominantCaptionStyle(List<Caption> captions) {
    if (captions.isEmpty) {
      return 'none';
    }

    final counts = <String, int>{};
    for (final caption in captions) {
      counts.update(caption.preset, (value) => value + 1, ifAbsent: () => 1);
    }

    final dominant = counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key
        .toLowerCase();
    if (dominant.contains('kinetic') ||
        dominant.contains('hormozi') ||
        dominant.contains('bold')) {
      return 'kinetic';
    }
    if (dominant.contains('minimal') || dominant.contains('clean')) {
      return 'minimal';
    }
    return dominant;
  }

  double _round(double value, int places) {
    final factor = _pow10(places);
    return (value * factor).round() / factor;
  }

  int _pow10(int places) {
    var result = 1;
    for (var i = 0; i < places; i++) {
      result *= 10;
    }
    return result;
  }
}
