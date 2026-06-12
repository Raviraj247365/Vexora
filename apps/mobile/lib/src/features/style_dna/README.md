# Style DNA Engine

The Style DNA Engine transforms a finished edit into a reusable editing personality that can be applied to completely different footage. This is **not** a template or preset system — it is a creator-style extraction layer.

## Architecture Flow

```
Video
↓
Video Intelligence Layer
↓
IntelligenceReport
↓
Style Extractor  ← reads finished ProjectSchema
↓
Style DNA
↓
Creator Marketplace (future)
↓
Creator Intent Engine (future StyleDNA input)
↓
AI Director Engine (future StyleDNA bias)
↓
Edit Blueprint
↓
Timeline Engine
↓
Universal Project Schema
↓
Renderer
```

## Module Layout

```
style_dna/
├── style_dna.dart        — immutable StyleDNA model
├── style_metrics.dart    — quantitative style measurements
├── style_extractor.dart  — deterministic extraction engine
├── style_profile.dart    — public marketplace profile wrapper
└── README.md
```

## Dependencies

| Upstream (reads) | Downstream (consumes Style DNA) |
|---|---|
| `video_intelligence/domain/intelligence_report.dart` | Creator Marketplace (planned) |
| `project_schema/project_schema.dart` | Creator Intent Engine (planned) |
| | AI Director Engine (planned) |

**Does not depend on:** Timeline Execution Engine, FFmpeg, AI models, or rendering.

## StyleDNA Model

```json
{
  "styleId": "fitness_v1",
  "name": "Alex Fitness",
  "energyScore": 92,
  "pace": "frenetic",
  "averageCutInterval": 0.8,
  "transitionStyle": "whip_pan",
  "zoomStyle": "snap_zoom",
  "captionStyle": "kinetic",
  "beatSync": true,
  "motionIntensity": 88,
  "creatorId": "creator_001",
  "metrics": { "...": "..." }
}
```

## Style Extractor

```dart
const extractor = StyleExtractor();

final styleDNA = extractor.extract(
  intelligenceReport: report,
  projectSchema: finishedEdit,
  styleId: 'fitness_v1',
  name: 'Alex Fitness',
  creatorId: 'creator_001',
);

final profile = extractor.buildProfile(
  styleDNA: styleDNA,
  creatorName: 'Alex',
  category: StyleCategory.fitness,
);
```

### Extraction Rules

| Signal | Source | Method |
|---|---|---|
| Cut pacing | `ProjectSchema.timeline` clips | Average clip duration on timeline |
| Transitions | `TransitionItem` entries | Dominant `transitionType` + frequency |
| Captions | `Timeline.captions` | Dominant preset + density per minute |
| Beat sync | Clip boundaries vs `IntelligenceReport.beats` | Match within 150ms tolerance |
| Motion | Highlights + pacing + scene frequency | Weighted composite score |
| Energy | All metrics | Weighted 0–100 composite |

## Integration Points

### Video Intelligence Layer
- **Input:** `IntelligenceReport` (beats, scenes, highlights).
- **Role:** Provides rhythm and motion signals for beat-sync and energy scoring.
- **Coupling:** Read-only; Style DNA never triggers analysis.

### Universal Project Schema
- **Input:** Finished `ProjectSchema` with timeline clips, transitions, and captions.
- **Role:** Source of truth for edit pacing, transition style, caption style, and zoom filters.
- **Coupling:** Read-only; no schema mutations.

### Creator Intent Engine (future)
- **Planned:** Accept optional `StyleDNA` to enrich `CreatorIntent.keywords` and `style` fields.
- **Hook:** `AIInstructions.styleReferenceId` already reserves a style reference slot.

### AI Director Engine (future)
- **Planned:** Use `StyleDNA` pace, transition style, and beat-sync flags to bias blueprint operation generation.

## Design Rules

- Deterministic: identical inputs always produce identical Style DNA.
- No AI models, rendering, or timeline mutations.
- `StyleMetrics` is independent from Timeline Engine operations.
- All public models support `toJson()`, `fromJson()`, and `copyWith()`.
- Module remains isolated with no circular dependencies.

## Risks

- Zoom detection relies on filter type naming until dedicated zoom timeline items exist.
- Beat-sync scoring depends on intelligence beat timestamps aligning with edit boundaries.
- Marketplace and downstream engine wiring are deferred to Phase 5B+.
