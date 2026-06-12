# Vexora — Project Brain

## 1. Project Overview
Vexora is a mobile-first video editing scaffold built as a proof-of-concept for AI-assisted creator workflows. It combines a Flutter frontend, a Node.js backend, a Python AI microservice, and local infrastructure helpers for Postgres, Firebase emulation, and FFmpeg.

## 2. Vision
The vision is to make lightweight mobile video editing feel smart and modern by separating UI, orchestration, and compute. The app should allow creators to import media, trim clips, preview results, and eventually use AI-powered helpers for captions, style filters, and scene detection.

## 3. Current Development Phase
This repository is currently in an early-stage architecture and prototype phase. The core scaffold is implemented, but many features are placeholders or not fully integrated across the mobile app, backend, and AI service.

## 4. Folder Structure
- `apps/mobile` — Flutter mobile app scaffold.
- `apps/backend` — Node.js backend API scaffold.
- `services/ai` — Python AI service scaffold.
- `infra/postgres` — Postgres dev helpers and bootstrap scripts.
- `infra/firebase` — Firebase emulator configuration notes.
- `infra/ffmpeg` — FFmpeg packaging and helper docs.
- `libs` — Shared utilities and cross-project helpers.
- `docs` — Project documentation and setup guides.

## 5. Folder Responsibilities
- `apps/mobile`: UI screens, feature logic, theme system, and local video trimming/export flow.
- `apps/backend`: API server, health/version endpoints, environment config, and container support.
- `services/ai`: AI service API surface and model service scaffolding.
- `infra/postgres`: Local Postgres setup and example database bootstrap.
- `infra/firebase`: Local Firebase auth/storage emulator instructions.
- `infra/ffmpeg`: FFmpeg Docker helpers and command examples for media processing.
- `libs`: Shared code to avoid duplication when cross-project integration begins.
- `docs`: Reference material, onboarding, architecture rationale, and change history.

## 6. Tech Stack
- Flutter + Dart for the mobile UI.
- Riverpod for state management in the Flutter app.
- GoRouter for navigation.
- Node.js with Express for the backend API.
- Python with FastAPI for the AI service.
- PostgreSQL for structured metadata and job state in local development.
- Firebase Emulator for auth and storage prototyping.
- FFmpeg for video trimming/export operations.

### FFmpeg trimming modes (fast vs safe)

- **Fast trim mode (stream-copy):** Uses FFmpeg stream-copy (`-c copy`) to produce trims quickly without re-encoding. Fast mode is low CPU and preserves original quality, but it requires start/end points aligned to keyframes; otherwise output can be imprecise or incompatible.
- **Safe trim mode (re-encode):** Re-encodes video/audio streams (e.g., using `libx264`/`aac`) to ensure frame-accurate, compatible output. Safe mode is slower and CPU-bound but reliable across formats.
- **Fallback behavior:** The mobile `FfmpegService` will attempt fast trim first and then validate the produced file (duration and readability). If validation fails, it automatically falls back to safe trim (re-encode) and returns a reliable export. This keeps the common-case fast while ensuring correctness on problematic inputs.

Comments in the code explain the rationale and where to adjust tolerance or encoding presets.

### Temporary file management

- **Storage location:** Temporary export files are created in the application's temporary/cache directory (via `path_provider`) under `vexora_ffmpeg_<timestamp>` subfolders. This keeps files in the app sandbox and avoids global system temp permission issues on Android/iOS.
- **Failed exports:** Any failed or invalid export is removed as part of the processing error path.
- **Abandoned temp files:** The `FfmpegService` exposes `cleanupAbandonedTempFiles()` which scans the app temp directory for `vexora_ffmpeg_*` folders and removes entries older than a TTL (default: 24 hours). This is a best-effort cleanup to prevent storage bloat.
- **Preserving successful exports:** When an export is confirmed successful and should be kept, the app can call `promoteTemporaryToPersistent(tempPath)` which moves the file into the application's documents directory, ensuring it isn't removed during cleanup until the user chooses to delete or share it.

These rules are implemented to be lightweight and mobile-friendly while giving the app explicit control over which exports are preserved.

### Processing error categories

The editor classifies processing failures into these categories to provide clear user messages while preserving technical details for debugging:

- `invalidTrim`: The requested start/end range is invalid (end <= start).
- `unsupportedFormat`: FFmpeg could not process the file format reliably.
- `storage`: Issues saving or moving temporary files (permissions, low disk).
- `cancelled`: Processing was cancelled by the user (via UI) or by the system.
- `ffmpeg`: FFmpeg execution failed with an error (see technical details).
- `unknown`: Any other unexpected error.

Behavior:
- User-facing messages are mapped from these categories to concise instructions.
- Technical details (FFmpeg output, return codes, stack traces) are preserved in the processing logs and exposed in the UI for debugging when requested.

## 7. Architecture Decisions
- Separate application responsibilities into distinct folders and services.
- Keep the mobile app focused on UI and on-device preview capabilities.
- Use backend and AI service scaffolds to allow later API integration without blocking the front-end prototype.
- Use Docker Compose for reproducible local infrastructure with Postgres, Adminer, Firebase emulator, backend, and AI service.
- Use the Firebase emulator in dev to avoid production credential dependency.

