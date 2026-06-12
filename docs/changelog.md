# Changelog

This changelog records high-level documentation and repository changes in a beginner-friendly format.

## 2026-06-01
- Change Summary:
  - Updated `docs/project_brain.md` with a complete project overview, vision, folder responsibilities, tech stack, actual implemented features, workflow guidance, AI collaboration rules, and scaling notes.
  - Updated `docs/changelog.md` to store structured project history and change impact details.
- Files Modified:
  - `docs/project_brain.md`
  - `docs/changelog.md`
  - `docs/TOC.md`
- Reason For Change:
  - Make the repository easier to understand for new contributors and future AI assistants by documenting the current codebase clearly and accurately.
- Impact On Project:
  - Improves onboarding and reduces confusion about which parts of the system are implemented vs scaffolded.
  - Provides a clearer source of truth for architecture decisions and future planning.

## [Unreleased]
- Planned updates to documentation structure and API docs as the project evolves.
- Added Phase 5A Style DNA Engine: deterministic creator-style extraction from finished edits, with `StyleDNA`, `StyleMetrics`, `StyleExtractor`, and `StyleProfile` models, unit tests, and module documentation.
- Added Phase 5B Style DNA Ecosystem architecture design: lifecycle, marketplace feeds, creator profiles, remix blending, AI Director integration, database schema, Phases 6–10 roadmap, and monetization strategy.
- Added the Video Intelligence Layer design and mobile scaffold for metadata-only video analysis, including scene, beat, speech, face, and highlight detection models, service abstractions, and documentation.
- Updated `docs/architecture/video_intelligence_layer.md` and `docs/project_brain.md` to explicitly connect Video Intelligence with the Universal Project Schema, Creator Intent Engine, AI Director Engine, and Timeline Execution Engine.
- Added Phase 4A foundation contracts: Creator Intent Engine, Project Schema models, AI Director contract, and metadata extractor abstraction.
- Added Phase 4B Video Intelligence implementation plan with concrete designs for scene detection, beat detection, speech detection, highlight extraction, and IntelligenceReport aggregation.
- Implemented Phase 4B Video Intelligence extraction engines: LocalMetadataExtractor now provides real scene, beat, speech, and highlight detection via deterministic on-device algorithms. Includes FFprobe helper for metadata extraction, detector implementations, comprehensive test coverage, and JSON serialization support.

## 2026-06-11 - Phase 5A Style DNA Engine
- Change Summary:
  - Created `style_dna/` feature module for deterministic creator-style extraction from finished edits.
  - Implemented `StyleDNA`, `StyleMetrics`, `StyleProfile`, and `StyleExtractor` with full JSON serialization and `copyWith()` support.
  - Added comprehensive unit tests for models, extractor determinism, and marketplace profile wrapping.
  - Documented integration points with Video Intelligence, Project Schema, Creator Intent, and AI Director layers.
- Files Modified:
  - `apps/mobile/lib/src/features/style_dna/style_dna.dart` (New)
  - `apps/mobile/lib/src/features/style_dna/style_metrics.dart` (New)
  - `apps/mobile/lib/src/features/style_dna/style_extractor.dart` (New)
  - `apps/mobile/lib/src/features/style_dna/style_profile.dart` (New)
  - `apps/mobile/lib/src/features/style_dna/README.md` (New)
  - `apps/mobile/test/features/style_dna/style_dna_test.dart` (New)
  - `docs/project_brain.md`
  - `docs/changelog.md`
  - `docs/BUILD_HISTORY.md`
- Reason For Change:
  - Enable extraction of reusable editing personalities from finished projects without templates or presets.
  - Prepare Creator Marketplace and downstream intent/director wiring with a strongly typed, deterministic style contract.
- Impact On Project:
  - Style DNA can be generated from any `IntelligenceReport` + `ProjectSchema` pair without timeline mutations or AI inference.
  - `AIInstructions.styleReferenceId` is the natural hook for applying extracted styles to future edits.
  - Timeline Engine and Video Intelligence Layer remain unchanged and isolated.

