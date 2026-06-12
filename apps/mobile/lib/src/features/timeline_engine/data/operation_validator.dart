/// operation_validator.dart
///
/// Pre-execution validation layer for the Timeline Execution Engine.
///
/// Architecture notes:
/// - [OperationValidator] is a pure, stateless service — no side effects.
/// - It receives a [TimelineOperation] and the current project state context,
///   runs every applicable rule, and returns a [ValidationResult].
/// - Adding a new rule requires:
///     1. Adding a value to [ValidationRule] in validation_result.dart.
///     2. Implementing a `_check<Rule>` method here.
///     3. Wiring it into [_rulesFor].
/// - No rendering, no AI, no mutation.

import '../domain/timeline_operation.dart';
import '../domain/validation_result.dart';

// ---------------------------------------------------------------------------
// Minimal project-state context passed into the validator.
// In a full implementation this would reference a proper ProjectSchema model.
// ---------------------------------------------------------------------------

class ValidationContext {
  /// Set of all asset IDs currently registered in the project.
  final Set<String> registeredAssetIds;

  /// Set of all clip IDs present on all tracks.
  final Set<String> registeredClipIds;

  /// Set of all track IDs present on the timeline.
  final Set<String> registeredTrackIds;

  /// Map of clipId → duration in milliseconds.
  final Map<String, int> clipDurations;

  /// Map of clipId → timeline start position in milliseconds.
  final Map<String, int> clipTimelineStarts;

  /// List of existing transition intervals [startMs, endMs] on the timeline.
  final List<({int startMs, int endMs})> existingTransitionIntervals;

  const ValidationContext({
    required this.registeredAssetIds,
    required this.registeredClipIds,
    required this.registeredTrackIds,
    required this.clipDurations,
    required this.clipTimelineStarts,
    required this.existingTransitionIntervals,
  });

  /// Convenience factory that creates an empty context (useful in unit tests).
  factory ValidationContext.empty() {
    return const ValidationContext(
      registeredAssetIds: {},
      registeredClipIds: {},
      registeredTrackIds: {},
      clipDurations: {},
      clipTimelineStarts: {},
      existingTransitionIntervals: [],
    );
  }
}

// ---------------------------------------------------------------------------
// Validator
// ---------------------------------------------------------------------------

class OperationValidator {
  const OperationValidator();

  /// Entry point. Validates [operation] against [context] and returns a result.
  ValidationResult validate(
    TimelineOperation operation,
    ValidationContext context,
  ) {
    final rules = _rulesFor(operation.type);
    final violations = <ValidationViolation>[];

    for (final rule in rules) {
      final violation = _evaluate(rule, operation, context);
      if (violation != null) {
        violations.add(violation);
      }
    }

    if (violations.isEmpty) {
      return ValidationResult.pass(operation: operation, rulesChecked: rules);
    }
    return ValidationResult.fail(
      operation: operation,
      violations: violations,
      rulesChecked: rules,
    );
  }

  // -------------------------------------------------------------------------
  // Rule sets per operation type
  // -------------------------------------------------------------------------

  List<ValidationRule> _rulesFor(TimelineOperationType type) {
    // Shared rules applied to every operation type.
    const shared = [
      ValidationRule.validTimestamp,
    ];

    switch (type) {
      case TimelineOperationType.cut:
        return [
          ...shared,
          ValidationRule.nonnegativeDuration,
          ValidationRule.trackReferenceValid
        ];
      case TimelineOperationType.trim:
        return [
          ...shared,
          ValidationRule.trimRangePositive,
          ValidationRule.trackReferenceValid
        ];
      case TimelineOperationType.split:
        return [
          ...shared,
          ValidationRule.splitPointInsideClip,
          ValidationRule.trackReferenceValid
        ];
      case TimelineOperationType.zoom:
        return [
          ...shared,
          ValidationRule.zoomFactorPositive,
          ValidationRule.nonnegativeDuration,
          ValidationRule.trackReferenceValid
        ];
      case TimelineOperationType.caption:
        return [...shared, ValidationRule.captionRangeValid];
      case TimelineOperationType.transition:
        return [
          ...shared,
          ValidationRule.nonnegativeDuration,
          ValidationRule.noOverlappingTransitions,
          ValidationRule.trackReferenceValid
        ];
      case TimelineOperationType.filter:
        return [
          ...shared,
          ValidationRule.assetExists,
          ValidationRule.trackReferenceValid
        ];
      case TimelineOperationType.audioGain:
        return [...shared, ValidationRule.audioGainInBounds];
    }
  }

