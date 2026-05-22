# Chrono Football

Cross-platform smartwatch game concept built with Flutter.

## Architecture (Clean + Modular)

```text
lib/
  core/
    di/
    navigation/
    theme/
    utils/
  features/
    game/
      data/
        datasources/
        repositories/
      domain/
        entities/
        repositories/
        services/
      presentation/
        controllers/
        screens/
        widgets/
```

## Recommended dependencies

- `flutter_riverpod` for state management
- `go_router` for navigation
- `shared_preferences` for local persistence

## Game models

- `GameState`: current mode, timer, target, score, streak, stats
- `GameTarget`: selected target stopwatch value
- `RoundResult`: elapsed time, delta, precision classification, points
- `GameSettings`: mute + visual mode

## Stopwatch / game engine

`StopwatchGameEngine` provides:

- 10ms game tick stream for UI updates
- start/stop/reset control
- precision scoring (`goal`, `nearMiss`, `save`, `fail`)
- random target generation for quick rounds

## First playable MVP

Implemented screens:

- Main menu with smartwatch-sized large touch targets
- Quick Play screen with:
  - target display
  - large START/STOP action button
  - live stopwatch
  - precision feedback banner
  - score, streak, average precision and reset/menu controls

## Run

```bash
flutter pub get
flutter run
flutter test
```
