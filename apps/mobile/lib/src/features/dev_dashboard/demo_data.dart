// demo_data.dart
//
// Static mock datasets for the Vexora Developer Dashboard.
// These datasets mirror real engine output shapes and allow
// all feature test screens to demonstrate live-looking data
// without network or AI calls.

import 'dart:convert';

class VexoraDemoData {
  VexoraDemoData._();

  // ─────────────────────────────────────────────────────────
  // VIDEO INTELLIGENCE
  // ─────────────────────────────────────────────────────────

  static final Map<String, dynamic> videoIntelligenceReport = {
    'videoId': 'vid_demo_20260611_001',
    'scenes': [
      {
        'sceneId': 'sc_001',
        'startMs': 0,
        'endMs': 4200,
        'label': 'Outdoor — golden hour',
        'confidence': 0.94
      },
      {
        'sceneId': 'sc_002',
        'startMs': 4200,
        'endMs': 8750,
        'label': 'Indoor — interview setup',
        'confidence': 0.91
      },
      {
        'sceneId': 'sc_003',
        'startMs': 8750,
        'endMs': 14100,
        'label': 'Action — crowd movement',
        'confidence': 0.88
      },
      {
        'sceneId': 'sc_004',
        'startMs': 14100,
        'endMs': 19300,
        'label': 'Close-up — product detail',
        'confidence': 0.96
      },
    ],
    'beats': [
      {'beatId': 'bt_001', 'timestampMs': 1230, 'bpm': 128.0, 'strength': 0.87},
      {'beatId': 'bt_002', 'timestampMs': 1698, 'bpm': 128.0, 'strength': 0.92},
      {'beatId': 'bt_003', 'timestampMs': 2168, 'bpm': 128.0, 'strength': 0.79},
      {'beatId': 'bt_004', 'timestampMs': 2636, 'bpm': 128.0, 'strength': 0.95},
      {'beatId': 'bt_005', 'timestampMs': 3105, 'bpm': 128.0, 'strength': 0.83},
    ],
    'faces': [
      {
        'faceId': 'fc_001',
        'timestampMs': 1500,
        'confidence': 0.97,
        'emotion': 'happy',
        'boundingBox': {'x': 0.22, 'y': 0.18, 'w': 0.14, 'h': 0.21}
      },
      {
        'faceId': 'fc_002',
        'timestampMs': 6200,
        'confidence': 0.93,
        'emotion': 'neutral',
        'boundingBox': {'x': 0.40, 'y': 0.15, 'w': 0.12, 'h': 0.19}
      },
    ],
    'speech': [
      {
        'segmentId': 'sp_001',
        'startMs': 2100,
        'endMs': 5400,
        'transcript': 'Welcome to the future of video editing.',
        'confidence': 0.96
      },
      {
        'segmentId': 'sp_002',
        'startMs': 6800,
        'endMs': 9200,
        'transcript': 'Vexora understands every frame.',
        'confidence': 0.94
      },
    ],
    'highlights': [
      {
        'highlightId': 'hl_001',
        'startMs': 1200,
        'endMs': 2800,
        'score': 0.91,
        'reason': 'Beat-synced action peak'
      },
      {
        'highlightId': 'hl_002',
        'startMs': 12400,
        'endMs': 14100,
        'score': 0.88,
        'reason': 'Face emotion spike'
      },
    ],
  };

  // ─────────────────────────────────────────────────────────
  // CREATOR INTENT
  // ─────────────────────────────────────────────────────────

  static final Map<String, dynamic> creatorIntentResult = {
    'prompt':
        'Make this feel like a cinematic travel vlog — fast-paced, energetic, with emotional peaks during the sunset shots.',
    'category': 'travel_vlog',
    'style': 'cinematic_energetic',
    'keywords': [
      'cinematic',
      'travel',
      'vlog',
      'fast-paced',
      'energetic',
      'sunset',
      'emotional'
    ],
    'parsedSignals': {
      'paceTarget': 'fast',
      'energyLevel': 0.85,
      'emotionalArc': 'build_to_peak',
      'preferredTransitions': ['whip_pan', 'zoom_cut', 'cross_dissolve'],
      'colorGrade': 'warm_golden',
      'beatSyncStrength': 0.9,
    },
    'confidence': 0.92,
    'generatedAt': '2026-06-11T14:09:00Z',
  };

