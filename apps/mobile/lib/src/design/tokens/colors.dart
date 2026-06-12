import 'package:flutter/material.dart';

/// Premium dark UI color palette for Vexora.
///
/// These design tokens are intentionally simple and scalable.
/// Change the values here to update the app look globally.
class VexoraColors {
  VexoraColors._();

  static const Color background = Color(0xFF0A0A0E); // Deepest dark background
  static const Color surface =
      Color(0xFF12121A); // Slightly lighter for nav/panels
  static const Color surfaceAlt = Color(0xFF1C1C26); // Elevated cards
  static const Color border = Color(0xFF2B2B36); // Subtle borders
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9EA7); // Muted text
  static const Color accent = Color(0xFF7000FF); // Core Vexora Purple
  static const Color accentSoft =
      Color(0xFF9E54FF); // Lighter purple for highlights
  static const Color success = Color(0xFF00E676); // Vibrant Green
  static const Color warning = Color(0xFFFFB547);
  static const Color error = Color(0xFFFF3B3B); // Red/Pink
  static const Color glass = Color(0x20FFFFFF);
  static const Color dim = Color(0x800A0A0E);
  static const Color shadow = Color(0x40000000);

  static const Gradient ambientGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C122C), Color(0xFF12121A), Color(0xFF0A0A0E)],
  );

  static const Gradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9E54FF), Color(0xFF7000FF)],
  );
}
