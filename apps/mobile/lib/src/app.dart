// Central app widget: sets up routing, theming, and top-level providers.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'design_system/design_system.dart';
import 'features/shell/app_shell.dart';
import 'features/home/home_page.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/splash/splash_page.dart';
import 'features/styleguide/styleguide_page.dart';
import 'features/video_editor/presentation/video_editor_page.dart';
import 'features/dev_dashboard/dev_dashboard_page.dart';
import 'features/import/import_page.dart';
import 'features/video_intelligence/presentation/intelligence_viewer_page.dart';
import 'features/ai_director/presentation/ai_playground_page.dart';
import 'features/export/export_page.dart';
import 'features/video_preview/presentation/preview_screen.dart';
import 'features/marketplace/presentation/screens/edit_details_screen.dart';
import 'features/marketplace/presentation/screens/creator_profile_screen.dart';
import 'features/marketplace/presentation/screens/marketplace_page.dart';
import 'features/marketplace/domain/marketplace_models.dart';
import 'features/project_management/presentation/project_dashboard.dart';
import 'features/analytics/analytics_page.dart';
import 'features/profile/profile_page.dart';

/// `VexoraApp` composes the app routing and theme.
///
/// Architecture notes:
/// - Keep this file small: routing and top-level theme providers only.
/// - Feature screens live under `lib/src/features/<feature>`.
class VexoraApp extends ConsumerWidget {
  const VexoraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashPage()),
        GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingPage()),
        
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/projects',
                  builder: (context, state) => const ProjectDashboard(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/marketplace',
                  builder: (context, state) => const MarketplacePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/analytics',
                  builder: (context, state) => const AnalyticsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),

        // Hidden / utility routes
        GoRoute(
            path: '/styleguide',
            builder: (context, state) => const StyleGuidePage()),
        GoRoute(
            path: '/editor',
            builder: (context, state) => const VideoEditorPage()),
        GoRoute(
            path: '/dev',
            builder: (context, state) => const DevDashboardPage()),
        GoRoute(
            path: '/import', builder: (context, state) => const ImportPage()),
        GoRoute(
            path: '/intelligence',
            builder: (context, state) => const IntelligenceViewerPage()),
        GoRoute(
            path: '/ai-playground',
            builder: (context, state) => const AiPlaygroundPage()),
        GoRoute(
            path: '/preview',
            builder: (context, state) => const PreviewScreen()),
        GoRoute(
            path: '/export', builder: (context, state) => const ExportPage()),
        GoRoute(
          path: '/marketplace/details',
          builder: (context, state) =>
              EditDetailsScreen(item: state.extra as MarketplaceItem),
        ),
        GoRoute(
          path: '/marketplace/creator',
          builder: (context, state) =>
              CreatorProfileScreen(creator: state.extra as CreatorProfile),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Vexora',
      theme: VexoraTheme.darkTheme,
      darkTheme: VexoraTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
