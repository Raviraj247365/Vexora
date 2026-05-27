// Central app widget: sets up routing, theming, and top-level providers.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'features/splash/splash_page.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/home/home_page.dart';
import 'features/settings/theme_provider.dart';

/// `VexoraApp` composes the app routing and theme.
///
/// Architecture notes:
/// - Keep this file small: routing and top-level theme providers only.
/// - Feature screens live under `lib/src/features/<feature>`.
class VexoraApp extends ConsumerWidget {
  const VexoraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashPage()),
        GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingPage()),
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Vexora',
      theme: buildLightTheme(context),
      darkTheme: buildDarkTheme(context),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
