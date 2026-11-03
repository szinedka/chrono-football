import Toybox.Lang;

module SessionPlayer {
    enum Id {
        P1,
        P2
    }
}

module SessionPhase {
    enum Value {
        PASSING,
        SHOOTING,
        GOALKEEPER
    }
}

module SessionMoment {
    enum Value {
        SHORT_PASS,
        LONG_BALL,
        INTERCEPTION,
        FREE_KICK,
        OFFSIDE_OR_OUT,
        SHOT_AWARDED,
        SHOT_ON_TARGET,
        SHOT_MISSED,
        SAVE,
        CORNER,
        GOAL
    }
}

class PossessionSession {
    private var _attacker as SessionPlayer.Id;
    private var _phase as SessionPhase.Value;
    private var _lastMoment as SessionMoment.Value?;
    private var _lastActionId as Long;
    private var _p1Score as Number;
    private var _p2Score as Number;

    function initialize() {
        _attacker = SessionPlayer.P1;
        _phase = SessionPhase.PASSING;
        _lastMoment = null;
        _lastActionId = 0l;
        _p1Score = 0;
        _p2Score = 0;
    }

    function actingPlayer() as SessionPlayer.Id {
        return _phase == SessionPhase.GOALKEEPER ? otherPlayer(_attacker) : _attacker;
    }

    function phase() as SessionPhase.Value {
        return _phase;
    }

    function lastMoment() as SessionMoment.Value? {
        return _lastMoment;
    }

    function p1Score() as Number {
        return _p1Score;
    }

    function p2Score() as Number {
        return _p2Score;
    }

    function onChronometerStopped(event as ChronometerStoppedEvent) as Void {
        if (event.getActionId() <= _lastActionId) {
            throw new Lang.OperationNotAllowedException("Stop event has already been processed");
        }

        var hundredths = StopwatchValue.hundredths(event.getElapsedMilliseconds());
        var moment = resolveMoment(hundredths);
        _lastMoment = moment;
        _lastActionId = event.getActionId();
    }

    private function resolveMoment(hundredths as Number) as SessionMoment.Value {
        switch (_phase) {
            case SessionPhase.PASSING:
                return resolvePassing(hundredths);
            case SessionPhase.SHOOTING:
                return resolveShooting(hundredths);
            case SessionPhase.GOALKEEPER:
                return resolveGoalkeeper(hundredths);
            default:
                throw new Lang.InvalidValueException("Unknown session phase");
        }
    }

    private function resolvePassing(hundredths as Number) as SessionMoment.Value {
        switch (PossessionMatrix.resolve(hundredths)) {
            case PossessionMatrix.SHORT_PASS:
                return SessionMoment.SHORT_PASS;
            case PossessionMatrix.LONG_BALL:
                _phase = SessionPhase.SHOOTING;
                return SessionMoment.LONG_BALL;
            case PossessionMatrix.INTERCEPTION:
                _attacker = otherPlayer(_attacker);
                return SessionMoment.INTERCEPTION;
            case PossessionMatrix.FREE_KICK:
                return SessionMoment.FREE_KICK;
            case PossessionMatrix.OFFSIDE_OR_OUT:
                _attacker = otherPlayer(_attacker);
                return SessionMoment.OFFSIDE_OR_OUT;
            case PossessionMatrix.SHOT:
                _phase = SessionPhase.SHOOTING;
                return SessionMoment.SHOT_AWARDED;
            default:
                throw new Lang.InvalidValueException("Unknown possession outcome");
        }
    }

    private function resolveShooting(hundredths as Number) as SessionMoment.Value {
        switch (ShootingRule.resolve(hundredths)) {
            case ShootingRule.ON_TARGET:
                _phase = SessionPhase.GOALKEEPER;
                return SessionMoment.SHOT_ON_TARGET;
            case ShootingRule.MISS:
                _attacker = otherPlayer(_attacker);
                _phase = SessionPhase.PASSING;
                return SessionMoment.SHOT_MISSED;
            default:
                throw new Lang.InvalidValueException("Unknown shooting outcome");
        }
    }

    private function resolveGoalkeeper(hundredths as Number) as SessionMoment.Value {
        switch (GoalkeeperRule.resolve(hundredths)) {
            case GoalkeeperRule.SAVE:
                _attacker = otherPlayer(_attacker);
                _phase = SessionPhase.PASSING;
                return SessionMoment.SAVE;
            case GoalkeeperRule.CORNER:
                _phase = SessionPhase.PASSING;
                return SessionMoment.CORNER;
            case GoalkeeperRule.GOAL:
                if (_attacker == SessionPlayer.P1) {
                    _p1Score += 1;
                } else {
                    _p2Score += 1;
                }
                _attacker = otherPlayer(_attacker);
                _phase = SessionPhase.PASSING;
                return SessionMoment.GOAL;
            default:
                throw new Lang.InvalidValueException("Unknown goalkeeper outcome");
        }
    }

    private function otherPlayer(player as SessionPlayer.Id) as SessionPlayer.Id {
        switch (player) {
            case SessionPlayer.P1:
                return SessionPlayer.P2;
            case SessionPlayer.P2:
                return SessionPlayer.P1;
            default:
                throw new Lang.InvalidValueException("Unknown player");
        }
    }
}
