import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:ffmpeg_kit_flutter_min/statistics.dart';

import 'export_service.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Categories for processing errors to allow mapping to user-friendly
/// messages while retaining technical details for debugging.
enum ProcessingErrorCategory {
  invalidTrim,
  unsupportedFormat,
  storage,
  cancelled,
  ffmpeg,
  unknown
}

/// Exception wrapper that carries category, user message, and technical
/// details. Throw this from processing layers and map it in the UI/state.
class ProcessingException implements Exception {
  final ProcessingErrorCategory category;
  final String message; // short technical message
  final String? details; // verbose details useful for debugging

  ProcessingException(this.category, this.message, {this.details});

  @override
  String toString() =>
      'ProcessingException($category): $message${details != null ? '\n$details' : ''}';
}

/// Dedicated FFmpeg service layer for the video editor.
///
/// This class keeps all FFmpeg command execution separate from UI and
/// state management. It provides a stable trim/export pipeline for the MVP,
/// and exposes clean extension points for filters, transitions, and future
/// AI-driven editing flows.
class FfmpegService implements VideoProcessingService {
  // Track recently created temporary output paths for optional cleanup.
  final List<String> _recentTempPaths = [];
  bool _isCancelled = false;

  @override
  Future<String> trimVideo({
    required String sourcePath,
    required Duration start,
    required Duration end,
    void Function(double progress)? onProgress,
  }) async {
    // Quick validation before starting subprocesses.
    _validateTrimRange(start, end);
    // Strategy: attempt a fast stream-copy trim first (low CPU, quick),
    // then validate the output. If validation fails (duration mismatch,
    // unreadable file, or other incompatibility), automatically fall back
    // to a safe re-encode trim to ensure a reliable output.

    // Fast (copy) command
    final fastOutput = await _createTempOutputPath();
    final fastCommand = _buildTrimCommand(
      sourcePath: sourcePath,
      start: start,
      end: end,
      outputPath: fastOutput,
    );

    try {
      await _executeFFmpegCommand(
        command: fastCommand,
        outputPath: fastOutput,
        start: start,
        end: end,
        onProgress: onProgress,
      );

      // Validate the fast output. If validation passes, return it.
      final valid = await _validateTrimOutput(fastOutput, start, end);
      if (valid) return fastOutput;

      // Otherwise fall back to safe re-encode path below.
      try {
        await deleteTemporaryFile(fastOutput);
      } catch (_) {}
    } catch (_) {
      // Fast path failed; fall back to re-encode without propagating yet.
      try {
        await deleteTemporaryFile(fastOutput);
      } catch (_) {}
    }

    // Safe (re-encode) command
    final safeOutput = await _createTempOutputPath();
    final safeCommand = _buildReencodeTrimCommand(
      sourcePath: sourcePath,
      start: start,
      end: end,
      outputPath: safeOutput,
    );

    // Run re-encode and return its result (may throw on failure).
    return _executeFFmpegCommand(
      command: safeCommand,
      outputPath: safeOutput,
      start: start,
      end: end,
      onProgress: onProgress,
    );
  }

  /// Validate trimmed output by attempting to read its duration and comparing
  /// it against the expected trimmed duration. We allow a small tolerance to
  /// account for encoding/FR discrepancies. If validation fails, the caller
  /// will typically fall back to a re-encode trim.
  Future<bool> _validateTrimOutput(
      String path, Duration start, Duration end) async {
    try {
      final controller = VideoPlayerController.file(File(path));
      await controller.initialize();
      final fileDuration = controller.value.duration;
      await controller.dispose();

      final expected = end - start;
      final diff = (fileDuration - expected).inMilliseconds.abs();
      // Accept up to 300ms difference as valid; adjust tolerance as needed.
      return diff <= 300 && fileDuration.inMilliseconds > 0;
    } catch (_) {
      return false;
    }
  }

  /// Build a re-encode trim command that produces an accurate output by
  /// re-encoding video and audio streams. This is slower but more reliable
  /// than stream-copy for formats that require keyframe alignment or where
  /// container compatibility is limited.
  String _buildReencodeTrimCommand({
    required String sourcePath,
    required Duration start,
    required Duration end,
    required String outputPath,
  }) {
    final startSeconds = (start.inMilliseconds / 1000.0).toStringAsFixed(3);
    final endSeconds = (end.inMilliseconds / 1000.0).toStringAsFixed(3);
    final input = _quotePath(sourcePath);
    final output = _quotePath(outputPath);

    // Re-encode using widely supported codecs. Adjust presets/CRF for quality.
    return '-ss $startSeconds -i $input -to $endSeconds -c:v libx264 -preset veryfast -crf 23 -c:a aac -b:a 128k -y $output';
  }

  @override
  Future<String> exportVideo({
    required String sourcePath,
    required Duration start,
    required Duration end,
    void Function(double progress)? onProgress,
  }) async {
    return trimVideo(
      sourcePath: sourcePath,
      start: start,
      end: end,
      onProgress: onProgress,
    );
  }

  @override
  Future<String> applyFilter({
    required String sourcePath,
    required String filterName,
    void Function(double progress)? onProgress,
  }) {
    return Future.error(UnimplementedError(
        'Filter operations are not implemented in the MVP layer.'));
  }

  @override
  Future<String> applyTransition({
    required String sourcePath,
    required String transitionName,
    void Function(double progress)? onProgress,
  }) {
    return Future.error(UnimplementedError(
        'Transition operations are not implemented in the MVP layer.'));
  }

  @override
  Future<String> runAiOperation({
    required String sourcePath,
    required String operationName,
    Map<String, dynamic>? parameters,
    void Function(double progress)? onProgress,
  }) {
    return Future.error(UnimplementedError(
        'AI operations are not implemented in the MVP layer.'));
  }

