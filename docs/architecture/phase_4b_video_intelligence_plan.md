# Phase 4B Video Intelligence Implementation Plan

## Objective

Convert the Video Intelligence Layer from scaffold contracts into a real metadata extraction engine. The focus is on mobile-friendly, deterministic, metadata-only extraction for:

- Scene detection
- Beat detection
- Speech detection
- Highlight detection
- Intelligence report aggregation

This phase does not introduce AI models, cloud services, or timeline mutations.

## Scope and Constraints

- No AI inference.
- No cloud dependencies.
- No timeline mutation or rendering.
- Mobile-first performance and battery sensitivity.
- Deterministic outputs using fixed thresholds and stable sampling.
- Use existing FFmpeg/FFprobe integration where possible.
- Maintain compatibility with the existing Creator Intent Engine and AI Director contracts.

## Output Contracts

The implementation must produce the existing contract objects:

- `SceneDetection(startMs, endMs, confidence)`
- `BeatDetection(timestampMs, beatType, confidence)`
- `SpeechDetection(startMs, endMs, isSpeech, confidence)`
- `HighlightDetection(score, timestamp, reason)`
- `IntelligenceReport(videoId, scenes, beats, faces, speech, highlights)`

All time values must be integer milliseconds to match the Universal Project Schema and Timeline Engine.

## 1. Scene Detection Design

### Goal

Detect shot boundaries and segment the source video into scene ranges.

### Implementation Approach

1. Use FFmpeg / FFprobe scene-change capabilities as the primary integration path.
2. Extract a low-resolution proxy or use a downscaled version of the video for analysis.
3. Compute frame-difference metrics on grayscale / luma only.
4. Treat large, sustained frame deltas as shot boundaries.

### Algorithm

- Sample at a low frame rate (1–2 fps for long-form clips, up to 5 fps for short-form reels).
- For each sampled frame pair, compute a difference score based on:
  - histogram distance on the luma channel,
  - average absolute pixel difference in downscaled grayscale,
  - or FFmpeg's built-in `scene` metric.
- Generate a candidate scene boundary when the difference exceeds a calibrated threshold.
- Merge adjacent boundaries that are too close together to avoid over-segmentation.
- Enforce a minimum scene duration (e.g. 300 ms).

### FFmpeg/FFprobe Options

- Preferred: Use the FFmpeg built-in `scene` filter:
  - `ffmpeg -i input.mp4 -filter:v "select='gt(scene,0.35)'" -showinfo -f null -`
- Alternative: Use `ffprobe` with a filter graph to emit frame metadata.
- Fallback: Export a low-res grayscale sample stream and compute differences in Dart or native code.

### Mobile Performance Considerations

- Use low-resolution proxies or downscaled frames (e.g. 320x180).
- Avoid full-resolution decode whenever possible.
- Perform analysis in a background isolate or native thread.
- Keep memory low by processing frames sequentially and discarding old frame data.
- Prefer FFmpeg native filters over per-pixel Dart loops when available.

### Output

- `SceneDetection(startMs, endMs, confidence)`
- `startMs` and `endMs` define each detected shot range.
- `confidence` is derived from the magnitude of the scene-change score and the stability of surrounding frames.

## 2. Frame Difference Analysis

### Role

Frame difference analysis is the core feature used by scene detection.

### Design

- Use grayscale / luma-only comparison.
- Compute differences at low resolution to reduce work.
- Produce a numeric score per sample interval.
- Smooth the score using a short rolling window.
- Threshold crossing indicates a scene boundary.

### Implementation Notes

- Downscale to a fixed width, preserving aspect ratio.
- Use 8-bit grayscale to minimize decode complexity.
- Use histogram or pixel-average difference rather than full structural similarity for speed.
- Capture both immediate peaks and sustained difference patterns.

## 3. FFmpeg / FFprobe Integration Options

### Preferred Mobile Integration

- Use the app's existing FFmpeg kit integration.
- Leverage FFmpeg filters for scene and audio analysis.
- Avoid raw video-frame transport into Dart when possible.

### Possible Commands

- Scene detection:
  - `-filter:v "select='gt(scene,0.35)',showinfo"`
- Beat / energy extraction:
  - `-af "astats=metadata=1:reset=1"`
- Speech / silence detection:
  - `-af "silencedetect=noise=-35dB:d=0.3"`

### Deterministic Behavior

- Fix filter thresholds and window durations.
- Use the same sampling rates and precision across runs.
- Parse and normalize FFmpeg metadata consistently.

## 4. Beat Detection Design

### Goal

Identify audio energy peaks that are musically relevant and useful for edit timing.

### Lightweight Mobile-Friendly Approach

1. Extract a low-rate mono audio stream, e.g. 16 kHz or 22 kHz.
2. Compute a short-term energy envelope in fixed windows (e.g. 50–100 ms).
3. Identify peaks that exceed a local energy threshold and are separated by a minimum interval.
4. Output the timestamp and strength of each beat candidate.

### FFmpeg Integration Options