## 2026-06-06 - Phase 4B Video Intelligence Implementation
- Change Summary:
  - Implemented `LocalMetadataExtractor` with real detection logic (scene, beat, speech, highlight).
  - Created `FfprobeHelper` for video metadata extraction (duration, fps, resolution).
  - Implemented `SceneDetector` for shot boundary detection using frame difference heuristics.
  - Implemented `BeatDetector` for audio energy analysis and rhythmic peak identification.
  - Implemented `SpeechDetector` for voice activity detection using silence thresholding.
  - Implemented `HighlightDetector` for composite scoring combining all detector signals.
  - Created comprehensive test suite validating detector outputs and report generation.
  - Added integration tests for JSON serialization and end-to-end report generation.
- Files Modified:
  - `apps/mobile/lib/src/features/video_intelligence/data/ffprobe_helper.dart` (New)
  - `apps/mobile/lib/src/features/video_intelligence/data/scene_detector.dart` (New)
  - `apps/mobile/lib/src/features/video_intelligence/data/beat_detector.dart` (New)
  - `apps/mobile/lib/src/features/video_intelligence/data/speech_detector.dart` (New)
  - `apps/mobile/lib/src/features/video_intelligence/data/highlight_detector.dart` (New)
  - `apps/mobile/lib/src/features/video_intelligence/data/metadata_extractor.dart` (Modified)
  - `test/features/video_intelligence/detector_test.dart` (New)
  - `test/features/video_intelligence/intelligence_report_test.dart` (New)
  - `docs/BUILD_HISTORY.md`
  - `docs/changelog.md`
- Reason For Change:
  - Replace placeholder metadata extraction with real, deterministic on-device detector implementations.
  - Enable Creator Intent Engine and AI Director Engine to receive enriched video analysis metadata.
  - Establish production-ready detector algorithms that don't require AI models, cloud services, or timeline mutations.
- Impact On Project:
  - Video Intelligence Layer is fully functional for metadata-only analysis.
  - All detector outputs are JSON-serializable and compatible with upstream layers (Creator Intent, AI Director).
  - Timeline Engine remains isolated from intelligence processing (no side effects or mutations).
  - Ready for Phase 4C (performance optimization) and Phase 5 (face detection, cloud integration).

## 2026-06-06 - Phase 1 UI Alignment Task
- Change Summary:
  - Added 'AI Director' entry to home bottom navigation.
  - Added `HomePromptBar` and a Quick AI section on the Home page.
  - Added `AiSuggestionsLayer` placeholder in the video editor timeline.
  - Updated template categories (Gym, Travel, Cinematic, Gaming, Podcast, Motivational).
  - Created `BUILD_HISTORY.md` to track implementation history.
- Files Modified:
  - `apps/mobile/lib/src/features/home/home_models.dart`
  - `apps/mobile/lib/src/features/home/home_widgets.dart`
  - `apps/mobile/lib/src/features/home/home_page.dart`
  - `apps/mobile/lib/src/features/video_editor/presentation/video_editor_widgets.dart`
  - `docs/project_brain.md`
  - `docs/changelog.md`
  - `docs/BUILD_HISTORY.md`
- Reason For Change:
  - Upgrade current Flutter UI to match approved Vexora design system and prepare for AI features.
- Impact On Project:
  - Provides UI hooks and placeholders for AI Director flows and Suggestions layer, no logic changes.

## 2026-06-06 - Phase 2 Timeline Execution Engine
- Change Summary:
  - Created `timeline_engine/` feature module under `apps/mobile/lib/src/features/`.
  - Implemented `TimelineOperation` sealed hierarchy for 8 operation types: CUT, TRIM, SPLIT, ZOOM, CAPTION, TRANSITION, FILTER, AUDIO_GAIN.
  - Implemented `ValidationResult` and `ExecutionResult` domain models.
  - Built `OperationValidator` — stateless, rule-driven, covering 10 discrete validation rules.
  - Built `TimelineExecutor` — stateful executor with bounded undo/redo stacks (max 50), batch execution, regeneration support, and safe state reset.
  - Added `HistoryPanel` presentation widget for displaying operation history.
  - Added `UndoRedoControls` presentation widget with count badges and accessibility labels.
  - Created `timeline_engine/README.md` with full architecture, execution flow, validation table, risks, and usage example.
