import 'dart:io';
import '../domain/style_pack.dart';

/// Handles importing a .vexstyle file into the application.
class StylePackImporter {
  /// Reads a .vexstyle file from the given [filePath] and parses it into a [StylePack].
  static Future<StylePack> importFromFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('Style pack file not found at $filePath');
    }

    final jsonContent = await file.readAsString();

    try {
      final pack = StylePack.fromJson(jsonContent);
      return pack;
    } catch (e) {
      throw Exception('Failed to parse style pack: $e');
    }
  }
}
