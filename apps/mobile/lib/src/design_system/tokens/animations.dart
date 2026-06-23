import 'package:flutter/material.dart';

class VexoraAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve smoothCurve = Curves.easeInOutQuart;
}
