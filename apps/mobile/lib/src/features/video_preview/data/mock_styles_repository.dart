import '../../style_engine/domain/edit_style.dart';
import '../../style_engine/domain/caption_style.dart';
import '../../style_engine/domain/effect_contract.dart';
import '../../style_engine/domain/transition_contract.dart';
import '../../style_engine/domain/style_pack.dart';

class MockStylesRepository {
  static StylePack get cyberpunkStyle => StylePack(
        version: '1.0.0',
        author: 'Vexora',
        previewUrl: '',
        style: EditStyle(
          id: 'style_cyberpunk',
          name: 'Cyberpunk',
          description: 'Neon, fast, glitchy.',
          allowedEffects: [
            CustomEffect(
                id: 'fx_glow',
                name: 'Neon Glow',
                category: 'light',
                defaultParameters: {'color': '#00E5FF'}),
            CustomEffect(
                id: 'fx_shake',
                name: 'Camera Shake',
                category: 'distortion',
                defaultParameters: {}),
          ],
          allowedTransitions: [
            CustomTransition(
                id: 'tr_whip_pan',
                name: 'Whip Pan',
                defaultDurationMs: 300,
                requiresOverlap: false,
                easingCurve: 'easeIn'),
          ],
          defaultCaptionStyle: const CaptionStyle(
            id: 'cap_cyber',
            name: 'Cyber Text',
            fontFamily: 'Inter',
            fontSize: 32,
            primaryColorHex: '#FFFFFF',
            highlightColorHex: '#00E5FF',
            animationType: 'glitch',
            uppercase: true,
          ),
          pacingRules: const PacingRules(
              cutsPerMinute: 40.0, beatMatchingIntensity: 1.0),
        ),
      );

  static StylePack get gymBeastStyle => StylePack(
        version: '1.0.0',
        author: 'Vexora',
        previewUrl: '',
        style: EditStyle(
          id: 'style_gym_beast',
          name: 'Gym Beast',
          description: 'Aggressive, high contrast, impact transitions.',
          allowedEffects: [
            CustomEffect(
                id: 'fx_scale',
                name: 'Beat Scale',
                category: 'motion',
                defaultParameters: {}),
          ],
          allowedTransitions: [
            CustomTransition(
                id: 'tr_flash',
                name: 'White Flash',
                defaultDurationMs: 200,
                requiresOverlap: true,
                easingCurve: 'easeOut'),
          ],
          defaultCaptionStyle: const CaptionStyle(
            id: 'cap_impact',
            name: 'Impact Text',
            fontFamily: 'Impact',
            fontSize: 40,
            primaryColorHex: '#FFFFFF',
            highlightColorHex: '#FF0055',
            animationType: 'pop',
            uppercase: true,
          ),
          pacingRules: const PacingRules(
              cutsPerMinute: 30.0, beatMatchingIntensity: 0.9),
        ),
      );

  static StylePack get cinematicStyle => StylePack(
        version: '1.0.0',
        author: 'Vexora',
        previewUrl: '',
        style: EditStyle(
          id: 'style_cinematic',
          name: 'Cinematic',
          description: 'Slow, dramatic, smooth fades.',
          allowedEffects: [
            CustomEffect(
                id: 'fx_blur',
                name: 'Cinematic Blur',
                category: 'lens',
                defaultParameters: {}),
          ],
          allowedTransitions: [
            CustomTransition(
                id: 'tr_dissolve',
                name: 'Slow Dissolve',
                defaultDurationMs: 1000,
                requiresOverlap: true,
                easingCurve: 'easeInOut'),
          ],
          defaultCaptionStyle: const CaptionStyle(
            id: 'cap_elegant',
            name: 'Elegant Serif',
            fontFamily: 'Georgia',
            fontSize: 24,
            primaryColorHex: '#F0F0F0',
            highlightColorHex: '#FFD700',
            animationType: 'fade',
            uppercase: false,
          ),
          pacingRules: const PacingRules(
              cutsPerMinute: 10.0, beatMatchingIntensity: 0.3),
        ),
      );

  static List<StylePack> get allMocks =>
      [cyberpunkStyle, gymBeastStyle, cinematicStyle];
}
