import '../../style_engine/domain/style_pack.dart';

class CreatorProfile {
  final String id;
  final String username;
  final String
      avatarUrl; // We will use a mock hex color or random string if no URL
  final int followers;
  final int totalUses;
  final bool isVerified;

  const CreatorProfile({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.followers,
    required this.totalUses,
    this.isVerified = false,
  });
}

class TrendingMetrics {
  final int views;
  final int uses;
  final int saves;
  final int shares;
  final double completionRate;

  const TrendingMetrics({
    required this.views,
    required this.uses,
    required this.saves,
    required this.shares,
    required this.completionRate,
  });

  /// A simple ranking score logic
  double get trendingScore => (uses * 2.0) + saves + (completionRate * 1000);
}

class EditDna {
  final StylePack stylePack;
  final String category;

  // In the future, this would also include CreatorIntent and specific Timeline Operations
  // For now, StylePack encapsulates the required effects/transitions/pacing.

  const EditDna({
    required this.stylePack,
    required this.category,
  });
}

class MarketplaceItem {
  final String id;
  final EditDna dna;
  final CreatorProfile creator;
  final TrendingMetrics metrics;
  final String thumbnailColorHex;
  final DateTime createdAt;

  const MarketplaceItem({
    required this.id,
    required this.dna,
    required this.creator,
    required this.metrics,
    required this.thumbnailColorHex,
    required this.createdAt,
  });
}
