import '../video_intelligence/domain/intelligence_report.dart';
import '../project_schema/project_schema.dart';
import '../style_dna/style_dna.dart';
import 'creator_intent.dart';
import 'creator_intent_engine.dart';

/// default_creator_intent_engine.dart
///
/// Default (rule-based) implementation of CreatorIntentEngine.
/// Converts natural language prompts into structured creator intents using
/// simple keyword matching and heuristics (no AI models required).
class DefaultCreatorIntentEngine implements CreatorIntentEngine {
  // Category keywords
  static const Map<String, List<String>> categoryPatterns = {
    'gym': [
      'gym',
      'workout',
      'exercise',
      'fitness',
      'lift',
      'weight',
      'strength'
    ],
    'travel': [
      'travel',
      'vlog',
      'adventure',
      'explore',
      'journey',
      'destination'
    ],
    'cinematic': ['cinematic', 'film', 'movie', 'dramatic', 'epic', 'story'],
    'gaming': ['gaming', 'game', 'gameplay', 'esports', 'stream', 'clip'],
    'podcast': [
      'podcast',
      'talk',
      'interview',
      'discussion',
      'dialogue',
      'voice'
    ],
    'motivational': [
      'motivational',
      'inspire',
      'motivation',
      'success',
      'goal',
      'dream'
    ],
  };

  // Style keywords
  static const Map<String, List<String>> stylePatterns = {
    'fast_paced': ['fast', 'quick', 'quick-cut', 'rapid', 'energetic', 'hype'],
    'cinematic': ['cinematic', 'film', 'smooth', 'slow-mo', 'dramatic'],
    'casual': ['casual', 'relaxed', 'chill', 'vibe', 'easy', 'fun'],
    'professional': ['professional', 'corporate', 'formal', 'clean', 'minimal'],
  };

  // Feature keywords
  static const List<String> featureKeywords = [
    'slow-mo',
    'slow motion',
    'zoom',
    'transition',
    'caption',
    'text',
    'subtitle',
    'beat-sync',
    'music',
    'highlight',
    'effect',
    'color',
    'filter',
    'grading',
  ];

  const DefaultCreatorIntentEngine();

  /// Parses a natural language prompt into a structured CreatorIntent.
  ///
  /// Optional [intelligenceReport] can enrich the intent with audio/visual metadata.
  /// Optional [projectSchema] can provide project context (duration, aspect ratio, etc.).
  @override
  CreatorIntent parseIntent(
    String prompt, {
    IntelligenceReport? intelligenceReport,
    ProjectSchema? projectSchema,
    StyleDNA? preferredStyle,
  }) {
    // 1. Detect category from keywords
    final category = _detectCategory(prompt);

    // 2. Detect style from keywords
    final style = _detectStyle(prompt);

    // 3. Extract all feature keywords mentioned in prompt
    final keywords = _extractKeywords(prompt);

    // 4. Enrich with intelligence metadata if available
    _enrichWithIntelligence(keywords, intelligenceReport);

    // Return structured intent
    return CreatorIntent(
      prompt: prompt,
      category: category,
      style: style,
      keywords: keywords,
      preferredStyle: preferredStyle,
    );
  }

  /// Detects editing category from keyword patterns in the prompt.
  String _detectCategory(String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    // Check category patterns and return highest priority match
    for (final entry in categoryPatterns.entries) {
      for (final keyword in entry.value) {
        if (lowerPrompt.contains(keyword)) {
          return entry.key;
        }
      }
    }

    // Default to generic if no category matched
    return 'generic';
  }

  /// Detects editing style from keyword patterns in the prompt.
  String _detectStyle(String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    // Check style patterns and return highest priority match
    for (final entry in stylePatterns.entries) {
      for (final keyword in entry.value) {
        if (lowerPrompt.contains(keyword)) {
          return entry.key;
        }
      }
    }

    // Default to 'mixed' if no style matched
    return 'mixed';
  }

  /// Extracts all feature keywords mentioned in the prompt.
  List<String> _extractKeywords(String prompt) {
    final lowerPrompt = prompt.toLowerCase();
    final extracted = <String>[];

    for (final keyword in featureKeywords) {
      if (lowerPrompt.contains(keyword)) {
        extracted.add(keyword);
      }
    }

    return extracted;
  }

  /// Enriches keywords with suggestions from intelligence metadata.
  ///
  /// This is rule-based enrichment: if the video has detected beats,
  /// suggest 'beat-sync'; if it has speech, suggest 'caption', etc.
  void _enrichWithIntelligence(
    List<String> keywords,
    IntelligenceReport? report,
  ) {
    if (report == null) return;

    // If video has detected beats and not already mentioned, suggest beat-sync
    if (report.beats.isNotEmpty && !keywords.contains('beat-sync')) {
      keywords.add('beat-sync');
    }

    // If video has detected speech and not already mentioned, suggest caption
    if (report.speech.isNotEmpty && !keywords.contains('caption')) {
      keywords.add('caption');
    }

    // If video has detected scenes and not already mentioned, suggest transition
    if (report.scenes.isNotEmpty && !keywords.contains('transition')) {
      keywords.add('transition');
    }

    // If video has highlights and not already mentioned, suggest zoom
    if (report.highlights.isNotEmpty && !keywords.contains('zoom')) {
      keywords.add('zoom');
    }
  }
}