  // -------------------------------------------------------------------------
  // Rule evaluators — each returns null (pass) or a [ValidationViolation].
  // -------------------------------------------------------------------------

  ValidationViolation? _evaluate(
    ValidationRule rule,
    TimelineOperation op,
    ValidationContext ctx,
  ) {
    switch (rule) {
      case ValidationRule.validTimestamp:
        return _checkTimestamp(op);
      case ValidationRule.assetExists:
        return _checkAssetExists(op, ctx);
      case ValidationRule.trackReferenceValid:
        return _checkTrackReference(op, ctx);
      case ValidationRule.trimRangePositive:
        return _checkTrimRange(op);
      case ValidationRule.noOverlappingTransitions:
        return _checkNoOverlappingTransitions(op, ctx);
      case ValidationRule.nonnegativeDuration:
        return _checkNonnegativeDuration(op);
      case ValidationRule.zoomFactorPositive:
        return _checkZoomFactor(op);
      case ValidationRule.audioGainInBounds:
        return _checkAudioGain(op);
      case ValidationRule.captionRangeValid:
        return _checkCaptionRange(op);
      case ValidationRule.splitPointInsideClip:
        return _checkSplitPoint(op, ctx);
    }
  }

  // ---- Individual rule implementations ------------------------------------

  ValidationViolation? _checkTimestamp(TimelineOperation op) {
    if (op.timestamp <= 0) {
      return ValidationViolation(
        rule: ValidationRule.validTimestamp,
        description:
            'Operation timestamp must be a positive epoch millisecond value.',
        field: 'timestamp',
      );
    }
    // Allow up to 10 seconds clock skew into the future.
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (op.timestamp > nowMs + 10000) {
      return ValidationViolation(
        rule: ValidationRule.validTimestamp,
        description:
            'Operation timestamp is more than 10 seconds in the future.',
        field: 'timestamp',
      );
    }
    return null;
  }

  ValidationViolation? _checkAssetExists(
      TimelineOperation op, ValidationContext ctx) {
    if (op is FilterOperation) {
      // For filters the clipId is referenced, not an assetId directly.
      // Clip→asset resolution is handled downstream. Skip here if clip exists.
      if (!ctx.registeredClipIds.contains(op.clipId)) {
        return ValidationViolation(
          rule: ValidationRule.assetExists,
          description: 'Clip "${op.clipId}" not found in registered clips.',
          field: 'clipId',
        );
      }
    }
    return null;
  }

  ValidationViolation? _checkTrackReference(
      TimelineOperation op, ValidationContext ctx) {
    final trackId = op.targetTrackId;
    if (trackId != null && !ctx.registeredTrackIds.contains(trackId)) {
      return ValidationViolation(
        rule: ValidationRule.trackReferenceValid,
        description: 'Track "$trackId" does not exist in the project timeline.',
        field: 'targetTrackId',
      );
    }
    return null;
  }

  ValidationViolation? _checkTrimRange(TimelineOperation op) {
    if (op is TrimOperation) {
      if (op.newTrimEndMs <= op.newTrimStartMs) {
        return ValidationViolation(
          rule: ValidationRule.trimRangePositive,
          description:
              'Trim end (${op.newTrimEndMs} ms) must be strictly greater than '
              'trim start (${op.newTrimStartMs} ms).',
          field: 'newTrimEndMs',
        );
      }
    }
    return null;
  }

