import 'package:flutter/material.dart';
import 'tokens/colors.dart';
import 'tokens/typography.dart';
import 'tokens/radius.dart';

class VexoraTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: VexoraColors.background,
      fontFamily: VexoraTypography.fontFamily,
      primaryColor: VexoraColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: VexoraColors.primary,
        secondary: VexoraColors.accent,
        surface: VexoraColors.surface,
        background: VexoraColors.background,
        error: VexoraColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: VexoraColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: VexoraColors.primary,
          foregroundColor: VexoraColors.textPrimary,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: VexoraRadius.mdBorder,
          ),
        ),
      ),
      // Prevent default splash/highlight
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.white.withOpacity(0.05),
    );
  }
}
