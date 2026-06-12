# Vexora Universal Project Schema

## Overview
This schema is the central source of truth for all editing operations in Vexora. It serves as the definitive contract between:
- Flutter Editor
- AI Director
- Style Clone Engine
- FFmpeg Renderer
- Future Backend Services

## Architectural Decisions
- **Assets are decoupled from timeline clips:** The `assets` block defines media references, and clips refer to them by `assetId`. This prevents duplication.
- **Time values are integer milliseconds:** Used uniformly across the timeline to prevent floating-point desync issues between Dart, Python, and C.
- **Captions are independent timeline entities:** A global `captions` array holds all text elements mapped to timeline timestamps.
- **Transitions are independent timeline entities:** Tracks consist of a sequence of `items` which can be `clip` or `transition`.
- **AI instructions are separate from clip data:** The `aiInstructions` block stores the history of prompts/generators.

## Schema Structure

```typescript
// Root Level
{
  "schemaVersion": "1.0", // For backward compatibility parsing
  "projectId": "uuid",
  "metadata": {
    "title": "String",
    "authorId": "String?",
    "createdAt": "ISO8601 String",
    "updatedAt": "ISO8601 String"
  },
  "renderSettings": {
    "aspectRatio": "String", // e.g., "9:16"
    "fps": 30,
    "resolution": { "width": 1080, "height": 1920 },
    "exportFormat": "mp4" // "mp4", "mov", etc.
  },
  "assets": [Asset], // Flat list of all media files used
  "timeline": Timeline, // The actual edit sequence
  "aiInstructions": AIContext, // Prompts and hints used to generate/modify the edit
  "history": [HistoryState] // Optional: for undo/redo states or edit checkpoints
}

// Asset Definition (Source Files)
Asset {
  "id": "uuid",
  "type": "video" | "audio" | "image",
  "sourceUrl": "String", // Local path or cloud URL
  "proxyUrl": "String?", // Optional low-res proxy for fast AI/Mobile rendering
  "duration": "Number" // In milliseconds
}

// Timeline Definition
Timeline {
  "videoTracks": [ Track ], 
  "audioTracks": [ Track ],
  "captions": [ Caption ]
}

// Track Definition
Track {
  "id": "uuid",
  "items": [ TrackItem ] // Sequence of clips and transitions
}

// Track Item (Base)
TrackItem {
  "type": "clip" | "transition"
}

// Clip Item (Extends TrackItem)
ClipItem {
  "type": "clip",
  "id": "uuid",
  "assetId": "uuid", // Maps to assets array
  "timelineStartTime": "Number", // When it starts on the master timeline (ms)
  "trim": {
    "start": "Number", // Start time in the source asset (ms)
    "end": "Number"    // End time in the source asset (ms)
  },
  "speed": "Number", // e.g., 1.0 is normal, 2.0 is 2x speed
  "volume": "Number", // 0.0 to 1.0 (for the clip's intrinsic audio)
  "filters": [Filter] // Color correction, denoise, etc.
}

// Transition Item (Extends TrackItem)
TransitionItem {
  "type": "transition",
  "id": "uuid",
  "transitionType": "none" | "crossfade" | "dip_to_black" | "zoom_in",
  "duration": "Number" // ms
}

// Filter Definition
Filter {
  "type": "denoise" | "sharpen" | "color_grade" | "style_transfer",
  "params": { ... } // Key-value pairs specific to the filter
}

// Caption Definition
Caption {
  "id": "uuid",
  "text": "String",
  "startTime": "Number", // Timeline start (ms)
  "endTime": "Number", // Timeline end (ms)
  "style": {
    "preset": "String", // Maps to Vexora UI presets (e.g., "gym_bold")
    "position": { "x": "Number", "y": "Number" } // Relative coordinates (0.0 to 1.0)
  }
}

// AI Context
AIContext {
  "originalPrompt": "String", 
  "styleReferenceId": "uuid?",
  "engineVersion": "String",
  "aiAppliedFilters": ["String"] // Which engines actually touched the timeline
}

// History State (Optional Undo/Redo Checkpoints)
HistoryState {
  "checkpointId": "uuid",
  "timestamp": "ISO8601 String",
  "description": "String", // E.g., "Applied AI Gym Template"
  "timelineSnapshot": Timeline // Full or partial snapshot of the timeline at this point
}
```

## Example Project File

```json
{
  "schemaVersion": "1.0",
  "projectId": "a1b2c3d4-5678-90ef-1234-567890abcdef",
  "metadata": {
    "title": "Gym PR Edit",
    "createdAt": "2026-06-03T10:00:00Z",
    "updatedAt": "2026-06-03T10:05:00Z"
  },
  "renderSettings": {
    "aspectRatio": "9:16",
    "fps": 30,
    "resolution": { "width": 1080, "height": 1920 },
    "exportFormat": "mp4"
  },
  "assets": [
    {
      "id": "asset-1",
      "type": "video",
      "sourceUrl": "file:///data/user/0/com.vexora.app/cache/raw_squat.mp4",
      "proxyUrl": "file:///data/user/0/com.vexora.app/cache/proxy_squat.mp4",
      "duration": 15000
    }
  ],
  "timeline": {
    "videoTracks": [
      {
        "id": "track-v1",
        "items": [
          {
            "type": "clip",
            "id": "clip-1",
            "assetId": "asset-1",
            "timelineStartTime": 0,
            "trim": { "start": 5000, "end": 10000 },
            "speed": 1.0,
            "volume": 0.0,
            "filters": [
              { "type": "color_grade", "params": { "preset": "cinematic_dark" } }
            ]
          },
          {
            "type": "transition",
            "id": "trans-1",
            "transitionType": "crossfade",
            "duration": 300
          },
          {
            "type": "clip",
            "id": "clip-2",
            "assetId": "asset-1",
            "timelineStartTime": 5300,
            "trim": { "start": 10000, "end": 15000 },
            "speed": 1.0,
            "volume": 0.0,
            "filters": []
          }
        ]
      }
    ],
    "audioTracks": [],
    "captions": [
      {
        "id": "cap-1",
        "text": "NEW PR!!",
        "startTime": 500,
        "endTime": 2500,
        "style": { "preset": "hormozi", "position": { "x": 0.5, "y": 0.8 } }
      }
    ]
  },
  "aiInstructions": {
    "originalPrompt": "Make this a hype gym reel",
    "engineVersion": "v1.0",
    "aiAppliedFilters": ["StyleClone", "ColorCorrection"]
  },
  "history": []
}
```

## Future Extension Strategy
- **Versioning:** Handled via `schemaVersion`. Any breaking structural changes must increment this number (e.g., to "2.0"). Parsers must respect version boundaries.
- **Filter Parameters:** The `params` object inside `Filter` is flexible. New engines can introduce new filter types without modifying the core JSON parsing logic.
- **Undo/Redo:** The optional `history` array allows Vexora to store multiple snapshots of the `timeline`, allowing users to undo changes made by the AI.
