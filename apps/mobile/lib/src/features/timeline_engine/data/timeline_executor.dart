/// timeline_executor.dart
///
/// Core execution layer of the Timeline Execution Engine.
///
/// Architecture notes:
/// - [TimelineExecutor] is the single stateful engine component.
/// - It owns two stacks: [_undoStack] and [_redoStack].
/// - Every applied operation goes through validation first.
/// - On success, a lightweight [TimelineSnapshot] is pushed to the undo stack.
/// - Undo pops the undo stack and pushes the current state to the redo stack.
/// - Redo pops the redo stack and re-applies the reversed snapshot.
/// - The engine is designed to be wrapped by a Riverpod notifier in the UI layer.
///
/// Do NOT implement rendering or AI logic here. Pure execution architecture.

import '../domain/execution_result.dart';
import '../domain/timeline_operation.dart';
import '../domain/validation_result.dart';
import 'operation_validator.dart';

// ---------------------------------------------------------------------------
// History entry — links a snapshot to the operation that produced it.
// ---------------------------------------------------------------------------

class _HistoryEntry {
  final TimelineOperation operation;
  final TimelineSnapshot snapshot;

  const _HistoryEntry({required this.operation, required this.snapshot});
}

// ---------------------------------------------------------------------------
// Executor
// ---------------------------------------------------------------------------

class TimelineExecutor {
  TimelineExecutor({
    OperationValidator? validator,
    int maxHistoryDepth = 50,
  })  : _validator = validator ?? const OperationValidator(),
        _maxHistoryDepth = maxHistoryDepth;

  final OperationValidator _validator;
  final int _maxHistoryDepth;

  // ---- Undo / Redo stacks -------------------------------------------------

  final List<_HistoryEntry> _undoStack = [];
  final List<_HistoryEntry> _redoStack = [];

  // ---- Mutable project-schema representation --------------------------------
  // In a full implementation this would be a typed [ProjectSchema].
  // Here we use a [Map] to remain decoupled from schema versioning concerns.

  Map<String, dynamic> _currentTimelineState = {};

  /// Read-only view of the current timeline state.
  Map<String, dynamic> get currentState =>
      Map.unmodifiable(_currentTimelineState);

  /// Whether there are operations available to undo.
  bool get canUndo => _undoStack.isNotEmpty;

  /// Whether there are operations available to redo.
  bool get canRedo => _redoStack.isNotEmpty;

  /// The full ordered undo history (oldest first).
  List<TimelineSnapshot> get undoHistory =>
      _undoStack.map((e) => e.snapshot).toList(growable: false);

  /// The full ordered redo history (oldest first).
  List<TimelineSnapshot> get redoHistory =>
      _redoStack.map((e) => e.snapshot).toList(growable: false);

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  /// Validates and applies [operation] to the current timeline state.
  ///
  /// Returns an [ExecutionResult] describing whether the operation succeeded.
  /// On success, the engine saves a history snapshot and clears the redo stack.
  ExecutionResult apply(
    TimelineOperation operation,
    ValidationContext context,
  ) {
    final stopwatch = Stopwatch()..start();

    // 1 — Validate
    final validation = _validator.validate(operation, context);
    if (!validation.isValid) {
      stopwatch.stop();
      return ExecutionResult.failure(
        operation: operation,
        reason: ExecutionFailureReason.validationFailed,
        message: _summariseViolations(validation),
        executionDurationMicros: stopwatch.elapsedMicroseconds,
      );
    }

    // 2 — Apply to state (pure transform — no rendering)
    ExecutionResult result;
    try {
      final nextState = _applyOperation(operation, _currentTimelineState);
      final snapshot = TimelineSnapshot(
        fromOperationId: operation.operationId,
        snapshotTimestamp: DateTime.now().millisecondsSinceEpoch,
        timelineState: nextState,
      );

      // 3 — Commit
      _currentTimelineState = nextState;
      _pushUndo(_HistoryEntry(operation: operation, snapshot: snapshot));
      _redoStack.clear(); // New operation invalidates redo history.

      stopwatch.stop();
      result = ExecutionResult.success(
        operation: operation,
        snapshot: snapshot,
        executionDurationMicros: stopwatch.elapsedMicroseconds,
      );
    } catch (e) {
      stopwatch.stop();
      result = ExecutionResult.failure(
        operation: operation,
        reason: ExecutionFailureReason.internalError,
        message: 'Unexpected engine error: $e',
        executionDurationMicros: stopwatch.elapsedMicroseconds,
      );
    }

    return result;
  }

