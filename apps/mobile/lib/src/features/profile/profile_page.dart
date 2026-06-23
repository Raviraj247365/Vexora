import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

/// Profile page — Phase 6 premium layout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: CustomScrollView(
        slivers: [
          // Profile header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + VexoraSpacing.lg,
                left: VexoraSpacing.lg,
                right: VexoraSpacing.lg,
                bottom: VexoraSpacing.lg,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    VexoraColors.primary.withOpacity(0.08),
                    VexoraColors.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [VexoraColors.primary, VexoraColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: VexoraShadows.glowPrimary,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: VexoraSpacing.md),
                  Text('Creator', style: VexoraTypography.heading),
                  const SizedBox(height: 4),
                  Text('@vexora_creator',
                      style: VexoraTypography.caption
                          .copyWith(color: VexoraColors.primary)),
                  const SizedBox(height: VexoraSpacing.lg),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ProfileStat(label: 'Projects', value: '18'),
                      _Divider(),
                      _ProfileStat(label: 'Styles', value: '7'),
                      _Divider(),
                      _ProfileStat(label: 'Copies', value: '893'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(VexoraSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionLabel('Creator Settings'),
                const SizedBox(height: VexoraSpacing.sm),
                _SettingsGroup(items: [
                  _SettingsItem(
                      icon: Icons.auto_awesome,
                      label: 'Style DNA Profile',
                      color: VexoraColors.primary),
                  _SettingsItem(
                      icon: Icons.video_library_outlined,
                      label: 'My Styles',
                      color: VexoraColors.accent),
                  _SettingsItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      color: VexoraColors.warning),
                ]),
                const SizedBox(height: VexoraSpacing.lg),
                _SectionLabel('Developer'),
                const SizedBox(height: VexoraSpacing.sm),
                _SettingsGroup(items: [
                  _SettingsItem(
                      icon: Icons.developer_mode,
                      label: 'Developer Dashboard',
                      color: VexoraColors.success,
                      onTap: () {}),
                  _SettingsItem(
                      icon: Icons.analytics_outlined,
                      label: 'Video Intelligence',
                      color: VexoraColors.accent),
                  _SettingsItem(
                      icon: Icons.style,
                      label: 'Style Guide',
                      color: VexoraColors.textTertiary),
                ]),
                const SizedBox(height: VexoraSpacing.lg),
                _SectionLabel('General'),
                const SizedBox(height: VexoraSpacing.sm),
                _SettingsGroup(items: [
                  _SettingsItem(
                      icon: Icons.help_outline,
                      label: 'Help & Feedback',
                      color: VexoraColors.textTertiary),
                  _SettingsItem(
                      icon: Icons.info_outline,
                      label: 'About Vexora',
                      color: VexoraColors.textTertiary),
                  _SettingsItem(
                      icon: Icons.logout,
                      label: 'Sign Out',
                      color: VexoraColors.error),
                ]),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VexoraSpacing.xl),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                color: VexoraColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 2),
          Text(label, style: VexoraTypography.caption),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 28, color: VexoraColors.border);
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: VexoraTypography.caption.copyWith(
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VexoraColors.surfaceElevated,
        borderRadius: VexoraRadius.lgBorder,
        border: Border.all(color: VexoraColors.border),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast)
                const Divider(
                    height: 1,
                    thickness: 1,
                    color: VexoraColors.border,
                    indent: VexoraSpacing.lg + 36,
                    endIndent: 0),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  State<_SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<_SettingsItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: VexoraAnimations.fast,
          color: _hovered
              ? VexoraColors.surfaceHighlight
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: VexoraSpacing.md,
            vertical: VexoraSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.12),
                  borderRadius: VexoraRadius.mdBorder,
                ),
                child: Icon(widget.icon, color: widget.color, size: 16),
              ),
              const SizedBox(width: VexoraSpacing.md),
              Expanded(
                child: Text(widget.label,
                    style: VexoraTypography.bodyStrong),
              ),
              const Icon(Icons.chevron_right,
                  color: VexoraColors.textTertiary, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
