import 'dart:math';
import '../domain/marketplace_models.dart';
import '../../style_engine/domain/style_pack.dart';
import '../../style_engine/domain/edit_style.dart';
import '../../style_engine/domain/caption_style.dart';
import '../../style_engine/domain/effect_contract.dart';
import '../../style_engine/domain/transition_contract.dart';

class MarketplaceRepository {
  static final _random = Random(42);

  static final List<String> categories = [
    'Gym',
    'Cinematic',
    'Anime',
    'Gaming',
    'Podcast',
    'Luxury',
    'Travel',
    'Motivation'
  ];

  static final List<CreatorProfile> _mockCreators = _generateMockCreators();
  static final List<MarketplaceItem> _mockItems = _generateMockItems();

  static List<CreatorProfile> _generateMockCreators() {
    final names = [
      'NeonBeast',
      'AeroEdits',
      'GigaChad',
      'SynthWave',
      'PixelGod',
      'Zenith',
      'Vortex',
      'Pulse',
      'Echo',
      'Drift',
      'Nova',
      'Apex',
      'Titan',
      'Onyx',
      'Jade',
      'Crimson',
      'Azure',
      'Frost',
      'Ember',
      'Glow'
    ];
    return List.generate(20, (index) {
      return CreatorProfile(
        id: 'creator_$index',
        username: names[index],
        avatarUrl:
            '#${(_random.nextDouble() * 0xFFFFFF).toInt().toRadixString(16).padLeft(6, '0')}',
        followers: 1000 + _random.nextInt(500000),
        totalUses: 500 + _random.nextInt(1000000),
        isVerified: _random.nextDouble() > 0.8,
      );
    });
  }

  static List<MarketplaceItem> _generateMockItems() {
    final colors = [
      '#FF0055',
      '#00E5FF',
      '#7000FF',
      '#00E676',
      '#FFD700',
      '#FF3D00',
      '#D50000',
      '#2962FF'
    ];

    return List.generate(50, (index) {
      final category = categories[_random.nextInt(categories.length)];
      final creator = _mockCreators[_random.nextInt(_mockCreators.length)];
      final color = colors[_random.nextInt(colors.length)];

      final style = EditStyle(
        id: 'style_$index',
        name: '$category Edit ${index + 1}',
        description: 'Premium $category edit template by ${creator.username}.',
        allowedEffects: [
          CustomEffect(
              id: 'fx_glow',
              name: 'Glow',
              category: 'light',
              defaultParameters: {})
        ],
        allowedTransitions: [
          CustomTransition(
              id: 'tr_cut',
              name: 'Cut',
              defaultDurationMs: 0,
              requiresOverlap: false,
              easingCurve: 'linear')
        ],
        defaultCaptionStyle: const CaptionStyle(
          id: 'cap_default',
          name: 'Standard',
          fontFamily: 'Inter',
          fontSize: 32,
          primaryColorHex: '#FFFFFF',
          highlightColorHex: '#00E5FF',
          animationType: 'pop',
          uppercase: true,
        ),
        pacingRules: PacingRules(
            cutsPerMinute: 20.0 + _random.nextInt(40),
            beatMatchingIntensity: 0.5 + _random.nextDouble() * 0.5),
      );

      final stylePack = StylePack(
        version: '1.0.0',
        author: creator.username,
        previewUrl: '',
        style: style,
      );

      final metrics = TrendingMetrics(
        views: 100 + _random.nextInt(100000),
        uses: 50 + _random.nextInt(50000),
        saves: 10 + _random.nextInt(10000),
        shares: _random.nextInt(5000),
        completionRate: 0.4 + _random.nextDouble() * 0.5,
      );

      return MarketplaceItem(
        id: 'item_$index',
        dna: EditDna(stylePack: stylePack, category: category),
        creator: creator,
        metrics: metrics,
        thumbnailColorHex: color,
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
      );
    });
  }

  static List<MarketplaceItem> getTrendingItems() {
    final items = List<MarketplaceItem>.from(_mockItems);
    items.sort(
        (a, b) => b.metrics.trendingScore.compareTo(a.metrics.trendingScore));
    return items;
  }

  static List<MarketplaceItem> getItemsByCategory(String category) {
    return _mockItems.where((item) => item.dna.category == category).toList();
  }

  static List<MarketplaceItem> getDiscoverItems() {
    final items = List<MarketplaceItem>.from(_mockItems);
    items.shuffle(_random);
    return items;
  }

  static CreatorProfile getCreator(String id) {
    return _mockCreators.firstWhere((c) => c.id == id);
  }

  static List<MarketplaceItem> getItemsByCreator(String creatorId) {
    return _mockItems.where((item) => item.creator.id == creatorId).toList();
  }
}
