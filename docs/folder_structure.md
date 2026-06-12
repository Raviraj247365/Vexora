# Vexora Folder Structure

Vexora is structured as a monorepo containing multiple distinct service boundaries and isolated workspaces.

```text
Vexora/
├── apps/
│   ├── backend/               # Node.js API Gateway & Orchestrator
│   │   ├── src/               # Express routes, controllers, and job queues
│   │   ├── Dockerfile
│   │   └── package.json
│   │
│   └── mobile/                # Flutter Mobile Client
│       ├── android/
│       ├── ios/
│       ├── lib/
│       │   ├── main.dart
│       │   └── src/
│       │       ├── core/      # Base utilities and models
│       │       ├── design/    # UI Component library and theme
│       │       └── features/  # Domain-driven feature modules
│       │           ├── ai_director/
│       │           ├── creator_intent/
│       │           ├── style_dna/
│       │           ├── timeline_engine/
│       │           ├── video_editor/
│       │           ├── video_intelligence/
│       │           └── ...
│       └── pubspec.yaml
│
├── services/
│   └── ai/                    # Python FastAPI Intelligence Service
│       ├── src/               # Models, routers, and intelligence extractors
│       ├── pyproject.toml
│       └── Dockerfile
│
├── infra/                     # Local Dev & Infrastructure Setup
│   ├── ffmpeg/                # Dockerfiles for custom FFmpeg builds
│   ├── firebase/              # Firebase emulator configuration
│   └── postgres/              # Database initialization scripts
│
├── libs/                      # Shared Monorepo Code
│   └── README.md              # Placeholder for shared DTOs/Schemas
│
└── docs/                      # Technical Documentation
    ├── api_docs/
    ├── architecture/          # Deep-dives into system logic
    └── setup_guides/
```

### Purpose Breakdown
- **`apps/`**: The main executable endpoints. `mobile` is the user client. `backend` is the primary traffic router and orchestrator.
- **`services/`**: Specialized compute microservices. The `ai` service runs Python for data science/ML dependencies without bloating the main backend.
- **`infra/`**: Setup wrappers that make local development predictable and unified via Docker.
- **`libs/`**: Code that needs to be shared across boundaries (e.g., API interfaces or the Universal Project Schema definitions).
