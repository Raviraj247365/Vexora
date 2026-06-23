import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// A beautiful empty state widget with icon, title, subtitle, and optional action.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VexoraSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: VexoraColors.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(color: VexoraColors.border),
              ),
              child: Icon(icon, color: VexoraColors.textTertiary, size: 28),
            ),
            const SizedBox(height: VexoraSpacing.lg),
            Text(
              title,
              style: VexoraTypography.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: VexoraSpacing.sm),
            Text(
              subtitle,
              style: VexoraTypography.body,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: VexoraSpacing.lg),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: VexoraSpacing.lg,
                    vertical: VexoraSpacing.sm + 4,
                  ),
                  decoration: BoxDecoration(
                    color: VexoraColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    actionLabel!,
                    style: VexoraTypography.bodyStrong
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
