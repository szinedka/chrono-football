import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 300;
            final buttonHeight = isCompact ? 46.0 : 56.0;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.92,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'CHRONO\nFOOTBALL',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      _MenuButton(
                        label: 'Quick Play',
                        onTap: () => context.push('/play'),
                        height: buttonHeight,
                      ),
                      const SizedBox(height: 8),
                      _MenuButton(
                        label: 'Multiplayer',
                        onTap: () {},
                        height: buttonHeight,
                      ),
                      const SizedBox(height: 8),
                      _MenuButton(
                        label: 'High Scores',
                        onTap: () {},
                        height: buttonHeight,
                      ),
                      const SizedBox(height: 8),
                      _MenuButton(
                        label: 'Settings',
                        onTap: () {},
                        height: buttonHeight,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.onTap,
    required this.height,
  });

  final String label;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FilledButton(
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
