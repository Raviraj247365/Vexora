// json_viewer.dart
//
// Scrollable, syntax-highlighted JSON viewer for the Vexora Developer Dashboard.
// Renders keys in cyan, strings in green, numbers in orange, booleans in violet.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/typography.dart';

class VexoraJsonViewer extends StatelessWidget {
  final String json;
  final double maxHeight;

  const VexoraJsonViewer({
    Key? key,
    required this.json,
    this.maxHeight = 320,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VexoraColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: _buildColorisedJson(json),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: VexoraColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(bottom: BorderSide(color: VexoraColors.border)),
      ),
      child: Row(
        children: [
          const Icon(Icons.data_object_rounded,
              color: Color(0xFF00E5FF), size: 15),
          const SizedBox(width: 6),
          Text('JSON Output',
              style: VexoraTypography.label(const Color(0xFF00E5FF))),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: json));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color(0xFF1C1C26),
                ),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.copy_rounded,
                    color: VexoraColors.textSecondary, size: 13),
                const SizedBox(width: 4),
                Text('Copy',
                    style:
                        VexoraTypography.caption(VexoraColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorisedJson(String raw) {
    final spans = <TextSpan>[];
    final lines = raw.split('\n');

    for (final line in lines) {
      spans.addAll(_parseLine(line));
      spans.add(const TextSpan(text: '\n'));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 11.5,
          height: 1.7,
        ),
        children: spans,
      ),
    );
  }

  List<TextSpan> _parseLine(String line) {
    // Key: "someKey":
    final keyValueRegex = RegExp(r'^(\s*)("[\w\d_]+")(\s*:\s*)(.*)$');
    final keyOnlyRegex = RegExp(r'^(\s*)("[\w\d_]+")(\s*)$');

    final kvMatch = keyValueRegex.firstMatch(line);
    if (kvMatch != null) {
      final indent = kvMatch.group(1)!;
      final key = kvMatch.group(2)!;
      final colon = kvMatch.group(3)!;
      final value = kvMatch.group(4)!;
      return [
        TextSpan(text: indent, style: const TextStyle(color: Colors.white)),
        TextSpan(
            text: key,
            style: const TextStyle(color: Color(0xFF00E5FF))), // cyan key
        TextSpan(
            text: colon,
            style: const TextStyle(color: VexoraColors.textSecondary)),
        ..._coloriseValue(value),
      ];
    }

    final koMatch = keyOnlyRegex.firstMatch(line);
    if (koMatch != null) {
      return [
        TextSpan(
            text: koMatch.group(1)!,
            style: const TextStyle(color: Colors.white)),
        TextSpan(
            text: koMatch.group(2)!,
            style: const TextStyle(color: Color(0xFF00E5FF))),
      ];
    }

    // Brackets, punctuation
    return [
      TextSpan(
          text: line, style: const TextStyle(color: VexoraColors.textSecondary))
    ];
  }

  List<TextSpan> _coloriseValue(String value) {
    final trimmed = value.trim();

    // String value
    if (trimmed.startsWith('"')) {
      return [
        TextSpan(text: value, style: const TextStyle(color: Color(0xFF69FF82)))
      ];
    }

    // Boolean
    if (trimmed == 'true' ||
        trimmed == 'true,' ||
        trimmed == 'false' ||
        trimmed == 'false,') {
      return [
        TextSpan(text: value, style: const TextStyle(color: Color(0xFFBF7FFF)))
      ];
    }

    // Null
    if (trimmed == 'null' || trimmed == 'null,') {
      return [
        TextSpan(
            text: value,
            style: const TextStyle(color: VexoraColors.textSecondary))
      ];
    }

    // Number
    if (RegExp(r'^-?[\d.]+,?$').hasMatch(trimmed)) {
      return [
        TextSpan(text: value, style: const TextStyle(color: Color(0xFFFFB547)))
      ];
    }

    return [TextSpan(text: value, style: const TextStyle(color: Colors.white))];
  }
}
