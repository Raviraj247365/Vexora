import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_system.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({Key? key, required this.navigationShell}) : super(key: key);

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            _buildNavigationRail(),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      backgroundColor: VexoraColors.surfaceElevated,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _goBranch,
      selectedLabelTextStyle: VexoraTypography.caption.copyWith(color: VexoraColors.primary),
      unselectedLabelTextStyle: VexoraTypography.caption,
      selectedIconTheme: const IconThemeData(color: VexoraColors.primary),
      unselectedIconTheme: const IconThemeData(color: VexoraColors.textTertiary),
      indicatorColor: VexoraColors.primary.withOpacity(0.1),
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_filled),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.folder_outlined),
          selectedIcon: Icon(Icons.folder),
          label: Text('Projects'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: Text('Marketplace'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: Text('Analytics'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: VexoraColors.surfaceElevated,
        border: Border(top: BorderSide(color: VexoraColors.border, width: 1)),
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        indicatorColor: VexoraColors.primary.withOpacity(0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: VexoraColors.textTertiary),
            selectedIcon: Icon(Icons.home_filled, color: VexoraColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined, color: VexoraColors.textTertiary),
            selectedIcon: Icon(Icons.folder, color: VexoraColors.primary),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined, color: VexoraColors.textTertiary),
            selectedIcon: Icon(Icons.storefront, color: VexoraColors.primary),
            label: 'Marketplace',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined, color: VexoraColors.textTertiary),
            selectedIcon: Icon(Icons.analytics, color: VexoraColors.primary),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: VexoraColors.textTertiary),
            selectedIcon: Icon(Icons.person, color: VexoraColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
