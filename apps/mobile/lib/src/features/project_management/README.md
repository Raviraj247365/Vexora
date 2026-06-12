# Project Management

Local project lifecycle for the Vexora mobile app: create, rename, delete, duplicate, recent projects, metadata, and auto-save.

## Module Layout

```
project_management/
├── domain/
│   └── project_model.dart       — wraps ProjectSchema + management metadata
├── data/
│   ├── project_persistence.dart — file + in-memory storage
│   └── project_repository.dart  — CRUD and recent-project queries
└── presentation/
    ├── project_management_provider.dart — Riverpod + auto-save
    └── project_dashboard.dart           — full project library UI
```

## Features

| Feature | Implementation |
|---|---|
| Create Project | `ProjectRepository.createProject()` |
| Rename Project | `ProjectRepository.renameProject()` |
| Delete Project | `ProjectRepository.deleteProject()` |
| Duplicate Project | `ProjectRepository.duplicateProject()` |
| Recent Projects | `getRecentProjects()` sorted by `recentActivityAt` |
| Project Metadata | `ProjectModel` — progress, assetCount, clipCount, dates |
| Auto Save | `scheduleAutoSave()` — 2s debounce via `ActiveProjectManagementNotifier` |

## Persistence

Projects are stored as JSON in `{appDocuments}/vexora_projects/{projectId}.json`.

Legacy bare `ProjectSchema` files are still readable.

## Routes

- `/projects` — `ProjectDashboard` (full library)
- Home screen — recent projects carousel with “View all” link

## Dependencies

- Reads/writes `ProjectSchema` from `project_schema/`
- Does not depend on timeline engine, video intelligence, or rendering
