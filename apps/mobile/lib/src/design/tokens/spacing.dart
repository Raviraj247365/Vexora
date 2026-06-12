import 'package:flutter/material.dart';

/// Spacing tokens for consistent visual rhythm.
///
/// Use `VexoraSpacing.sm`, `md`, and `lg` instead of hard-coded values.
class VexoraSpacing {
  VexoraSpacing._();

  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;

  static const EdgeInsets page =
      EdgeInsets.symmetric(horizontal: 20, vertical: 20);
  static const EdgeInsets section = EdgeInsets.symmetric(vertical: 16);
}
