# Changelog

## [Unreleased]

### Added
- **Phase 5B (Style DNA Influence)**:
  - `StyleBiasMatrix` and `StyleDNAMapper` to deterministically scale AI Director generation from Style DNA.
  - `BlueprintStyleHints` to persist style metadata in the generated `EditBlueprint`.
  - `StyleApplicationService` to orchestrate end-to-end Style DNA application.
  - Test suite validating that fitness/travel styles demonstrably change cut frequencies and transitions deterministically.
- Developer Dashboard: Created a complete visual verification layer for checking all AI pipeline features.
- Pipeline Flow Widget: Visualized the 5-stage Vexora AI processing chain (Video Intelligence → Creator Intent → AI Director → Timeline Engine → Style DNA).
- Demo Data: Created mock datasets to simulate realistic outputs for all features.
- Feature Cards: Added interactive glassmorphism cards for monitoring feature status.
- JSON Viewer: Added syntax-highlighted, scrollable JSON viewers to display feature output directly in the app.
- Interactive Test Screens for all 5 core features:
  - `VideoIntelligenceTestScreen`
  - `CreatorIntentTestScreen`
  - `AiDirectorTestScreen`
  - `TimelineEngineTestScreen`
  - `StyleDnaTestScreen`
- Navigation: Added Developer Dashboard quick-access buttons to both the Splash Screen and Home Screen.
- Routing: Configured GoRouter to support `/dev` route.

### Fixed
- Fixed corrupted file format with "+" symbols in `loading_widgets.dart`.
- Added missing `flutter_riverpod` and `go_router` dependencies to `pubspec.yaml`.
