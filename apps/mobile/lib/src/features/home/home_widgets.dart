import 'package:flutter/material.dart';
import '../../design/design_system.dart';
import 'home_models.dart';
import '../project_management/domain/project_model.dart';

/// Reusable home screen widgets for the Vexora home experience.
///
/// Keep these widgets feature-scoped so the home feature remains modular.

class HomeSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onViewAll;

  const HomeSectionTitle({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: VexoraTypography.heading2(VexoraColors.textPrimary)),
            const SizedBox(height: VexoraSpacing.xs),
            Text(subtitle,
                style: VexoraTypography.caption(VexoraColors.textSecondary)),
          ],
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text('View all',
              style: VexoraTypography.label(
                  onViewAll != null
                      ? VexoraColors.accent
                      : VexoraColors.textSecondary)),
        ),
      ],
    );
  }
}

class HomeProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const HomeProjectCard({
    Key? key,
    required this.project,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: VexoraCard(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.title,
                    style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
                const SizedBox(height: VexoraSpacing.xs),
                Text('${project.assetCount} assets',
                    style: VexoraTypography.body(VexoraColors.textSecondary)),
                const SizedBox(height: VexoraSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: project.progress,
                    minHeight: 6,
                    backgroundColor: VexoraColors.surfaceAlt,
                    valueColor: const AlwaysStoppedAnimation(VexoraColors.accent),
                  ),
                ),
                const SizedBox(height: VexoraSpacing.xs),
                Text(
                  'Updated ${project.updatedAt.toIso8601String().split('T').first}',
                  style: VexoraTypography.caption(VexoraColors.textSecondary),
                ),
              ],
            ),
            if (onDelete != null)
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeTemplateCard extends StatelessWidget {
  final VexoraTemplate template;

  const HomeTemplateCard({Key? key, required this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VexoraCard(
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(template.category.toUpperCase(),
                style: VexoraTypography.label(VexoraColors.accent)),
            const SizedBox(height: VexoraSpacing.xs),
            Text(template.name,
                style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
            const SizedBox(height: VexoraSpacing.xs),
            Text(template.description,
                style: VexoraTypography.body(VexoraColors.textSecondary)),
            const SizedBox(height: VexoraSpacing.lg),
            VexoraButton(
                label: 'Use template',
                onPressed: () {},
                variant: ButtonVariant.secondary),
          ],
        ),
      ),
    );
  }
}

class HomeAiToolCard extends StatelessWidget {
  final VexoraAiTool tool;

  const HomeAiToolCard({Key? key, required this.tool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VexoraCard(
      child: Padding(
        padding: const EdgeInsets.all(VexoraSpacing.md),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: VexoraColors.accent.withOpacity(0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(tool.asset,
                    style: VexoraTypography.heading2(VexoraColors.accent)),
              ),
            ),
            const SizedBox(width: VexoraSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.title,
                      style:
                          VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
                  const SizedBox(height: VexoraSpacing.xs),
                  Text(tool.subtitle,
                      style: VexoraTypography.body(VexoraColors.textSecondary)),
                ],
              ),
            ),
            VexoraButton(
                label: tool.action,
                onPressed: () {},
                variant: ButtonVariant.ghost),
          ],
        ),
      ),
    );
  }
}

class HomeBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const HomeBottomNavigation(
      {Key? key, required this.selectedIndex, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home, label: 'Home'),
      _NavItem(icon: Icons.auto_awesome, label: 'Create'),
      _NavItem(icon: Icons.movie_filter, label: 'AI Director'),
      _NavItem(icon: Icons.analytics, label: 'Insights'),
      _NavItem(icon: Icons.person, label: 'Profile'),
    ];

    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(
          horizontal: VexoraSpacing.lg, vertical: VexoraSpacing.sm),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onChanged(index),
            child: AnimatedContainer(
              duration: VexoraAnimation.standard,
              padding: const EdgeInsets.symmetric(
                  horizontal: VexoraSpacing.sm, vertical: VexoraSpacing.xs),
              decoration: BoxDecoration(
                color: isSelected
                    ? VexoraColors.accent.withOpacity(0.14)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon,
                      color: isSelected
                          ? VexoraColors.accent
                          : VexoraColors.textSecondary),
                  const SizedBox(height: VexoraSpacing.xs),
                  Text(item.label,
                      style: VexoraTypography.caption(isSelected
                          ? VexoraColors.accent
                          : VexoraColors.textSecondary)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}

class HomePromptBar extends StatelessWidget {
  const HomePromptBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: VexoraSpacing.md, vertical: VexoraSpacing.xs),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: VexoraColors.accent),
          const SizedBox(width: VexoraSpacing.sm),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Describe your vision...',
                hintStyle: VexoraTypography.body(VexoraColors.textSecondary),
                border: InputBorder.none,
              ),
              style: VexoraTypography.bodyLarge(VexoraColors.textPrimary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: VexoraColors.accent),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
