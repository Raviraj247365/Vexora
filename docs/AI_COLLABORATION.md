# AI Collaboration Guide

This document helps AI-assisted tools and prompt-driven workflows understand the Vexora project quickly.

## Purpose

Use this guide when you want to:
- target prompts to the right folder or file
- understand what is implemented vs scaffolded
- identify where AI-related logic should live
- avoid hallucination in code changes

## Key folders

- `apps/mobile`
  - Flutter mobile app UI and feature scaffold.
  - This folder is the main frontend project and contains the canonical Flutter app.
  - Look here for UI, theming, routing, and mobile feature implementation.

- `apps/backend`
  - Node.js API gateway and orchestration entrypoint.
  - This folder contains the backend scaffold and route entrypoints.
  - Add API routes, business logic, and service coordination here.

- `services/ai`
  - Python AI service scaffold and inference API.
  - Use this folder for model serving, preprocessing, and AI feature endpoints.
  - Keep model weights and large data outside source control.

- `infra/`
  - Infrastructure helpers and local development scripts.
  - Subfolders:
    - `infra/postgres` — database init scripts and Postgres helpers.
    - `infra/firebase` — Firebase emulator config and auth/storage integration notes.
    - `infra/ffmpeg` — FFmpeg processing helpers and Docker examples.

- `docs/`
  - Project documentation, architecture notes, and setup guides.
  - This folder is the best place to answer questions about repo structure and workflow.

- `libs/`
  - Placeholder for shared libraries and reusable SDK code.
  - Use this folder for cross-project utilities, client libraries, or shared types.

## What is implemented

- `apps/mobile` contains a Flutter UI scaffold and navigation.
- `apps/backend` contains a minimal Express API with health and version routes.
- `services/ai` contains a FastAPI scaffold for AI inference.
- `docker-compose.yml` starts Postgres, Adminer, and a Firebase emulator.

## What is scaffold only

- The backend does not yet implement real job orchestration or database models.
- The AI service is a placeholder and does not include actual model inference logic.
- The mobile app is a UI prototype and does not contain real upload or editing workflows.

## Prompt guidance

To direct a prompt clearly, use the following structure:

1. Start with the target area:
   - `apps/mobile` for Flutter UI and frontend changes.
   - `apps/backend` for API and backend orchestration.
   - `services/ai` for AI inference and model service work.
   - `infra/*` for infrastructure, local emulators, or deployment helpers.
   - `docs/*` for documentation improvements.

2. Mention the desired outcome:
   - `Update this file for better state handling`.
   - `Add documentation for AI model service boundaries`.
   - `Keep changes simple and avoid adding new features`.

3. Ask for file-level focus when needed:
   - `Review apps/mobile/lib/src/app.dart for routing improvements.`
   - `Update docs/AI_COLLABORATION.md to reflect the current repo shape.`
   - `Improve service/ai README to describe placeholder responsibilities.`

## Avoiding hallucinations

- Prefer explicit references to files and folders rather than broad feature descriptions.
- Use the `docs/AI_COLLABORATION.md` guide to choose the correct project area.
- If a file is a scaffold, do not assume the feature is fully implemented.

## Notes for AI-assisted reviews

- The root `README.md` and `docs/project_brain.md` explain the repo purpose.
- `docs/architecture/system_design.md` explains the intended architecture and data flow.
- `docs/setup_guides/local_setup.md` describes the local environment and startup commands.
- `docs/TOC.md` indexes the main docs, making it easier for AI tools to discover resources.

## Best practices

- Keep code changes small and focused.
- Use clear, descriptive comments where the intent is not obvious.
- Prefer adding README and doc notes when the repository structure changes.
- Avoid changing file names or folder structure unless it clearly improves clarity.
