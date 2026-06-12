import 'package:flutter/material.dart';

/// analysis_status_panel.dart
///
/// Simple status panel for the Video Intelligence analysis flow.
class AnalysisStatusPanel extends StatelessWidget {
  final String status;
  final double progress;
  final String details;

  const AnalysisStatusPanel({
    super.key,
    required this.status,
    this.progress = 0.0,
    this.details = '',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12.0),
            LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
            if (details.isNotEmpty) ...[
              const SizedBox(height: 12.0),
              Text(
                details,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
