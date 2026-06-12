# Vexora Tech Stack

High-level technologies chosen for clarity and scalability. Each entry includes a short, beginner-friendly explanation.

- Flutter (Mobile): Cross-platform SDK for building iOS and Android apps from a single Dart codebase. Good for fast UI iteration.
- Node.js (Backend API): JavaScript runtime for the API gateway, auth flows, and orchestration. Easy to integrate with Firebase SDKs.
- Python (AI Services): Python is the ecosystem standard for ML; use containerized microservices for model inference.
- PostgreSQL (Database): Reliable relational DB for user data, metadata, and job records.
- Firebase (Auth & Storage): Mobile-friendly identity and object storage with SDKs for Flutter.
- FFmpeg (Video Processing): Industry-standard CLI for encoding, trimming, and format conversions.
- Docker (Dev & Production): Containerization for reproducible deployments of services.
- Docker Compose (Local Dev): Quickly spin up Postgres and emulators locally.

Why these choices?
- Prioritize developer productivity, cross-platform mobile support, and ML ecosystem maturity.

Common libraries and tools to expect
- Flutter packages: `firebase_auth`, `firebase_storage`, `provider` or `riverpod` for state management.
- Node.js: `express`, `pg` (Postgres client), `firebase-admin`.
- Python: `fastapi` or `flask` for lightweight service APIs, ML libs: `torch`, `transformers` (as needed).
