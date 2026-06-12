# Style DNA Ecosystem — Architecture Design (Phase 5B)

> **Status:** Design document — no implementation code.
> **Audience:** Product, engineering, and investor stakeholders.
> **Positioning:** Vexora is building an **Editing Intelligence Network**, not a template or preset marketplace.

---

## Executive Summary

Vexora's Style DNA Ecosystem turns finished edits into portable editing personalities that can be saved, published, discovered, remixed, and applied to new footage. The network compounds value through creator reputation, style lineage, and usage telemetry — similar to how GitHub compounds code reuse, Spotify compounds taste graphs, Figma Community compounds design systems, and TikTok compounds trend velocity.

**Core insight:** Templates sell layouts. Presets sell filters. **Style DNA sells decision-making** — the invisible rhythm, energy, and editorial instincts that make a creator recognizable.

---

## Architecture Audit (Pre-Design Baseline)

### What Exists Today

| Layer | Status | Relevance to Ecosystem |
|---|---|---|
| Video Intelligence (4B) | Implemented | Supplies beats, scenes, highlights for extraction + application |
| Project Schema (4A) | Implemented | Source of finished-edit structure; `AIInstructions.styleReferenceId` hook exists |
| Style DNA Engine (5A) | Implemented | `StyleExtractor`, `StyleDNA`, `StyleMetrics`, `StyleProfile` — local only |
| Creator Intent (4A) | Scaffold + default impl | Accepts prompt + optional `IntelligenceReport`; no `StyleDNA` input yet |
| AI Director (4A) | Scaffold + default impl | Produces `EditBlueprint`; no style bias layer yet |
| Timeline Engine (2) | Implemented | Applies blueprints; must remain isolated from marketplace logic |
| Backend | Health/version only | No persistence, auth, or style APIs |
| Postgres infra | Bootstrap scripts only | No style tables |
| Mobile UI | Home templates (cosmetic) | Not connected to Style DNA network |

### Integration Hooks Already in Place

1. **`AIInstructions.styleReferenceId`** — Project Schema slot for referencing an applied or extracted style.
2. **`StyleExtractor`** — Deterministic extraction from `IntelligenceReport` + `ProjectSchema`.
3. **`StyleProfile` + `StyleCategory`** — Marketplace-facing wrapper with 9 categories aligned to product vision.
4. **`CreatorIntentEngine` contract** — Optional enrichment point for style-aware intent parsing.
5. **`AIDirectorEngine` contract** — Optional bias input for blueprint generation.

### Critical Gaps

| Gap | Risk if Unaddressed |
|---|---|
| No cloud storage for styles | Styles die on device; no network effects |
| No versioning or lineage | Remix and attribution break |
| No social graph (follow/like/copy) | No creator economy flywheel |
| No discovery/ranking service | Marketplace becomes a static catalog |
| No style application pipeline | Extraction is a dead end |
| No monetization rails | Creators have no incentive to publish |
| Backend/auth not wired | Cannot enforce ownership or payouts |

### Architectural Constraints (Non-Negotiable)

- Style DNA must never mutate source video or timelines directly.
- Marketplace logic must not leak into Timeline Engine or FFmpeg renderer.
- Style application flows through: **Style DNA → Creator Intent → AI Director → Edit Blueprint → Timeline Engine**.
- All style operations must be deterministic at the contract level (remix weights + inputs = reproducible output).
- Schema versioning (`schemaVersion`, `styleVersion`) must support backward-compatible evolution.

---

## 1. Style DNA Lifecycle

The lifecycle is the product. Every stage creates data that feeds the next.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           STYLE DNA LIFECYCLE                               │
└─────────────────────────────────────────────────────────────────────────────┘

  [1] CAPTURE                    [2] EXTRACT                 [3] STORE
  ───────────                    ───────────                 ─────────
  User imports video      →      Video Intelligence    →     Private Style Vault
  User edits in Vexora           IntelligenceReport          (draft / saved)
  User exports finished    →     StyleExtractor        →     style_versions row
  edit completes                 StyleDNA + metrics          encrypted JSON blob

                                        │
                                        ▼
  [6] APPLY                      [5] DISCOVER                [4] PUBLISH
  ───────────                    ───────────                 ───────────
  New footage imported    ←      Marketplace feeds     ←     Creator publishes
  StyleDNA loaded                Trending / Copied /           Public listing
  Creator Intent enriched        Category browse               Moderation queue
  AI Director biased       →     Follow graph            →     Attribution locked
  Edit Blueprint generated       Style preview cards           License tier set
  Timeline Engine executes
  New edit produced        →     Usage telemetry         →     popularityScore ↑
