import 'package:flutter/material.dart';
import 'responsive.dart';

// Centralized theme definitions. Keep colors and typography here.
ThemeData buildLightTheme(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,
    textTheme: textTheme.apply(fontFamily: 'Roboto'),
  );
}

ThemeData buildDarkTheme(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
    useMaterial3: true,
    textTheme: textTheme.apply(fontFamily: 'Roboto'),
  );
}

// Example helper: scale text size based on device width using Responsive helper.
double scaledFontSize(BuildContext context, double base) {
  final width = Responsive.width(context);
  if (width < 360) return base * 0.9;
  if (width > 720) return base * 1.2;
  return base;
}