  @override
  Future<void> deleteTemporaryFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // ignore cleanup errors
    } finally {
      _recentTempPaths.remove(path);
    }
  }

  @override
  Future<String> promoteTemporaryToPersistent(String tempPath) async {
    try {
      final src = File(tempPath);
      if (!await src.exists()) throw Exception('Temp file not found');

      final docs = await getApplicationDocumentsDirectory();
      final fileName = p.basename(tempPath);
      final destPath = p.join(docs.path, fileName);

      // Move file to documents directory to preserve it until user action.
      final destFile = await src.rename(destPath);
      // Remove from tracked temp paths if present.
      _recentTempPaths.remove(tempPath);
      return destFile.path;
    } catch (e) {
      throw Exception('Failed to promote temp file: $e');
    }
  }

  @override
  Future<void> cleanupAbandonedTempFiles(
      {Duration olderThan = const Duration(hours: 24)}) async {
    try {
      final base = await getTemporaryDirectory();
      final entries = Directory(base.path).listSync();
      final now = DateTime.now();
      for (final e in entries) {
        try {
          if (e is Directory &&
              p.basename(e.path).startsWith('vexora_ffmpeg_')) {
            final stat = await e.stat();
            final age = now.difference(stat.modified);
            if (age > olderThan) {
              await e.delete(recursive: true);
            }
          }
        } catch (_) {
          // ignore per-entry errors
        }
      }
    } catch (_) {
      // best-effort cleanup; ignore errors
    }
  }

  Future<String> _createTempOutputPath() async {
    // Use the app's cache/temporary directory instead of the global
    // system temp directory. This avoids permission issues on mobile and
    // keeps temporary files within the app sandbox for easier cleanup.
    final baseDir = await getTemporaryDirectory();
    final tempDir = Directory(
        '${baseDir.path}/vexora_ffmpeg_${DateTime.now().millisecondsSinceEpoch}');
    await tempDir.create(recursive: true);
    final outputFileName = 'trim_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final outputPath = '${tempDir.path}/$outputFileName';
    _recentTempPaths.add(outputPath);
    return outputPath;
  }

  /// Validate provided trim range before invoking FFmpeg. This is a lightweight
  /// check to detect obviously invalid ranges and return a categorized error.
  void _validateTrimRange(Duration start, Duration end) {
    if (end <= start) {
      throw ProcessingException(
          ProcessingErrorCategory.invalidTrim, 'Invalid trim range',
          details: 'start=${start.inMilliseconds} end=${end.inMilliseconds}');
    }
  }

  String _buildTrimCommand({
    required String sourcePath,
    required Duration start,
    required Duration end,
    required String outputPath,
  }) {
    final startSeconds = (start.inMilliseconds / 1000.0).toStringAsFixed(3);
    final endSeconds = (end.inMilliseconds / 1000.0).toStringAsFixed(3);
    final input = _quotePath(sourcePath);
    final output = _quotePath(outputPath);

    return '-ss $startSeconds -i $input -to $endSeconds -c copy -avoid_negative_ts make_zero -y $output';
  }

  String _quotePath(String path) => '"${path.replaceAll('"', '\\"')}"';

  Future<String> _executeFFmpegCommand({
    required String command,
    required String outputPath,
    required Duration start,
    required Duration end,
    void Function(double progress)? onProgress,
  }) {
    final completer = Completer<String>();
    final operationDurationMs = max(1, (end - start).inMilliseconds);

    FFmpegKit.executeAsync(
      command,
      (FFmpegSession session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          completer.complete(outputPath);
          return;
        }

        // Distinguish cancellation from other failures if possible.
        if (ReturnCode.isCancel(returnCode)) {
          try {
            await deleteTemporaryFile(outputPath);
          } catch (_) {}
          completer.completeError(ProcessingException(
              ProcessingErrorCategory.cancelled,
              'Processing was cancelled by user',
              details:
                  'FFmpeg return code: ${returnCode?.getValue() ?? 'cancel'}'));
          return;
        }

        // Attempt to collect session output for diagnostics.
        String? sessionOutput;
        try {
          sessionOutput = await session.getOutput();
        } catch (_) {
          sessionOutput = null;
        }

        try {
          await deleteTemporaryFile(outputPath);
        } catch (_) {}

        completer.completeError(
          ProcessingException(
              ProcessingErrorCategory.ffmpeg, 'FFmpeg execution failed',
              details:
                  'returnCode=${returnCode?.getValue() ?? 'unknown'} output=${sessionOutput ?? 'n/a'}'),
        );
      },
      null,
      (Statistics statistics) {
        if (_isCancelled) return;
        final raw = statistics.getTime() / operationDurationMs;
        var progress = raw.isFinite ? raw : 0.0;
        if (progress.isNaN) progress = 0.0;
        if (progress < 0.0) progress = 0.0;
        if (progress > 1.0) progress = 1.0;
        onProgress?.call(progress);
      },
    );

    return completer.future;
  }

  @override
  Future<void> cancelProcessing() async {
    _isCancelled = true;
    try {
      // FFmpegKit provides a global cancel() to stop running sessions.
      await FFmpegKit.cancel();
    } catch (_) {
      // best-effort cancellation; ignore errors
    } finally {
      // clear tracked temp paths and reset cancellation flag after a short delay
      _recentTempPaths.clear();
      _isCancelled = false;
    }
  }
}

/// Represents an error returned by the FFmpeg processing layer.
class FfmpegException implements Exception {
  final String message;

  FfmpegException(this.message);

  @override
  String toString() => 'FfmpegException: $message';
}
