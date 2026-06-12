// Entry point for the Vexora mobile app.
// Uses Riverpod for state management and boots the App widget.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: VexoraApp()));
}
