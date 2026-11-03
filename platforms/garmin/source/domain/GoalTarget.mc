import Toybox.Lang;

module GoalTarget {
    const MIN = 1;
    const MAX = 10;
    const DEFAULT = 3;

    function validate(value as Number) as Void {
        if (value < MIN || value > MAX) {
            throw new Lang.InvalidValueException("Goal target must be between 1 and 10");
        }
    }
}