  // ─────────────────────────────────────────────────────────
  // AI DIRECTOR
  // ─────────────────────────────────────────────────────────

  static final Map<String, dynamic> editBlueprintResult = {
    'blueprintVersion': '1.4.0',
    'blueprintId': 'bp_demo_20260611_7a2c',
    'overallConfidenceScore': 0.89,
    'operations': [
      {
        'type': 'cut',
        'operationId': 'op_001',
        'timestamp': 1718099340000,
        'confidence': 0.94,
        'source': 'aiDirector',
        'targetTrackId': 'track_video_main',
        'startMs': 0,
        'endMs': 800,
      },
      {
        'type': 'trim',
        'operationId': 'op_002',
        'timestamp': 1718099340001,
        'confidence': 0.91,
        'source': 'aiDirector',
        'targetTrackId': 'track_video_main',
        'clipId': 'clip_sc_001',
        'newTrimStartMs': 800,
        'newTrimEndMs': 4100,
      },
      {
        'type': 'transition',
        'operationId': 'op_003',
        'timestamp': 1718099340002,
        'confidence': 0.87,
        'source': 'aiDirector',
        'targetTrackId': null,
        'beforeClipId': 'clip_sc_001',
        'afterClipId': 'clip_sc_002',
        'transitionType': 'whip_pan',
        'durationMs': 280,
      },
      {
        'type': 'zoom',
        'operationId': 'op_004',
        'timestamp': 1718099340003,
        'confidence': 0.85,
        'source': 'aiDirector',
        'targetTrackId': 'track_video_main',
        'clipId': 'clip_sc_003',
        'zoomFactor': 1.35,
        'zoomStartMs': 8750,
        'zoomEndMs': 9200,
      },
      {
        'type': 'caption',
        'operationId': 'op_005',
        'timestamp': 1718099340004,
        'confidence': 0.96,
        'source': 'aiDirector',
        'targetTrackId': 'track_caption',
        'captionId': 'cap_001',
        'text': 'Welcome to the future of video editing.',
        'captionStartMs': 2100,
        'captionEndMs': 5400,
        'stylePreset': 'bold_white_drop_shadow',
      },
      {
        'type': 'filter',
        'operationId': 'op_006',
        'timestamp': 1718099340005,
        'confidence': 0.88,
        'source': 'aiDirector',
        'targetTrackId': 'track_video_main',
        'clipId': 'clip_sc_001',
        'filterType': 'warm_golden_grade',
        'params': {
          'temperature': 0.22,
          'tint': 0.05,
          'saturation': 1.15,
          'contrast': 1.08
        },
      },
      {
        'type': 'audioGain',
        'operationId': 'op_007',
        'timestamp': 1718099340006,
        'confidence': 0.90,
        'source': 'aiDirector',
        'targetTrackId': 'track_audio_music',
        'targetId': 'audio_bg_music',
        'gainDb': -3.5,
      },
    ],
  };

  // ─────────────────────────────────────────────────────────
  // TIMELINE ENGINE
  // ─────────────────────────────────────────────────────────

  static final Map<String, dynamic> timelineEngineResult = {
    'executionId': 'exec_demo_20260611_9f1a',
    'blueprintId': 'bp_demo_20260611_7a2c',
    'status': 'success',
    'totalOperations': 7,
    'appliedOperations': 7,
    'failedOperations': 0,
    'skippedOperations': 0,
    'executionTimeMs': 142,
    'timeline': {
      'tracks': [
        {
          'trackId': 'track_video_main',
          'type': 'video',
          'clips': [
            {
              'clipId': 'clip_sc_001',
              'startMs': 800,
              'endMs': 4100,
              'source': 'sc_001',
              'hasFilter': true
            },
            {
              'clipId': 'clip_sc_002',
              'startMs': 4380,
              'endMs': 8750,
              'source': 'sc_002',
              'hasFilter': false
            },
            {
              'clipId': 'clip_sc_003',
              'startMs': 8750,
              'endMs': 14100,
              'source': 'sc_003',
              'hasFilter': false
            },
            {
              'clipId': 'clip_sc_004',
              'startMs': 14100,
              'endMs': 19300,
              'source': 'sc_004',
              'hasFilter': false
            },
          ],
        },
        {
          'trackId': 'track_caption',
          'type': 'caption',
          'clips': [
            {
              'clipId': 'cap_001',
              'startMs': 2100,
              'endMs': 5400,
              'text': 'Welcome to the future of video editing.'
            },
          ],
        },
        {
          'trackId': 'track_audio_music',
          'type': 'audio',
          'clips': [
            {
              'clipId': 'audio_bg_music',
              'startMs': 0,
              'endMs': 19300,
              'gainDb': -3.5
            },
          ],
        },
      ],
      'totalDurationMs': 19300,
      'transitionCount': 1,
    },
    'validationResult': {
      'isValid': true,
      'warnings': [],
      'errors': [],
    },
  };

