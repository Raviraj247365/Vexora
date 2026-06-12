import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/export_service.dart';
import 'data/ffmpeg_service.dart';
import 'data/video_import_service.dart';
import 'domain/video_editor_models.dart';

final videoEditorStateProvider =
    StateNotifierProvider<VideoEditorStateNotifier, VideoEditorState>(
  (ref) => VideoEditorStateNotifier(),
);

enum ProcessingStatus { idle, processing, success, failed, cancelled }

class VideoEditorState {
  final VideoProject? project;
  final ProcessingStatus processingStatus;
  final double processingProgress;
  final String? processingError;
  final String? statusMessage;

  const VideoEditorState({
    this.project,
    this.processingStatus = ProcessingStatus.idle,
    this.processingProgress = 0.0,
    this.processingError,
    this.statusMessage,
  });

  bool get hasSource => project != null;
  bool get canExport => project?.canExport ?? false;
  Duration get totalDuration => project?.source.duration ?? Duration.zero;
  Duration get trimStart => project?.trim.start ?? Duration.zero;
  Duration get trimEnd => project?.trim.end ?? Duration.zero;
  String? get sourcePath => project?.source.path;
  String? get exportedPath => project?.exportedPath;
  bool get isProcessing => processingStatus == ProcessingStatus.processing;
  bool get hasProcessingError => processingStatus == ProcessingStatus.failed;

  static const _undefined = Object();

  VideoEditorState copyWith({
    VideoProject? project,
    ProcessingStatus? processingStatus,
    double? processingProgress,
    Object? processingError = _undefined,
    Object? statusMessage = _undefined,
  }) {
    return VideoEditorState(
      project: project ?? this.project,
      processingStatus: processingStatus ?? this.processingStatus,
      processingProgress: processingProgress ?? this.processingProgress,
      processingError: processingError == _undefined
          ? this.processingError
          : processingError as String?,
      statusMessage: statusMessage == _undefined
          ? this.statusMessage
          : statusMessage as String?,
    );
  }
}

class VideoEditorStateNotifier extends StateNotifier<VideoEditorState> {
  final VideoImportService _importService;
  final VideoProcessingService _processingService;

  // Simple job tracking to avoid race conditions when multiple operations
  // (import/trim/export) are started in quick succession.
  int _jobCounter = 0;
  int? _activeJobId;

  VideoEditorStateNotifier({
    VideoImportService? importService,
    VideoProcessingService? processingService,
  })  : _importService = importService ?? VideoImportService(),
        _processingService = processingService ?? FfmpegService(),
        super(const VideoEditorState());

  Future<void> importVideo() async {
    final source = await _importService.pickVideoSource();
    if (source == null) {
      state = state.copyWith(
          statusMessage: 'Video import cancelled or unsupported file.');
      return;
    }

    final trimmed = VideoTrim(start: Duration.zero, end: source.duration);
    final timeline = VideoTimeline(segments: [trimmed]);
    final project =
        VideoProject(source: source, trim: trimmed, timeline: timeline);
    state = state.copyWith(
        project: project, statusMessage: 'Imported video for trimming.');
  }

  void setTrimRange(Duration start, Duration end) {
    final project = state.project;
    if (project == null) return;

    final newTrim = project.trim
        .copyWith(start: start, end: end)
        .clamp(project.source.duration);
    if (!newTrim.isValid) {
      state =
          state.copyWith(statusMessage: 'Please select a valid trim range.');
      return;
    }

    final timeline = project.timeline.hasSegments
        ? project.timeline.copyWith(segments: [newTrim])
        : project.timeline;

    state = state.copyWith(
      project: project.copyWith(trim: newTrim, timeline: timeline),
      statusMessage: 'Trim range updated.',
    );
  }

  void setTrimStart(Duration start) {
    setTrimRange(start, state.project?.trim.end ?? Duration.zero);
  }

  void setTrimEnd(Duration end) {
    setTrimRange(state.project?.trim.start ?? Duration.zero, end);
  }

