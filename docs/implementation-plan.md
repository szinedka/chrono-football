# Implementation plan: Garmin-first Chrono Football

## Handoff

This plan is for an implementing agent. The product owner approves gameplay
decisions; [gameplay-spec.md](gameplay-spec.md) is the source of truth for
agreed rules. This plan is an engineering proposal, not approval of any new
game rule. Do not invent defaults to get past an open decision.

The first release targets a Garmin vívoactive 5 and two people sharing one
watch. Prove a second, contrasting Garmin profile in the simulator, but do
not claim it as a supported release device without separate validation.
Wear OS and Apple Watch are future targets, not part of this implementation.
This repository is a monorepo; keep platform implementations under separate
platform directories and share specifications and conformance cases at the root.

Work on one task at a time. Each task below has a bounded output, prerequisites
and a concrete acceptance condition. Run the smallest relevant checks when
implementing it. Tasks with unmet prerequisites or owner decisions must remain
blocked; use test-only values when a component can be tested independently.
Do not silently turn test values into product defaults.

## Proposed boundaries

```text
Watch input -> input adapter -> session commands
                                      |
Platform clock -> chronometer -> stopped-value event
                                      |
                       session routes event by phase
                                      |
                     pure rules -> football outcome
                                      |
                    session state + domain events
                                      |
          presentation model -> device-specific watch UI

Match clock and lifecycle adapters feed the session separately.
```

- **Chronometer:** starts and stops using an injected clock, then emits one
  immutable stopped-value event per accepted stop. Display refreshes are not
  game results.
- **Rules:** pure functions interpret a stopped value and explicit context.
  They do not read clocks, draw UI, change score, or call Garmin APIs.
- **Session:** owns players, possession, phases, score and match outcome. It
  routes each stopped-value event once to the relevant rule and applies the
  result. UI and input adapters never implement scoring or rules.
- **Platform:** provides clock readings, controls, scheduling, lifecycle and
  rendering. Calculate elapsed time from clock readings, never by counting
  timer callbacks; callback and display refresh rates may be slower than the
  resolution needed to classify a stop.
- **Presentation:** consumes state and domain events, maps them to a layout and
  text, and translates player input into commands. A goalkeeper's running
  chronometer value must not be visible.
- **Reuse:** make the game contract, rules specification and conformance cases
  portable. Garmin needs a Monkey C implementation; do not assume Dart or
  another native shared library can run on every target watch. Later platforms
  can implement the same contract and verify against the same cases.

Use the following initial repository layout. These paths describe intended new
work, not files that already exist:

```text
docs/gameplay-spec.md               Approved rules and open decisions
docs/implementation-plan.md         This handoff
spec/conformance/                   Versioned platform-neutral rule cases
platforms/garmin/                   Connect IQ project and device resources
platforms/garmin/source/domain/     Game rules, session and clock contracts
platforms/garmin/source/platform/   Garmin adapters
platforms/garmin/source/ui/         Presentation and device UI
platforms/garmin/tests/             Garmin unit and integration tests
```

Use actual SDK conventions where they differ from the suggested test directory;
document the resulting paths and commands. Do not add a generic plugin system,
backend, high scores, multiplayer networking or unapproved gameplay features.

## Owner decisions that block dependent work

1. **Hundredths conversion:** define truncation/rounding and exact boundary
   behavior. Blocks production conversion and end-to-end outcome resolution;
   pure rule tests can use supplied hundredths values meanwhile.
2. **Even/Odd pass counter:** specify when it resets, including possession
   changes, shot awards, shots, corners and new attacks. Blocks the production
   session transitions that depend on the counter.
3. **Handover interaction:** agree how the watch enters and leaves handover,
   including attacker-to-goalkeeper and goalkeeper-to-attacker changes. Blocks
   the complete handover UI and match-clock integration.
4. **Setup values:** approve available goal targets and match durations, and
   any initial selection. Blocks release setup; tests may inject values.
5. **Timed boundary:** specify how a stop or goal occurring at the exact
   duration boundary is ordered against match expiry. Expiry is immediate as
   specified; do not award an outcome after expiry.

Ask the owner one focused question at a time. Update the gameplay specification
when a decision is approved, then update the relevant conformance cases. Until
then, do not claim the affected end-to-end feature is complete.

## Tasks

### A. SDK and platform proof

