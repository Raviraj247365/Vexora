import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';

/// Skeleton loading shimmer for async states.
class LoadingSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingSkeleton({
    Key? key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: VexoraColors.surface.withOpacity(_animation.value + 0.3),
            borderRadius: widget.borderRadius ?? VexoraRadius.smBorder,
          ),
        );
      },
    );
  }
}

/// A column of skeleton lines for list loading states.
class SkeletonLoader extends StatelessWidget {
  final int lines;
  final double lineHeight;

  const SkeletonLoader({Key? key, this.lines = 3, this.lineHeight = 14})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: VexoraSpacing.sm),
          child: LoadingSkeleton(
            width: i == lines - 1 ? 140 : double.infinity,
            height: lineHeight,
          ),
        );
      }),
    );
  }
}
