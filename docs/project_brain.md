# Vexora — Project Brain

Purpose:
- Capture high-level product goals, core features, and architecture decisions.

Core idea:
- A mobile-first video editor that leverages AI for tasks like smart trimming, scene detection, automatic captions, and stylized filters.

Primary components:
- Mobile app (Flutter): UI, local edits, upload/download media via Firebase Storage.
- Backend (Node.js): user management, job orchestration, API gateway to AI services.
- AI services (Python): model inference for video/audio processing, runs as containerized microservices.
- Database (Postgres): users, metadata, job records.
- Storage/Auth (Firebase): fast mobile auth and media storage.
- Processing (FFmpeg): resilient video processing in workers or containers.

Design principles:
- Keep mobile lightweight — heavy processing happens server-side.
- Clear separation of concerns: API gateway vs AI workers vs storage.
- Containerize AI services for reproducibility.

Developer notes:
- Start with local dev setup using docker-compose for Postgres and local emulators for Firebase.
- Use feature branches and small PRs; document API contracts in `docs/`.
