# VEXORA UX/UI Audit — Phase UX-1

## 1. UX Audit
**Current State Analysis:**
VEXORA currently functions as a highly technical prototype rather than a premium product. The architecture under the hood is robust (Timeline Engine, AI Director, Style DNA), but the UI presents these capabilities like a developer diagnostic tool.

**Identified UX/Visual Problems:**
- **Cognitive Overload:** The Home Page currently shows too many technical abstractions (e.g., "Developer Dashboard", "Quick AI", "Timeline Execution Engine" placeholders).
- **Navigation Issues:** Routes are a mix of technical debug screens (`/dev`, `/intelligence`) and core product screens. There's no cohesive bottom navigation or workspace abstraction.
- **Missing Hierarchy:** Information architecture lacks clear priority. Technical details are exposed alongside creative tools.
- **Empty States:** Missing or basic text-based empty states (e.g., `Text('No recent projects. Create one!')`). No actionable onboarding.
- **Visual Identity:** Relies heavily on generic Flutter Material components, standard shadows, and basic gradients. The design lacks the tailored, immersive "AI Video Operating System" feel found in Cursor or Linear.

## 2. Screen Inventory
**Current Screens:**
1. Splash (`/`)
2. Onboarding (`/onboarding`)
3. Home (`/home`)
4. Developer Dashboard (`/dev`)
5. Style Guide (`/styleguide`)
6. Import (`/import`)
7. Video Intelligence Viewer (`/intelligence`)
8. AI Playground (`/ai-playground`)
9. Preview (`/preview`)
10. Video Editor / Timeline (`/editor`)
11. Export (`/export`)
12. Project Dashboard (`/projects`)
13. Marketplace Details (`/marketplace/details`)
14. Marketplace Creator Profile (`/marketplace/creator`)

**Action:** Consolidate these into a clean 5-tab workspace model, moving technical diagnostics (`/dev`, `/intelligence`) strictly into a hidden developer menu.

## 3. Navigation Map (Proposed)
**Primary Workspace Navigation (Bottom Navigation):**
- **Home:** Hero action ("Create with AI"), Quick Stats, AI Insights, Recent Projects.
- **Projects:** Library of all user projects (Notion/Canva style grid with thumbnails, progress, and actions).
- **Create (FAB / Central Tab):** Deep links into the new "AI Workspace" flow.
- **Marketplace:** Premium style discovery (Spotify/TikTok feed).
- **Profile:** Creator stats, downloaded styles, and settings.

**Project Flow:**
`Home/Projects` -> `Select Project` -> `AI Workspace ("What would you like to do?")` -> `Timeline / Properties`.

## 4. Updated Folder Structure
The UI components will be migrated to a centralized design system package/folder:
```
lib/src/
├── design_system/
│   ├── tokens/         (colors, typography, spacing, radius, shadows, motion)
│   ├── components/     (ActionCard, ProjectCard, StyleCard, GlassPanel, etc.)
│   ├── layouts/        (Responsive wrappers, screen scaffolds)
│   └── theme.dart      (Global app theme overriding Material defaults)
```

## 5. Migration Notes
- **Theme Injection:** The current `VexoraTheme` in `lib/src/core/theme.dart` will be deprecated in favor of `lib/src/design_system/theme.dart`.
- **Component Replacement:** Standard Flutter `Cards`, `ElevatedButtons`, and `Containers` will be systematically replaced with `GlassPanel`, `VexoraButton`, `AIActionCard`, etc.
- **Routing:** `GoRouter` in `lib/src/app.dart` will be restructured to use a `ShellRoute` for the main bottom navigation experience.
- **Business Logic Preservation:** Providers (e.g., `projectManagementProvider`, `aiDirectorProvider`) will remain entirely untouched. Only the `Widget` build methods consuming them will be rewritten.
