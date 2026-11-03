# Chrono Football

Chrono Football is a smartwatch football game inspired by childhood stopwatch
games. This repository is a monorepo for its shared specifications and future
platform-specific implementations.

The first intended release targets Garmin vívoactive 5 through Connect IQ.
Wear OS and Apple Watch are future targets. The Garmin app currently provides
a two-player Possession Matrix practice flow; a complete match is not yet
implemented.

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

This opens the simulator only. To build and run the chronometer on the
vívoactive 5 simulator, also install Java and configure a Connect IQ developer
key, then run:

```bash
./scripts/garmin-run.sh
```

Tap the screen or press the upper watch button to start and stop. The display
shows minutes, seconds and hundredths (`MM:SS:HH`) and refreshes periodically;
the stopped result comes from the clock, not the display refresh. The
chronometer pauses when stopped and resumes from that value on the next start.
The shared conversion truncates to hundredths for display and the rule
components. The command stays attached until the app exits.

The first player is `P1`. The top line shows whose turn it is and whether
they are passing, shooting or saving. When the chronometer stops, the result
appears below it and the player indicator updates if possession changes.
During a goalkeeper attempt, the running time is hidden until the defender
stops it. This is a practice flow: match setup, match endings and the
Even/Odd variant are not implemented yet.

By default the script looks for
`~/.config/chrono-football/developer_key.der`. Set `CONNECT_IQ_DEVELOPER_KEY`
to use an existing key instead. You can create a key with the Monkey C
extension in VS Code using **Monkey C: Generate a Developer Key**. Keep the
key private and backed up: Garmin requires the same key for app updates.
Do not commit it to the repository.

To run the Garmin unit tests, start the simulator first, then run:

```bash
./scripts/garmin-test.sh
```

The simulator may print `Unhandled Exception` for callback-failure cases that
the tests deliberately catch. Check the final test summary for their status.

The chronometer measures elapsed milliseconds using Garmin's counter rather
than UI refreshes. It accounts for signed 32-bit counter rollover, provided an
individual interval is shorter than one full counter cycle (about 50 days).
Counter resets cannot be distinguished from rollover. Device timing and
sleep behavior still need real-watch verification.

The chronometer can notify one optional stopped-event listener. Each valid
stop reports its accumulated milliseconds and an action ID unique to that
chronometer instance. Starting, refreshing and invalid stops do not emit events.
The stop is committed before the listener is called; listener errors propagate
and do not undo or repeat the stop. The listener cannot start or stop the
chronometer during notification. A separate session uses these events to
manage the Possession Matrix practice flow.

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
