/// Mock data models for the Vexora home screen.
///
/// These models are intentionally simple and used only for UI structure.
class VexoraProject {
  final String title;
  final String subtitle;
  final double progress;
  final String updatedAt;

  const VexoraProject({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.updatedAt,
  });
}

class VexoraTemplate {
  final String name;
  final String category;
  final String description;

  const VexoraTemplate({
    required this.name,
    required this.category,
    required this.description,
  });
}

class VexoraAiTool {
  final String title;
  final String subtitle;
  final String action;
  final String asset;

  const VexoraAiTool({
    required this.title,
    required this.subtitle,
    required this.action,
    required this.asset,
  });
}

final mockProjects = <VexoraProject>[
  const VexoraProject(
    title: 'Neon Burst Reel',
    subtitle: '60% complete · 2 mins',
    progress: 0.6,
    updatedAt: 'Today',
  ),
  const VexoraProject(
    title: 'City Lights Montage',
    subtitle: '45% complete · 1.4 mins',
    progress: 0.45,
    updatedAt: 'Yesterday',
  ),
  const VexoraProject(
    title: 'Future Vlog Intro',
    subtitle: '30% complete · 0.8 mins',
    progress: 0.3,
    updatedAt: '2 days ago',
  ),
];

final mockTemplates = <VexoraTemplate>[
  const VexoraTemplate(
    name: 'Power Lift',
    category: 'Gym',
    description: 'High energy beats and impact transitions.',
  ),
  const VexoraTemplate(
    name: 'Wanderlust',
    category: 'Travel',
    description: 'Smooth zooms and bright color grading.',
  ),
  const VexoraTemplate(
    name: 'Cinematic Pulse',
    category: 'Cinematic',
    description: 'Dark mood with premium cuts.',
  ),
  const VexoraTemplate(
    name: 'Headshot Highlights',
    category: 'Gaming',
    description: 'Fast pacing and glitch effects.',
  ),
  const VexoraTemplate(
    name: 'Deep Dive',
    category: 'Podcast',
    description: 'Clean layouts with auto-captions.',
  ),
  const VexoraTemplate(
    name: 'Daily Grind',
    category: 'Motivational',
    description: 'Inspiring text overlays and slow-mo.',
  ),
];

final mockAiTools = <VexoraAiTool>[
  const VexoraAiTool(
    title: 'Smart Trim',
    subtitle: 'Auto cut the best moments.',
    action: 'Try now',
    asset: '✂️',
  ),
  const VexoraAiTool(
    title: 'Scene Scanner',
    subtitle: 'Find the coolest beats.',
    action: 'Launch',
    asset: '🔍',
  ),
  const VexoraAiTool(
    title: 'Auto Caption',
    subtitle: 'Generate captions instantly.',
    action: 'Open',
    asset: '💬',
  ),
];