  /// Applies a batch of operations in order, stopping on the first failure.
  ///
  /// Returns one [ExecutionResult] per operation.
  List<ExecutionResult> applyBatch(
    List<TimelineOperation> operations,
    ValidationContext context,
  ) {
    final results = <ExecutionResult>[];
    for (final op in operations) {
      final result = apply(op, context);
      results.add(result);
      if (!result.isSuccess) break; // Halt on first failure.
    }
    return results;
  }

  /// Undoes the last applied operation.
  ///
  /// Returns the restored [TimelineSnapshot] or null if the undo stack is empty.
  TimelineSnapshot? undo() {
    if (_undoStack.isEmpty) return null;
    final entry = _undoStack.removeLast();
    _redoStack.add(entry);

    // Restore to the snapshot one step before — the previous state.
    if (_undoStack.isNotEmpty) {
      _currentTimelineState = Map.of(_undoStack.last.snapshot.timelineState);
    } else {
      _currentTimelineState = {}; // Back to the empty initial state.
    }

    return entry.snapshot;
  }

  /// Redoes the last undone operation.
  ///
  /// Returns the re-applied [TimelineSnapshot] or null if redo stack is empty.
  TimelineSnapshot? redo() {
    if (_redoStack.isEmpty) return null;
    final entry = _redoStack.removeLast();
    _undoStack.add(entry);
    _currentTimelineState = Map.of(entry.snapshot.timelineState);
    return entry.snapshot;
  }

