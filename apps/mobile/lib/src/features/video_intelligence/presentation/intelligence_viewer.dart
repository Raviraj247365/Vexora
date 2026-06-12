import 'package:flutter/material.dart';
import '../domain/intelligence_report.dart';

/// intelligence_viewer.dart
///
/// Lightweight reader widget for a Video Intelligence metadata report.
class IntelligenceViewer extends StatelessWidget {
  final IntelligenceReport report;

  const IntelligenceViewer({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Video Intelligence Report',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text('Video ID: ${report.videoId}'),
            const SizedBox(height: 12.0),
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              children: [
                _buildCountChip('Scenes', report.scenes.length),
                _buildCountChip('Beats', report.beats.length),
                _buildCountChip('Faces', report.faces.length),
                _buildCountChip('Speech', report.speech.length),
                _buildCountChip('Highlights', report.highlights.length),
              ],
            ),
            if (report.highlights.isNotEmpty) ...[
              const SizedBox(height: 12.0),
              Text(
                'Top highlight',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Timestamp: ${report.highlights.first.timestamp} ms, score: ${report.highlights.first.score.toStringAsFixed(2)}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCountChip(String label, int count) {
    return Chip(
      label: Text('$label: $count'),
    );
  }
}
