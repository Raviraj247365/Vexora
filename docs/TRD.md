# Vexora Technical Requirements Document (TRD)

## 1. Technology Stack

### 1.1 Frontend (Mobile)
- **Framework:** Flutter + Dart
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Media Processing:** FFmpegKit
- **Video Playback:** `video_player`

### 1.2 Backend (API Gateway & Orchestrator)
- **Runtime:** Node.js
- **Framework:** Express.js
- **Environment:** `dotenv`

### 1.3 AI Intelligence Services
- **Runtime:** Python 3.10+
- **Framework:** FastAPI + Uvicorn
- **Dependencies:** `pytest` (Current dev). Future: PyTorch, Transformers.

### 1.4 Infrastructure & Storage
- **Primary Database:** PostgreSQL (Stores Projects, Jobs, Social Graph, Metadata).
- **Authentication:** Firebase Auth.
- **Object Storage:** Firebase Storage / Amazon S3.
- **Containerization:** Docker & Docker Compose.

## 2. Universal Project Schema
Vexora operates on a centralized, deterministic JSON schema that acts as the contract between the UI, AI Director, and Renderer.
- Features `schemaVersion` for migrations.
- Assets are decoupled from Timeline clips.
- Timeline operations (cuts, zooms, transitions) are stored independently of rendering logic.

## 3. Architecture Constraints
- **Separation of Concerns:** Intelligence extraction, AI direction, Timeline execution, and Rendering are strictly isolated layers.
- **Deterministic Execution:** The AI Director must be idempotent given the same `CreatorIntent` + `IntelligenceReport` + `StyleDNA`.
- **No Source Mutation:** Video files are treated as immutable. All edits are logical slices on the Universal Project Schema until final export rendering.

## 4. System Scalability & Future State
- **Compute:** Migrate local Node/Python services to container orchestrators (Amazon ECS/EKS). Python workers require GPU-accelerated instances (e.g., `g4dn.xlarge`).
- **Async Processing:** Adopt Redis + BullMQ or Amazon SQS for background jobs (rendering, intelligence extraction) as the platform shifts from local-only editing to cloud processing.
- **Databases:** Managed PostgreSQL (e.g., RDS) with connection pooling and multi-AZ failover.