  /// Replaces the current state with [snapshot] (used for regeneration passes).
  ///
  /// This creates a new undo entry so the regeneration itself can be undone.
  void regenerate(TimelineSnapshot snapshot) {
    final syntheticEntry = _HistoryEntry(
      operation: _RegenerationMarker(
        operationId: 'regen-${snapshot.fromOperationId}',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      snapshot: snapshot,
    );
    _currentTimelineState = Map.of(snapshot.timelineState);
    _pushUndo(syntheticEntry);
    _redoStack.clear();
  }

  /// Clears all history stacks and resets state to empty.
  void reset() {
    _undoStack.clear();
    _redoStack.clear();
    _currentTimelineState = {};
  }

  // -------------------------------------------------------------------------
  // Private helpers
  // -------------------------------------------------------------------------

  void _pushUndo(_HistoryEntry entry) {
    _undoStack.add(entry);
    // Prune oldest entries if depth exceeded.
    while (_undoStack.length > _maxHistoryDepth) {
      _undoStack.removeAt(0);
    }
  }

  String _summariseViolations(ValidationResult result) {
    return result.violations
        .map((v) => '[${v.rule.name}] ${v.description}')
        .join(' | ');
  }

  // ---- Operation dispatch --------------------------------------------------
  // Each operation type produces a new immutable state map.
  // In a full implementation these would deeply transform a typed schema.
  // Here we use a shallow merge strategy to represent deterministic transforms.

  Map<String, dynamic> _applyOperation(
    TimelineOperation op,
    Map<String, dynamic> state,
  ) {
    final next = Map<String, dynamic>.from(state);

    // Record the operation in the state's applied operations log.
    final log = List<Map<String, dynamic>>.from(
      (next['_operationsLog'] as List?) ?? [],
    );

    log.add({
      'operationId': op.operationId,
      'type': op.type.name,
      'timestamp': op.timestamp,
      'confidence': op.confidence,
      'source': op.source.name,
    });
    next['_operationsLog'] = log;

    // Dispatch to type-specific handler.
    switch (op.type) {
      case TimelineOperationType.cut:
        return _applyCut(op as CutOperation, next);
      case TimelineOperationType.trim:
        return _applyTrim(op as TrimOperation, next);
      case TimelineOperationType.split:
        return _applySplit(op as SplitOperation, next);
      case TimelineOperationType.zoom:
        return _applyZoom(op as ZoomOperation, next);
      case TimelineOperationType.caption:
        return _applyCaption(op as CaptionOperation, next);
      case TimelineOperationType.transition:
        return _applyTransition(op as TransitionOperation, next);
      case TimelineOperationType.filter:
        return _applyFilter(op as FilterOperation, next);
      case TimelineOperationType.audioGain:
        return _applyAudioGain(op as AudioGainOperation, next);
    }
  }

  Map<String, dynamic> _applyCut(CutOperation op, Map<String, dynamic> s) {
    final cuts = List<Map<String, dynamic>>.from((s['cuts'] as List?) ?? []);
    cuts.add(
        {'start': op.startMs, 'end': op.endMs, 'trackId': op.targetTrackId});
    return {...s, 'cuts': cuts};
  }

  Map<String, dynamic> _applyTrim(TrimOperation op, Map<String, dynamic> s) {
    final trims = Map<String, dynamic>.from((s['trims'] as Map?) ?? {});
    trims[op.clipId] = {'start': op.newTrimStartMs, 'end': op.newTrimEndMs};
    return {...s, 'trims': trims};
  }

  Map<String, dynamic> _applySplit(SplitOperation op, Map<String, dynamic> s) {
    final splits =
        List<Map<String, dynamic>>.from((s['splits'] as List?) ?? []);
    splits.add({'clipId': op.clipId, 'at': op.splitPointMs});
    return {...s, 'splits': splits};
  }

  Map<String, dynamic> _applyZoom(ZoomOperation op, Map<String, dynamic> s) {
    final zooms = List<Map<String, dynamic>>.from((s['zooms'] as List?) ?? []);
    zooms.add({
      'clipId': op.clipId,
      'factor': op.zoomFactor,
      'from': op.zoomStartMs,
      'to': op.zoomEndMs,
    });
    return {...s, 'zooms': zooms};
  }

  Map<String, dynamic> _applyCaption(
      CaptionOperation op, Map<String, dynamic> s) {
    final captions =
        List<Map<String, dynamic>>.from((s['captions'] as List?) ?? []);
    captions.add({
      'id': op.captionId,
      'text': op.text,
      'start': op.captionStartMs,
      'end': op.captionEndMs,
      'style': op.stylePreset,
    });
    return {...s, 'captions': captions};
  }

  Map<String, dynamic> _applyTransition(
      TransitionOperation op, Map<String, dynamic> s) {
    final transitions =
        List<Map<String, dynamic>>.from((s['transitions'] as List?) ?? []);
    transitions.add({
      'before': op.beforeClipId,
      'after': op.afterClipId,
      'type': op.transitionType,
      'duration': op.durationMs,
    });
    return {...s, 'transitions': transitions};
  }

  Map<String, dynamic> _applyFilter(
      FilterOperation op, Map<String, dynamic> s) {
    final filters = Map<String, dynamic>.from((s['filters'] as Map?) ?? {});
    final clipFilters = List<Map<String, dynamic>>.from(
      (filters[op.clipId] as List?) ?? [],
    );
    clipFilters.add({'type': op.filterType, 'params': op.params});
    filters[op.clipId] = clipFilters;
    return {...s, 'filters': filters};
  }

  Map<String, dynamic> _applyAudioGain(
      AudioGainOperation op, Map<String, dynamic> s) {
    final gains = Map<String, dynamic>.from((s['audioGains'] as Map?) ?? {});
    gains[op.targetId] = op.gainDb;
    return {...s, 'audioGains': gains};
  }
}

// ---------------------------------------------------------------------------
// Internal marker used to represent regeneration events in the undo stack.
// ---------------------------------------------------------------------------

class _RegenerationMarker extends TimelineOperation {
  const _RegenerationMarker({
    required super.operationId,
    required super.timestamp,
  }) : super(
          confidence: 1.0,
          source: OperationSource.regeneration,
        );

  @override
  TimelineOperationType get type => TimelineOperationType.cut;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'operationId': operationId,
        'timestamp': timestamp,
        'confidence': confidence,
        'source': source.name,
        'targetTrackId': targetTrackId,
      };
}
