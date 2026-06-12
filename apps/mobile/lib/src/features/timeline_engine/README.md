# Timeline Execution Engine

## Purpose

The Timeline Execution Engine (TEE) is Vexora's deterministic bridge between the **AI Director's Edit Blueprint** and the **Universal Project Schema**. It converts AI-generated or user-initiated editing intents into safe, validated, reversible state mutations on the project timeline.

---

## Architecture

```
Edit Blueprint (AI Director Output)
          │
          ▼
  ┌───────────────────┐
  │ OperationValidator│  ← Pure, stateless. Enforces all rules.
  └───────┬───────────┘
          │  ValidationResult (pass / fail + violations)
          ▼
  ┌───────────────────┐
  │  TimelineExecutor │  ← Stateful. Owns undo/redo stacks.
  └───────┬───────────┘
          │  ExecutionResult (success / failure + snapshot)
          ▼
  Project Schema State Update
          │
          ▼
  History Snapshot → Undo Stack
```

---

## Folder Structure

```
timeline_engine/
├── domain/
│   ├── timeline_operation.dart   — All 8 operation types (CUT, TRIM, SPLIT, ZOOM,
│   │                                CAPTION, TRANSITION, FILTER, AUDIO_GAIN)
│   ├── execution_result.dart     — Sealed result of applying one operation
│   └── validation_result.dart    — Validation outcome with per-rule violation detail
│
├── data/
│   ├── operation_validator.dart  — Stateless validator; runs all applicable rules
│   └── timeline_executor.dart    — Stateful executor; owns undo/redo history
│
└── presentation/
    ├── history_panel.dart        — Scrollable list of all operation snapshots
    └── undo_redo_controls.dart   — Compact undo/redo toolbar widget with badges
```

---

## Supported Operations

| Operation      | Description                                           |
|----------------|-------------------------------------------------------|
| `CUT`          | Removes a segment from the timeline                   |
| `TRIM`         | Adjusts in/out points of an existing clip             |
| `SPLIT`        | Divides a clip into two at a given point              |
| `ZOOM`         | Applies a zoom effect over a clip region              |
| `CAPTION`      | Inserts a timed text caption on the timeline          |
| `TRANSITION`   | Inserts a transition between two clips                |
| `FILTER`       | Applies a visual filter to a clip                     |
| `AUDIO_GAIN`   | Adjusts the gain (dB) of a clip or audio track        |

---

## Operation Contract

Every operation **must** carry:

| Field         | Type     | Description                                         |
|---------------|----------|-----------------------------------------------------|
| `operationId` | `String` | Globally unique identifier for this operation       |
| `timestamp`   | `int`    | UTC epoch milliseconds when the operation was created |
| `confidence`  | `double` | Confidence score [0.0–1.0]; user ops use 1.0        |
| `source`      | `OperationSource` | `aiDirector`, `user`, `regeneration`, `replay` |

---

## Execution Flow

1. **Blueprint → Operations** — The AI Director converts an Edit Blueprint into a list of `TimelineOperation` objects.
2. **Validate** — `OperationValidator.validate()` checks all applicable rules for the operation type. Returns a `ValidationResult`.
3. **Gate** — The executor only proceeds if `ValidationResult.isValid == true`. On failure, `ExecutionResult.failure()` is returned immediately.
4. **Apply** — `TimelineExecutor._applyOperation()` dispatches to a type-specific transform, producing a new immutable state map.
5. **Snapshot** — The new state is wrapped in a `TimelineSnapshot` and pushed to the undo stack.
6. **Clear Redo** — Any redo history is discarded (new intent invalidates previous redo chain).
7. **Return** — `ExecutionResult.success()` is returned to the caller.

---

## Undo / Redo

- **Undo Stack** — Each successful operation pushes a `TimelineSnapshot`. `undo()` pops the top, moves it to the redo stack, and restores the previous state.
- **Redo Stack** — `redo()` pops the top, restores that snapshot, and pushes it back to the undo stack.
- **Max Depth** — Configurable via `maxHistoryDepth` (default: 50). Oldest entries are pruned automatically.
- **Regeneration** — `regenerate(snapshot)` replaces the current state with an external snapshot and creates an undo-able entry so the regeneration itself is reversible.

---

## Validation Rules

| Rule                       | Enforcement                                                     |
|----------------------------|-----------------------------------------------------------------|
| `validTimestamp`           | Reject timestamp ≤ 0 or > now + 10 s (clock skew guard)        |
| `assetExists`              | Referenced asset/clip must exist in the project registry        |
| `trackReferenceValid`      | `targetTrackId`, if provided, must exist in the timeline        |
| `trimRangePositive`        | `trimEnd > trimStart` strictly                                  |
| `noOverlappingTransitions` | Proposed transition interval must not overlap existing ones     |
| `nonnegativeDuration`      | Cut / zoom / transition duration must be ≥ 1 ms                |
| `zoomFactorPositive`       | Zoom factor must be ≥ 1.0                                       |
| `audioGainInBounds`        | Gain must be within [−60 dB, +20 dB]                            |
| `captionRangeValid`        | Caption `end > start` strictly                                  |
| `splitPointInsideClip`     | Split point must be in (0, clipDuration) exclusive              |

---

## What This Module Does NOT Do

- ❌ No FFmpeg rendering
- ❌ No AI inference
- ❌ No network calls
- ❌ No file I/O

The engine is a **pure in-memory state machine**. Persistence and rendering are handled by separate layers.

---

## Future Risks

- **Schema Migration** — When `ProjectSchema` is introduced as a typed class, `_applyOperation` handlers will need to be refactored from `Map<String, dynamic>` to typed transforms. The validation context (`ValidationContext`) will similarly need to reference the real schema.
- **Concurrency** — The executor is not thread-safe. If background AI operations and user edits need to apply concurrently, a queue or lock mechanism will be required.
- **History Size** — Large projects with many operations may accumulate large snapshot maps. Consider a diff-based snapshot strategy instead of full clones.
- **Batch Failures** — `applyBatch` halts at the first failure. Partial rollback of already-applied operations in the batch is not currently supported.

---

## Usage Example

```dart
final validator = OperationValidator();
final executor = TimelineExecutor(validator: validator);

final context = ValidationContext(
  registeredTrackIds: {'track-v1'},
  registeredClipIds: {'clip-1'},
  clipDurations: {'clip-1': 10000},
  clipTimelineStarts: {},
  registeredAssetIds: {},
  existingTransitionIntervals: [],
);

final op = TrimOperation(
  operationId: 'trim-001',
  timestamp: DateTime.now().millisecondsSinceEpoch,
  confidence: 0.95,
  source: OperationSource.aiDirector,
  targetTrackId: 'track-v1',
  clipId: 'clip-1',
  newTrimStartMs: 1000,
  newTrimEndMs: 8000,
);

final result = executor.apply(op, context);

if (result.isSuccess) {
  // Project schema updated. Snapshot pushed to undo stack.
} else {
  // result.failureMessage describes what went wrong.
}

// Undo the last operation:
executor.undo();

// Redo it:
executor.redo();
```
