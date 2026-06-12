/// Video processing contract for the video editor feature.
///
/// This interface keeps FFmpeg and future rendering implementations isolated
/// from the UI layer. It also provides clean extension points for filters,
/// transitions, and AI editing operations in the future.
abstract class VideoProcessingService {
  /// Trim a segment from the source video and return a temporary output path.
  Future<String> trimVideo({
    required String sourcePath,
    required Duration start,
    required Duration end,
    void Function(double progress)? onProgress,
  });

  /// Export the final video clip, currently implemented as a trim operation.
  Future<String> exportVideo({
    required String sourcePath,
    required Duration start,
    required Duration end,
    void Function(double progress)? onProgress,
  });

  /// Placeholder contract for future filter processing.
  Future<String> applyFilter({
    required String sourcePath,
    required String filterName,
    void Function(double progress)? onProgress,
  });

  /// Placeholder contract for future transition processing.
  Future<String> applyTransition({
    required String sourcePath,
    required String transitionName,
    void Function(double progress)? onProgress,
  });

  /// Placeholder contract for future AI-driven video editing workflows.
  Future<String> runAiOperation({
    required String sourcePath,
    required String operationName,
    Map<String, dynamic>? parameters,
    void Function(double progress)? onProgress,
  });

  /// Remove a temporary file if it is no longer needed.
  Future<void> deleteTemporaryFile(String path);

  /// Cancel any in-flight processing. Implementations should stop native
  /// FFmpeg sessions when possible and return quickly.
  Future<void> cancelProcessing();

  /// Move a temporary export into a persistent location under the app's
  /// documents directory. Implementations should return the new path.
  Future<String> promoteTemporaryToPersistent(String tempPath);

  /// Cleanup abandoned temporary files in the app cache. Implementations
  /// should remove old `vexora_ffmpeg_*` temp directories beyond a
  /// reasonable TTL to prevent storage bloat.
  Future<void> cleanupAbandonedTempFiles({Duration olderThan});
}
