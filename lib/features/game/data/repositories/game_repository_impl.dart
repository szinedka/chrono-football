import 'package:chrono_football/features/game/data/datasources/local_game_storage.dart';
import 'package:chrono_football/features/game/domain/entities/game_settings.dart';
import 'package:chrono_football/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  const GameRepositoryImpl(this._storage);

  final LocalGameStorage _storage;

  @override
  Future<GameSettings> loadSettings() => _storage.loadSettings();

  @override
  Future<void> saveSettings(GameSettings settings) =>
      _storage.saveSettings(settings);

  @override
  Future<int> loadHighScore() => _storage.loadHighScore();

  @override
  Future<void> saveHighScore(int score) => _storage.saveHighScore(score);
}