## 8. Features Completed
- Flutter app scaffold with splash, onboarding, home, styleguide, and video editor screens.
- Mobile feature wiring for video import, trim range adjustment, preview, and export via FFmpeg.
- Local FFmpeg command wrapper in `apps/mobile/lib/src/features/video_editor/data/ffmpeg_service.dart`.
- Basic Node.js backend with `/health` and `/version` endpoints.
- Basic FastAPI AI service with `/health` and `/version` endpoints.
- Docker Compose setup for Postgres, Adminer, Firebase emulator, backend, and AI service.
- Common Makefile targets for infrastructure, backend, mobile, and AI service startup.
- Documentation scaffolding in `docs/`, including project brain, setup guides, and changelog.
- Phase 1 UI Alignment: AI Director navigation entry, Prompt Bar widget, Quick AI section on Home, AI Suggestions Layer in timeline, and template categories (Gym, Travel, Cinematic, Gaming, Podcast, Motivational).
- Phase 2 Timeline Execution Engine: deterministic blueprint-to-schema execution layer with 8 operation types (CUT, TRIM, SPLIT, ZOOM, CAPTION, TRANSITION, FILTER, AUDIO_GAIN), stateless validator, stateful executor, undo/redo stacks, snapshot-based history, and regeneration support.
- Phase 4A Foundation Contracts: Creator Intent Engine contract, Project Schema Dart models, AI Director contract, and metadata extractor abstractions.
- Phase 4B Video Intelligence Implementation: deterministic on-device scene, beat, speech, and highlight detection with `IntelligenceReport` aggregation.
- Phase 5A Style DNA Engine: deterministic creator-style extraction from finished edits into reusable `StyleDNA` profiles.

## 9. Features In Progress
- Real backend API contract for mobile app integration is not implemented yet.
- AI service does not yet provide editing or inference endpoints beyond health/version checks.
- Firebase auth/storage integration is documented but not wired into actual mobile or backend flows.
- FFmpeg features beyond trim/export are not implemented.
- The Video Intelligence Layer is being designed as a metadata-only analysis layer for scene, beat, speech, face, and highlight detection.
- There are no end-to-end job orchestration, cloud deployment, or production-ready authentication flow exists yet.

## 10. Planned Features
- Add backend routes for project metadata, upload orchestration, and AI job submission.
- Add AI service endpoints for captioning, scene detection, style filters, and automated editing helpers.
- Add a metadata-oriented Video Intelligence service that can produce `IntelligenceReport` objects without editing source video.
- Connect the mobile app to backend APIs and Firebase storage.
- Add a real database schema and job state persistence for video processing workflows.
- Add CI checks, linting, and automated tests across the repo.

## 11. Commands Used
- `docker-compose up --build` — start local infrastructure.
- `make up` — same as `docker-compose up --build`.
- `cd apps/backend && npm install && npm run dev` — start backend.
- `make backend` — start backend via Makefile.
- `cd apps/mobile && flutter pub get && flutter run` — run mobile app.
- `make mobile` — start mobile app via Makefile.
- `cd services/ai && poetry install && poetry run uvicorn src.app:app --reload --port 8001` — run AI service.
- `make ai` — start AI service via Makefile.

## 12. Development Workflow
- Work from `main` and create feature branches like `feature/<short>` or `fix/<short>`.
- Keep PRs small, include a summary, and add testing notes.
- Use `.env` templates and local Docker Compose for environment setup.
- Start services in separate terminals for mobile, backend, and AI service.
- Update docs when architecture or workflows change.

### Cancellation flow (processing)

- Cancellation is a first-class operation in the editor: when a user cancels processing, the UI requests cancellation from the processing service, which calls FFmpegKit's cancel API to stop native sessions. The editor maintains a job id for each operation so that stale progress or completion events from cancelled jobs are ignored. Processing states include `idle`, `processing`, `success`, `failed`, and `cancelled`.

Notes:
- The cancellation call attempts a best-effort native stop; session termination time depends on platform/FFmpeg internals. The UI will immediately reflect the `cancelled` state and prevent cancelled jobs from overwriting newer jobs.

## 13. AI Collaboration Rules
- Document any model or AI service changes in the PR.
- Include a short evaluation plan for AI-related updates.
- Track version, dataset, and random seed when relevant.
- Add automated validation or regression checks for AI outputs when possible.
- Major model changes should be reviewed by an ML-savvy team member.

## 14. Known Limitations
- Backend and AI service are scaffolds, not fully integrated with the mobile app.
- AI service currently exposes only health and version endpoints.
- Firebase emulator is documented but not connected to the app flow.
- FFmpeg support is limited to trimming/export; filters and AI operations are unimplemented.
- There are no end-to-end tests or production-ready deployment scripts yet.

## 15. Future Scaling Notes
- Short-term: add CI, linting, tests, and stronger local setup docs.
- Mid-term: move Postgres to a managed cloud service, add message brokering for video jobs, and separate worker processes.
- Long-term: deploy AI services to Kubernetes or cloud containers, add GPU-backed inference nodes, model registry, and observability tooling.