**A01 — Identify the SDK and target.** Prerequisites: none. Identify the
installed Connect IQ SDK, SDK Manager, compiler, simulator, vívoactive 5
device profile and required signing setup using Garmin's current documentation.
Do not assume the tools are on `PATH` or download/install them without the
owner's agreement. **Done:** record reproducible local setup, versions and
unresolved blockers; no generated keys or SDK files are committed.

**A02 — Create an empty Garmin app.** Prerequisites: A01. Scaffold a minimal
Connect IQ watch app under `platforms/garmin/`, using supported SDK tooling
and the vívoactive 5 profile. **Done:** it builds and opens in that simulator;
setup/build/run instructions are recorded, with no unrelated platform changes.

**A03 — Establish the test entry point.** Prerequisites: A02. Add the smallest
supported Garmin unit-test example and document how to run it. **Done:** one
intentional passing test runs through the SDK; no unverified test command is
presented as working.

**A04 — Choose a contrasting profile.** Prerequisites: A01. Identify a
second SDK-supported simulator profile with substantially different input
and/or display capabilities, ideally button-driven or monochrome. **Done:**
document actual capabilities and any limits; do not claim hardware support
or assume the device exists in a particular SDK.

**A05 — Measure timing and controls.** Prerequisites: A02. In an isolated
technical spike, determine supported clock readings, rollover behavior, timer
limits, available inputs and screen constraints. Exercise start/stop in the
simulator and, when available, on the vívoactive 5. **Done:** record observed
resolution, input/refresh behavior, lifecycle limitations and remaining risks;
do not equate timer callback frequency with clock precision.

### B. Contracts and conformance

**B01 — Define rule-facing values.** Prerequisites: none. Specify the
two-digit hundredths value (`00`–`99`), final digit, player identity, passing
variant, match-ending mode, and outcome vocabulary in a platform-neutral
contract. **Done:** valid ranges and invalid inputs are explicit; no platform
types, rendering or implementation-specific assumptions are required.

**B02 — Define commands and events.** Prerequisites: B01. Specify commands
for starting/stopping an action and the minimal state/event vocabulary for
turns, possession, football outcomes, handovers and match completion.
**Done:** payloads and ordering are documented; a stopped event identifies its
action so a duplicate cannot be applied twice.

**B03 — Define clock contracts.** Prerequisites: B01. Specify a monotonic
elapsed-time source, chronometer start/stop/reset behavior and an injectable
test clock. Specify handling of rollover and clock failure based on A05 before
implementing the Garmin adapter. **Done:** invalid transitions and clock
errors are explicit; no UI scheduler or wall-clock dependency is required.

**B04 — Add passing conformance cases.** Prerequisites: B01. Add versioned,
platform-neutral cases for every Possession Matrix digit and Even/Odd double
precedence, odd/even outcomes and the third successful pass. Include `.00`,
`.11`, `.22`, `.24`, `.35` and `.99`. **Done:** inputs, context and expected
rule outcomes are readable without Garmin tooling; unresolved counter-reset
behavior is not fabricated.

**B05 — Add shot and keeper conformance cases.** Prerequisites: B01. Cover
all final digits for shooting, and goalkeeper `.00`, other endings `0`/`5`,
and non-save values. Include `.00`, `.10`, `.15`, `.33` and `.46`.
**Done:** `.00` precedence and the lack of a shooting double-digit exception
are explicit.

**B06 — Add match conformance cases.** Prerequisites: B02. Describe approved
transitions for miss, clean save, corner, goal, target reached, timed draw,
handover pause/resume and immediate expiry. **Done:** cases identify the
acting player, phase, score and next possession; unresolved boundary cases are
marked blocked rather than assigned an invented answer.

### C. Chronometer and time

**C01 — Implement a fake clock.** Prerequisites: A03, B03. Add a deterministic
clock for tests with explicit time advancement. **Done:** independent tests
can control elapsed time without waiting or using Garmin APIs.

**C02 — Start an action chronometer.** Prerequisites: C01. Record a start
reading and running state. **Done:** a valid start begins one action;
duplicate/invalid starts are explicitly rejected or reported and cannot
replace its start timestamp.

**C03 — Stop an action chronometer.** Prerequisites: C02. Compute elapsed
time from start and stop clock readings and stop the action. **Done:** a
second stop cannot produce another result; invalid stop and clock errors are
explicitly reported. Verify delayed callbacks do not alter elapsed time.

