import 'package:chrono_football/core/utils/duration_format.dart';

class GameTarget {
  const GameTarget(this.value);

  final Duration value;

  String get label => DurationFormat.stopwatch(value);
}
