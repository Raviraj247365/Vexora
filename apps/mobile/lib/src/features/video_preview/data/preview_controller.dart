import 'package:flutter/material.dart';
import '../../style_engine/domain/style_pack.dart';
import 'mock_styles_repository.dart';

class PreviewController extends ChangeNotifier {
  bool _isPlaying = false;
  double _currentTimeMs = 0.0;
  final double _totalDurationMs = 10000.0; // 10 seconds total mock timeline
  StylePack? _activeStylePack;

  bool get isPlaying => _isPlaying;
  double get currentTimeMs => _currentTimeMs;
  double get totalDurationMs => _totalDurationMs;
  StylePack? get activeStylePack => _activeStylePack;

  // Mock clip boundaries
  final List<int> clipStartTimesMs = [0, 3000, 7000];

  void play() {
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void seek(double timeMs) {
    _currentTimeMs = timeMs.clamp(0.0, _totalDurationMs);
    notifyListeners();
  }

  void updateTime(double deltaMs) {
    if (!_isPlaying) return;
    _currentTimeMs += deltaMs;
    if (_currentTimeMs >= _totalDurationMs) {
      _currentTimeMs = 0;
      _isPlaying = false;
    }
    notifyListeners();
  }

  void applyStylePack(StylePack pack) {
    _activeStylePack = pack;
    notifyListeners();
  }

  void applyBlueprint() {
    // In a real app, this would apply AI generated JSON.
    // For this prototype, applying a random style pack simulates the result.
    applyStylePack(MockStylesRepository.cyberpunkStyle);
  }
}
