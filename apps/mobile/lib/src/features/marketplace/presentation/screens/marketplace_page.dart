import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';


/// Marketplace screen — Phase 6E
/// Spotify/TikTok-inspired style discovery feed.
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final _tabs = ['Featured', 'Trending', 'Most Copied', 'Newest'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            backgroundColor: VexoraColors.background,
            floating: true,
            snap: true,
            elevation: 0,
            leadingWidth: 0,
            leading: const SizedBox.shrink(),
            title: const Text(
              'Marketplace',
              style: TextStyle(
                color: VexoraColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_outlined,
                    color: VexoraColors.textSecondary),
                onPressed: () {},
              ),
              const SizedBox(width: VexoraSpacing.sm),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(104),
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        VexoraSpacing.lg, 0, VexoraSpacing.lg, VexoraSpacing.sm),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: VexoraColors.surfaceElevated,
                        borderRadius: VexoraRadius.lgBorder,
                        border: Border.all(color: VexoraColors.border),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: VexoraSpacing.md),
                          const Icon(Icons.search,
                              color: VexoraColors.textTertiary, size: 18),
                          const SizedBox(width: VexoraSpacing.sm),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) =>
                                  setState(() => _searchQuery = v),
                              style: VexoraTypography.body
                                  .copyWith(color: VexoraColors.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'Search styles, creators...',
                                hintStyle: TextStyle(
                                    color: VexoraColors.textTertiary,
                                    fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: VexoraColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: VexoraColors.primary,
                    unselectedLabelColor: VexoraColors.textTertiary,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                    unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14),
                    tabs: _tabs.map((t) => Tab(text: t)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _StyleGrid(section: 'Featured', query: _searchQuery),
            _StyleGrid(section: 'Trending', query: _searchQuery),
            _StyleGrid(section: 'Most Copied', query: _searchQuery),
            _StyleGrid(section: 'Newest', query: _searchQuery),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────── Style Grid ───────────────────────────

class _StyleGrid extends StatelessWidget {
  final String section;
  final String query;

  const _StyleGrid({required this.section, required this.query});

  List<_StyleData> get _mockStyles => [
    _StyleData('Cinematic Dark', '@nova_cuts', 'Cinematic', 0.9, VexoraColors.primary, 2341),
    _StyleData('Lofi Beats', '@chill.ai', 'Lofi', 0.45, VexoraColors.accent, 1892),
    _StyleData('Energy Rush', '@hyper_edit', 'Action', 0.85, VexoraColors.warning, 3104),
    _StyleData('Minimal White', '@clean.cuts', 'Minimal', 0.3, VexoraColors.success, 987),
    _StyleData('Neon Glow', '@neon_ninja', 'Cyberpunk', 0.75, const Color(0xFFFF00FF), 1543),
    _StyleData('Travel Vlog', '@wanderlust', 'Vlog', 0.55, const Color(0xFF00BCD4), 2210),
    _StyleData('Fitness Promo', '@fit_guru', 'Sports', 0.8, const Color(0xFFFF6B35), 1678),
    _StyleData('Romance', '@dreamy.edits', 'Soft', 0.25, const Color(0xFFFF69B4), 892),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = query.isEmpty
        ? _mockStyles
        : _mockStyles
            .where((s) =>
                s.name.toLowerCase().contains(query.toLowerCase()) ||
                s.creator.toLowerCase().contains(query.toLowerCase()))
            .toList();

    if (filtered.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No styles found',
        subtitle: 'Try a different search term or browse by category.',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(VexoraSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
        crossAxisSpacing: VexoraSpacing.sm,
        mainAxisSpacing: VexoraSpacing.sm,
        childAspectRatio: 0.75,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final s = filtered[i];
        return StyleCard(
          name: s.name,
          creator: s.creator,
          category: s.category,
          energy: s.energy,
          accentColor: s.color,
          copyCount: s.copies,
          onTap: () {},
        );
      },
    );
  }
}

class _StyleData {
  final String name;
  final String creator;
  final String category;
  final double energy;
  final Color color;
  final int copies;
  const _StyleData(this.name, this.creator, this.category, this.energy,
      this.color, this.copies);
}
