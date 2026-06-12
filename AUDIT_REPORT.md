# Vexora Codebase Audit Report

## 1. Dead Code Analysis

- **Flutter Frontend:** A structural scan via `flutter analyze` reveals **0 linting issues**, indicating that the Dart code is well-structured without syntactic dead code (e.g., unused variables or uncalled internal functions).
- **Architectural Dead Code:** However, due to the scaffolded nature of the backend and AI services (which only expose `/health` endpoints), large swaths of the Flutter frontend's domain logic (`video_intelligence`, `ai_director`, `style_dna`) are functionally "dead." They operate on mock data or remain unexercised end-to-end because the server-side counterparts have not been implemented.

## 2. Unused & Missing Dependencies

- **Mobile (`pubspec.yaml`):** The dependency list is lean and clean (`flutter_riverpod`, `go_router`, `ffmpeg_kit`, `video_player`). However, despite `project_brain.md` mentioning Firebase Auth and Storage, the official Firebase SDK packages (`firebase_auth`, `firebase_storage`, `firebase_core`) are notably missing from the pubspec and are unused.
- **Backend (`package.json`):** `express` and `dotenv` are used. However, the `docker-compose.yml` spins up a PostgreSQL container, but the backend lacks any database driver (e.g., `pg`, `prisma`, `typeorm`). The DB is provisioned but unused.
- **AI Service (`pyproject.toml`):** Contains `fastapi` and `uvicorn`. No ML/AI libraries (like `torch`, `opencv-python`, or `transformers`) are installed yet.

## 3. Duplicate Components

- **Clean Structure:** A review of the `apps/mobile/lib/src/features` directory shows strict domain-driven design. `timeline_engine`, `style_engine`, and `ai_director` are isolated correctly. There is no evidence of widespread component duplication or copy-pasted UI widgets.

## 4. Performance Bottlenecks

- **Mobile FFmpeg Re-Encoding:** The `FfmpegService` relies on stream-copy (`-c copy`) for fast trimming, but falls back to safe re-encoding if frame alignment fails. Re-encoding HD/4K video locally on a mobile device is a severe performance and battery bottleneck. Future heavy rendering must be offloaded to cloud workers.
- **Node.js JSON Parsing:** The Universal Project Schema is a deeply nested JSON object. The backend's current `app.use(express.json())` middleware will parse these payloads synchronously on the main thread, which can cause event-loop blocking when handling massive project files at scale.
- **Lack of Pagination:** Current placeholders for `IntelligenceReport` arrays (`scenes`, `beats`, `faces`) lack pagination boundaries. A 30-minute video could produce arrays large enough to cause memory pressure on mobile devices.

## 5. Security Issues

- **Unbounded JSON Payloads:** The `apps/backend/src/index.js` file configures `app.use(express.json())` without a payload size limit (e.g., `{ limit: '1mb' }`). This exposes the Express server to Denial of Service (DoS) attacks via oversized payloads.
- **Missing API Hardening:** The Express backend lacks basic security headers. It should integrate `helmet` and configure strict `cors` policies.
- **Insecure Defaults:** The `docker-compose.yml` file sets a default database password (`POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-changeme}`). While acceptable for local dev, this poses a risk if these configurations are accidentally promoted to staging/production without environment variable injection.
- **Firebase Emulator Unprotected:** The Firebase emulator runs without strict security rules initialized, which could mask poorly structured client-side access patterns during development.
