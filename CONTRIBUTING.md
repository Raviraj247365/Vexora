# Contributing to Vexora

Welcome — thank you for contributing. This guide covers common commands, Git workflow, code review expectations, and communication norms.

Getting started
- Fork the repo and clone your fork, or branch off `main` if you have direct push access.

Common local commands

Install dependencies (backend):
```bash
cd apps/backend
npm install
```

Run Flutter app:
```bash
cd apps/mobile
flutter pub get
flutter run
```

Run AI service locally (example):
```bash
cd services/ai
poetry install
poetry run uvicorn src.app:app --reload --port 8001
```

For AI-assisted development
- Use `docs/AI_COLLABORATION.md` to understand folder roles and prompt targeting.
- Reference the folder README for the area you are changing before editing.

Docker compose (local dev):
```bash
docker-compose up --build
```

Git workflow
- Branch naming: `feature/<short-desc>`, `fix/<short-desc>`, `chore/<short-desc>`.
- Create a branch from `main` and open a PR back to `main`.
- PRs should have a short description, list of changes, and testing notes.
- Use small, focused PRs — reviewers appreciate tiny diffs.

Code reviews
- Add unit tests when adding business logic. Keep functions small and testable.
- Provide a short explanation for design decisions in PR description.

AI workflow rules (high level)
- Any change to AI models or inference code must include an evaluation plan and expected metrics.
- Store training configuration and random seeds for reproducibility.
- New models must be validated against a holdout dataset and approved by at least one reviewer with ML experience.

Reporting issues
- Open issues for bugs, feature requests, or design discussions. Use templates when available.

Future notes
- Add CI rules and code style checkers (ESLint, dartfmt, black) in future iterations.
