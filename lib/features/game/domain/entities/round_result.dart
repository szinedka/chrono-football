import 'package:chrono_football/features/game/domain/entities/precision_result.dart';

class RoundResult {
  const RoundResult({
    required this.elapsed,
    required this.target,
    required this.delta,
    required this.precision,
    required this.points,
  });

  final Duration elapsed;
  final Duration target;
  final Duration delta;
  final PrecisionResult precision;
  final int points;
}
