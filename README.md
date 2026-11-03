# Chrono Football

Chrono Football is a smartwatch football game inspired by childhood stopwatch
games. This repository is a monorepo for its shared specifications and future
platform-specific implementations.

The first intended release targets Garmin vívoactive 5 through Connect IQ.
Wear OS and Apple Watch are future targets. The Garmin app currently contains
only a welcome screen; gameplay has not been implemented.

## Documentation

- [Gameplay specification](docs/gameplay-spec.md): agreed rules and open
  product decisions.
- [Implementation plan](docs/implementation-plan.md): small, dependency-aware
  tasks for the Garmin-first implementation and reusable game contracts.

## Garmin simulator

Install the Connect IQ SDK using Garmin's SDK Manager, then on macOS run:

```bash
./scripts/garmin-simulator.sh
```

The script uses the SDK selected in Garmin's SDK Manager. To use a different
installed SDK, set `CONNECT_IQ_SDK_HOME` to its root directory:

```bash
CONNECT_IQ_SDK_HOME="/path/to/connectiq-sdk" ./scripts/garmin-simulator.sh
```

This opens the simulator only. To build and run the welcome screen on the
vívoactive 5 simulator, also install Java and configure a Connect IQ developer
key, then run:

```bash
./scripts/garmin-run.sh
```

The command stays attached to the simulator session until the app exits.

By default the script looks for
`~/.config/chrono-football/developer_key.der`. Set `CONNECT_IQ_DEVELOPER_KEY`
to use an existing key instead. You can create a key with the Monkey C
extension in VS Code using **Monkey C: Generate a Developer Key**. Keep the
key private and backed up: Garmin requires the same key for app updates.
Do not commit it to the repository.

## Planned repository layout

```text
docs/                  Gameplay and implementation documentation
scripts/               Local development commands
spec/conformance/      Shared, platform-neutral rule cases
platforms/garmin/      Garmin Connect IQ app
```

The Garmin directory contains the initial app; shared conformance cases will
be added when gameplay implementation begins. Each platform can use its own
tools and UI while following the shared game specification.
