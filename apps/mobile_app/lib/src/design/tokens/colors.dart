import 'package:flutter/material.dart';

/// Premium dark UI color palette for Vexora.
///
/// These design tokens are intentionally simple and scalable.
/// Change the values here to update the app look globally.
class VexoraColors {
  VexoraColors._();

  static const Color background = Color(0xFF090B16);
  static const Color surface = Color(0xFF121826);
  static const Color surfaceAlt = Color(0xFF181D33);
  static const Color border = Color(0xFF2C3351);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB7C3E2);
  static const Color accent = Color(0xFF62E7FF);
  static const Color accentSoft = Color(0xFF54C8FF);
  static const Color success = Color(0xFF3CE2B6);
  static const Color warning = Color(0xFFFFB547);
  static const Color error = Color(0xFFFF5C8A);
  static const Color glass = Color(0x33FFFFFF);
  static const Color dim = Color(0x602A3A5B);
  static const Color shadow = Color(0x26000000);

  static const Gradient ambientGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E1428), Color(0xFF141A33), Color(0xFF0D0F1A)],
  );
}