```

### Stage Definitions

| Stage | Actor | Input | Output | Storage |
|---|---|---|---|---|
| **Capture** | Creator | Raw footage | Finished `ProjectSchema` | `projects` table |
| **Extract** | System | `ProjectSchema` + `IntelligenceReport` | `StyleDNA` v1 | `style_versions` |
| **Store** | Creator | `StyleDNA` | Private draft or saved style | `styles` (visibility=private) |
| **Publish** | Creator | Saved style + metadata | Public `StyleProfile` listing | `styles` (visibility=public) |
| **Discover** | Consumer | Browse/search/follow | Selected `styleId` | Read replicas + cache |
| **Apply** | Consumer | New footage + `StyleDNA` | New `EditBlueprint` → edit | `style_copies` event |
| **Remix** | Creator | Style A + Style B + weights | `HybridStyleDNA` | `style_remixes` lineage |
| **Train** | Creator | Multiple own edits | Personal aggregate profile | `creator_style_profiles` |

### Personal Editing Profile Training

Over time, a creator's **Personal Style Genome** is computed from their last N published or private extractions:

```
PersonalProfile = weighted_aggregate(
  own_styles[0..N],
  weights = recency × export_count × engagement
)
```

This is not ML training in Phase 6–7. It is a deterministic rolling aggregate of their Style DNA metrics, surfaced as "Your Default Style" during new project creation.

---

## 2. Style DNA Schema

### Design Principles

- **Separate identity from payload:** `styles` row holds metadata; `style_versions` holds immutable DNA payloads.
- **Version everything:** Every extraction, remix, or re-extract creates a new version — never overwrite.
- **Extensible metrics block:** Unknown future signals live in `metrics` without breaking parsers.
- **Public vs. internal fields:** Marketplace sees summarized scores; full metrics available to owner and application engine.

### Canonical Schema (v1.0)

```json
{
  "schemaVersion": "1.0",
  "styleId": "fitness_alex_v3",
  "version": 3,
  "creatorId": "creator_001",
  "creatorName": "Alex Rivera",
  "styleName": "Frenetic Gym Hype",
  "category": "Fitness",
  "description": "Fast cuts on beat drops with kinetic captions",
  "visibility": "public",
  "license": "free_with_attribution",

  "pace": "frenetic",
  "energy": 92,
  "beatSync": true,
  "transitionStyle": "whip_pan",
  "zoomStyle": "snap_zoom",
  "captionStyle": "kinetic",
  "motionIntensity": 88,
  "sceneDensity": 1.25,

  "averageCutInterval": 0.8,
  "metrics": {
    "averageCutDuration": 0.8,
    "transitionFrequency": 0.31,
    "zoomFrequency": 0.18,
    "captionDensity": 6.2,
    "beatSyncScore": 78.5,
    "motionIntensity": 88.0,
    "sceneChangeFrequency": 1.25,
    "energyScore": 92.0
  },

  "lineage": {
    "parentStyleIds": [],
    "remixWeights": null,
    "extractedFromProjectId": "project_abc123",
    "extractedAt": "2026-06-11T14:30:00Z"
  },

  "social": {
    "popularityScore": 847.2,
    "copyCount": 1240,
    "likeCount": 3890,
    "remixCount": 87,
    "followerReach": 12000
  },

  "applicationHints": {
    "minFootageDurationSec": 15,
    "preferredAspectRatios": ["9:16"],
    "requiresMusicBeats": true,
    "confidenceFloor": 0.6
  },

  "createdAt": "2026-06-11T14:30:00Z",
  "updatedAt": "2026-06-11T14:30:00Z"
}
```

### Field Reference

| Field | Type | Description | Evolution Notes |
|---|---|---|---|
| `schemaVersion` | string | Contract version (`"1.0"`) | Bump on breaking changes |
| `styleId` | uuid/slug | Stable style identity across versions | Immutable after creation |
| `version` | int | Monotonic version per style | New row in `style_versions` |
| `creatorId` | uuid | Owner reference | FK → `creators` |
| `creatorName` | string | Denormalized display name | Refreshed on publish |
| `styleName` | string | Human label | Editable per version |
| `category` | enum | Marketplace category | See §3 |
| `pace` | enum | `frenetic`, `fast`, `moderate`, `slow` | Add enums in v2 if needed |
| `energy` | int 0–100 | Composite energy score | Derived from metrics |
| `beatSync` | bool | Whether cuts should align to beats | Threshold from beatSyncScore |
| `transitionStyle` | string | Dominant transition type | Extensible string registry |
| `zoomStyle` | string | Dominant zoom behavior | Extensible string registry |
| `captionStyle` | string | Dominant caption preset family | Maps to caption ops |
| `motionIntensity` | int 0–100 | Motion/highlight bias | |
| `sceneDensity` | float | Scene/cut changes per second | Alias of `sceneChangeFrequency` |
| `popularityScore` | float | Computed ranking signal | Not stored in DNA blob; computed |
| `copyCount` | int | Times style was applied | Denormalized counter |
| `metrics` | object | Full `StyleMetrics` block | Add keys freely in v1.x |
| `lineage` | object | Parent styles, remix weights | Critical for attribution |
| `applicationHints` | object | Constraints for AI Director | Added in v1.1+ |

### Mapping from Phase 5A Models

| Phase 5A (`StyleDNA`) | Ecosystem Schema | Notes |
|---|---|---|
| `energyScore` | `energy` | Renamed for API brevity |
| `metrics.sceneChangeFrequency` | `sceneDensity` | Surfaced as first-class field |
| `metrics` (full) | `metrics` | Preserved verbatim |
| N/A | `version`, `popularityScore`, `copyCount` | New ecosystem fields |
| `StyleProfile.likes/copies/followers` | `social.*` | Moved to social block + DB counters |

---

## 3. Style Marketplace

The marketplace is a **discovery engine**, not a file store. Users discover editing personalities, not project templates.

### Product Metaphor

| Platform | Vexora Equivalent |
|---|---|
| GitHub Trending | Styles gaining copies in 24h |
| Spotify Discover | "Because you edit fitness reels" |
| Figma Community | Preview cards with live style stats |
| TikTok Trends | Fastest-growing styles by category |

### Feed Types

| Feed | Algorithm (Phase 6) | Sort Key |
|---|---|---|
| **Trending** | `0.4 × copies_24h + 0.3 × likes_24h + 0.3 × remix_24h` | `trending_score DESC` |
| **Recent** | Published in last 7 days | `published_at DESC` |
| **Most Copied** | All-time application count | `copy_count DESC` |
| **Most Liked** | All-time likes | `like_count DESC` |
| **Fastest Growing** | `(copies_7d - copies_prev_7d) / max(copies_prev_7d, 1)` | `growth_rate DESC` |

### Popularity Score (Composite)

```
popularityScore =
    (copyCount × 3.0) +
    (likeCount × 1.0) +
    (remixCount × 5.0) +
    (followerReach × 0.01) +
    (growthRate7d × 100) +
    freshnessBoost

