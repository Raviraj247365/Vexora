Vexora Mobile App (Flutter)
=================================

This folder contains a clean, scalable Flutter frontend foundation for Vexora.

Architecture:
- Clean architecture / feature-first layout under `lib/src/`.
- State management: Riverpod (`flutter_riverpod`).
- Navigation: GoRouter (`go_router`).
- Theme & responsiveness: centralized theme system with dark mode and responsive helpers.

What this scaffold includes:
- `splash`, `onboarding`, and `home` feature folders with placeholder UI.
- A new video editor feature under `lib/src/features/video_editor`.
- `ThemeMode` managed via Riverpod and a toggle on the home screen.
- `GoRouter` navigation wired between screens.

What is implemented:
- Canonical Flutter app in `apps/mobile`.
- UI scaffold, theme system, and initial navigation routes.
- Video import, trim controls, preview playback, and export placeholder MVP.

What is scaffold only:
- No real backend API integration yet.
- No AI inference workflows or video editing pipelines implemented.

Notes:
- This is a UI foundation only — no backend, AI, or video editing logic is included.
- Keep feature folders small and focused; add models/services under `lib/src/features/<feature>/` when needed.
