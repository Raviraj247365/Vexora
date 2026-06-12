# Vexora Product Requirements Document (PRD)

## 1. Vision & Positioning
Vexora is an **Editing Intelligence Network** designed for mobile-first creators. It abstracts the complexity of video editing timelines by utilizing AI to translate *creator intent* and *style DNA* into deterministic edits. It is not just an editor; it is a marketplace where editing decisions are extracted, shared, remixed, and monetized.

## 2. Target Audience
- **Primary:** Mobile-first creators (TikTok, Shorts, Reels) who want high-retention editing styles without the learning curve of desktop NLEs.
- **Secondary:** Pro editors who wish to monetize their "editing personality" by publishing Style DNA to the Vexora marketplace.

## 3. Core Features & Capabilities

### 3.1 Deterministic Timeline Editing
- Fast, frame-accurate trimming and rendering using local FFmpeg or cloud orchestration.
- Reversible actions, stored as history states within the Universal Project Schema.

### 3.2 Video Intelligence Layer
- **Scene Detection:** Identify hard cuts and transitions.
- **Beat Detection:** Detect musical rhythm drops and peaks.
- **Speech & Face Detection:** Find spoken words, silences, and center faces for smart-cropping.
- **Highlight Detection:** Aggregate motion, beats, and speech into highlight confidence scores.

### 3.3 AI Director Engine
- Translates natural language intent (e.g., "Make it a hype gym reel") + Intelligence Reports into a strictly structured `EditBlueprint`.
- Enforces safety boundaries (e.g., no negative durations).

### 3.4 Style DNA Extraction
- Analyzes finished edits to extract a reusable "editing personality" (metrics like average cut duration, zoom frequency, pace).
- Packages style data into an immutable, versioned DNA payload.

### 3.5 Creator Marketplace
- A social ecosystem for discovering, copying, and remixing Style DNA.
- Feeds for Trending, Fasting Growing, and Category specific styles.
- Royalties and payouts for remix chains.

## 4. Success Metrics
- **Activation:** Time to first exported video < 3 minutes.
- **Engagement:** Average copies per published Style DNA > 10.
- **Retention:** Day 7 active user retention > 25%.
- **Monetization (Phase 7):** Number of creators earning > $100/mo.
