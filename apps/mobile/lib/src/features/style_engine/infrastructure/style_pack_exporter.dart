import 'dart:io';
import '../domain/style_pack.dart';

/// Handles exporting a StylePack to a shareable .vexstyle format (JSON).
class StylePackExporter {
  /// Exports a given [StylePack] to a specified file path.
  /// Returns the path to the exported file.
  static Future<String> exportToFile(
      StylePack pack, String outputDirectory) async {
    final sanitizedName = pack.style.name.toLowerCase().replaceAll(' ', '_');
    final filename = '${sanitizedName}_v${pack.version}.vexstyle';
    final path = '$outputDirectory/$filename';

    final file = File(path);
    final jsonContent = pack.toJson();

    // In a real app, this might be compressed/zipped. For now, it's raw JSON.
    await file.writeAsString(jsonContent, mode: FileMode.writeOnly);

    return path;
  }
}
