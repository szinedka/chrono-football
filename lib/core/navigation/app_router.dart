import 'package:chrono_football/features/game/presentation/screens/game_screen.dart';
import 'package:chrono_football/features/game/presentation/screens/main_menu_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const MainMenuScreen(),
      ),
      GoRoute(
        path: '/play',
        builder: (context, state) => const GameScreen(),
      ),
    ],
  );
}
