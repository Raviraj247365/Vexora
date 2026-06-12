# Vexora Roadmap

This roadmap outlines near-term milestones, medium-term goals, and long-term scaling plans for Vexora.

Current state
- Basic starter apps exist for `apps/mobile`, `apps/backend`, and `services/ai`.
- Local infrastructure is wired through `docker-compose.yml`.
- Core production flows and AI inference are still under development.

Short-term (0-3 months)
- Stabilize repo structure and documentation.
- Finish mobile skeleton and UI flows for the main creator experience.
- Add backend API routes for job creation, status, and result retrieval.
- Containerize AI service and improve local dev startup.
- Add linting and basic CI validation for each project.

Medium-term (3-12 months)
- Implement core AI features: smart trim, scene detection, auto-captioning.
- Add background processing workers for FFmpeg and AI inference.
- Add observability: logging, metrics, and error reporting.
- Expand integration tests and CI build pipelines.
- Improve developer ergonomics with better onboarding and run scripts.

Long-term (12+ months)
- Migrate to managed cloud infrastructure: managed Postgres, object storage.
- Scale AI services horizontally with model sharding and autoscaling.
- Add paid plans, pricing tiers, and multi-tenant support.
- Add a model registry or artifact store for versioned AI models.

Milestone checklist
- [ ] End-to-end upload → process → download flow
- [ ] AI quality baseline tests
- [ ] Production deployment runbook
- [ ] Complete developer onboarding guide and architecture overview
- [ ] Add a durable job queue and worker orchestration layer

Notes
- Roadmap is high-level — break milestones into sprint tasks in your tracker.
- Add risk items and dependencies as the project moves from prototype to production.
