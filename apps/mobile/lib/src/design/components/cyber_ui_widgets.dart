import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';

/// A button that glows with a cyber aesthetic when pressed or hovered.
class CyberButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color glowColor;

  const CyberButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.glowColor = const Color(0xFF00E5FF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C122C),
          foregroundColor: glowColor,
          padding: const EdgeInsets.symmetric(
              horizontal: VexoraSpacing.lg, vertical: VexoraSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: glowColor.withOpacity(0.6), width: 1.5),
          ),
        ),
      ),
    );
  }
}

/// A panel with a glassmorphism effect and subtle border.
class CyberPanel extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsets padding;
  final Color? borderColor;

  const CyberPanel({
    Key? key,
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(VexoraSpacing.md),
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: VexoraColors.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? VexoraColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: VexoraColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: VexoraSpacing.sm),
            Divider(color: VexoraColors.border, height: 1),
            const SizedBox(height: VexoraSpacing.md),
          ],
          child,
        ],
      ),
    );
  }
}

/// A mock timeline track for the editor.
class MockTimelineTrack extends StatelessWidget {
  final String label;
  final Color color;
  final int itemLength;

  const MockTimelineTrack({
    Key? key,
    required this.label,
    required this.color,
    this.itemLength = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: VexoraColors.border)),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemLength,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              itemBuilder: (context, index) {
                return Container(
                  width: 120.0 + (index * 20),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: color.withOpacity(0.5)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