freshnessBoost = max(0, 50 - days_since_publish)
```

Scores are recomputed by a background worker every 15 minutes. Hot styles get cache TTL of 60 seconds; long-tail styles get 15 minutes.

### Categories

| Category | Discovery Tags | Typical Signals |
|---|---|---|
| Fitness | gym, workout, PR, hype | frenetic pace, beat-sync, kinetic captions |
| Gaming | clutch, montage, stream | fast cuts, snap zoom, high scene density |
| Travel | vlog, adventure, wander | moderate pace, cinematic transitions |
| Anime | amv, edit, sakuga | high motion, whip pans, dense cuts |
| Cars | automotive, drift, showcase | slow zoom, cinematic, bass sync |
| Luxury | premium, lifestyle, brand | slow pace, minimal captions, smooth transitions |
| Business | corporate, talking head, promo | moderate pace, clean captions, low zoom |
| Motivation | grind, success, speech | speech-synced captions, build-up pacing |
| Cinematic | film, story, mood | slow pace, long takes, color grade bias |

### Marketplace UX Surfaces (Phase 6)

1. **Style Card** — pace badge, energy meter, copy count, 5s preview reel (style applied to sample footage).
2. **Style Detail** — full metrics radar chart, creator profile link, remix button, copy-to-project CTA.
3. **Category Hub** — curated collections + algorithmic feed per category.
4. **Creator Spotlight** — top creators by category ranking.

### What the Marketplace Is NOT

- No downloadable project files.
- No timeline JSON exposed to consumers.
- No filter preset packs.
- No "duplicate this exact video" — only the **editing personality** transfers.

---

## 4. Creator Profiles

Creator profiles are the reputation layer. They convert style quality into followership and economic leverage.

### Profile Schema

```json
{
  "creatorId": "creator_001",
  "displayName": "Alex Rivera",
  "handle": "@alexfitness",
  "avatarUrl": "https://...",
  "bio": "Gym edits that hit different",
  "verified": false,
  "tier": "rising",

  "stats": {
    "followers": 12400,
    "following": 89,
    "publishedStyles": 7,
    "totalCopies": 18400,
    "totalLikes": 45200,
    "totalUses": 23100,
    "ranking": 42,
    "categoryRankings": {
      "Fitness": 3,
      "Motivation": 18
    }
  },

  "featuredStyleIds": ["fitness_alex_v3", "fitness_alex_v1"],
  "createdAt": "2026-01-15T10:00:00Z"
}
```

### Ranking System

```
creatorScore =
    (totalCopies × 2.0) +
    (totalLikes × 0.5) +
    (publishedStyles × 10) +
    (avgStylePopularity × 5) +
    (followerCount × 0.1)

