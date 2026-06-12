import 'package:flutter/material.dart';
import '../../domain/marketplace_models.dart';
import 'package:go_router/go_router.dart';

class DnaCard extends StatelessWidget {
  final MarketplaceItem item;
  final bool isLarge;

  const DnaCard({Key? key, required this.item, this.isLarge = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color thumbColor = Colors.grey;
    try {
      thumbColor =
          Color(int.parse(item.thumbnailColorHex.replaceFirst('#', '0xFF')));
    } catch (_) {}

    return GestureDetector(
      onTap: () {
        context.push('/marketplace/details', extra: item);
      },
      child: Container(
        width: isLarge ? 280 : 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: thumbColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: thumbColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: thumbColor.withOpacity(0.05), blurRadius: 20),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Mock Video Thumbnail Gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      thumbColor.withOpacity(0.4),
                      Colors.transparent,
                      Colors.black87
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.dna.stylePack.style.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Color(int.parse(
                            item.creator.avatarUrl.replaceFirst('#', '0xFF'))),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.creator.username,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.play_arrow,
                          color: Colors.white54, size: 14),
                      const SizedBox(width: 4),
                      Text('${(item.metrics.views / 1000).toStringAsFixed(1)}k',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                      const Spacer(),
                      const Icon(Icons.bookmark_border,
                          color: Colors.white54, size: 14),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
