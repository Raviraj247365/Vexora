import 'package:flutter/animation.dart';

/// Animation timing tokens for consistent motion.
///
/// Use these named durations and curves in animated widgets.
class VexoraAnimation {
  VexoraAnimation._();

  static const Duration ultraFast = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration standard = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 380);
  static const Duration long = Duration(milliseconds: 520);

  static const Curve smooth = Curves.easeOutCubic;
  static const Curve gentle = Curves.easeInOut;
  static const Curve dramatic = Curves.easeOutQuint;
}
