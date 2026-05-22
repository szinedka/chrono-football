import 'package:chrono_football/features/game/domain/entities/game_settings.dart';

abstract class GameRepository {
  Future<GameSettings> loadSettings();
  Future<void> saveSettings(GameSettings settings);
  Future<int> loadHighScore();
  Future<void> saveHighScore(int score);
}
