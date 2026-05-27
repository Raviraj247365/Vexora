import 'package:flutter/material.dart';
import '../tokens/spacing.dart';

/// Typography tokens for Vexora.
///
/// Use these text styles across the app to keep headings,
/// body copy, and labels consistent.
class VexoraTypography {
  VexoraTypography._();

  static const String fontFamily = 'Inter';

  static TextStyle heading1(Color color) => TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle heading2(Color color) => TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.24,
      );

  static TextStyle bodyLarge(Color color) => TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle body(Color color) => TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle label(Color color) => TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
+        height: 1.4,
      );
+
+  static TextStyle caption(Color color) => TextStyle(
+        color: color,
+        fontFamily: fontFamily,
+        fontSize: 11,
+        fontWeight: FontWeight.w400,
+        height: 1.4,
+      );
 }
