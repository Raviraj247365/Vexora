import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Loading widgets for Vexora.
///
/// Use these inside feature placeholders and data-loading states.
class VexoraLoadingIndicator extends StatelessWidget {
  final String message;

  const VexoraLoadingIndicator({
    Key? key,
    this.message = 'Loading...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 64,
          height: 64,
+          child: CircularProgressIndicator(
+            strokeWidth: 4,
+            valueColor: AlwaysStoppedAnimation(VexoraColors.accent),
+          ),
+        ),
+        const SizedBox(height: VexoraSpacing.md),
+        Text(message, style: VexoraTypography.body(VexoraColors.textSecondary)),
+      ],
+    );
+  }
+}
+
+class VexoraLoadingCard extends StatelessWidget {
+  final String title;
+  final String subtitle;
+
+  const VexoraLoadingCard({
+    Key? key,
+    this.title = 'Preparing workspace',
+    this.subtitle = 'Please wait while we set things up.',
+  }) : super(key: key);
+
+  @override
+  Widget build(BuildContext context) {
+    return Container(
+      padding: const EdgeInsets.all(VexoraSpacing.lg),
+      decoration: BoxDecoration(
+        color: VexoraColors.surfaceAlt,
+        borderRadius: BorderRadius.circular(24),
+        border: Border.all(color: VexoraColors.border),
+      ),
+      child: Row(
+        children: [
+          const CircularProgressIndicator(
+            valueColor: AlwaysStoppedAnimation(VexoraColors.accent),
+          ),
+          const SizedBox(width: VexoraSpacing.md),
+          Expanded(
+            child: Column(
+              crossAxisAlignment: CrossAxisAlignment.start,
+              children: [
+                Text(title, style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
+                const SizedBox(height: VexoraSpacing.xs),
+                Text(subtitle, style: VexoraTypography.caption(VexoraColors.textSecondary)),
+              ],
+            ),
+          ),
+        ],
+      ),
+    );
+  }
+}