  ValidationViolation? _checkNoOverlappingTransitions(
      TimelineOperation op, ValidationContext ctx) {
    if (op is TransitionOperation) {
      // Compute approximate position of the proposed transition.
      // Position is derived from the timeline start of the clip that follows.
      final afterStart = ctx.clipTimelineStarts[op.afterClipId];
      if (afterStart == null) {
        return ValidationViolation(
          rule: ValidationRule.noOverlappingTransitions,
          description:
              'After-clip "${op.afterClipId}" not found; cannot verify transition overlap.',
          field: 'afterClipId',
        );
      }
      final proposedStart = afterStart - op.durationMs;
      final proposedEnd = afterStart;

      for (final interval in ctx.existingTransitionIntervals) {
        final overlaps =
            proposedStart < interval.endMs && proposedEnd > interval.startMs;
        if (overlaps) {
          return ValidationViolation(
            rule: ValidationRule.noOverlappingTransitions,
            description:
                'Proposed transition [$proposedStart–$proposedEnd ms] overlaps with '
                'existing transition [${interval.startMs}–${interval.endMs} ms].',
            field: 'durationMs',
          );
        }
      }
    }
    return null;
  }

  ValidationViolation? _checkNonnegativeDuration(TimelineOperation op) {
    if (op is CutOperation && op.endMs - op.startMs < 1) {
      return ValidationViolation(
        rule: ValidationRule.nonnegativeDuration,
        description: 'Cut duration must be at least 1 ms.',
        field: 'endMs',
      );
    }
    if (op is ZoomOperation && op.zoomEndMs - op.zoomStartMs < 1) {
      return ValidationViolation(
        rule: ValidationRule.nonnegativeDuration,
        description: 'Zoom duration must be at least 1 ms.',
        field: 'zoomEndMs',
      );
    }
    if (op is TransitionOperation && op.durationMs < 1) {
      return ValidationViolation(
        rule: ValidationRule.nonnegativeDuration,
        description: 'Transition duration must be at least 1 ms.',
        field: 'durationMs',
      );
    }
    return null;
  }

  ValidationViolation? _checkZoomFactor(TimelineOperation op) {
    if (op is ZoomOperation && op.zoomFactor < 1.0) {
      return ValidationViolation(
        rule: ValidationRule.zoomFactorPositive,
        description: 'Zoom factor ${op.zoomFactor} is invalid. Must be ≥ 1.0.',
        field: 'zoomFactor',
      );
    }
    return null;
  }

  ValidationViolation? _checkAudioGain(TimelineOperation op) {
    if (op is AudioGainOperation) {
      if (op.gainDb < -60.0 || op.gainDb > 20.0) {
        return ValidationViolation(
          rule: ValidationRule.audioGainInBounds,
          description:
              'Audio gain ${op.gainDb} dB is out of safe bounds (−60 to +20 dB).',
          field: 'gainDb',
        );
      }
    }
    return null;
  }

  ValidationViolation? _checkCaptionRange(TimelineOperation op) {
    if (op is CaptionOperation) {
      if (op.captionEndMs <= op.captionStartMs) {
        return ValidationViolation(
          rule: ValidationRule.captionRangeValid,
          description:
              'Caption end (${op.captionEndMs} ms) must be strictly greater than '
              'start (${op.captionStartMs} ms).',
          field: 'captionEndMs',
        );
      }
    }
    return null;
  }

  ValidationViolation? _checkSplitPoint(
      TimelineOperation op, ValidationContext ctx) {
    if (op is SplitOperation) {
      final duration = ctx.clipDurations[op.clipId];
      if (duration == null) {
        return ValidationViolation(
          rule: ValidationRule.splitPointInsideClip,
          description:
              'Clip "${op.clipId}" not found; cannot validate split point.',
          field: 'clipId',
        );
      }
      if (op.splitPointMs <= 0 || op.splitPointMs >= duration) {
        return ValidationViolation(
          rule: ValidationRule.splitPointInsideClip,
          description:
              'Split point ${op.splitPointMs} ms must be strictly inside clip '
              'duration [1, ${duration - 1}] ms.',
          field: 'splitPointMs',
        );
      }
    }
    return null;
  }
}
