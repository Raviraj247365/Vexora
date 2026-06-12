# Video Intelligence Layer

This feature module provides a metadata-only analysis layer for mobile video assets.
It is intentionally separate from the editing and rendering layers and does not modify
any source video content.

## Purpose

The Video Intelligence Layer analyzes source video files and generates structured metadata
that can later be consumed by AI editing helpers. It is not responsible for any editing,
rendering, or timeline mutation.

## Folder Structure

```
video_intelligence/
│
├── domain/
│   ├── scene_detection.dart
│   ├── face_detection.dart
│   ├── beat_detection.dart
│   ├── speech_detection.dart
│   ├── highlight_detection.dart
│   ├── intelligence_report.dart
│
├── data/
│   ├── intelligence_service.dart
│   ├── metadata_extractor.dart
│
├── presentation/
│   ├── analysis_status_panel.dart
│   ├── intelligence_viewer.dart
```

## Key Concepts

- `IntelligenceReport` is the central metadata exchange model.
- Analysis is only metadata generation; no video editing occurs here.
- `MetadataExtractor` is responsible for extracting scene, beat, speech, face, and highlight data.
- `IntelligenceService` provides the public service API for the feature.

## Phase 3 Modules

1. Scene Detection
   - Detects hard cuts, scene transitions, and major visual changes.
2. Beat Detection
   - Detects audio beats, drops, and rhythm peaks.
3. Speech Detection
   - Detects spoken sections and silence sections.
4. Face Detection
   - Detects face centers and bounding boxes for future auto-zoom and smart crop.
5. Highlight Detection
   - Detects exciting moments by combining motion, rhythm, and speech emphasis.

## Output Contract

The layer produces a single metadata report with arrays for each analysis category.

This module is a scaffold for future on-device or cloud-powered video intelligence.