- Use FFmpeg audio statistics filters like `astats`.
- Use `ebur128` or `showvolume` if available.
- If necessary, export PCM data for local energy calculation.

### Deterministic Output

- Use constant audio resampling and window sizes.
- Normalize strength to a fixed 0.0–1.0 range.
- Prefer local maxima relative to the recent average energy envelope.

### Output

- `BeatDetection(timestampMs, strength)`
- `strength` is a normalized energy peak score.

## 5. Speech Detection Design

### Goal

Detect spoken versus silent sections using non-AI voice activity heuristics.

### Implementation Approach

- Use audio amplitude and silence detection.
- Apply threshold-based voice activity detection, not speech recognition.
- Derive speech segments by inverting silence intervals.

### FFmpeg Options

- Use `silencedetect=noise=-35dB:d=0.3` on a mono resampled audio stream.
- Parse `silence_start` and `silence_end` events to infer speech ranges.
- Optionally use energy-derived speech confidence.

### Mobile Constraints

- Use low-rate audio resampling for performance.
- Keep thresholds conservative to avoid false positives.
- Process audio metadata in a streaming pass instead of holding full audio in memory.

### Output

- `SpeechDetection(startMs, endMs, confidence)`
- `confidence` is based on the energy gap between speech and silence.

## 6. Highlight Detection Design

### Goal

Create a small set of salient highlight segments from combined scene, beat, and speech signals.

### Heuristic Design

- Score candidate events using a weighted combination of:
  - shot boundary strength,
  - beat energy peaks,
  - speech onset / offset events,
  - optional motion intensity.
- Group nearby candidate events into highlight regions.
- Normalize scores to a stable 0.0–1.0 range.

### Composition

- Scene changes contribute a high base score for edit-worthy moments.
- Beat peaks provide rhythmic emphasis.
- Speech starts or strong speech segments increase storytelling relevance.
- Optionally emphasize a region that contains both strong audio and a scene transition.

### Output

- `HighlightDetection(startMs, endMs, score)`
- `score` is a composite relevance score.
- `reason` can annotate the dominant signal type, e.g. `scene_change`, `beat_peak`, or `speech_highlight`.

## 7. Intelligence Report Builder

### Role

Aggregate detector outputs into a single `IntelligenceReport` for downstream systems.

### Build Process

1. Run scene detection to get shot ranges.
2. Run beat detection to get audio timing cues.
3. Run speech detection to map spoken regions.
4. Run highlight detection to produce prioritized segments.
5. Assemble all outputs into a deterministic `IntelligenceReport`.

### Structure

- `videoId`: the source video identifier.
- `scenes`: list of `SceneDetection` objects.
- `beats`: list of `BeatDetection` objects.
- `faces`: preserve existing face detection contract or leave empty until Phase 5.
- `speech`: list of `SpeechDetection` objects.
- `highlights`: list of `HighlightDetection` objects.

### Determinism

- Use fixed thresholds and sample rates.
- Avoid randomization or adaptive AI behavior.
- Document the exact filter and window parameters used.

## 8. Compatibility with Creator Intent Engine and AI Director

### Creator Intent Engine

- The `IntelligenceReport` provides metadata for intent parsing and enrichment.
- Scene boundaries help the Creator Intent Engine reason about shot structure and pacing.
- Beat timestamps help align intent-driven edits to musical timing.
- Speech segments support caption placement, dialogue-driven edits, and pacing.
- Highlights provide candidate emphasis regions for intent categories like `action`, `dialogue`, or `story`.

### AI Director

- The AI Director receives `IntelligenceReport` as a non-mutating signal.
- Scene data can be used to select source clips and transition points.
- Beat data can drive rhythm-aligned cuts and audio transitions.
- Speech segments can be used to preserve or highlight spoken content.
- Highlight segments can seed `EditBlueprint` operations for focus moments without modifying the report itself.

## 9. Implementation Notes

### Performance Best Practices

- Prefer FFmpeg/FFprobe native metadata extraction over Dart-level pixel loops.
- Keep frame and audio sample rates low.
- Offload extraction to a background isolate or native worker.
- Use proxies for mobile-friendly analysis.
- Parse metadata incrementally.

### Quality / Accuracy

- Calibrate scene thresholds to balance false positives and missed cuts.
- Use minimum durations to avoid rapid flicker reporting.
- Use peak-prominence analysis for beats rather than raw thresholding.
- Use silence-gap heuristics for speech rather than speech recognition.

### Future Extension

- Add face detection later as a separate Phase 4C or Phase 5 feature.
- Keep the metadata extraction API stable so the Creator Intent and AI Director layers can consume it unchanged.
- Preserve the contract that `IntelligenceService` only returns metadata and never edits video.

## 10. Summary

Phase 4B transforms the Video Intelligence Layer from placeholder scaffold into a concrete mobile metadata engine. It relies on deterministic FFmpeg/FFprobe analysis, low-resolution proxies, and fixed heuristics. The output report is compatible with the existing Creator Intent and AI Director layers, while remaining isolated from timeline mutation and rendering.
