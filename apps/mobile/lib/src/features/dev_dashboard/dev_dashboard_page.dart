// dev_dashboard_page.dart
//
// Vexora Developer Dashboard — Visual Verification Layer.
// Accessible from app startup. Shows all 6 features with live demo data,
// action buttons, pipeline flow, and links to individual test screens.

import 'package:flutter/material.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/typography.dart';
import 'demo_data.dart';
import 'widgets/feature_card.dart';
import 'widgets/pipeline_flow.dart';
import 'widgets/json_viewer.dart';
import 'screens/video_intelligence_test_screen.dart';
import 'screens/creator_intent_test_screen.dart';
import 'screens/ai_director_test_screen.dart';
import 'screens/timeline_engine_test_screen.dart';
import 'screens/style_dna_test_screen.dart';
import 'screens/project_schema_test_screen.dart';

class DevDashboardPage extends StatefulWidget {
  const DevDashboardPage({Key? key}) : super(key: key);

  @override
  State<DevDashboardPage> createState() => _DevDashboardPageState();
}

class _DevDashboardPageState extends State<DevDashboardPage>
    with TickerProviderStateMixin {
  int _pipelineStep = -1;
  bool _isRunningPipeline = false;
  String? _activeJsonLabel;
  Map<String, dynamic>? _activeJson;

  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  // ─── Pipeline runner ────────────────────────────────────────────────────────

  Future<void> _runFullPipeline() async {
    if (_isRunningPipeline) return;
    setState(() {
      _isRunningPipeline = true;
      _pipelineStep = 0;
      _activeJson = null;
      _activeJsonLabel = null;
    });

    final steps = [
      ('Video Intelligence', VexoraDemoData.videoIntelligenceReport),
      ('Creator Intent', VexoraDemoData.creatorIntentResult),
      ('AI Director', VexoraDemoData.editBlueprintResult),
      ('Timeline Engine', VexoraDemoData.timelineEngineResult),
      ('Style DNA', VexoraDemoData.styleDnaResult),
      ('Project Schema', VexoraDemoData.projectSchemaResult),
    ];

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1100));
      if (!mounted) return;
      setState(() {
        _pipelineStep = i;
        _activeJsonLabel = steps[i].$1;
        _activeJson = steps[i].$2;
      });
    }

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _isRunningPipeline = false);
  }

  // ─── Individual action buttons ───────────────────────────────────────────────

  void _showJson(String label, Map<String, dynamic> data) {
    setState(() {
      _activeJsonLabel = label;
      _activeJson = data;
    });
    _scrollToBottom();
  }

  final ScrollController _scrollCtrl = ScrollController();
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexoraColors.background,
      body: CustomScrollView(
        controller: _scrollCtrl,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSystemStatusRow(),
                  const SizedBox(height: 28),
                  _buildPipelineSection(),
                  const SizedBox(height: 28),
                  _buildActionButtons(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Feature Verification Cards'),
                  const SizedBox(height: 16),
                  _buildFeatureCards(),
                  if (_activeJson != null) ...[
                    const SizedBox(height: 32),
                    _buildSectionHeader(
                        'Live Output · ${_activeJsonLabel ?? ""}'),
                    const SizedBox(height: 12),
                    VexoraJsonViewer(
                      json: VexoraDemoData.prettyJson(_activeJson!),
                      maxHeight: 420,
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: VexoraColors.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded,
            color: VexoraColors.textSecondary, size: 18),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: FadeTransition(
          opacity: _headerFade,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1C122C), Color(0xFF12121A)],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: VexoraColors.accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: VexoraColors.accent.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.developer_mode_rounded,
                            color: VexoraColors.accentSoft, size: 12),
                        SizedBox(width: 5),
                        Text('DEV MODE',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                                color: VexoraColors.accentSoft)),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                Text('Developer Dashboard',
                    style: VexoraTypography.heading2(VexoraColors.textPrimary)),
                const SizedBox(height: 4),
                Text(
                    'Visual verification layer · All features · Live demo data',
                    style: VexoraTypography.body(VexoraColors.textSecondary)),
              ],
            ),
          ),
        ),
        collapseMode: CollapseMode.parallax,
        titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
        title: Text('Dev Dashboard',
            style: VexoraTypography.label(VexoraColors.textPrimary)),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: VexoraColors.border),
      ),
    );
  }

  Widget _buildSystemStatusRow() {
    final statuses = [
      _StatusBadge('Video Intel', true, const Color(0xFF00E5FF)),
      _StatusBadge('Creator Intent', true, const Color(0xFF7000FF)),
      _StatusBadge('AI Director', true, const Color(0xFF9E54FF)),
      _StatusBadge('Timeline', true, const Color(0xFF00E676)),
      _StatusBadge('Style DNA', true, const Color(0xFFFFB547)),
      _StatusBadge('Project Schema', true, VexoraColors.accentSoft),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VexoraColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.monitor_heart_rounded,
              color: VexoraColors.success, size: 16),
          const SizedBox(width: 8),
          Text('System Status',
              style: VexoraTypography.label(VexoraColors.textPrimary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: VexoraColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: VexoraColors.success.withOpacity(0.3)),
            ),
            child: Text('6/6 ACTIVE',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: VexoraColors.success)),
          ),
        ]),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: statuses.map((s) => _buildStatusChip(s)).toList(),
        ),
      ]),
    );
  }

  Widget _buildStatusChip(_StatusBadge badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badge.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badge.color.withOpacity(0.25)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
              color: badge.isActive ? badge.color : VexoraColors.textSecondary,
              shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(badge.label,
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: badge.color)),
      ]),
    );
  }

  Widget _buildPipelineSection() {
    return PipelineFlowWidget(activeStep: _pipelineStep);
  }

  Widget _buildActionButtons() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionHeader('Quick Actions'),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(
          child: _buildActionBtn(
            'Run Analysis',
            Icons.play_arrow_rounded,
            const Color(0xFF00E5FF),
            () => _showJson(
                'Video Intelligence', VexoraDemoData.videoIntelligenceReport),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionBtn(
            'Generate Intent',
            Icons.psychology_rounded,
            const Color(0xFF7000FF),
            () =>
                _showJson('Creator Intent', VexoraDemoData.creatorIntentResult),
          ),
        ),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: _buildActionBtn(
            'Generate Blueprint',
            Icons.movie_filter_rounded,
            const Color(0xFF9E54FF),
            () => _showJson('AI Director', VexoraDemoData.editBlueprintResult),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionBtn(
            'Extract Style DNA',
            Icons.auto_awesome_rounded,
            const Color(0xFFFFB547),
            () => _showJson('Style DNA', VexoraDemoData.styleDnaResult),
          ),
        ),
      ]),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isRunningPipeline ? null : _runFullPipeline,
          icon: _isRunningPipeline
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.account_tree_rounded, size: 18),
          label: Text(
              _isRunningPipeline
                  ? 'Running Full Pipeline...'
                  : '▶  Run Full Pipeline Flow',
              style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: VexoraColors.accent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: VexoraColors.accent.withOpacity(0.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
        ),
      ),
    ]);
  }

  Widget _buildActionBtn(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15, color: color),
      label: Text(label,
          style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.35)),
        backgroundColor: color.withOpacity(0.07),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(children: [
      Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
              gradient: VexoraColors.brandGradient,
              borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(title, style: VexoraTypography.label(VexoraColors.textPrimary)),
    ]);
  }

  Widget _buildFeatureCards() {
    final cards = [
      _CardDef(
        title: 'Video Intelligence',
        subtitle: 'Scene · Beat · Face · Speech · Highlight detection',
        icon: Icons.video_settings_rounded,
        color: const Color(0xFF00E5FF),
        status: FeatureStatus.active,
        statusLabel: 'Active',
        stats: ['4 Scenes', '5 Beats', '2 Faces', '2 Speech'],
        screen: const VideoIntelligenceTestScreen(),
      ),
      _CardDef(
        title: 'Creator Intent',
        subtitle: 'Natural language → structured editing signals',
        icon: Icons.auto_fix_high_rounded,
        color: const Color(0xFF7000FF),
        status: FeatureStatus.active,
        statusLabel: 'Active',
        stats: ['NLP Parser', '7 Keywords', '0.92 Confidence'],
        screen: const CreatorIntentTestScreen(),
      ),
      _CardDef(
        title: 'AI Director',
        subtitle:
            'Generates typed blueprint operations from intent + intelligence',
        icon: Icons.movie_filter_rounded,
        color: const Color(0xFF9E54FF),
        status: FeatureStatus.active,
        statusLabel: 'Active',
        stats: ['7 Operations', 'v1.4.0', '89% Confidence'],
        screen: const AiDirectorTestScreen(),
      ),
      _CardDef(
        title: 'Timeline Engine',
        subtitle: 'Executes blueprint operations on the project timeline',
        icon: Icons.timeline_rounded,
        color: const Color(0xFF00E676),
        status: FeatureStatus.active,
        statusLabel: 'Active',
        stats: ['3 Tracks', '142ms', '7/7 Applied'],
        screen: const TimelineEngineTestScreen(),
      ),
      _CardDef(
        title: 'Style DNA',
        subtitle:
            'Extracts reusable creator editing personality from finished edits',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFFFFB547),
        status: FeatureStatus.active,
        statusLabel: 'Active',
        stats: ['Energy 85', 'BeatSync 91%', 'Fast Pace'],
        screen: const StyleDnaTestScreen(),
      ),
      _CardDef(
        title: 'Project Schema',
        subtitle: 'Universal JSON format representing the final project state',
        icon: Icons.schema_rounded,
        color: VexoraColors.accentSoft,
        status: FeatureStatus.active,
        statusLabel: 'Active',
        stats: ['v1.2.0', '1080x1920', '2 Tracks'],
        screen: const ProjectSchemaTestScreen(),
      ),
    ];

    return Column(
      children: cards
          .map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: FeatureCard(
                  title: c.title,
                  subtitle: c.subtitle,
                  icon: c.icon,
                  accentColor: c.color,
                  status: c.status,
                  statusLabel: c.statusLabel,
                  stats: c.stats,
                  onTest: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => c.screen),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

// ─── Data classes ─────────────────────────────────────────────────────────────

class _StatusBadge {
  final String label;
  final bool isActive;
  final Color color;
  const _StatusBadge(this.label, this.isActive, this.color);
}

class _CardDef {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final FeatureStatus status;
  final String statusLabel;
  final List<String> stats;
  final Widget screen;

  const _CardDef({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.status,
    required this.statusLabel,
    required this.stats,
    required this.screen,
  });
}
