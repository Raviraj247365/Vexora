import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/animations.dart';

/// Card for Marketplace style items. Spotify-inspired.
class StyleCard extends StatefulWidget {
  final String name;
  final String creator;
  final String category;
  final int copyCount;
  final double energy;
  final Color? accentColor;
  final VoidCallback? onTap;

  const StyleCard({
    Key? key,
    required this.name,
    required this.creator,
    required this.category,
    this.copyCount = 0,
    this.energy = 0.5,
    this.accentColor,
    this.onTap,
  }) : super(key: key);

  @override
  State<StyleCard> createState() => _StyleCardState();
}

class _StyleCardState extends State<StyleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? VexoraColors.primary;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: VexoraAnimations.fast,
          decoration: BoxDecoration(
            color: _isHovered
                ? VexoraColors.surfaceHighlight
                : VexoraColors.surfaceElevated,
            borderRadius: VexoraRadius.lgBorder,
            border: Border.all(
              color: _isHovered ? accent.withOpacity(0.4) : VexoraColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Style preview bar with energy visualization
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(VexoraRadius.lg),
                ),
                child: Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withOpacity(0.3),
                        accent.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.auto_awesome, color: accent, size: 28),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(VexoraSpacing.sm + 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: VexoraColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.creator,
                      style: const TextStyle(
                        color: VexoraColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Energy bar
                    ClipRRect(
                      borderRadius: VexoraRadius.smBorder,
                      child: LinearProgressIndicator(
                        value: widget.energy,
                        backgroundColor: VexoraColors.surface,
                        valueColor: AlwaysStoppedAnimation(accent),
                        minHeight: 3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: VexoraColors.surface,
                            borderRadius: VexoraRadius.smBorder,
                          ),
                          child: Text(
                            widget.category,
                            style: const TextStyle(
                              color: VexoraColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.copy_outlined,
                            size: 11, color: VexoraColors.textTertiary),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.copyCount}',
                          style: const TextStyle(
                            color: VexoraColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