categoryRanking = rank within category by creatorScore
globalRanking = rank across all creators by creatorScore
```

### Tier Progression

| Tier | Threshold | Benefits |
|---|---|---|
| **New** | 0 copies | Publish up to 3 public styles |
| **Rising** | 100 copies | Analytics dashboard, featured eligibility |
| **Established** | 1,000 copies | Remix royalties, priority discovery |
| **Top Creator** | 10,000 copies | Verified badge, revenue share tier |
| **Legend** | 100,000 copies | Platform partnerships, custom category |

### Social Actions

| Action | Effect | Stored In |
|---|---|---|
| **Follow** | User sees creator's new styles in feed | `creator_followers` |
| **Like** | Increments style like count | `style_likes` |
| **Copy** | Applies style to user's project | `style_copies` |
| **Remix** | Creates derived style with lineage | `style_remixes` |
| **Save** | Bookmarks style for later (no copy) | `style_saves` (Phase 6.1) |

---

## 5. Style Remix System

Remix is the compounding mechanism. It creates style lineage (like git forks) and enables hybrid editing personalities.

### Remix Input

```json
{
  "remixId": "remix_001",
  "parentStyles": [
    { "styleId": "fitness_alex_v3", "version": 3, "weight": 0.70 },
    { "styleId": "cinematic_sarah_v2", "version": 2, "weight": 0.30 }
  ],
  "outputStyleName": "Hype Cinematic Fusion",
  "creatorId": "creator_042"
}
```

### Blending Logic (Deterministic)

Weights must sum to 1.0. Output is a new `StyleDNA` with a new `styleId` and `version: 1`.

#### Numeric Fields — Weighted Linear Interpolation

| Field | Formula |
|---|---|
| `energy` | `round(A.energy × wA + B.energy × wB)` |
| `motionIntensity` | `round(A.motion × wA + B.motion × wB)` |
| `sceneDensity` | `A.density × wA + B.density × wB` |
| `averageCutInterval` | `A.interval × wA + B.interval × wB` |
| `metrics.*` | Each metric blended independently |

#### Boolean Fields — Weighted Threshold

| Field | Formula |
|---|---|
| `beatSync` | `true` if `(wA × (A.beatSync ? 1 : 0) + wB × (B.beatSync ? 1 : 0)) >= 0.5` |

#### Categorical Fields — Weighted Dominance with Tie-Break

| Field | Formula |
|---|---|
| `pace` | Map pace to ordinal (`frenetic=4, fast=3, moderate=2, slow=1`). Blend ordinals, round, map back. |
| `transitionStyle` | If `wA >= wB` use A's style; else B's. If equal, lexicographic tie-break. |
| `zoomStyle` | Same as transitionStyle |
| `captionStyle` | Same as transitionStyle |
| `category` | Inherit from highest-weight parent |

#### Pace Blending Example

```
Style A: pace=frenetic (4), weight=0.70
Style B: pace=moderate (2), weight=0.30
Blended ordinal = 4×0.70 + 2×0.30 = 3.4 → round → 3 → fast
```

#### Lineage (Immutable)

```json
{
  "lineage": {
    "parentStyleIds": ["fitness_alex_v3", "cinematic_sarah_v2"],
    "remixWeights": { "fitness_alex_v3": 0.70, "cinematic_sarah_v2": 0.30 },
    "remixId": "remix_001",
    "remixedBy": "creator_042"
  }
}
```

### Remix Rules

- Maximum 3 parents per remix (Phase 6); expandable to 5 in Phase 8.
- Remix creates a **new** style owned by the remixer.
- Parent creators receive attribution credit and optional royalty share (Phase 7).
- Remix of a remix is allowed; lineage chain preserved up to depth 10.
- Cannot remix private styles you do not own (unless shared via collaboration link).

---

## 6. AI Director Integration

Style DNA must integrate without breaking the existing layered architecture. The rule: **Style DNA biases decisions; it does not replace intelligence or intent.**

### Current Flow (Unchanged)

```
CreatorIntent + IntelligenceReport + ProjectSchema → AIDirectorEngine → EditBlueprint
```

### Extended Flow (Phase 5B+)

```
                    ┌─────────────────┐
                    │    StyleDNA     │
                    │  (or Hybrid)    │
                    └────────┬────────┘
                             │ bias
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
     ┌────────────┐  ┌──────────────┐  ┌──────────────┐
     │  Creator   │  │ Intelligence │  │   Project    │
     │   Intent   │  │    Report    │  │   Schema     │
     │  (enriched)│  │  (per-footage)│  │  (new footage)│
     └─────┬──────┘  └──────┬───────┘  └──────┬───────┘
           │                │                  │
           └────────────────┼──────────────────┘
                            ▼
                   ┌─────────────────┐
                   │  AI Director    │
                   │  Style Bias     │
                   │  Decision Matrix│
                   └────────┬────────┘
                            ▼
                   ┌─────────────────┐
                   │  Edit Blueprint │
                   └────────┬────────┘
                            ▼
                   ┌─────────────────┐
                   │ Timeline Engine │
                   └─────────────────┘
