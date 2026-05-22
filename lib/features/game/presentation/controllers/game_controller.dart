import 'dart:async';

import 'package:chrono_football/features/game/domain/entities/game_state.dart';
import 'package:chrono_football/features/game/domain/entities/precision_result.dart';
import 'package:chrono_football/features/game/domain/repositories/game_repository.dart';
import 'package:chrono_football/features/game/domain/services/stopwatch_game_engine.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameController extends StateNotifier<GameState> {
  GameController(this._engine, this._repository) : super(GameState.initial()) {
    _elapsedSubscription = _engine.elapsedStream.listen((elapsed) {
      state = state.copyWith(elapsed: elapsed);
    });
    _bootstrap();
  }

  final StopwatchGameEngine _engine;
  final GameRepository _repository;
  StreamSubscription<Duration>? _elapsedSubscription;
  int _highScore = 0;

  int get highScore => _highScore;

  Future<void> _bootstrap() async {
    _highScore = await _repository.loadHighScore();
  }

  void startRound() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true, clearResult: true, elapsed: Duration.zero);
    _engine.reset();
    _engine.start();
  }

  Future<void> stopRound() async {
    if (!state.isRunning) return;

    final result = _engine.stopAndScore(state.target.value);
    final isSuccess = result.precision != PrecisionResult.fail;

    final updatedStreak = isSuccess ? state.streak + 1 : 0;
    final updatedRounds = state.roundsPlayed + 1;
    final updatedAvg = ((state.averageDeltaMs * state.roundsPlayed) +
            result.delta.inMilliseconds.toDouble()) /
        updatedRounds;
    final updatedScore = state.score + result.points + (updatedStreak >= 3 ? 1 : 0);

    state = state.copyWith(
      isRunning: false,
      elapsed: result.elapsed,
      lastResult: result,
      score: updatedScore,
      streak: updatedStreak,
      bestStreak:
          updatedStreak > state.bestStreak ? updatedStreak : state.bestStreak,
      roundsPlayed: updatedRounds,
      averageDeltaMs: updatedAvg,
      target: _engine.nextTarget(),
    );

    if (updatedScore > _highScore) {
      _highScore = updatedScore;
      await _repository.saveHighScore(_highScore);
    }

    if (isSuccess) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void resetMatch() {
    _engine.reset();
    state = GameState.initial();
  }

  @override
  void dispose() {
    _elapsedSubscription?.cancel();
    _engine.dispose();
    super.dispose();
  }
}