## Phase 1 Readiness (Import → Trim → Preview → Export)

- Status: Phase 1 implemented and hardened for common mobile use-cases.
- What was done:
	- Fast stream-copy trimming with validation, and automatic re-encode fallback for accuracy.
	- Job IDs and guarded progress updates to avoid race conditions.
	- Native FFmpeg cancellation wired through `FFmpegKit.cancel()` and UI Cancel button.
	- Platform-safe temp directory usage via `path_provider` and temp-file promotion/cleanup APIs.
- Remaining work before wider rollout:
	- Add automated smoke tests for import→trim→export and CI integration.
	- Improve user-facing retry/fallback messages for different error cases.
	- Backend integration for uploads and persistence (Phase 2 scope).

Phase 1 Readiness: 8/10 — Ready to begin Phase 2 (integration) with recommended next steps above.

## 16. Universal Project Schema
Vexora relies on a single source of truth for all editing operations: the Universal Project Schema. This JSON-based schema is the primary contract between the Flutter UI, the AI Director, the Style Clone Engine, the FFmpeg Renderer, and the Backend.

Key architecture principles of the schema:
- **`schemaVersion`** is strictly enforced for future upgrades.
- **Assets are decoupled** from timeline clips to prevent duplication.
- **Time values** are recorded in integer milliseconds for precision across Dart, Python, and C.
- **Transitions and Captions** are independent entities on the timeline.
- **AI instructions, render settings, and history** are separated from core clip data.

For the full specification, JSON structure, and examples, refer to `docs/architecture/universal_project_schema.md`.

## Architecture Flow
The Vexora architecture is designed as a sequence of isolated responsibilities.

- The mobile app imports raw video assets and submits them to the `Video Intelligence Layer`.
- The `Video Intelligence Layer` creates an `IntelligenceReport` containing scenes, beats, speech, faces, and highlights.
- The `Style DNA Engine` (Phase 5A) reads a finished `Project Schema` plus `IntelligenceReport` and extracts a reusable `StyleDNA` editing personality.
- Extracted styles surface in the future `Creator Marketplace` as `StyleProfile` listings.
- The `Creator Intent Engine` transforms intelligence metadata (and eventually applied `StyleDNA`) into `Creator Intent JSON` for higher-level decision-making.
- The `AI Director Engine` consumes `Creator Intent JSON`, the `Universal Project Schema`, and eventually `StyleDNA` bias to produce a deterministic `Edit Blueprint`.
- The `Timeline Execution Engine` validates and applies the blueprint to update the project schema.
- The renderer or export layer consumes the final `Project Schema` to generate output without embedding intelligence logic directly into rendering.

This flow keeps intelligence, style extraction, intent, editing decisions, and rendering separate while preserving a clear handoff between layers.

## 19. Style DNA Engine
The Style DNA Engine transforms a finished edit into a reusable editing personality that can be applied to completely different footage. This is not a template or preset system — it is a creator-style extraction layer.

**Extraction Flow:**
```
IntelligenceReport + ProjectSchema → StyleExtractor → StyleDNA → StyleProfile (marketplace)
```

**Key properties:**
- Deterministic: identical inputs always produce identical Style DNA.
- No AI models, rendering, or timeline mutations.
- `StyleMetrics` is independent from Timeline Engine operations.
- `AIInstructions.styleReferenceId` is the schema hook for referencing an extracted style.

For full architecture, extraction rules, and integration plan, refer to `apps/mobile/lib/src/features/style_dna/README.md`.

## 17. AI Director Engine
The AI Director Engine is Vexora's core intelligence layer. It converts `Creator Intent JSON` and the `Universal Project Schema` into an `Edit Blueprint JSON`. The Blueprint categorizes operations (`cuts`, `zooms`, `transitions`, `captions`, `effects`, `audio`), ensuring deterministic decisions are tracked (with confidence scores and source attributions) without mutating source files or rendering video.

For the full architecture and schema, refer to `docs/architecture/ai_director_engine.md`.

## 18. Timeline Execution Engine (TEE)
The Timeline Execution Engine is the deterministic execution layer between the AI Director's Edit Blueprint and the Universal Project Schema.

**Execution Flow:**
```
Edit Blueprint → OperationValidator → TimelineExecutor → Project Schema Update → History Snapshot
```

**Supported Operations:** CUT, TRIM, SPLIT, ZOOM, CAPTION, TRANSITION, FILTER, AUDIO_GAIN.

**Key properties:**
- Every operation carries `operationId`, `timestamp`, `confidence`, and `source`.
- The validator enforces 10 discrete rules (timestamp validity, asset existence, track references, trim ranges, transition overlaps, non-negative durations, zoom factors, audio gain bounds, caption ranges, split-point bounds).
- The executor owns two bounded stacks: undo (default max 50) and redo.
- Regeneration passes create undo-able entries so AI re-generates are fully reversible.
- No rendering, no AI inference — pure in-memory state machine.

For full architecture, validation rules, and usage examples, refer to `apps/mobile/lib/src/features/timeline_engine/README.md`.
