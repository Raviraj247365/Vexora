/// validation_result.dart
///
/// Represents the output of the pre-execution validation step.
///
/// Architecture notes:
/// - The [OperationValidator] always returns a [ValidationResult] — never throws.
/// - A failed result carries one or more [ValidationViolation] objects, each
///   identifying which rule was broken and why.
/// - The executor must only proceed if [ValidationResult.isValid] is true.
///
/// Do NOT add rendering or AI logic here. This is pure domain data.

import 'timeline_operation.dart';

/// Enumerates every discrete validation rule the engine enforces.
///
/// Adding a new rule here forces the validator to handle it explicitly.
enum ValidationRule {
  /// Operation timestamp must be > 0 and not in the future by more than 5 s.
  validTimestamp,

  /// All asset references in the operation must exist in the project asset registry.
  assetExists,

  /// Clip or track referenced by the operation must exist in the timeline.
  trackReferenceValid,

  /// Trim start must be strictly less than trim end.
  trimRangePositive,

  /// No two transitions may overlap at the same timeline position.
  noOverlappingTransitions,

  /// Cut/split/zoom durations must be ≥ 1 ms.
  nonnegativeDuration,

  /// Zoom factor must be ≥ 1.0 (no de-zoom operations).
  zoomFactorPositive,

  /// Audio gain must be within safe bounds (−60 dB to +20 dB).
  audioGainInBounds,

  /// Caption time range must be positive and non-overlapping for the same track.
  captionRangeValid,

  /// Split point must be strictly inside the clip duration.
  splitPointInsideClip,
}

/// Describes a single rule violation found during validation.
class ValidationViolation {
  /// The rule that was broken.
  final ValidationRule rule;

  /// Human-readable explanation suitable for developer logs.
  final String description;

  /// Optional: the field name or value that triggered the violation.
  final String? field;

  const ValidationViolation({
    required this.rule,
    required this.description,
    this.field,
  });

  @override
  String toString() => 'ValidationViolation(rule=$rule, '
      'field=$field, description="$description")';
}

/// The result of validating a [TimelineOperation] before execution.
class ValidationResult {
  /// The operation that was validated (always present).
  final TimelineOperation operation;

  /// True only when all rules pass with zero violations.
  final bool isValid;

  /// All violations found during validation. Empty on a passing result.
  final List<ValidationViolation> violations;

  /// Rules that were evaluated during this validation pass.
  final List<ValidationRule> rulesChecked;

  const ValidationResult._({
    required this.operation,
    required this.isValid,
    required this.violations,
    required this.rulesChecked,
  });

  /// Creates a passing [ValidationResult].
  factory ValidationResult.pass({
    required TimelineOperation operation,
    required List<ValidationRule> rulesChecked,
  }) {
    return ValidationResult._(
      operation: operation,
      isValid: true,
      violations: const [],
      rulesChecked: rulesChecked,
    );
  }

  /// Creates a failing [ValidationResult] with one or more violations.
  factory ValidationResult.fail({
    required TimelineOperation operation,
    required List<ValidationViolation> violations,
    required List<ValidationRule> rulesChecked,
  }) {
    assert(violations.isNotEmpty,
        'A failing ValidationResult must have at least one violation.');
    return ValidationResult._(
      operation: operation,
      isValid: false,
      violations: violations,
      rulesChecked: rulesChecked,
    );
  }

  /// Convenience: returns only the violated rules (subset of rulesChecked).
  List<ValidationRule> get failedRules =>
      violations.map((v) => v.rule).toList();

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult.pass(opId=${operation.operationId})';
    }
    return 'ValidationResult.fail(opId=${operation.operationId}, '
        'violations=${violations.length})';
  }
}
