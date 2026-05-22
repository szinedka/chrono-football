import 'package:chrono_football/core/di/providers.dart';
import 'package:chrono_football/core/utils/duration_format.dart';
import 'package:chrono_football/features/game/presentation/widgets/precision_feedback_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minSize = constraints.biggest.shortestSide;
            final actionSize = minSize * 0.48;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('TARGET ${state.target.label}'),
                  Text(
                    DurationFormat.stopwatch(state.elapsed),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: minSize * 0.16,
                          letterSpacing: 1,
                        ),
                  ),
                  PrecisionFeedbackBanner(precision: state.lastResult?.precision),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatChip(label: 'Score', value: state.score.toString()),
                      _StatChip(label: 'Streak', value: state.streak.toString()),
                      _StatChip(
                        label: 'Avg Δ',
                        value: '${state.averageDeltaMs.toStringAsFixed(0)}ms',
                      ),
                    ],
                  ),
                  SizedBox(
                    width: actionSize,
                    height: actionSize,
                    child: FilledButton(
                      style: FilledButton.styleFrom(shape: const CircleBorder()),
                      onPressed: state.isRunning
                          ? controller.stopRound
                          : controller.startRound,
                      child: Text(
                        state.isRunning ? 'STOP' : 'START',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: controller.resetMatch,
                        child: const Text('Reset'),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Menu'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Text('$label: $value'),
    );
  }
}
