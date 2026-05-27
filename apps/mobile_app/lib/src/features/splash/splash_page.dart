import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Simple splash page placeholder.
/// Keep this page lightweight: it should show branding and navigate to onboarding or home.
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FlutterLogo(size: 96),
            const SizedBox(height: 16),
            const Text('Vexora', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/onboarding'),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
