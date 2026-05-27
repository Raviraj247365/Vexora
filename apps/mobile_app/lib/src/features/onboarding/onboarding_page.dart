import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Onboarding placeholder screen.
/// Keep onboarding as a small, self-contained feature folder so it can grow independently.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Vexora')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: Center(child: Text('Onboarding placeholder — explain features here')),
            ),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/home'),
              child: const Text('Get started'),
            ),
          ],
        ),
      ),
    );
  }
}
