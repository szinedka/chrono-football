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
        engine.classifyDelta(const Duration(milliseconds: 40)),
        PrecisionResult.nearMiss,
      );
      expect(
        engine.classifyDelta(const Duration(milliseconds: 120)),
        PrecisionResult.save,
      );
      expect(
        engine.classifyDelta(const Duration(milliseconds: 400)),
        PrecisionResult.fail,
      );
    });
  });
}
