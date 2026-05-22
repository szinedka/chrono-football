import 'package:chrono_football/core/navigation/app_router.dart';
import 'package:chrono_football/features/game/data/datasources/local_game_storage.dart';
import 'package:chrono_football/features/game/data/repositories/game_repository_impl.dart';
import 'package:chrono_football/features/game/domain/entities/game_state.dart';
import 'package:chrono_football/features/game/domain/repositories/game_repository.dart';
import 'package:chrono_football/features/game/domain/services/stopwatch_game_engine.dart';
import 'package:chrono_football/features/game/presentation/controllers/game_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localGameStorageProvider = Provider<LocalGameStorage>((ref) {
  return LocalGameStorage();
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final storage = ref.watch(localGameStorageProvider);
  return GameRepositoryImpl(storage);
});

final stopwatchGameEngineProvider = Provider<StopwatchGameEngine>((ref) {
  return StopwatchGameEngine();
});

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
      final engine = ref.watch(stopwatchGameEngineProvider);
      final repository = ref.watch(gameRepositoryProvider);
      return GameController(engine, repository);
    });

final appRouterProvider = Provider((ref) => AppRouter.router);
