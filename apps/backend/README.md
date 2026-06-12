Backend (Node.js)
------------------

Purpose:
- Host the API gateway, job metadata persistence, and orchestration entry points for mobile and AI workflows.

Folder role:
- `src/` application source
- `Dockerfile` container image build instructions
- `.env.example` runtime environment hints

Getting started:
- Copy environment settings: `cp apps/backend/.env.example apps/backend/.env`
- Install dependencies: `cd apps/backend && npm install`
- Start locally: `npm run dev`

Docker:
- Build with `docker build -t vexora-backend apps/backend`
- Run using `docker-compose up --build` once `docker-compose.yml` is updated.

Notes:
- Keep secrets out of source control by using `.env` or a secrets manager.
- Add routes and job orchestration logic under `apps/backend/src/`.

What is implemented:
- Basic Express scaffold with health and version endpoints.
- Environment-driven startup and Docker support.

What is scaffold only:
- No full API contract or backend business logic is implemented yet.
- No job queue or worker orchestration code.