- Files Modified:
  - `apps/mobile/lib/src/features/timeline_engine/domain/timeline_operation.dart` (New)
  - `apps/mobile/lib/src/features/timeline_engine/domain/execution_result.dart` (New)
  - `apps/mobile/lib/src/features/timeline_engine/domain/validation_result.dart` (New)
  - `apps/mobile/lib/src/features/timeline_engine/data/operation_validator.dart` (New)
  - `apps/mobile/lib/src/features/timeline_engine/data/timeline_executor.dart` (New)
  - `apps/mobile/lib/src/features/timeline_engine/presentation/history_panel.dart` (New)
  - `apps/mobile/lib/src/features/timeline_engine/presentation/undo_redo_controls.dart` (New)
  - `apps/mobile/lib/src/features/timeline_engine/README.md` (New)
  - `docs/project_brain.md`
  - `docs/changelog.md`
  - `docs/BUILD_HISTORY.md`
- Reason For Change:
  - Convert Edit Blueprints into deterministic Project Schema updates with full undo/redo and validation safety.
- Impact On Project:
  - Unblocks Phase 3 AI Director integration. The executor is ready to receive blueprint operations and apply them safely.

## 2026-06-03 - AI Director Engine Architecture
- Change Summary:
  - Designed the AI Director Engine architecture and the Edit Blueprint Schema.
  - Operations in the blueprint are strictly categorized (cuts, transitions, zooms, captions, effects, audio).
  - Added tracking requirements for `operationId`, `confidence`, and `source` to the schema.
- Files Modified:
  - `docs/architecture/ai_director_engine.md` (New)
  - `docs/project_brain.md`
  - `docs/changelog.md`
- Reason For Change:
  - Needed a deterministic brain to convert creative intent into actionable edit instructions without coupling intelligence directly to the rendering layer.
- Impact On Project:
  - Lays the foundation for AI-generated edits and provides a standardized blueprint format for the Timeline Engine to consume.

## 2026-06-03 - Universal Project Schema
- Change Summary:
  - Created and formalized the Universal Project Schema.
  - Defined the architecture for `schemaVersion`, `metadata`, `renderSettings`, `assets`, `timeline`, `aiInstructions`, and optional `history`.
  - Updated `docs/project_brain.md` to reference the new schema.
- Files Modified:
  - `docs/architecture/universal_project_schema.md` (New)
  - `docs/project_brain.md`
  - `docs/changelog.md`
- Reason For Change:
  - Vexora requires a single source of truth for edit operations that is shared and understood by the Flutter frontend, Python AI services, FFmpeg renderer, and Node.js backend.
- Impact On Project:
  - Establishes a permanent JSON contract enabling AI features (Style Clone, AI Director) to generate edits that the mobile UI can instantly render and parse.

## 0.1.0 - 2026-06-01
- Added initial repo scaffold for the Flutter mobile app, Node.js backend, Python AI service, Postgres, Firebase emulator, and FFmpeg support.
- Added foundational documentation in `docs/`, including project brain, setup guides, and architecture notes.

## 2026-06-01 - Phase 1 trimming and lifecycle improvements

- Change Summary:
  - Implemented robust FFmpeg trimming pipeline with fast (stream-copy) and safe (re-encode) modes and automatic fallback.
  - Added job-safe state tracking to prevent race conditions and overwrites.
  - Integrated FFmpeg cancellation via `FFmpegKit.cancel()` and provided UI cancel support.
  - Switched temporary file handling to platform-safe app cache directories using `path_provider`.
  - Added temp-file promotion (`promoteTemporaryToPersistent`) and abandoned-temp cleanup (`cleanupAbandonedTempFiles`).
  - Updated documentation to describe modes, cancellation, and temp-file policies.

- Files Modified:
  - `apps/mobile/lib/src/features/video_editor/data/ffmpeg_service.dart`
  - `apps/mobile/lib/src/features/video_editor/video_editor_state.dart`
  - `apps/mobile/lib/src/features/video_editor/presentation/video_editor_page.dart`
  - `apps/mobile/lib/src/features/video_editor/data/export_service.dart`
  - `apps/mobile/pubspec.yaml`
  - `docs/project_brain.md`

- Reason For Change:
  - Improve reliability of import→trim→preview→export flow on mobile devices and handle cancellations, temp-file lifecycle, and format edge cases.

- Impact On Project:
  - Phase 1 trimming flow is now more robust and reliable across common mobile formats.
  - Easier onboarding for QA and developers due to clearer temp-file and cancellation behavior.
