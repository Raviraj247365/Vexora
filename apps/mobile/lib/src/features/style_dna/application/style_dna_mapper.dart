import '../style_dna.dart';
import 'style_bias_matrix.dart';

/// style_dna_mapper.dart
///
/// Deterministic mapper that translates StyleDNA attributes into a StyleBiasMatrix.
/// This acts as the translation layer between abstract style preferences and
/// concrete editing threshold multipliers.
class StyleDNAMapper {
  const StyleDNAMapper();

  StyleBiasMatrix mapToBias(StyleDNA styleDNA) {
    // 1. Cut Aggressiveness (based on pace & averageCutInterval)
    double cutAggressiveness = 1.0;
    if (styleDNA.pace == 'frenetic') cutAggressiveness = 1.5;
    else if (styleDNA.pace == 'fast') cutAggressiveness = 1.25;
    else if (styleDNA.pace == 'slow') cutAggressiveness = 0.75;
    
    if (styleDNA.metrics.averageCutDuration < 1.0) {
      cutAggressiveness *= 1.2;
    } else if (styleDNA.metrics.averageCutDuration > 4.0) {
      cutAggressiveness *= 0.8;
    }

    // 2. Beat Priority
    double beatPriority = styleDNA.beatSync ? 1.5 : 0.8;
    beatPriority *= (styleDNA.metrics.beatSyncScore / 50.0).clamp(0.5, 2.0);

    // 3. Transition Frequency
    double transitionFrequency = 1.0;
    if (styleDNA.transitionStyle == 'hard_cut') transitionFrequency = 0.5;
    transitionFrequency *= (styleDNA.metrics.transitionFrequency * 2).clamp(0.5, 2.0);

    // 4. Zoom Frequency
    double zoomFrequency = 1.0;
    if (styleDNA.zoomStyle == 'none') zoomFrequency = 0.0;
    else if (styleDNA.zoomStyle == 'snap_zoom') zoomFrequency = 1.5;
    zoomFrequency *= (styleDNA.metrics.zoomFrequency * 2).clamp(0.5, 2.0);

    // 5. Caption Density
    double captionDensity = 1.0;
    if (styleDNA.captionStyle == 'none') captionDensity = 0.0;
    else if (styleDNA.captionStyle == 'kinetic') captionDensity = 1.5;
    captionDensity *= (styleDNA.metrics.captionDensity / 5.0).clamp(0.5, 2.0);

    // 6. Motion Preference
    double motionPreference = (styleDNA.motionIntensity / 50.0).clamp(0.5, 2.0);

    // 7. Energy Bias
    double energyBias = (styleDNA.energyScore / 50.0).clamp(0.5, 2.0);

    return StyleBiasMatrix(
      cutAggressiveness: cutAggressiveness,
      beatPriority: beatPriority,
      transitionFrequency: transitionFrequency,
      zoomFrequency: zoomFrequency,
      captionDensity: captionDensity,
      motionPreference: motionPreference,
      energyBias: energyBias,
    );
  }
}
