import 'package:chrono_football/features/game/domain/entities/game_mode.dart';
import 'package:chrono_football/features/game/domain/entities/game_target.dart';
import 'package:chrono_football/features/game/domain/entities/round_result.dart';

class GameState {
  const GameState({
    required this.mode,
    required this.isRunning,
    required this.elapsed,
    required this.target,
    required this.score,
    required this.streak,
    required this.bestStreak,
    required this.roundsPlayed,
    required this.averageDeltaMs,
    this.lastResult,
  });

  final GameMode mode;
  final bool isRunning;
  final Duration elapsed;
  final GameTarget target;
  final int score;
  final int streak;
  final int bestStreak;
  final int roundsPlayed;
  final double averageDeltaMs;
  final RoundResult? lastResult;

  factory GameState.initial() {
    return const GameState(
      mode: GameMode.penaltyShootout,
      isRunning: false,
      elapsed: Duration.zero,
      target: GameTarget(Duration(seconds: 1)),
      score: 0,
      streak: 0,
      bestStreak: 0,
      roundsPlayed: 0,
      averageDeltaMs: 0,
    );
  }

  GameState copyWith({
    GameMode? mode,
    bool? isRunning,
    Duration? elapsed,
    GameTarget? target,
    int? score,
    int? streak,
    int? bestStreak,
    int? roundsPlayed,
    double? averageDeltaMs,
    RoundResult? lastResult,
    bool clearResult = false,
  }) {
    return GameState(
      mode: mode ?? this.mode,
      isRunning: isRunning ?? this.isRunning,
      elapsed: elapsed ?? this.elapsed,
      target: target ?? this.target,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
      averageDeltaMs: averageDeltaMs ?? this.averageDeltaMs,
      lastResult: clearResult ? null : (lastResult ?? this.lastResult),
    );
  }
}
