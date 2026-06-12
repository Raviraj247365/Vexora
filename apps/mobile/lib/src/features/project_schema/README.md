# Project Schema

This module contains immutable dart models for the Universal Project Schema.
The models mirror `docs/architecture/universal_project_schema.md` and are intended
for use as read-only contract data passed between features.

## Contents

- `project_schema.dart` — root project schema and metadata.
- `asset.dart` — source asset representation.
- `timeline_track.dart` — timeline and track definitions.
- `timeline_clip.dart` — clip items, filters, trims, and captions.
- `transition.dart` — transition item definition.
- `render_settings.dart` — output render settings.
- `ai_instructions.dart` — AI prompt and metadata model.
- `history_entry.dart` — optional undo/checkpoint entry.
