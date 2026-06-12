import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vexora_mobile_app/src/design/design_system.dart';
import '../../domain/marketplace_models.dart';
import '../../data/marketplace_repository.dart';
import '../widgets/dna_card.dart';

class CreatorProfileScreen extends StatelessWidget {
  final CreatorProfile creator;

  const CreatorProfileScreen({Key? key, required this.creator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = MarketplaceRepository.getItemsByCreator(creator.id);
    final avatarColor =
        Color(int.parse(creator.avatarUrl.replaceFirst('#', '0xFF')));

    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: VexoraColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(creator.username,
            style: VexoraTypography.bodyLarge(Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            backgroundColor: avatarColor,
            child: Text(creator.username[0],
                style: const TextStyle(fontSize: 32, color: Colors.white)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('@${creator.username}',
                  style: VexoraTypography.h3(Colors.white)),
              if (creator.isVerified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.blue, size: 20),
              ],
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('FOLLOWERS', _formatNumber(creator.followers)),
              _buildStatColumn('TOTAL USES', _formatNumber(creator.totalUses)),
              _buildStatColumn('PACKS', items.length.toString()),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: VexoraColors.border),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(VexoraSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return DnaCard(item: items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: VexoraTypography.h3(Colors.white)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white54, fontSize: 12, letterSpacing: 1.2)),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}k';
    return number.toString();
  }
}
