import Toybox.Lang;

module StopwatchValue {
    function hundredths(milliseconds as Long) as Number {
        if (milliseconds < 0l) {
            throw new Lang.InvalidValueException("Elapsed time cannot be negative");
        }
        return ((milliseconds / 10l) % 100l).toNumber();
    }
}