```

### Step 1 — Creator Intent Enrichment

`CreatorIntentEngine.parseIntent()` gains an optional `StyleDNA?` parameter:

| StyleDNA Field | Maps To CreatorIntent |
|---|---|
| `pace` | `style` field (`frenetic` → `fast_paced`) |
| `beatSync: true` | adds `beat-sync` keyword |
| `captionStyle` | adds `caption` keyword + style hint |
| `transitionStyle` | adds `transition` keyword |
| `zoomStyle` | adds `zoom` keyword |
| `category` | overrides or reinforces `category` |
| `energy > 80` | adds `hype` keyword |

Intent enrichment is deterministic string mapping — no ML.

### Step 2 — AI Director Style Bias Layer

New internal module: `StyleBiasMatrix` (does not replace existing decision logic).

| StyleDNA Signal | Blueprint Effect |
|---|---|
| `averageCutInterval` | Target clip duration for CUT/TRIM operations |
| `beatSync: true` | Snap cut boundaries to nearest `IntelligenceReport.beats` within 150ms |
| `transitionStyle` | Set `transitionType` on TRANSITION operations |
| `zoomStyle` | Set zoom factor curve on ZOOM operations |
| `captionStyle` | Set `stylePreset` on CAPTION operations |
| `motionIntensity` | Weight highlight-based FILTER operations |
| `sceneDensity` | Target number of cuts per timeline minute |
| `energy` | Scales confidence thresholds for aggressive vs. conservative ops |

### Step 3 — Project Schema Link

When a style is applied:

```json
{
  "aiInstructions": {
    "originalPrompt": "Apply @alexfitness Frenetic Gym Hype",
    "styleReferenceId": "fitness_alex_v3",
    "styleVersion": 3,
    "engineVersion": "v1.0",
    "aiAppliedFilters": ["StyleDNA", "AIDirector"]
  }
}
```

### Idempotency Guarantee

```
same(CreatorIntent, StyleDNA, IntelligenceReport, ProjectSchema)
  → same(EditBlueprint)
```

Style bias parameters are pure functions. No randomness in the bias layer (regeneration seed remains separate).

### What Does NOT Change

- Timeline Engine validation rules
- Video Intelligence extraction
- FFmpeg renderer
- Edit Blueprint schema shape (only operation parameters shift)

---

## 7. Database Design

PostgreSQL is the system of record. Firebase handles auth and media; Postgres handles style intelligence and social graph.

### Entity Relationship Diagram

```
creators ─────────────┬──────────── styles ──────────── style_versions
    │                 │               │                        │
    │                 │               ├──── style_likes        │
    │                 │               ├──── style_copies       │
    │                 │               └──── style_remixes ─────┘
    │                 │
    ├──── creator_followers
    │
    └──── creator_style_profiles (personal genome)
