import os
import re

base_path = r"c:/Users/GAJADHAR/OneDrive/Desktop/Vexora/apps/mobile/lib/src/features/project_schema/"

files = {
    "asset.dart": """
  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: json['id'] as String,
        type: json['type'] as String,
        sourceUrl: json['sourceUrl'] as String,
        proxyUrl: json['proxyUrl'] as String?,
        duration: json['duration'] as int,
      );
""",
    "render_settings.dart": """
  factory RenderSettings.fromJson(Map<String, dynamic> json) => RenderSettings(
        aspectRatio: json['aspectRatio'] as String,
        fps: json['fps'] as int,
        width: json['resolution']['width'] as int,
        height: json['resolution']['height'] as int,
        exportFormat: json['exportFormat'] as String,
      );
""",
    "ai_instructions.dart": """
  factory AIInstructions.fromJson(Map<String, dynamic> json) => AIInstructions(
        originalPrompt: json['originalPrompt'] as String,
        styleReferenceId: json['styleReferenceId'] as String?,
        engineVersion: json['engineVersion'] as String,
        aiAppliedFilters: (json['aiAppliedFilters'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      );
""",
    "history_entry.dart": """
  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        checkpointId: json['checkpointId'] as String,
        timestamp: json['timestamp'] as String,
        description: json['description'] as String,
        timelineSnapshot: Timeline.fromJson(json['timelineSnapshot'] as Map<String, dynamic>),
      );
"""
}

for fname, snippet in files.items():
    with open(base_path + fname, "r") as f:
        content = f.read()
    content = content.rstrip()
    if content.endswith("}"):
        content = content[:-1] + snippet + "}\n"
        with open(base_path + fname, "w") as f:
            f.write(content)

# Complex ones with multiple classes:
def add_to_class(content, class_name, snippet):
    # Find the class closing brace.
    match = re.search(r'class\s+'+class_name+r'\s*(?:implements [^{]+)?\{(?:.*?)^}', content, re.MULTILINE | re.DOTALL)
    if match:
        end_idx = match.end() - 1
        return content[:end_idx] + snippet + content[end_idx:]
    return content

with open(base_path + "transition.dart", "r") as f:
    tc = f.read()
tc = add_to_class(tc, "TransitionItem", """
  factory TransitionItem.fromJson(Map<String, dynamic> json) => TransitionItem(
        id: json['id'] as String,
        transitionType: json['transitionType'] as String,
        duration: json['duration'] as int,
      );
""")
with open(base_path + "transition.dart", "w") as f:
    f.write(tc)

with open(base_path + "timeline_clip.dart", "r") as f:
    tc = f.read()
tc = add_to_class(tc, "TrimRange", """
  factory TrimRange.fromJson(Map<String, dynamic> json) => TrimRange(
        start: json['start'] as int,
        end: json['end'] as int,
      );
""")
tc = add_to_class(tc, "Filter", """
  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        type: json['type'] as String,
        params: json['params'] as Map<String, dynamic>? ?? const {},
      );
""")
tc = add_to_class(tc, "ClipItem", """
  factory ClipItem.fromJson(Map<String, dynamic> json) => ClipItem(
        id: json['id'] as String,
        assetId: json['assetId'] as String,
        timelineStartTime: json['timelineStartTime'] as int,
        trim: TrimRange.fromJson(json['trim'] as Map<String, dynamic>),
        speed: (json['speed'] as num).toDouble(),
        volume: (json['volume'] as num).toDouble(),
        filters: (json['filters'] as List<dynamic>?)?.map((e) => Filter.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      );
""")
tc = add_to_class(tc, "Caption", """
  factory Caption.fromJson(Map<String, dynamic> json) => Caption(
        id: json['id'] as String,
        text: json['text'] as String,
        startTime: json['startTime'] as int,
        endTime: json['endTime'] as int,
        preset: json['style']['preset'] as String,
        x: (json['style']['position']['x'] as num).toDouble(),
        y: (json['style']['position']['y'] as num).toDouble(),
      );
""")
with open(base_path + "timeline_clip.dart", "w") as f:
    f.write(tc)

with open(base_path + "timeline_track.dart", "r") as f:
    tc = f.read()

# Add transition import to timeline_track
if "import 'transition.dart';" not in tc:
    tc = tc.replace("import 'timeline_clip.dart';", "import 'timeline_clip.dart';\nimport 'transition.dart';")

tc = add_to_class(tc, "Track", """
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>?)?.map((e) {
        final itemJson = e as Map<String, dynamic>;
        if (itemJson['type'] == 'transition') {
          return TransitionItem.fromJson(itemJson);
        }
        return ClipItem.fromJson(itemJson);
      }).toList() ?? const [],
    );
  }
""")
tc = add_to_class(tc, "Timeline", """
  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        videoTracks: (json['videoTracks'] as List<dynamic>?)?.map((e) => Track.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
        audioTracks: (json['audioTracks'] as List<dynamic>?)?.map((e) => Track.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
        captions: (json['captions'] as List<dynamic>?)?.map((e) => Caption.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      );
""")
with open(base_path + "timeline_track.dart", "w") as f:
    f.write(tc)

with open(base_path + "project_schema.dart", "r") as f:
    tc = f.read()
tc = add_to_class(tc, "Metadata", """
  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        title: json['title'] as String,
        authorId: json['authorId'] as String?,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );
""")
tc = add_to_class(tc, "ProjectSchema", """
  factory ProjectSchema.fromJson(Map<String, dynamic> json) => ProjectSchema(
        schemaVersion: json['schemaVersion'] as String,
        projectId: json['projectId'] as String,
        metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
        renderSettings: RenderSettings.fromJson(json['renderSettings'] as Map<String, dynamic>),
        assets: (json['assets'] as List<dynamic>?)?.map((e) => Asset.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
        timeline: Timeline.fromJson(json['timeline'] as Map<String, dynamic>),
        aiInstructions: AIInstructions.fromJson(json['aiInstructions'] as Map<String, dynamic>),
        history: (json['history'] as List<dynamic>?)?.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      );
""")
with open(base_path + "project_schema.dart", "w") as f:
    f.write(tc)
