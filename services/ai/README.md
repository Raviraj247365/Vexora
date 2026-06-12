AI Services (Python)
--------------------

Purpose:
- Host AI inference endpoints, preprocessing, and model pipeline logic for Vexora.

Folder role:
- `src/` service entrypoint and API routes
- `Dockerfile` container image instructions
- `.env.example` runtime environment hints

Getting started:
- Copy environment settings: `cp services/ai/.env.example services/ai/.env`
- Install dependencies: `cd services/ai && poetry install`
- Start locally: `poetry run uvicorn src.app:app --reload --port 8001`

Docker:
- Build with `docker build -t vexora-ai services/ai`
- Run using `docker-compose up --build` once `docker-compose.yml` is updated.

Notes:
- Add model code under `services/ai/src/` and keep saved model weights outside source control.
- Use a message queue or API contract to connect backend and AI services cleanly.

What is implemented:
- FastAPI scaffold for AI inference endpoints.
- Dockerfile and local startup guidance.

What is scaffold only:
- No actual model inference or AI pipelines are implemented yet.
- This folder is currently the intended home for future AI service code.
