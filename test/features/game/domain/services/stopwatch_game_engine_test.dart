import 'dart:math';

import 'package:chrono_football/features/game/domain/entities/precision_result.dart';
import 'package:chrono_football/features/game/domain/services/stopwatch_game_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StopwatchGameEngine', () {
    test('returns GOAL only on exact hit', () {
      final engine = StopwatchGameEngine();

      final result = engine.evaluateAttempt(
        elapsed: const Duration(seconds: 1),
        target: const Duration(seconds: 1),
      );

      expect(result.precision, PrecisionResult.goal);
      expect(result.points, 3);
    });

    test('classifies near miss and save windows', () {
      final engine = StopwatchGameEngine();

      expect(
        engine.classifyDelta(const Duration(milliseconds: 10)),
        PrecisionResult.goal,
      );
      expect(
        engine.classifyDelta(const Duration(milliseconds: 11)),
        PrecisionResult.nearMiss,
      );
      expect(
        engine.classifyDelta(const Duration(milliseconds: 40)),
        PrecisionResult.nearMiss,
      );
      expect(
        engine.classifyDelta(const Duration(milliseconds: 60)),
        PrecisionResult.nearMiss,
      );
      expect(
        engine.classifyDelta(const Duration(milliseconds: 120)),
        PrecisionResult.save,
      );
      expect(
        engine.classifyDelta(const Duration(milliseconds: 150)),
        PrecisionResult.save,
      );
      expect(
        engine.classifyDelta(const Duration(milliseconds: 400)),
        PrecisionResult.fail,
      );
    });

    test('returns deterministic and valid targets with injected Random', () {
      final engine = StopwatchGameEngine();
      final seededA = engine.nextTarget(random: Random(7));
      final seededB = engine.nextTarget(random: Random(7));

      const pool = <Duration>{
        Duration(milliseconds: 100),
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
        Duration(seconds: 5),
        Duration(seconds: 10),
      };

      expect(seededA.value, seededB.value);
      expect(pool.contains(seededA.value), isTrue);
    });
  });
}
