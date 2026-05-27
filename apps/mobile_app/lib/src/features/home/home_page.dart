import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/theme_provider.dart';

/// Home screen placeholder. Organize UI by feature and keep this file focused on presentation.
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeCtrl = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vexora Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Home screen placeholder — feature folders live under `lib/src/features`.'),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Dark mode'),
                const Spacer(),
                Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (_) => themeCtrl.toggle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
