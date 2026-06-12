# AI Director

This module defines the AI Director contract layer.
It is a pure contract module and does not implement AI inference or network calls.

## Contents

- `ai_director_engine.dart` — abstract engine contract.
- `edit_blueprint.dart` — edit blueprint output contract.

## Goal

Provide a stable interface for the AI Director to convert creator intent, intelligence metadata, and project schema into a deterministic edit blueprint consisting of executable timeline operations.
