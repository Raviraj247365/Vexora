import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/animations.dart';
import '../tokens/shadows.dart';

/// A card for project tiles. Inspired by Notion / Canva.
class ProjectCard extends StatefulWidget {
  final String title;
  final String duration;
  final String? thumbnail;
  final String status;
  final VoidCallback? onTap;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.duration,
    this.thumbnail,
    this.status = 'Draft',
    this.onTap,
  }) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  Color get _statusColor {
    switch (widget.status.toLowerCase()) {
      case 'published':
        return VexoraColors.success;
      case 'processing':
        return VexoraColors.warning;
      case 'draft':
      default:
        return VexoraColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              color: _isHovered
                  ? VexoraColors.borderFocus.withOpacity(0.3)
                  : VexoraColors.border,
            ),
            boxShadow: _isHovered ? VexoraShadows.md : VexoraShadows.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail / Preview area
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(VexoraRadius.lg),
                ),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: VexoraColors.surface,
                  child: widget.thumbnail != null
                      ? Image.asset(widget.thumbnail!, fit: BoxFit.cover)
                      : Center(
                          child: Icon(
                            Icons.video_library_outlined,
                            color: VexoraColors.textTertiary,
                            size: 32,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(VexoraSpacing.sm + 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: VexoraColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          widget.duration,
                          style: const TextStyle(
                            color: VexoraColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor.withOpacity(0.1),
                            borderRadius: VexoraRadius.smBorder,
                          ),
                          child: Text(
                            widget.status,
                            style: TextStyle(
                              color: _statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
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
