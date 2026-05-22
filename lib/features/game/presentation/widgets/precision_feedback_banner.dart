import 'package:chrono_football/features/game/domain/entities/precision_result.dart';
import 'package:flutter/material.dart';

class PrecisionFeedbackBanner extends StatelessWidget {
  const PrecisionFeedbackBanner({
    super.key,
    required this.precision,
  });

  final PrecisionResult? precision;

  @override
  Widget build(BuildContext context) {
    if (precision == null) {
      return const SizedBox.shrink();
    }

    late final String text;
    late final Color color;

    switch (precision!) {
      case PrecisionResult.goal:
        text = 'GOAL!';
        color = Colors.greenAccent;
      case PrecisionResult.nearMiss:
        text = 'NEAR MISS';
        color = Colors.lightGreenAccent;
      case PrecisionResult.save:
        text = 'SAVE';
        color = Colors.amberAccent;
      case PrecisionResult.fail:
        text = 'FAIL';
        color = Colors.redAccent;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
