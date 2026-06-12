// project_schema_test_screen.dart

import 'package:flutter/material.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';
import '../demo_data.dart';
import '../widgets/json_viewer.dart';

class ProjectSchemaTestScreen extends StatefulWidget {
  const ProjectSchemaTestScreen({Key? key}) : super(key: key);

  @override
  State<ProjectSchemaTestScreen> createState() =>
      _ProjectSchemaTestScreenState();
}

class _ProjectSchemaTestScreenState extends State<ProjectSchemaTestScreen> {
  bool _isExporting = false;
  bool _hasResult = false;

  Future<void> _exportSchema() async {
    setState(() {
      _isExporting = true;
      _hasResult = false;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isExporting = false;
        _hasResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final schema = VexoraDemoData.projectSchemaResult;
    final stats = schema['stats'] as Map;

    return Scaffold(
      backgroundColor: VexoraColors.background,
      appBar: AppBar(
        backgroundColor: VexoraColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: VexoraColors.accentSoft, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.schema_rounded,
              color: VexoraColors.accentSoft, size: 18),
          const SizedBox(width: 8),
          Text('Project Schema',
              style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
        ]),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: VexoraColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(schema),
            const SizedBox(height: 24),
            _buildSectionLabel('Project Stats'),
            const SizedBox(height: 12),
            _buildStatsGrid(stats),
            const SizedBox(height: 24),
            _buildExportButton(),
            if (_isExporting) ...[
              const SizedBox(height: 20),
              _buildExportingState(),
            ],
            if (_hasResult) ...[
              const SizedBox(height: 24),
              _buildSectionLabel('Universal Schema JSON'),
              const SizedBox(height: 10),
              VexoraJsonViewer(
                json: VexoraDemoData.prettyJson(schema),
                maxHeight: 500,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHero(Map schema) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VexoraColors.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VexoraColors.accentSoft.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: VexoraColors.accentSoft.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.file_copy_rounded,
              color: VexoraColors.accentSoft),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Project: ${schema['name']}',
                style: VexoraTypography.bodyLarge(VexoraColors.textPrimary)),
            const SizedBox(height: 4),
            Text(
                'Schema v${schema['version']} · ${schema['resolution']} @ ${schema['fps']}fps',
                style: VexoraTypography.body(VexoraColors.textSecondary)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(children: [
      Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
              color: VexoraColors.accentSoft,
              borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(label, style: VexoraTypography.label(VexoraColors.textPrimary)),
    ]);
  }

  Widget _buildStatsGrid(Map stats) {
    final items = [
      ['Total Tracks', '${stats['totalTracks']}', Icons.layers_rounded],
      ['Total Clips', '${stats['totalClips']}', Icons.movie_rounded],
      [
        'Transitions',
        '${stats['totalTransitions']}',
        Icons.switch_right_rounded
      ],
      ['Effects', '${stats['totalEffects']}', Icons.auto_awesome_rounded],
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: items
          .map((i) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: VexoraColors.accentSoft.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: VexoraColors.accentSoft.withOpacity(0.15)),
                ),
                child: Row(children: [
                  Icon(i[2] as IconData,
                      color: VexoraColors.accentSoft, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(i[1] as String,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: VexoraColors.textPrimary)),
                      Text(i[0] as String,
                          style: VexoraTypography.caption(
                              VexoraColors.textSecondary)),
                    ],
                  ),
                ]),
              ))
          .toList(),
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isExporting ? null : _exportSchema,
        icon: const Icon(Icons.code_rounded, size: 20),
        label: Text(_isExporting ? 'Exporting...' : 'Export Universal Schema',
            style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: VexoraColors.accentSoft,
          foregroundColor: VexoraColors.background,
          disabledBackgroundColor: VexoraColors.accentSoft.withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildExportingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VexoraColors.accentSoft.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: VexoraColors.accentSoft.withOpacity(0.25)),
      ),
      child: Row(children: [
        SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: VexoraColors.accentSoft)),
        const SizedBox(width: 14),
        Text('Compiling project tracks and assets...',
            style: VexoraTypography.body(VexoraColors.accentSoft)),
      ]),
    );
  }
}
