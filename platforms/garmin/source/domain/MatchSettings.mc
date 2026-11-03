import Toybox.Lang;

module MatchMode {
    enum Value {
        GOAL_TARGET,
        TIMED
    }
}

module TimedMatchDuration {
    const DEFAULT_MINUTES = 3;

    function options() as Array<Number> {
        return [1, 3, 5];
    }

    function validate(minutes as Number) as Void {
        if (options().indexOf(minutes) < 0) {
            throw new Lang.InvalidValueException("Match duration must be 1, 3 or 5 minutes");
        }
    }
}

class MatchSettings {
    private var _mode as MatchMode.Value;
    private var _value as Number;

    function initialize(mode as MatchMode.Value, value as Number) {
        switch (mode) {
            case MatchMode.GOAL_TARGET:
                GoalTarget.validate(value);
                break;
            case MatchMode.TIMED:
                TimedMatchDuration.validate(value);
                break;
            default:
                throw new Lang.InvalidValueException("Unknown match mode");
        }
        _mode = mode;
        _value = value;
    }

    function mode() as MatchMode.Value {
        return _mode;
    }

    function goalTarget() as Number {
        if (_mode != MatchMode.GOAL_TARGET) {
            throw new Lang.OperationNotAllowedException("Match has no goal target");
        }
        return _value;
    }

    function durationMilliseconds() as Long {
        if (_mode != MatchMode.TIMED) {
            throw new Lang.OperationNotAllowedException("Match has no time limit");
        }
        return _value.toLong() * 60000l;
    }
}
