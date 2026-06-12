/// execution_result.dart
///
/// Represents the outcome of applying a [TimelineOperation] through the
/// Timeline Execution Engine.
///
/// Architecture notes:
/// - The executor always returns an [ExecutionResult] — it never throws.
/// - A successful result carries the updated project schema snapshot.
/// - A failed result carries an [ExecutionFailureReason] and a human-readable message.
/// - Callers pattern-match on [isSuccess] to handle both paths cleanly.
///
/// Do NOT add rendering or AI logic here. This is pure domain data.

import 'timeline_operation.dart';

/// Categorises why an execution step failed.
///
/// Used by the UI to present specific, actionable error messages.
enum ExecutionFailureReason {
  /// The operation did not pass the pre-flight validation step.
  validationFailed,

  /// The targeted clip, track, or asset does not exist in the project.
  targetNotFound,

  /// The operation would create an illegal timeline state (e.g. negative duration).
  illegalState,

  /// Concurrent operations produced a conflict (e.g. overlapping transitions).
  conflict,

  /// An unexpected internal engine error occurred.
  internalError,
}

/// Lightweight snapshot of the project timeline state at the moment of an operation.
///
/// This is intentionally a thin representation — enough to reconstruct the state
/// for undo/redo without duplicating every media asset reference.
class TimelineSnapshot {
  /// The operation that produced this snapshot.
  final String fromOperationId;

  /// UTC timestamp (ms) when the snapshot was taken.
  final int snapshotTimestamp;

  /// Opaque JSON-compatible representation of the timeline at this point.
  /// In a full implementation this would be a typed [Timeline] object;
  /// here it is a [Map] so the engine can serialize/deserialize freely.
  final Map<String, dynamic> timelineState;

  const TimelineSnapshot({
    required this.fromOperationId,
    required this.snapshotTimestamp,
    required this.timelineState,
  });
}

/// The sealed result of executing a single [TimelineOperation].
class ExecutionResult {
  // ---- Success path --------------------------------------------------------

  /// Whether the operation was applied successfully.
  final bool isSuccess;

  /// The operation that was executed (always present).
  final TimelineOperation operation;

  /// Post-execution timeline snapshot. Non-null only on success.
  final TimelineSnapshot? snapshot;

  // ---- Failure path --------------------------------------------------------

  /// Why the execution failed. Null on success.
  final ExecutionFailureReason? failureReason;

  /// Human-readable explanation of what went wrong. Null on success.
  final String? failureMessage;

  // ---- Metadata ------------------------------------------------------------

  /// Wall-clock duration of the execution step in microseconds.
  /// Useful for performance diagnostics.
  final int executionDurationMicros;

  const ExecutionResult._({
    required this.isSuccess,
    required this.operation,
    required this.executionDurationMicros,
    this.snapshot,
    this.failureReason,
    this.failureMessage,
  });

  /// Creates a successful [ExecutionResult] with an accompanying snapshot.
  factory ExecutionResult.success({
    required TimelineOperation operation,
    required TimelineSnapshot snapshot,
    required int executionDurationMicros,
  }) {
    return ExecutionResult._(
      isSuccess: true,
      operation: operation,
      snapshot: snapshot,
      executionDurationMicros: executionDurationMicros,
    );
  }

  /// Creates a failed [ExecutionResult] with a reason and description.
  factory ExecutionResult.failure({
    required TimelineOperation operation,
    required ExecutionFailureReason reason,
    required String message,
    required int executionDurationMicros,
  }) {
    return ExecutionResult._(
      isSuccess: false,
      operation: operation,
      failureReason: reason,
      failureMessage: message,
      executionDurationMicros: executionDurationMicros,
    );
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'ExecutionResult.success('
          'opId=${operation.operationId}, '
          'snapshotAt=${snapshot?.snapshotTimestamp})';
    }
    return 'ExecutionResult.failure('
        'opId=${operation.operationId}, '
        'reason=$failureReason, '
        'msg="$failureMessage")';
  }
}