  Future<void> trimProject() async {
    final project = state.project;
    if (project == null || !project.canExport) {
      state = state.copyWith(
        processingStatus: ProcessingStatus.failed,
        processingError: 'Import a video and select a valid trim first.',
        statusMessage: 'Trim failed.',
      );
      return;
    }
    // Register a new job and capture its id for progress guarding.
    final jobId = ++_jobCounter;
    _activeJobId = jobId;

    state = state.copyWith(
      processingStatus: ProcessingStatus.processing,
      processingProgress: 0.0,
      processingError: null,
      statusMessage: 'Trimming video...',
    );

    try {
      final trimmedPath = await _processingService.trimVideo(
        sourcePath: project.source.path,
        start: project.trim.start,
        end: project.trim.end,
        onProgress: (progress) {
          // Ignore progress updates for stale jobs.
          if (_activeJobId != jobId) return;
          state = state.copyWith(processingProgress: progress.clamp(0.0, 1.0));
        },
      );

      // Only apply success state if this is still the active job.
      if (_activeJobId != jobId) return;

      state = state.copyWith(
        processingStatus: ProcessingStatus.success,
        processingProgress: 1.0,
        project: project.copyWith(exportedPath: trimmedPath),
        statusMessage: 'Trim completed successfully.',
      );
    } catch (error) {
      if (_activeJobId != jobId) return;

      if (error is ProcessingException) {
        final userMessage = _userMessageForCategory(error.category);
        state = state.copyWith(
          processingStatus: error.category == ProcessingErrorCategory.cancelled
              ? ProcessingStatus.cancelled
              : ProcessingStatus.failed,
          processingError: error.toString(),
          statusMessage: userMessage,
        );
      } else {
        state = state.copyWith(
          processingStatus: ProcessingStatus.failed,
          processingError: error.toString(),
          statusMessage: 'Trim failed.',
        );
      }
    } finally {
      // Clear active job if it is this one.
      if (_activeJobId == jobId) _activeJobId = null;
    }
  }

  Future<void> exportProject() async {
    final project = state.project;
    if (project == null || !project.canExport) {
      state = state.copyWith(
        processingStatus: ProcessingStatus.failed,
        processingError: 'Import a video and select a valid trim first.',
        statusMessage: 'Export failed.',
      );
      return;
    }

    // Register a new job and capture its id for progress guarding.
    final jobId = ++_jobCounter;
    _activeJobId = jobId;

    state = state.copyWith(
      processingStatus: ProcessingStatus.processing,
      processingProgress: 0.0,
      processingError: null,
      statusMessage: 'Exporting trimmed video...',
    );

    try {
      final exportPath = await _processingService.exportVideo(
        sourcePath: project.source.path,
        start: project.trim.start,
        end: project.trim.end,
        onProgress: (progress) {
          if (_activeJobId != jobId) return;
          state = state.copyWith(processingProgress: progress.clamp(0.0, 1.0));
        },
      );

      if (_activeJobId != jobId) return;

      state = state.copyWith(
        processingStatus: ProcessingStatus.success,
        processingProgress: 1.0,
        project: project.copyWith(exportedPath: exportPath),
        statusMessage: 'Export completed successfully.',
      );
    } catch (error) {
      if (_activeJobId != jobId) return;

      if (error is ProcessingException) {
        final userMessage = _userMessageForCategory(error.category);
        state = state.copyWith(
          processingStatus: error.category == ProcessingErrorCategory.cancelled
              ? ProcessingStatus.cancelled
              : ProcessingStatus.failed,
          processingError: error.toString(),
          statusMessage: userMessage,
        );
      } else {
        state = state.copyWith(
          processingStatus: ProcessingStatus.failed,
          processingError: error.toString(),
          statusMessage: 'Export failed.',
        );
      }
    } finally {
      if (_activeJobId == jobId) _activeJobId = null;
    }
  }

  String _userMessageForCategory(ProcessingErrorCategory category) {
    switch (category) {
      case ProcessingErrorCategory.invalidTrim:
        return 'Invalid trim range. Please select a valid segment.';
      case ProcessingErrorCategory.unsupportedFormat:
        return 'Unsupported file format. Try a different video.';
      case ProcessingErrorCategory.storage:
        return 'Storage error while saving the export. Check available space and permissions.';
      case ProcessingErrorCategory.cancelled:
        return 'Processing cancelled.';
      case ProcessingErrorCategory.ffmpeg:
        return 'Video processing failed. Tap Details for more info.';
      case ProcessingErrorCategory.unknown:
      default:
        return 'Processing failed due to an unexpected error.';
    }
  }

  /// Cancel any active processing job locally. This prevents further progress
  /// updates from being applied to the current state. Note: this does not
  /// forcibly terminate native FFmpeg sessions; implement native cancellation
  /// if required by the platform FFmpeg API.
  Future<void> cancelProcessing() async {
    // Request processing service to cancel native work first.
    try {
      await _processingService.cancelProcessing();
    } catch (_) {
      // ignore cancellation errors - we still update UI state below
    }

    // Clear active job and mark state as cancelled. Guard ensures further
    // progress updates from stale jobs will be ignored.
    _activeJobId = null;
    state = state.copyWith(
      processingStatus: ProcessingStatus.cancelled,
      processingError: 'Processing cancelled by user',
      statusMessage: 'Processing cancelled.',
    );
  }
}
