/// undo_redo_controls.dart
///
/// Compact undo/redo action bar for the Timeline Execution Engine UI.
///
/// Architecture notes:
/// - This widget is purely presentational.
/// - It receives [canUndo], [canRedo], and callbacks — never the executor directly.
/// - Designed to be embedded in the editor toolbar or bottom action bar.
/// - Supports an optional history count badge on each button.

import 'package:flutter/material.dart';
import '../../../design/design_system.dart';

class UndoRedoControls extends StatelessWidget {
  /// Whether the undo action is currently available.
  final bool canUndo;

  /// Whether the redo action is currently available.
  final bool canRedo;

  /// Number of items in the undo stack (shown as badge).
  final int undoCount;

  /// Number of items in the redo stack (shown as badge).
  final int redoCount;

  /// Called when the user taps the Undo button.
  final VoidCallback? onUndo;

  /// Called when the user taps the Redo button.
  final VoidCallback? onRedo;

  /// Called when the user taps the History button to open the [HistoryPanel].
  final VoidCallback? onShowHistory;

  const UndoRedoControls({
    Key? key,
    required this.canUndo,
    required this.canRedo,
    this.undoCount = 0,
    this.redoCount = 0,
    this.onUndo,
    this.onRedo,
    this.onShowHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: VexoraSpacing.md, vertical: VexoraSpacing.xs),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt.withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ControlButton(
            id: 'undo_button',
            icon: Icons.undo_rounded,
            label: 'Undo',
            enabled: canUndo,
            badge: undoCount > 0 ? undoCount : null,
            badgeColor: VexoraColors.accent,
            onTap: canUndo ? onUndo : null,
          ),
          _Divider(),
          _ControlButton(
            id: 'redo_button',
            icon: Icons.redo_rounded,
            label: 'Redo',
            enabled: canRedo,
            badge: redoCount > 0 ? redoCount : null,
            badgeColor: Colors.orangeAccent,
            onTap: canRedo ? onRedo : null,
          ),
          if (onShowHistory != null) ...[
            _Divider(),
            _ControlButton(
              id: 'history_button',
              icon: Icons.history_rounded,
              label: 'History',
              enabled: true,
              onTap: onShowHistory,
            ),
          ],
        ],
      ),
    );
  }
}

// ---- Sub-widgets -----------------------------------------------------------

class _ControlButton extends StatelessWidget {
  final String id;
  final IconData icon;
  final String label;
  final bool enabled;
  final int? badge;
  final Color? badgeColor;
  final VoidCallback? onTap;

  const _ControlButton({
    required this.id,
    required this.icon,
    required this.label,
    required this.enabled,
    this.badge,
    this.badgeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = badgeColor ?? VexoraColors.accent;
    final iconColor = enabled ? activeColor : VexoraColors.textSecondary;

    return Semantics(
      button: true,
      label: label,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.38,
          duration: VexoraAnimation.fast,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: VexoraSpacing.sm, vertical: VexoraSpacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(icon, color: iconColor, size: 22),
                    if (badge != null && badge! > 0)
                      Positioned(
                        top: -4,
                        right: -6,
                        child: _Badge(count: badge!, color: activeColor),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: VexoraTypography.caption(iconColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final Color color;

  const _Badge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: VexoraSpacing.xs),
      color: VexoraColors.border,
    );
  }
}
