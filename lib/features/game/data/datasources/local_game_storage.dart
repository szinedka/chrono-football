import 'dart:convert';

import 'package:chrono_football/features/game/domain/entities/game_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalGameStorage {
  static const _settingsKey = 'game_settings';
  static const _highScoreKey = 'high_score';

  Future<GameSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) return const GameSettings();

    final json = jsonDecode(raw) as Map<String, dynamic>;
    return GameSettings.fromJson(json);
  }

  Future<void> saveSettings(GameSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<int> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, score);
  }
}