**C04 — Publish stopped-value events.** Prerequisites: B02, C03. Publish
exactly one event with action identity and measured elapsed time on a valid
stop. **Done:** listeners see no result on start or display refresh and cannot
receive duplicate outcomes from repeated stops.

**C05 — Convert elapsed time to hundredths.** Prerequisites: C04 and owner
decision 1. Implement the approved conversion separately from rules.
**Done:** test exact boundaries, second/minute rollover, `00` and `99`; the
display and rule input use the same converted value.

**C06 — Implement the Garmin clock adapter.** Prerequisites: A05, B03.
Implement the chosen Garmin time source, including verified rollover and
error behavior. **Done:** it satisfies the clock contract in simulator and
device checks; UI refresh frequency does not define elapsed time.

**C07 — Implement a match clock.** Prerequisites: C01, B03. Add a separate
count-up clock with start, pause and resume; accept duration as configuration.
**Done:** fake-clock checks prove elapsed active time excludes pauses and is
independent of the action chronometer. No match transitions are added here.

### D. Pure football rules

**D01 — Implement Possession Matrix.** Prerequisites: A03, B04. Map a
supplied last digit to the specified moment, without changing session state.
**Done:** all ten digits match the conformance cases, including `8` as a
free kick that retains possession.

**D02 — Implement Even/Odd classification.** Prerequisites: A03, B04. Map
the supplied two-digit value and explicit prior pass count to pass, turnover
or shot. **Done:** doubles take precedence and the third eligible even pass
awards a shot. Leave counter-reset policy to the session and owner decision 2.

**D03 — Implement shot classification.** Prerequisites: A03, B05. Map the
supplied last digit to on-target or miss. **Done:** only `0` and `5` are
on target; a double such as `.33` is not special.

**D04 — Implement goalkeeper classification.** Prerequisites: A03, B05. Map
the supplied two-digit value to clean save, corner or goal. **Done:** `.00`
is a clean save, other `0`/`5` endings are corners, all remaining values
are goals.

**D05 — Wire portable cases into Garmin tests.** Prerequisites: B04, B05,
D01–D04. Use SDK-supported means to run or generate Garmin cases from the
versioned neutral cases; do not assume runtime JSON loading is available.
**Done:** one source of expected results checks each rule implementation, and
instructions explain how to rerun it without network access.

### E. Session and match behavior

**E01 — Define session state.** Prerequisites: B01, B02. Represent both
players, first attacker, possession, match configuration, phase, score,
pass count, active action identity and completion status. **Done:** state
contains no Garmin UI objects and does not invent setup defaults.

**E02 — Start a match.** Prerequisites: E01. Start from explicit configuration;
whoever starts the first chronometer turn becomes the first attacker.
**Done:** initial player, phase and zero score are observable; invalid
configuration is reported, not silently replaced.

**E03 — Route stopped events.** Prerequisites: C04, E01, D01–D04. Route an
action stop to the rule for its current phase and selected passing variant.
**Done:** stale or duplicate action events cannot change state twice; a UI
refresh never triggers a rule. Conversion is injected until C05 is approved.

**E04 — Apply passing results.** Prerequisites: E03 and owner decision 2 for
counter-related transitions. Apply passes, free kicks, turnovers and shot
awards. **Done:** possession and phase follow both rule tables; no new
free-kick table exists.

**E05 — Apply shot results.** Prerequisites: E03, D03. Route an on-target shot
to the defender's goalkeeper phase; a miss changes possession. **Done:** a
miss never opens the goalkeeper phase and an on-target shot never scores
without the goalkeeper result.

**E06 — Apply goalkeeper results.** Prerequisites: E03, D04. Apply save,
corner and goal outcomes, including score and next attacker. **Done:** save
changes possession, corner returns to the selected passing variant for the
same attacker, and a goal adds one goal before the conceding player starts
the next attack.

**E07 — Implement goal-target ending.** Prerequisites: E06. Accept a
configured goal target and finish when it is reached. **Done:** the match
stops accepting gameplay commands after completion; no default target is
invented.

**E08 — Represent handover.** Prerequisites: E01 and owner decision 3.
Model required changes of acting player as explicit transitions; same-player
turns must not be mistaken for handovers. **Done:** the next player is visible
to the presentation layer and no action starts for the wrong player.

