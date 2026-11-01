# Chrono Football

Chrono Football is a smartwatch football game inspired by childhood stopwatch
games. This repository is a monorepo for its shared specifications and future
platform-specific implementations.

The first intended release targets Garmin vívoactive 5 through Connect IQ.
Wear OS and Apple Watch are future targets. No platform implementation has
been added yet.

## Documentation

- [Gameplay specification](docs/gameplay-spec.md): agreed rules and open
  product decisions.
- [Implementation plan](docs/implementation-plan.md): small, dependency-aware
  tasks for the Garmin-first implementation and reusable game contracts.

## Planned repository layout

```text
docs/                  Gameplay and implementation documentation
spec/conformance/      Shared, platform-neutral rule cases
platforms/garmin/      Garmin Connect IQ app
```

Only `docs/` exists today. Additional platform directories and shared
conformance cases will be added when their implementation work begins. Each
platform can use its own tools and UI while following the shared game
specification.
