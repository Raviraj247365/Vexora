# Phase 5B Audit

## Current Architecture Contracts

### `CreatorIntent`
- Location: `lib/src/features/creator_intent/creator_intent.dart`
- Responsibility: Pure domain model for creator intent parsing.
- Structure: Contains `prompt`, `category`, `style`, and `keywords`.

### `CreatorIntentEngine` & `DefaultCreatorIntentEngine`
- Location: `lib/src/features/creator_intent/creator_intent_engine.dart` and `default_creator_intent_engine.dart`
- Responsibility: Converts natural language prompts into a structured `CreatorIntent`. Can optionally use `IntelligenceReport` and `ProjectSchema` to enrich the intent. `DefaultCreatorIntentEngine` is a rule-based implementation.

### `AIDirectorEngine` & `DefaultAIDirectorEngine`
- Location: `lib/src/features/ai_director/ai_director_engine.dart` and `default_ai_director_engine.dart`
- Responsibility: Converts creator intent, intelligence metadata, and project schema into an `EditBlueprint`. `DefaultAIDirectorEngine` generates TRIM/CUT, TRANSITION/ZOOM, CAPTION, and FILTER operations based on heuristics.

### `EditBlueprint`
- Location: `lib/src/features/ai_director/edit_blueprint.dart`
- Responsibility: Contract model for AI Director output. Emits a typed list of timeline operations intended to be consumed by the Timeline Execution Engine. Contains `blueprintVersion`, `blueprintId`, `overallConfidenceScore`, and `operations`.

### `StyleDNA`
- Location: `lib/src/features/style_dna/style_dna.dart`
- Responsibility: Immutable representation of a reusable creator editing personality, extracted from a finished edit.
- Structure: Contains pacing, transition style, zoom style, caption style, beat sync preferences, and energy metrics.

## Future Modifications for Phase 5B

1. **CreatorIntent**: Extend to include `StyleDNA? preferredStyle`.
2. **CreatorIntentEngine**: Update to optionally consume `StyleDNA` and forward it into `CreatorIntent`.
3. **AIDirectorEngine**: Inject `StyleBiasMatrix` into blueprint generation to influence pacing, transitions, zoom frequency, caption density, and beat synchronization without changing public contracts unless necessary.
4. **EditBlueprint**: Attach `BlueprintStyleHints` safely to keep it serializable.
