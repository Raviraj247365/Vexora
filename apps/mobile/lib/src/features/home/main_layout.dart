import 'package:flutter/material.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import 'home_page.dart';
import '../marketplace/presentation/screens/marketplace_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const MarketplaceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: VexoraColors.surfaceAlt,
        selectedItemColor: VexoraColors.accent,
        unselectedItemColor: VexoraColors.textSecondary,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Marketplace',
          ),
        ],
      ),
    );
  }
}
