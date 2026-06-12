import '../domain/intelligence_report.dart';
import 'metadata_extractor.dart';

/// intelligence_service.dart
///
/// The public service surface for the Video Intelligence Layer.
/// This service is responsible for producing metadata-only reports
/// and never mutates or edits source video content.
abstract class IntelligenceService {
  Future<IntelligenceReport> analyzeVideo({
    required String videoId,
    required String videoPath,
  });
}

/// Default in-app intelligence service implementation.
///
/// In a production implementation, this service may delegate to a background
/// isolate or a remote cloud worker. For now, it composes the metadata extractor.
class DefaultIntelligenceService implements IntelligenceService {
  final MetadataExtractor extractor;

  const DefaultIntelligenceService({required this.extractor});

  @override
  Future<IntelligenceReport> analyzeVideo({
    required String videoId,
    required String videoPath,
  }) {
    return extractor.extractIntelligence(
      videoId: videoId,
      videoPath: videoPath,
    );
  }
}
