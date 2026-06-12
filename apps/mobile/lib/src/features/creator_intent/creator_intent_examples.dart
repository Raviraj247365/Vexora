import 'creator_intent.dart';

/// creator_intent_examples.dart
///
/// Example CreatorIntent objects for common reel styles.
class CreatorIntentExamples {
  static const gymReel = CreatorIntent(
    prompt:
        'Create a fast-paced gym reel with weightlifting highlights and energetic text.',
    category: 'Gym Reel',
    style: 'energetic',
    keywords: ['fitness', 'strength', 'reps', 'motivation'],
  );

  static const travelReel = CreatorIntent(
    prompt:
        'Create a travel reel with scenic transitions and upbeat adventure energy.',
    category: 'Travel Reel',
    style: 'adventurous',
    keywords: ['landscape', 'journey', 'exploration', 'sunrise'],
  );

  static const podcastReel = CreatorIntent(
    prompt:
        'Create a polished podcast highlight reel with warm captions and clear pacing.',
    category: 'Podcast Reel',
    style: 'polished',
    keywords: ['conversation', 'insight', 'host', 'storytelling'],
  );

  static const gamingReel = CreatorIntent(
    prompt:
        'Create a high-energy gaming reel with action highlights and dramatic sound cues.',
    category: 'Gaming Reel',
    style: 'intense',
    keywords: ['gameplay', 'victory', 'skill', 'highlight'],
  );

  static const luxuryReel = CreatorIntent(
    prompt:
        'Create a luxury lifestyle reel with elegant pacing and premium visual style.',
    category: 'Luxury Reel',
    style: 'luxury',
    keywords: ['premium', 'glamour', 'sleek', 'refined'],
  );

  static const examples = [
    gymReel,
    travelReel,
    podcastReel,
    gamingReel,
    luxuryReel,
  ];
}