  // ─────────────────────────────────────────────────────────
  // STYLE DNA
  // ─────────────────────────────────────────────────────────

  static final Map<String, dynamic> styleDnaResult = {
    'styleId': 'dna_demo_20260611_3e8b',
    'name': 'Golden Hour Cinematic',
    'energyScore': 85,
    'pace': 'fast',
    'averageCutInterval': 2.8,
    'transitionStyle': 'whip_pan',
    'zoomStyle': 'push_in',
    'captionStyle': 'bold_white_drop_shadow',
    'beatSync': true,
    'motionIntensity': 78,
    'creatorId': 'creator_vexora_demo',
    'metrics': {
      'averageCutDuration': 2.8,
      'transitionFrequency': 0.21,
      'zoomFrequency': 0.14,
      'captionDensity': 4.2,
      'beatSyncScore': 91.0,
      'motionIntensity': 78.0,
      'sceneChangeFrequency': 0.22,
      'energyScore': 85.0,
    },
    'extractedFrom': 'timeline_exec_demo_20260611_9f1a',
    'generatedAt': '2026-06-11T14:14:00Z',
    'tags': ['cinematic', 'travel', 'energetic', 'beat-sync', 'warm-grade'],
  };

  // ─────────────────────────────────────────────────────────
  // PROJECT SCHEMA
  // ─────────────────────────────────────────────────────────

  static final Map<String, dynamic> projectSchemaResult = {
    'projectId': 'proj_demo_20260611_vexora',
    'name': 'Golden Hour Travel Vlog',
    'version': '1.0.0',
    'createdAt': '2026-06-11T13:00:00Z',
    'updatedAt': '2026-06-11T14:14:00Z',
    'assets': [
      {
        'assetId': 'asset_001',
        'type': 'video',
        'uri': 'assets/raw/clip_outdoor.mp4',
        'durationMs': 19300
      },
      {
        'assetId': 'asset_002',
        'type': 'audio',
        'uri': 'assets/raw/bg_music.mp3',
        'durationMs': 180000
      },
    ],
    'renderSettings': {
      'resolution': '1920x1080',
      'frameRate': 30.0,
      'codec': 'h264',
      'bitrate': '8000kbps',
    },
    'aiInstructions': {
      'blueprintId': 'bp_demo_20260611_7a2c',
      'styleDnaId': 'dna_demo_20260611_3e8b',
      'intentCategory': 'travel_vlog',
    },
    'history': [
      {
        'entryId': 'hist_001',
        'action': 'project_created',
        'timestamp': '2026-06-11T13:00:00Z'
      },
      {
        'entryId': 'hist_002',
        'action': 'intelligence_analyzed',
        'timestamp': '2026-06-11T13:45:00Z'
      },
      {
        'entryId': 'hist_003',
        'action': 'blueprint_generated',
        'timestamp': '2026-06-11T14:09:00Z'
      },
      {
        'entryId': 'hist_004',
        'action': 'timeline_executed',
        'timestamp': '2026-06-11T14:10:00Z'
      },
      {
        'entryId': 'hist_005',
        'action': 'style_dna_extracted',
        'timestamp': '2026-06-11T14:14:00Z'
      },
    ],
  };

  // ─────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────

  static String prettyJson(Map<String, dynamic> data) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }
}
