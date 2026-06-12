/// history_panel.dart
///
/// Presentation layer widget that displays the full operation history
/// produced by the [TimelineExecutor].
///
/// Architecture notes:
/// - This widget is purely presentational — it receives data via constructor.
/// - No direct dependency on [TimelineExecutor]; the parent page passes down
///   the list of snapshots and callbacks.
/// - No AI logic. No rendering logic.

import 'package:flutter/material.dart';
import '../../../design/design_system.dart';
import '../domain/execution_result.dart';

class HistoryPanel extends StatelessWidget {
  /// Undo-able snapshots, latest first.
  final List<TimelineSnapshot> undoHistory;

  /// Redo-able snapshots, latest first.
  final List<TimelineSnapshot> redoHistory;

  /// Called when the user taps a snapshot entry (e.g., jump-to).
  final ValueChanged<TimelineSnapshot>? onSnapshotTap;

  const HistoryPanel({
    Key? key,
    required this.undoHistory,
    required this.redoHistory,
    this.onSnapshotTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allEntries = [
      ..._taggedEntries('Undo', undoHistory),
      ..._taggedEntries('Redo', redoHistory),
    ];

    return Container(
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(color: VexoraColors.border, height: 1),
          if (allEntries.isEmpty)
            _buildEmptyState()
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: VexoraSpacing.sm),
                itemCount: allEntries.length,
                separatorBuilder: (_, __) => const Divider(
                    color: VexoraColors.border, height: 1, indent: 56),
                itemBuilder: (context, index) => _buildEntry(allEntries[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: VexoraSpacing.md, vertical: VexoraSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.history, color: VexoraColors.accent, size: 18),
          const SizedBox(width: VexoraSpacing.xs),
          Text(
            'Operation History',
            style: VexoraTypography.bodyLarge(VexoraColors.textPrimary),
          ),
          const Spacer(),
          Text(
            '${undoHistory.length} entries',
            style: VexoraTypography.caption(VexoraColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(VexoraSpacing.lg),
      child: Center(
        child: Text(
          'No operations applied yet.',
          style: VexoraTypography.body(VexoraColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildEntry(_TaggedSnapshot entry) {
    return InkWell(
      onTap:
          onSnapshotTap != null ? () => onSnapshotTap!(entry.snapshot) : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: VexoraSpacing.md, vertical: VexoraSpacing.sm),
        child: Row(
          children: [
            _OperationBadge(tag: entry.tag),
            const SizedBox(width: VexoraSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _labelForOperationId(entry.snapshot.fromOperationId),
                    style: VexoraTypography.bodyLarge(VexoraColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTimestamp(entry.snapshot.snapshotTimestamp),
                    style: VexoraTypography.caption(VexoraColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (onSnapshotTap != null)
              const Icon(Icons.chevron_right,
                  color: VexoraColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }

  List<_TaggedSnapshot> _taggedEntries(
      String tag, List<TimelineSnapshot> list) {
    return list.reversed
        .map((s) => _TaggedSnapshot(tag: tag, snapshot: s))
        .toList();
  }

  String _labelForOperationId(String operationId) {
    // Derive a readable label from the operation id prefix pattern.
    // e.g. "cut-abc123" → "Cut · abc123"
    final parts = operationId.split('-');
    if (parts.length >= 2) {
      final typePart = parts.first
          .replaceAll('_', ' ')
          .split(' ')
          .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
      return '$typePart · ${parts.sublist(1).join('-')}';
    }
    return operationId;
  }

  String _formatTimestamp(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

// ---- Internal models -------------------------------------------------------

class _TaggedSnapshot {
  final String tag;
  final TimelineSnapshot snapshot;

  const _TaggedSnapshot({required this.tag, required this.snapshot});
}

class _OperationBadge extends StatelessWidget {
  final String tag;

  const _OperationBadge({required this.tag});

  @override
  Widget build(BuildContext context) {
    final isUndo = tag == 'Undo';
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: (isUndo ? VexoraColors.accent : Colors.orangeAccent)
            .withOpacity(0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isUndo ? Icons.undo : Icons.redo,
        size: 18,
        color: isUndo ? VexoraColors.accent : Colors.orangeAccent,
      ),
    );
  }
}
