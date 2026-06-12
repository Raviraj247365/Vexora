# AI Director Engine Architecture

## Overview
The AI Director Engine is the core intelligence layer of Vexora. It acts purely as a decision-maker and does not render video or mutate files. It consumes the `Creator Intent JSON` (the "how") and the `Universal Project Schema` (the "what") and outputs an `Edit Blueprint JSON` (the action plan).

## Architecture Flow
* **Inputs**: Creator Intent JSON + Universal Project Schema + Audio/Scene Metadata from ML.
* **Analysis**: Context Analyzer maps intent to metadata.
* **Rules**: Safety Rule Engine enforces constraints (e.g., asset boundaries).
* **Decisions**: Decision Matrix selects cuts, transitions, zooms, etc.
* **Output**: Edit Blueprint JSON is produced and sent to the Timeline Engine.

## Edit Blueprint Schema
The Edit Blueprint organizes deterministic operations into strict categories. Each operation is tracked with an ID, a confidence score, and the source AI that proposed it.

```json
{
  "blueprintVersion": "1.0",
  "blueprintId": "uuid",
  "overallConfidenceScore": 0.92,
  "highlights": [
    { "timestamp": 2000, "description": "Weight lifted / Beat Drop", "intensity": 1.0 }
  ],
  "operations": {
    "cuts": [
      {
        "operationId": "cut-1",
        "confidence": 0.98,
        "source": "beat_detector_v2",
        "assetId": "asset-1",
        "timestamp": 0,
        "trim": { "start": 1000, "end": 2000 },
        "trackIndex": 0
      }
    ],
    "transitions": [
      {
        "operationId": "trans-1",
        "confidence": 0.85,
        "source": "style_mapper",
        "timestamp": 2000,
        "transitionStyle": "whip_pan",
        "duration": 300
      }
    ],
    "zooms": [
      {
        "operationId": "zoom-1",
        "confidence": 0.90,
        "source": "action_spotter",
        "timestamp": 2300,
        "zoomStyle": "snap_zoom",
        "strength": 1.5,
        "duration": 500
      }
    ],
    "captions": [
      {
        "operationId": "cap-1",
        "confidence": 0.99,
        "source": "intent_parser",
        "timestamp": 0,
        "text": "WAIT FOR IT...",
        "duration": 2000,
        "style": "hormozi_bold"
      }
    ],
    "effects": [],
    "audio": [
      {
        "operationId": "aud-1",
        "confidence": 0.95,
        "source": "music_selector",
        "timestamp": 0,
        "assetId": "audio-2",
        "volume": 0.8
      }
    ]
  }
}
```

## Safety and Performance Rules
- **Asset Boundaries:** Operations cannot reference timestamps outside the bounds of the original asset.
- **Idempotency:** Identical inputs must yield identical Blueprints.
- **Performance:** Engine relies purely on metadata and proxies; it never loads `.mp4` into RAM. Blueprint generation takes < 500ms.
- **Regeneration:** Supported via modifying the `seed` or `temperature` parameters during the AI request, yielding a new Edit Blueprint.
