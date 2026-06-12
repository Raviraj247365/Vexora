# Video Intelligence Layer

## Objective

The Video Intelligence Layer analyzes raw video assets and generates structured metadata for AI-assisted editing.
It must never mutate or edit the source video. Its only output is intelligence data.

## Scope

- Scene detection
- Beat detection
- Speech detection
- Face detection
- Highlight detection
- Intelligence report aggregation

## Output Schema

The layer produces an `IntelligenceReport` object with this shape:

```json
{
  "videoId": "...",
  "scenes": [],
  "beats": [],
  "faces": [],
  "speech": [],
  "highlights": []
}
```

### Scene detection

Detects hard cuts, scene transitions, and major visual changes.
Example output:

```json
{
  "sceneStart": 0,
  "sceneEnd": 4500
}
```

### Beat detection

Detects musical beats, drops, and rhythm peaks.
Example output:

```json
{
  "beatTimestamp": 5200
}
```

### Speech detection

Detects spoken sections and silence sections.
Example output:

```json
{
  "speechStart": 2000,
  "speechEnd": 5500
}
```

### Face detection

Detects face center coordinates and optional bounding boxes for future auto-zoom,
smart crop, and vertical conversion.
Example output:

```json
{
  "faceCenterX": 0.52,
  "faceCenterY": 0.41
}
```

### Highlight detection

Detects exciting moments using motion peaks, beat drops, and speech emphasis.
Example output:

```json
{
  "score": 0.92,
  "timestamp": 8500
}
```

## Architecture

```
video_intelligence/
├── domain/
│   ├── scene_detection.dart
│   ├── face_detection.dart
│   ├── beat_detection.dart
│   ├── speech_detection.dart
│   ├── highlight_detection.dart
│   └── intelligence_report.dart
├── data/
│   ├── intelligence_service.dart
│   └── metadata_extractor.dart
└── presentation/
    ├── analysis_status_panel.dart
    └── intelligence_viewer.dart
```

## Relationships to the Wider System

- The Video Intelligence Layer produces metadata that can be consumed by the `Creator Intent Engine`.
- `IntelligenceReport` is the metadata artifact that feeds higher-level decision-making.
- The `Creator Intent Engine` converts a prompt, optionally enriched with intelligence metadata, into a structured `CreatorIntent`.
- The `AI Director Engine` consumes `CreatorIntent` and the `Universal Project Schema` to emit an `Edit Blueprint`.
- The `Timeline Execution Engine` receives the edit blueprint, validates it, and updates the project schema.

## System Flow

```
Video
↓
Video Intelligence Layer
↓
Intelligence Report
↓
Creator Intent Engine
↓
Intent JSON
↓
AI Director Engine
↓
Edit Blueprint
↓
Timeline Execution Engine
↓
Project Schema
↓
Renderer
```

## Design Rules

- Never load the entire video into memory.
- Prefer metadata-only extraction and streaming analysis.
- Allow background processing.
- Support future cloud processing.
- Do not edit video or modify timelines.

## Implementation Notes

- `IntelligenceService` exposes the feature boundary.
- `MetadataExtractor` contains the analysis contract and placeholder methods.
- `IntelligenceReport` is the central metadata source consumed by AI helpers.
- Presentation widgets show analysis status and report previews.

## Future Considerations

- Add native or cloud-backed frame extraction for accurate scene and face detection.
- Add audio fingerprinting for beat detection.
- Add silence segmentation for robust speech boundaries.
- Keep the layer isolated from editing and rendering logic.
