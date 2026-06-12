# Creator Intent Engine

This module defines the foundation for the Creator Intent Engine.
It is a pure domain contract layer and does not perform AI inference, network calls, or timeline edits.

## Contents

- `creator_intent.dart` — `CreatorIntent` domain model.
- `creator_intent_engine.dart` — abstract engine contract for parsing prompts.
- `creator_intent_examples.dart` — example prompt-to-intent mappings for common reel styles.

## Goal

Convert a human prompt into a structured `CreatorIntent` object that can be consumed by the AI Director.
The engine may optionally use intelligence metadata and project context when available.
