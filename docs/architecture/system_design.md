# System Design — Vexora

This document explains the high-level system architecture and each folder's role in the repository so both humans and automation can understand the layout quickly.

What is included in this repo
- `apps/mobile` — Flutter client that authenticates users with Firebase, uploads media to Firebase Storage, and displays processing results.
- `apps/backend` — Node.js service acting as API gateway, metadata coordinator, and orchestration entrypoint.
- `services/ai` — Python microservice scaffold for AI inference, scene detection, captioning, and enhancement.
- `infra/postgres` — PostgreSQL initialization scripts and local database resources.
- `infra/firebase` — Firebase emulator configuration for auth and storage.
- `infra/ffmpeg` — FFmpeg helper Dockerfiles and local processing examples.

Folder-by-folder explanation (beginner-friendly)
- `apps/` — runnable applications. `apps/mobile` contains the Flutter client; `apps/backend` contains the API service.
- `services/` — microservices for specialized processing tasks. These services should be independent and deployable.
- `infra/` — local infrastructure helpers and deployment helpers for databases, emulators, and media processing.
- `libs/` — shared code libraries and helpers used across apps and services.
- `docs/` — documentation for architecture, setup guides, and project decisions.
- `docker-compose.yml` — local developer orchestration of services and infrastructure.

Service responsibilities
- Mobile app: UI, authentication, uploads, and progress display.
- Backend API: receive requests from the app, persist job metadata, and coordinate worker execution.
- AI service: serve model inference endpoints and return structured results.
- Postgres: store users, job state, metadata, and app configuration.
- Firebase: provide auth and object storage for media files.
- FFmpeg: handle deterministic media transforms, encoding, and output packaging.

Data flow overview
1. User authenticates via Firebase in the mobile app.
2. Mobile uploads raw video to Firebase Storage.
3. Mobile sends a job request to the backend API.
4. Backend persists job metadata in Postgres and schedules processing.
5. Processing workers or AI services fetch media from Firebase Storage.
6. Workers upload processed assets back to Storage.
7. Backend updates job status and notifies the mobile client.

What is ready now
- Basic mobile UI scaffold in `apps/mobile`.
- Backend and AI service starter scaffolds with placeholder health routes.
- Local environment wiring using `docker-compose.yml`.

Known gaps
- No production-ready authentication or authorization flows.
- No real job queue or durable task system yet.
- AI service is a minimal scaffold without model logic.
- No CDN / object storage separation beyond local Firebase emulation.

Future architecture notes
- Use managed Postgres for reliability and backups.
- Store media in highly-available object storage (S3, Cloud Storage).
- Add a dedicated queue broker (Redis, RabbitMQ) and worker autoscaling.
- Use Kubernetes for AI service orchestration, with GPU nodes for inference.
- Add a caching layer for output assets and metadata aggregation.

Security notes
- Keep service account keys out of source control; use env vars or secret managers.
- Require HTTPS for production endpoints.
- Enforce auth and authorization checks in the backend before returning job data.

Why this structure matters
- Separating storage, metadata, and compute keeps the app easier to scale.
- Independent AI services make model updates safer and easier to test.
- Clear folder separation improves onboarding and reduces accidental coupling.
