import 'dart:async';
import 'dart:math';

import 'package:chrono_football/features/game/domain/entities/game_target.dart';
import 'package:chrono_football/features/game/domain/entities/precision_result.dart';
import 'package:chrono_football/features/game/domain/entities/round_result.dart';

class StopwatchGameEngine {
  StopwatchGameEngine({
    this.tickInterval = const Duration(milliseconds: 10),
    this.exactWindow = const Duration(milliseconds: 10),
    this.nearWindow = const Duration(milliseconds: 60),
    this.saveWindow = const Duration(milliseconds: 150),
  });

  final Duration tickInterval;
  final Duration exactWindow;
  final Duration nearWindow;
  final Duration saveWindow;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  final StreamController<Duration> _elapsedController =
      StreamController<Duration>.broadcast();

  Stream<Duration> get elapsedStream => _elapsedController.stream;

  bool get isRunning => _stopwatch.isRunning;

  Duration get elapsed => _stopwatch.elapsed;

  void start() {
    if (_stopwatch.isRunning) return;

    _stopwatch.start();
    _ticker?.cancel();
    _ticker = Timer.periodic(tickInterval, (_) {
      _elapsedController.add(_stopwatch.elapsed);
    });
  }

  void reset() {
    _ticker?.cancel();
    _stopwatch
      ..stop()
      ..reset();
    _elapsedController.add(Duration.zero);
  }

  RoundResult stopAndScore(Duration target) {
    _ticker?.cancel();
    _stopwatch.stop();

    final result = evaluateAttempt(
      elapsed: _stopwatch.elapsed,
      target: target,
    );

    return result;
  }

  RoundResult evaluateAttempt({
    required Duration elapsed,
    required Duration target,
  }) {
    final deltaMs = (elapsed.inMilliseconds - target.inMilliseconds).abs();
    final delta = Duration(milliseconds: deltaMs);
    final precision = classifyDelta(delta);

    return RoundResult(
      elapsed: elapsed,
      target: target,
      delta: delta,
      precision: precision,
      points: pointsFor(precision),
    );
  }

  PrecisionResult classifyDelta(Duration delta) {
    if (delta <= exactWindow) return PrecisionResult.goal;
    if (delta <= nearWindow) return PrecisionResult.nearMiss;
    if (delta <= saveWindow) return PrecisionResult.save;
    return PrecisionResult.fail;
  }

  int pointsFor(PrecisionResult precision) {
    switch (precision) {
      case PrecisionResult.goal:
        return 3;
      case PrecisionResult.nearMiss:
        return 2;
      case PrecisionResult.save:
        return 1;
      case PrecisionResult.fail:
        return 0;
    }
  }

  GameTarget nextTarget({Random? random}) {
    final rng = random ?? Random();
    const pool = <Duration>[
      Duration.zero,
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
      Duration(seconds: 5),
      Duration(seconds: 10),
    ];
    return GameTarget(pool[rng.nextInt(pool.length)]);
  }

  void dispose() {
    _ticker?.cancel();
    _elapsedController.close();
  }
}
