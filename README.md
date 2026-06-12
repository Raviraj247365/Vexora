Vexora
======

Monorepo for the Vexora AI-powered mobile video editing app.

This repository is a working architecture scaffold for a Flutter mobile client, a Node.js backend, and Python AI services. The current codebase includes starter apps, local dev setup, and documentation for a scalable startup architecture.

Repository layout
-----------------
- `apps/mobile` — Flutter mobile app UI and feature scaffold.
- `apps/backend` — Node.js backend API and orchestration entrypoint.
- `services/ai` — Python AI service scaffold and inference API.
- `infra/` — Infrastructure helpers for Postgres, Firebase, and FFmpeg.
- `libs/` — Shared libraries, helpers, and cross-project code.
- `docs/` — Design notes, architecture docs, and setup guides.

Status
------
- Mobile app scaffold is available under `apps/mobile`.
- Backend and AI service scaffolds are included for local development.
- The project is still in early-stage architecture and does not yet implement full production workflows.

Quick start
-----------
1. Copy environment templates and update values:

```bash
cp .env.example .env
cp apps/backend/.env.example apps/backend/.env
cp services/ai/.env.example services/ai/.env
cp infra/firebase/.env.example infra/firebase/.env
```

2. Start local infrastructure and services:

```bash
docker-compose up --build
```

3. Start the backend in another terminal:

```bash
cd apps/backend
npm install
npm run dev
```

4. Start the mobile app in a separate terminal:

```bash
cd apps/mobile
flutter pub get
flutter run
```

5. Start AI services in another terminal:

```bash
cd services/ai
poetry install
poetry run uvicorn src.app:app --reload --port 8001
```

Developer tools
---------------
This repo includes a simple `Makefile` for common tasks:

```bash
make up      # start local infrastructure
make backend # start backend dev server
make mobile  # start Flutter app
make ai      # start AI service
make deps    # install dependencies for all projects
```

Documentation
-------------
- `docs/TOC.md` — table of contents for project documentation.
- `docs/project_brain.md` — product goals, architecture thinking, and style guidance.
- `docs/architecture/system_design.md` — high-level system architecture and service responsibilities.
- `docs/setup_guides/local_setup.md` — local development setup steps.
- `docs/AI_COLLABORATION.md` — AI-friendly project mapping, prompt guidance, and folder responsibilities.

Git workflow
------------
- Create a branch from `main`: `git checkout -b feature/my-change`.
- Keep PRs small and include a summary plus testing notes.
- Use commit prefixes like `feat:`, `fix:`, `chore:`, `docs:`.

Need more details? See `CONTRIBUTING.md` and the `docs/` folder.
