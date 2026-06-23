import 'package:flutter/material.dart';
import 'colors.dart';

class VexoraTypography {
  static const String fontFamily = 'Inter';
  static const String monoFamily = 'JetBrains Mono';

  static TextStyle display = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: VexoraColors.textPrimary,
  );

  static TextStyle heading = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: VexoraColors.textPrimary,
  );

  static TextStyle title = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: VexoraColors.textPrimary,
  );

  static TextStyle body = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: VexoraColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodyStrong = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: VexoraColors.textPrimary,
    height: 1.5,
  );

  static TextStyle caption = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    color: VexoraColors.textTertiary,
  );

  static TextStyle mono = const TextStyle(
    fontFamily: monoFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: VexoraColors.textSecondary,
  );
}