```

### Table Definitions

#### `creators`

| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | Matches Firebase UID |
| `handle` | VARCHAR(30) UNIQUE | @username |
| `display_name` | VARCHAR(100) | |
| `avatar_url` | TEXT | |
| `bio` | TEXT | |
| `tier` | ENUM | new, rising, established, top, legend |
| `verified` | BOOLEAN | Default false |
| `follower_count` | INT | Denormalized |
| `following_count` | INT | Denormalized |
| `total_copies` | INT | Denormalized |
| `total_likes` | INT | Denormalized |
| `ranking` | INT | Global rank, recomputed |
| `created_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

#### `styles`

| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | Stable styleId |
| `creator_id` | UUID FK → creators | |
| `name` | VARCHAR(100) | |
| `category` | ENUM | 9 categories |
| `description` | TEXT | |
| `visibility` | ENUM | private, public, unlisted |
| `license` | ENUM | free, attribution, premium |
| `current_version` | INT | Points to latest style_versions |
| `copy_count` | INT | Denormalized |
| `like_count` | INT | Denormalized |
| `remix_count` | INT | Denormalized |
| `popularity_score` | FLOAT | Recomputed by worker |
| `published_at` | TIMESTAMPTZ | Null if never published |
| `created_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

#### `style_versions`

| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | Version row ID |
| `style_id` | UUID FK → styles | |
| `version` | INT | Monotonic per style |
| `dna_payload` | JSONB | Full Style DNA schema (§2) |
| `metrics_payload` | JSONB | StyleMetrics block |
| `lineage` | JSONB | Parent styles, remix weights |
| `extracted_from_project_id` | UUID | Nullable |
| `created_at` | TIMESTAMPTZ | Immutable |

**Unique constraint:** `(style_id, version)`

#### `style_copies`

| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | |
| `style_id` | UUID FK → styles | |
| `style_version` | INT | Version at time of copy |
| `user_id` | UUID FK → creators | Who applied |
| `project_id` | UUID | Target project |
| `created_at` | TIMESTAMPTZ | |

#### `style_likes`

| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | |
| `style_id` | UUID FK → styles | |
| `user_id` | UUID FK → creators | |
| `created_at` | TIMESTAMPTZ | |

**Unique constraint:** `(style_id, user_id)`

#### `style_remixes`

| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | |
| `output_style_id` | UUID FK → styles | The new hybrid style |
| `parent_style_id` | UUID FK → styles | |
| `parent_version` | INT | |
| `weight` | FLOAT | 0.0–1.0 |
| `remixer_id` | UUID FK → creators | |
| `created_at` | TIMESTAMPTZ | |

#### `creator_followers`

| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | |
| `follower_id` | UUID FK → creators | |
| `following_id` | UUID FK → creators | |
| `created_at` | TIMESTAMPTZ | |

**Unique constraint:** `(follower_id, following_id)`

#### `creator_style_profiles` (Personal Genome)

| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | |
| `creator_id` | UUID FK → creators UNIQUE | |
| `genome_payload` | JSONB | Aggregated StyleDNA |
| `source_style_count` | INT | How many styles contributed |
| `last_trained_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

### Indexing Strategy

| Index | Purpose |
|---|---|
| `styles(category, popularity_score DESC)` | Category feeds |
| `styles(published_at DESC) WHERE visibility='public'` | Recent feed |
| `style_copies(style_id, created_at)` | Copy velocity |
| `style_copies(created_at) WHERE created_at > now() - 24h` | Trending |
| `creator_followers(following_id)` | Follower lists |
| `style_versions USING GIN(dna_payload)` | Future semantic search |

