# Video Editor Feature

This folder contains the foundational video editing architecture for the Vexora mobile app.

## Responsibilities

- `domain/` defines core feature entities: imported video source, trim segment, timeline placeholder, and project state.
- `data/` provides lightweight services for local media import and a dedicated FFmpeg processing layer for trim/export.
- `presentation/` contains the UI screen and widgets for import, trim, preview, and export.
- `video_editor_state.dart` manages project state with Riverpod, tracks export processing status, and keeps the feature isolated from other app flows.

## Video flow

1. Import local video via a native file picker.
2. Set trim `start` and `end` values on a simple range control.
3. Preview the imported video locally with basic play/pause controls.
4. Export through a placeholder FFmpeg service that returns a stub path.

## Future scalability

- Replace `VideoImportService` with a dedicated media library or native platform bridge.
- Replace `FfmpegService` with a real platform-backed FFmpeg implementation or cloud export service.
- Extend `domain/` to support multiple clips, timeline segments, and audio tracks.
- Add a dedicated preview timeline scrubber and position marker once the MVP playback flow is stable.

## MVP focus

- Keep implementation lightweight and feature-focused.
- Do not add transitions, filters, or AI features yet.
- Preserve startup speed by keeping the editor isolated and only loading video playback when a file is imported.
