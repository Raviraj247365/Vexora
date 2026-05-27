import 'package:flutter/material.dart';

/// Small responsive helpers used throughout the app.
/// Keep these simple: they are useful for scaling paddings, fonts, and layout decisions.
class Responsive {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  static bool isPhone(BuildContext context) => width(context) < 600;
  static bool isTablet(BuildContext context) => width(context) >= 600 && width(context) < 1200;
  static bool isDesktop(BuildContext context) => width(context) >= 1200;
}
