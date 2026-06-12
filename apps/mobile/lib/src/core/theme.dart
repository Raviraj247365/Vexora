import 'package:flutter/material.dart';
import '../design/design_system.dart';

/// App theme provider for Vexora.
///
/// This file ties the visual design tokens into the Material theme.
class VexoraTheme {
  VexoraTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: VexoraColors.background,
    cardColor: VexoraColors.surface,
    canvasColor: VexoraColors.background,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: VexoraColors.accent,
      background: VexoraColors.background,
      surface: VexoraColors.surface,
      onPrimary: VexoraColors.background,
      onSurface: VexoraColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: VexoraColors.surface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: VexoraTypography.heading2(VexoraColors.textPrimary),
    ),
    textTheme: TextTheme(
      headlineLarge: VexoraTypography.heading1(VexoraColors.textPrimary),
      headlineMedium: VexoraTypography.heading2(VexoraColors.textPrimary),
      bodyLarge: VexoraTypography.bodyLarge(VexoraColors.textPrimary),
      bodyMedium: VexoraTypography.body(VexoraColors.textSecondary),
      labelLarge: VexoraTypography.label(VexoraColors.textSecondary),
      labelSmall: VexoraTypography.caption(VexoraColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: VexoraColors.background,
        backgroundColor: VexoraColors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: VexoraColors.background,
    cardColor: VexoraColors.surface,
    canvasColor: VexoraColors.background,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: VexoraColors.accent,
      background: VexoraColors.background,
      surface: VexoraColors.surface,
      onPrimary: VexoraColors.background,
      onSurface: VexoraColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: VexoraColors.surfaceAlt,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: VexoraTypography.heading2(VexoraColors.textPrimary),
    ),
    textTheme: TextTheme(
      headlineLarge: VexoraTypography.heading1(VexoraColors.textPrimary),
      headlineMedium: VexoraTypography.heading2(VexoraColors.textPrimary),
      bodyLarge: VexoraTypography.bodyLarge(VexoraColors.textPrimary),
      bodyMedium: VexoraTypography.body(VexoraColors.textSecondary),
      labelLarge: VexoraTypography.label(VexoraColors.textSecondary),
      labelSmall: VexoraTypography.caption(VexoraColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: VexoraColors.background,
        backgroundColor: VexoraColors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

/// Helper to create a subtle, future-forward glow effect.
Decoration buildNeonBorder() {
  return BoxDecoration(
    border:
        Border.all(color: VexoraColors.accent.withOpacity(0.25), width: 1.2),
    boxShadow: [
      BoxShadow(
        color: VexoraColors.accent.withOpacity(0.10),
        blurRadius: 22,
        spreadRadius: 1,
      ),
    ],
    borderRadius: BorderRadius.circular(28),
  );
}
