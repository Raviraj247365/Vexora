import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

import '../domain/video_editor_models.dart';

/// Lightweight platform file import service for the video editor.
///
/// Responsibilities:
/// - Open a native file picker for video files.
/// - Measure the imported asset duration using the video playback engine.
///
/// This is intentionally simple so it can be replaced later with
/// a more robust media library or native platform implementation.
class VideoImportService {
  Future<VideoSource?> pickVideoSource() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    final filePath = result?.files.single.path;
    if (filePath == null) {
      return null;
    }

    final file = File(filePath);
    final controller = VideoPlayerController.file(file);

    try {
      await controller.initialize();
      final duration = controller.value.duration;
      return VideoSource(path: file.path, duration: duration);
    } catch (_) {
      return null;
    } finally {
      await controller.dispose();
    }
  }
}