**E09 — Connect the timed match.** Prerequisites: C07, E08, owner decisions
3–5. Pause at approved handovers, resume at the next player's action start,
and end immediately at the configured duration, including mid-action.
**Done:** the result is a draw when tied; no late action changes a completed
match, including the approved exact-boundary case.

**E10 — Exercise complete match sequences.** Prerequisites: B06, C05, E04–E09.
Run conformance scenarios for both passing variants and both ending modes.
**Done:** all four configurations work, with possession, handovers, score,
corner, expiry and completion verified using deterministic clocks.

### F. Input and presentation

**F01 — Define input bindings.** Prerequisites: B02, A05. Map supported
device inputs to semantic commands; keep rules unaware of physical controls.
**Done:** unavailable or conflicting controls are reported, not silently
mapped to an unusable interaction.

**F02 — Implement vívoactive 5 input adapter.** Prerequisites: F01, A02.
Translate supported inputs into commands, without directly changing session
state. **Done:** start/stop works in the simulator and on the target device.

**F03 — Define the presentation model.** Prerequisites: E01. Expose concise
current player, action, result, score, match status and handover information.
**Done:** goalkeeper running time is absent from the model while the attempt
is active; display code cannot accidentally reveal it.

**F04 — Define device presentation profiles.** Prerequisites: A04, F03.
Describe screen dimensions/shape, color capabilities, text/layout resources
and input capabilities for the target and contrasting simulator profile.
**Done:** profiles select supported layouts and bindings without placing
device-specific branches in the domain.

**F05 — Render one action screen.** Prerequisites: F03, F04. Implement the
smallest screen for the active player, current action and start/stop control.
**Done:** it fits the target and contrasting simulator screens, remains legible
without color, and renders from the presentation model.

**F06 — Render result and handover states.** Prerequisites: F05, E08. Show
the football moment and the next player's handover instruction using the
approved interaction. **Done:** the keeper's running value stays hidden and
handover cannot be skipped by an unrelated control.

**F07 — Render match setup.** Prerequisites: F04 and owner decision 4.
Provide passing variant and ending-mode selection plus approved target/duration
values. **Done:** all four combinations can be selected; invalid or missing
configuration is explained rather than silently defaulted.

**F08 — Render match completion.** Prerequisites: E07, E09, F03. Show final
score and winner or draw, with an explicit way to leave or start another
match. **Done:** completed matches cannot resume from stale input.

### G. Integration and release

**G01 — Compose the Garmin application.** Prerequisites: C06, E10, F02,
F06–F08. Wire platform adapters, chronometer, session, clocks and UI in one
composition root. **Done:** a full match is playable without UI code
reimplementing game rules; no unfinished placeholder actions appear enabled.

**G02 — Handle lifecycle interruptions.** Prerequisites: G01. Investigate
backgrounding, display sleep, app exit and resume on the actual device. Agree
any gameplay implications with the owner before defining behavior. **Done:**
unsupported or interrupted states are handled explicitly; immediate timed
expiry is not claimed where platform scheduling cannot deliver it.

**G03 — Verify target and contrasting profile.** Prerequisites: G01, G02.
Exercise both passing variants and both ending modes, goalkeeper privacy,
handovers and readable layouts on vívoactive 5 and the second simulator.
**Done:** record results and timing limitations; second-profile simulator
success is not represented as a supported physical-device release.

**G04 — Prepare the release handoff.** Prerequisites: G03. Document supported
devices, SDK/build/signing prerequisites, known limitations and the Garmin
distribution checklist. **Done:** another contributor can reproduce the
release build without committing credentials or private keys.

## Coordination rules

- Independent work may proceed in parallel only after its prerequisites are
  met. B04/B05 and D01–D04 are separable; C01–C04 do not depend on Garmin
  rendering. Do not have multiple agents edit the same contract, conformance
  file, session reducer or composition root simultaneously.
- An agent owns its task's files until handoff. Report changed files, commands
  actually run, acceptance results, blockers and assumptions. Do not claim a
  simulator or real-device check that was not performed.
- If an SDK limitation invalidates an interface or a gameplay rule is
  ambiguous, stop the dependent task, document evidence and ask the owner.
  Do not work around the issue by changing gameplay silently.
- A second watch platform is a later project: reuse the specification and
  conformance cases first, then decide executable-code sharing from an actual
  platform proof rather than assuming it.