### API Surface (Backend — Phase 6)

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/v1/styles/extract` | Extract + save draft |
| POST | `/v1/styles/:id/publish` | Publish to marketplace |
| GET | `/v1/styles/feed/:type` | Trending, recent, etc. |
| GET | `/v1/styles/:id` | Style detail |
| POST | `/v1/styles/:id/copy` | Apply to project |
| POST | `/v1/styles/:id/like` | Like style |
| POST | `/v1/styles/remix` | Create hybrid |
| GET | `/v1/creators/:id` | Creator profile |
| POST | `/v1/creators/:id/follow` | Follow creator |

---

## 8. Future Roadmap

### Phase 6 — Style Marketplace (Q3 2026)

**Goal:** Make styles discoverable and applicable.

| Deliverable | Description |
|---|---|
| Backend style APIs | CRUD, feeds, social actions |
| Postgres migrations | All tables from §7 |
| Mobile marketplace UI | Feeds, style cards, detail pages |
| Style application flow | StyleDNA → Intent → Director → Blueprint |
| Creator profiles | Follow, stats, published styles list |
| Basic remix | 2-parent weighted blend |
| Moderation queue | Report/flag public styles |

**Success metric:** 1,000 public styles, 10,000 copies in 90 days.

### Phase 7 — Creator Economy (Q4 2026)

**Goal:** Creators earn from their editing intelligence.

| Deliverable | Description |
|---|---|
| Premium styles | Paid copy ($0.99–$4.99) |
| Remix royalties | Parent creators earn % on hybrid copies |
| Creator payouts | Stripe Connect integration |
| Style analytics | Copy geography, retention, remix tree |
| Brand partnerships | Sponsored style placements |
| Attribution enforcement | Watermark/metadata in exports |

**Monetization model:**

| Revenue Stream | Split |
|---|---|
| Premium style copy | 70% creator / 30% Vexora |
| Remix royalty | 15% parent A / 15% parent B / 40% remixer / 30% Vexora |
| Pro subscription ($9.99/mo) | Unlimited copies, advanced remix, analytics |
| Brand sponsored styles | CPM-based placement fees |

**Success metric:** 100 creators earning > $100/month.

### Phase 8 — AI Style Evolution (Q1 2027)

**Goal:** Styles improve automatically from usage data.

| Deliverable | Description |
|---|---|
| Usage-informed re-extraction | Popular styles re-extracted from best-performing copies |
| Style fitness scoring | Which styles produce highest export rates |
| Multi-parent remix (up to 5) | Complex hybrid personalities |
| Semantic style search | "Find styles like @alexfitness but more cinematic" |
| Style deprecation | Auto-archive low-performing versions |
| ML-assisted extraction (optional) | Enhance deterministic metrics with learned embeddings |

**Guardrail:** Deterministic contract preserved; ML is an optional enrichment layer, not a replacement.

### Phase 9 — Cross-Platform Intelligence (Q2 2027)

**Goal:** Style DNA works beyond Vexora mobile.

| Deliverable | Description |
|---|---|
| Public Style DNA API | Third-party apps apply Vexora styles |
| Premiere / DaVinci export | Style DNA → NLE-compatible edit markers |
| Web editor | Browser-based style application |
| TikTok / Reels trend ingestion | Detect trending edit patterns, suggest extractions |
| Cross-creator collaboration | Shared style workspaces |
| Enterprise API | Agencies manage brand style libraries |

**Success metric:** 10% of style copies originate outside Vexora mobile.

### Phase 10 — Autonomous Content Factory (Q4 2027)

**Goal:** Full pipeline from raw footage to published content with minimal human input.

| Deliverable | Description |
|---|---|
| Auto-style selection | AI picks best style for footage based on intelligence |
| Batch processing | 100 videos × 1 style → 100 edits |
| Scheduled publishing | Export → TikTok/YouTube/Instagram |
| Performance feedback loop | Post-publish analytics → style ranking update |
| Brand style governance | Enterprise controls on approved styles |
| Autonomous creator agents | AI agents that extract, publish, and iterate styles |

**Vision:** A creator uploads raw footage. Vexora selects the optimal style (personal genome or trending), generates the edit, and publishes — with creator approval gates.

---

## Competitive Positioning

### Why This Is Not a Template Marketplace

| Templates | Style DNA |
|---|---|
| Fixed clip arrangement | Portable decision-making rules |
| Same footage required | Any footage works |
| Static, breaks on new content | Adapts via Intelligence + Director |
| No creator attribution chain | Lineage, remix, royalties |
| Commodity (thousands identical) | Unique (each creator's rhythm) |

### Competitive Moat Layers

1. **Data moat** — Every copy generates telemetry that improves ranking, remix, and application.
2. **Network moat** — More creators → more styles → more consumers → more creators.
3. **Intelligence moat** — Video Intelligence + Style DNA + AI Director is an integrated stack competitors must rebuild.
4. **Economy moat** — Creator payouts create supply-side lock-in (Spotify model).
5. **Lineage moat** — Remix trees create attribution graphs no preset store has.

### Comparable Valuation Logic

| Company | Model | Relevance |
|---|---|---|
| GitHub | Code reuse + fork lineage | Style remix + attribution |
| Spotify | Taste graph + creator payouts | Style discovery + economy |
| Figma Community | Design system sharing | Style preview + copy |
| TikTok | Trend velocity + algorithm | Trending styles + growth rate |
| Canva | Template marketplace | Anti-pattern — we avoid this |

---

## Risks and Mitigations

| Risk | Severity | Mitigation |
|---|---|---|
| Styles don't transfer well across footage types | High | `applicationHints` + confidence floor + preview before apply |
| Low creator supply at launch | High | Seed with Vexora-authored styles; personal genome for every user |
| Remix attribution disputes | Medium | Immutable lineage in `style_versions`; clear ToS |
| Premium style piracy | Medium | Style DNA is useless without Vexora application pipeline |
| Metric gaming (fake copies) | Medium | Rate limits, device fingerprinting, copy-to-export validation |
| Schema evolution breaks old styles | Medium | `schemaVersion` + migration workers |
| Regulatory (creator payouts) | Low | Stripe Connect KYC; regional compliance in Phase 7 |

---

## Brutal Assessment

### Can this become a billion-dollar product?

**Yes — but only if Vexora executes on the network, not the feature.**

The Style DNA Engine in isolation is a clever extraction algorithm. That is not worth a billion dollars. What is worth a billion dollars is owning the **editing personality layer** for short-form video — the place where creators publish how they edit, consumers copy how they edit, and brands pay to be edited a certain way.

**Why it could work:**

1. **Timing.** Short-form video is the dominant content format. Every creator needs editing velocity. Templates are saturated; taste is not.
2. **Supply-side incentive.** Phase 7 royalties give creators a reason to publish styles that presets and templates never offered.
3. **Compounding data.** Every copy is a labeled data point: this style, this footage, this outcome. Phase 8 turns that into an evolving intelligence layer.
4. **Platform expansion.** Phase 9 makes Style DNA a horizontal API — Vexora becomes infrastructure, not just an app.
5. **Enterprise angle.** Brands will pay for consistent editing personality across hundreds of UGC videos. That is a B2B revenue line Canva cannot serve.

**Why it could fail:**

1. **Chicken-and-egg.** Marketplace needs styles; creators need audience. Without seed investment in supply, discovery is empty.
2. **Transfer quality.** If "apply @alexfitness style" produces mediocre edits, copies stop and the flywheel dies.
3. **Incumbent response.** CapCut, Adobe, and TikTok can ship "style copy" as a feature toggle. Vexora must be 10× better on transfer quality and creator economics.
4. **Execution gap.** Today the backend is a health endpoint. Phase 6–10 is 18+ months of serious engineering, growth, and creator ops.
5. **Monetization timing.** Premium styles before quality is proven will alienate creators and users.

**Verdict:** The architecture is sound. The moat is real but not yet built. The billion-dollar outcome requires Vexora to become the **Spotify of editing taste** — not the Canva of editing templates. The Style DNA Ecosystem design supports that outcome. The current codebase does not yet — and that gap is the only thing between this being a product thesis and a product.

**Probability estimate (honest):**

| Outcome | Probability | Condition |
|---|---|---|
| Niche creator tool ($1–10M ARR) | 40% | Phase 6 shipped, 10K MAU |
| Category leader ($50–100M ARR) | 15% | Phase 7 economy works, CapCut differentiation |
| Platform infrastructure ($500M+ ARR) | 5% | Phase 9 API adoption, enterprise traction |
| Billion-dollar outcome | 2–3% | All phases + market timing + no incumbent kill-shot |

The 2–3% is honest and still worth building — because the downside is a useful editing product, and the upside is a new content infrastructure category.

---

## References

- `apps/mobile/lib/src/features/style_dna/README.md` — Phase 5A implementation
- `docs/architecture/universal_project_schema.md` — Project Schema contract
- `docs/architecture/ai_director_engine.md` — AI Director contract
- `docs/architecture/video_intelligence_layer.md` — Intelligence layer contract
- `docs/project_brain.md` — System architecture overview
