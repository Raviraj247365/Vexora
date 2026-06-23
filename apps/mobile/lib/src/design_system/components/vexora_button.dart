import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/animations.dart';

enum VexoraButtonStyle { primary, secondary, ghost, danger }

class VexoraButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final VexoraButtonStyle style;
  final Widget? icon;
  final bool isLoading;
  final bool fullWidth;

  const VexoraButton({
    Key? key,
    required this.label,
    this.onTap,
    this.style = VexoraButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  State<VexoraButton> createState() => _VexoraButtonState();
}

class _VexoraButtonState extends State<VexoraButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: VexoraAnimations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: VexoraAnimations.defaultCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bg {
    switch (widget.style) {
      case VexoraButtonStyle.primary:
        return _isHovered ? VexoraColors.primaryHover : VexoraColors.primary;
      case VexoraButtonStyle.secondary:
        return VexoraColors.surfaceHighlight;
      case VexoraButtonStyle.ghost:
        return _isHovered
            ? VexoraColors.surfaceHighlight
            : Colors.transparent;
      case VexoraButtonStyle.danger:
        return VexoraColors.error.withOpacity(0.15);
    }
  }

  Color get _fg {
    switch (widget.style) {
      case VexoraButtonStyle.danger:
        return VexoraColors.error;
      default:
        return VexoraColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: VexoraAnimations.fast,
            width: widget.fullWidth ? double.infinity : null,
            padding: const EdgeInsets.symmetric(
              horizontal: VexoraSpacing.md,
              vertical: VexoraSpacing.sm + 4,
            ),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: VexoraRadius.mdBorder,
              border: widget.style == VexoraButtonStyle.secondary
                  ? Border.all(color: VexoraColors.border)
                  : null,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: VexoraColors.textPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize:
                        widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        const SizedBox(width: VexoraSpacing.xs),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: _fg,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
