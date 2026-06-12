# Local Setup Guide

This guide helps you run Vexora locally for development with a repeatable, beginner-friendly setup.

Prerequisites
- Install Docker and Docker Compose
- Install Flutter SDK (for mobile development)
- Install Node.js (v16+ recommended)
- Install Python 3.10+ and Poetry
- Optional: Install `firebase-tools` CLI for emulators

Setup checklist
- [ ] Clone the repository
- [ ] Copy the required `.env.example` files
- [ ] Install app dependencies
- [ ] Start local infrastructure and services
- [ ] Launch mobile, backend, and AI services separately as needed

Quick start

1. Clone the repo and navigate to the root:
```bash
git clone <your-fork-or-upstream-url>
cd Vexora
```

2. Copy environment templates and update values:
```bash
cp .env.example .env
cp apps/backend/.env.example apps/backend/.env
cp services/ai/.env.example services/ai/.env
cp infra/firebase/.env.example infra/firebase/.env
```

3. Start local services using Docker Compose:
```bash
docker-compose up --build
```

4. Start the backend in a new terminal:
```bash
cd apps/backend
npm install
npm run dev
```

5. Start the mobile app in another terminal:
```bash
cd apps/mobile
flutter pub get
flutter run
```

6. Start AI services in another terminal:
```bash
cd services/ai
poetry install
poetry run uvicorn src.app:app --reload --port 8001
```

Optional commands
```bash
make up      # start local infrastructure and services
make backend # start backend dev server
make mobile  # start Flutter app
make ai      # start AI service
make deps    # install dependencies for all projects
```

What should be running
- `postgres` for metadata storage
- `firebase-emulator` for auth and storage emulation
- `backend` for API and orchestration
- `ai-service` for AI inference placeholder
- `apps/mobile` for the Flutter client

Common troubleshooting
- If Postgres port conflicts, change `5432` mapping in `docker-compose.yml`.
- Ensure Firebase emulator ports (`9099`, `9199`) are free.
- Make sure `.env` files exist before starting services.
- On Windows PowerShell, use `Copy-Item` instead of `cp` if needed.

Future enhancements
- Add a one-command bootstrap target that starts backend, AI, and mobile together.
- Add a dedicated queue broker for job processing.
- Add health-check and readiness URLs for local service validation.
