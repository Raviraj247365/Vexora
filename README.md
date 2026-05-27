Vexora
======

Monorepo for the Vexora AI-powered mobile video editing app.

Overview:
- Flutter mobile app in `apps/mobile` (cross-platform UI)
- Node.js backend API in `apps/backend` (auth, API gateway)
- Python AI services in `services/ai` (models, pipelines)
- Infra helpers in `infra` (Postgres, Firebase, FFmpeg helpers)
- Shared libraries in `libs` (shared types, clients)

This repository contains only the architectural foundation and setup placeholders.

Next steps:
- Initialize each app's dependencies and add CI workflows.

Quick start (local development)
-------------------------------

1. Copy environment examples and edit values as needed:

```powershell
cp .env.example .env
cp apps/backend/.env.example apps/backend/.env
cp services/ai/.env.example services/ai/.env
cp infra/firebase/.env.example infra/firebase/.env
```

2. Start local infrastructure (Postgres + Firebase emulator):

```powershell
docker-compose up --build
```

3. Start the backend (hot reload):

```powershell
cd apps/backend
npm install
npm run dev
```

4. Start the AI services (example):

```powershell
cd services/ai
poetry install
poetry run uvicorn src.app:app --reload --port 8001
```

5. Start the Flutter app:

```powershell
cd apps/mobile
flutter pub get
flutter run
```

Common Git workflow
-------------------

- Create a branch from `main`: `git checkout -b feature/my-change`.
- Keep changes small; open PRs to `main` with a description and testing notes.
- Commit message conventions: `feat:`, `fix:`, `chore:`, `docs:`.

Need CI or further setup? See `CONTRIBUTING.md` and the `docs/` folder.
