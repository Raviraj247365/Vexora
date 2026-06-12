import 'package:flutter/material.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import '../../data/marketplace_repository.dart';
import '../widgets/dna_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: VexoraColors.surface,
        elevation: 0,
        title: Text('Marketplace',
            style: VexoraTypography.h2(VexoraColors.textPrimary)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: VexoraColors.accent,
          labelColor: VexoraColors.accent,
          unselectedLabelColor: VexoraColors.textSecondary,
          tabs: const [
            Tab(text: 'Discover'),
            Tab(text: 'Trending'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverTab(),
          _buildTrendingTab(),
          _buildCategoriesTab(),
        ],
      ),
    );
  }

  Widget _buildDiscoverTab() {
    final items = MarketplaceRepository.getDiscoverItems();
    return GridView.builder(
      padding: const EdgeInsets.all(VexoraSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return DnaCard(item: items[index], isLarge: false);
      },
    );
  }

  Widget _buildTrendingTab() {
    final items = MarketplaceRepository.getTrendingItems();
    return ListView.builder(
      padding: const EdgeInsets.all(VexoraSpacing.md),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            height: 250,
            child: Row(
              children: [
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: index < 3
                        ? VexoraColors.accent
                        : VexoraColors.textSecondary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: DnaCard(item: item, isLarge: true)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(VexoraSpacing.md),
      itemCount: MarketplaceRepository.categories.length,
      itemBuilder: (context, index) {
        final category = MarketplaceRepository.categories[index];
        final items = MarketplaceRepository.getItemsByCategory(category);
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category,
                style: VexoraTypography.h3(VexoraColors.textPrimary)),
            const SizedBox(height: VexoraSpacing.sm),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, idx) {
                  return DnaCard(item: items[idx]);
                },
              ),
            ),
            const SizedBox(height: VexoraSpacing.lg),
          ],
        );
      },
    );
  }
}
