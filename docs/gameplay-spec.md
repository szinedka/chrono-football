# Gameplay specification

This document records the agreed direction for Chrono Football. The Garmin app
currently implements a limited Possession Matrix practice flow, not a complete
match. Open decisions are listed separately and must not be treated as approved
rules.

## Match setup

- Two people play against each other, taking turns on one watch.
- The players decide who starts: the player who starts the chronometer begins
  the match as the first attacker.
- Players choose a passing variant and a match-ending mode before the match.
  Either passing variant can be combined with either match-ending mode.

## Reading the stopwatch

Gameplay uses the two hundredths digits after the decimal point. For example,
if the display reads `00:02.46`, the two-digit value is `46` and its last digit
is `6`. Milliseconds are truncated to hundredths: `953 ms` gives `95`, while
`1,000 ms` gives `00`.

The action chronometer pauses when stopped. The next start resumes from the
stopped value; time spent stopped is not added.

The match clock and the chronometer used for individual actions are separate.

## Possession and passing

The attacker starts and stops the chronometer to determine the next action.
A successful pass keeps possession; a turnover gives possession to the other
player. When a result awards a shot, the attacker takes a separate shot turn.

### Possession Matrix

Use the last hundredths digit:

| Last digit | Action | Result |
| --- | --- | --- |
| `1`, `2`, `3` | Short pass | The attacker keeps possession. |
| `4`, `5` | Long ball or cross | The attacker takes a shot. |
| `6`, `7` | Tackle or interception | Possession changes. |
| `8` | Foul | The attacker keeps possession and takes the free kick using the normal possession matrix. |
| `9` | Offside or out of bounds | Possession changes. |
| `0` | Shot | The attacker takes a shot. |

### Even/Odd

Use both hundredths digits. Matching digits take precedence over even or odd:

| Value | Result |
| --- | --- |
| Matching digits, such as `.11` or `.22` | The attacker takes a shot. |
| Any other even value | A successful pass; the attacker keeps possession. Three consecutive successful even passes award a shot. |
| Any other odd value | Interception; possession changes. |

## Shooting

When a shot is awarded, the attacker starts and stops the chronometer again:

- A last hundredths digit of `0` or `5` is a shot on target and leads to a
  goalkeeper attempt.
- Any other last digit is a miss; possession changes to the defender.

Matching digits have no special meaning for shooting.

## Goalkeeper attempt

The defending player takes one blind attempt. The running chronometer is hidden
until the defender stops it. Apply these results in order:

| Defender's result | Outcome |
| --- | --- |
| Exactly `.00` | Clean save; possession changes to the defender. |
| Any other value ending in `0` or `5` | Parried for a corner; the attacker keeps possession and plays the selected normal passing rules again. |
| Anything else | Goal for the attacker. The player who conceded starts the next attack. |

The `.00` result takes precedence over the other values ending in `0`.

## Match ending

### Goal target

The match ends when a player reaches the selected number of goals.

### Timed match

- The match clock counts forward from zero to the selected duration.
- It pauses during handovers and resumes when the next player starts their
  chronometer turn.
- The match ends immediately when the selected duration is reached, even if an
  action is in progress. A tied match ends in a draw.

## Open decisions

- Selectable goal targets and match durations.
- The exact on-watch handover interaction and how it relates to pausing the
  match clock.
- When and how the action chronometer resets, including for a new match.
- When the consecutive-pass count resets in Even/Odd mode.
- Whether to add penalties or other football moments and, if so, their rules.
- Device-specific presentation, controls, and timing behavior to be validated
  on the first target watch.
