# Vexora Implementation Roadmap

This roadmap breaks down the engineering effort required to transition Vexora from its current scaffold state to a fully integrated production application. 

---

## Phase 1: Core AI (The Director Layer)

**Goal:** Implement the AI Director Engine on the Python microservice, allowing the translation of natural language intent and project schema into deterministic Edit Blueprints.

* **Target Services:** `services/ai` (Python), `apps/backend` (Node.js)
* **Complexity:** High (Algorithmic logic and schema validation)
* **New Dependencies:** 
  - Python: `pydantic` (for schema validation), `openai` or `anthropic` (for LLM intent parsing), `celery` (for async task queue).
* **Estimated Files to Modify/Create:** ~15 files
  - `services/ai/src/director/intent_parser.py`
  - `services/ai/src/director/blueprint_generator.py`
  - `services/ai/src/director/safety_rules.py`
  - `services/ai/src/routers/director_api.py`
  - Validation schemas mapping to the Universal Project Schema.
* **Development Hours:** ~60 - 80 hours
* **Milestone:** Passing a mock Project Schema to the API returns a valid Edit Blueprint containing frame-accurate cuts and captions.

---

## Phase 2: Video Intelligence

**Goal:** Build the metadata extraction pipeline that analyzes raw video to generate the `IntelligenceReport` (Scenes, Beats, Speech, Highlights) without rendering video.

* **Target Services:** `services/ai` (Python)
* **Complexity:** Very High (Machine Learning Inference and Audio/Video processing)
* **New Dependencies:** 
  - Python: `librosa` (audio/beat detection), `opencv-python` (scene/face detection), `whisper` or Google Cloud Speech-to-Text (speech detection), `ffmpeg-python`.
* **Estimated Files to Modify/Create:** ~20 files
  - `services/ai/src/intelligence/beat_detector.py`
  - `services/ai/src/intelligence/scene_detector.py`
  - `services/ai/src/intelligence/speech_recognizer.py`
  - `services/ai/src/intelligence/highlight_scorer.py`
  - `services/ai/src/routers/intelligence_api.py`
* **Development Hours:** ~100 - 120 hours
* **Milestone:** Submitting a proxy video URL to the AI service returns a complete JSON `IntelligenceReport` accurately mapping the file's dynamic peaks.

---

## Phase 3: Marketplace (Style DNA Ecosystem)

**Goal:** Implement the backend persistence layer, database schemas, and API routes required to extract, save, discover, and remix Style DNA profiles.

* **Target Services:** `apps/backend` (Node.js), `apps/mobile` (Flutter)
* **Complexity:** Medium (Standard CRUD, Feed algorithms, and SQL)
* **New Dependencies:**
  - Node.js: `pg` (Postgres client), `prisma` or `drizzle-orm` (Database ORM).
* **Estimated Files to Modify/Create:** ~25 files
  - Backend: `src/controllers/style.controller.js`, `src/services/marketplace.service.js`, `src/services/style_extractor.js`, Prisma/SQL schema definitions.
  - Mobile: `lib/src/features/marketplace/presentation/*` (Feed UI, Style Cards), `lib/src/features/marketplace/data/marketplace_repository.dart`.
* **Development Hours:** ~80 - 100 hours
* **Milestone:** Users can browse a live feed of trending styles on their mobile device, view the metrics radar chart, and tap "Apply Style" to load it into their local project.

---

## Phase 4: Cloud Sync & Orchestration

**Goal:** Connect the isolated local experiences into a seamless cloud-synced workflow, including Firebase Auth, S3 proxy uploads, and asynchronous cloud rendering queues.

* **Target Services:** `apps/backend` (Node.js), `apps/mobile` (Flutter), `infra`
* **Complexity:** High (Distributed systems, async state synchronization)
* **New Dependencies:**
  - Node.js: `firebase-admin`, `bullmq` (Redis job queue), `@aws-sdk/client-s3`.
  - Mobile: `firebase_core`, `firebase_auth`, `firebase_storage`.
* **Estimated Files to Modify/Create:** ~30 files
  - Mobile: Auth flow screens, `UploadService` for pushing proxy/raw assets to S3/Firebase.
  - Backend: `src/middlewares/auth.middleware.js`, `src/queues/render.queue.js`, `src/queues/intelligence.queue.js`.
  - Infra: Redis container in `docker-compose.yml`.
* **Development Hours:** ~120 - 150 hours
* **Milestone:** A user logs in, imports a video, it invisibly syncs proxies to the cloud, the cloud generates the intelligence report and edit blueprint asynchronously, and the final high-res render occurs on a cloud FFmpeg worker.
