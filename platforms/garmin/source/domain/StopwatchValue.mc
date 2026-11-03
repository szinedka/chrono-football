import Toybox.Lang;

module StopwatchValue {
    function hundredths(milliseconds as Long) as Number {
        if (milliseconds < 0l) {
            throw new Lang.InvalidValueException("Elapsed time cannot be negative");
        }
        return ((milliseconds / 10l) % 100l).toNumber();
    }

    function validateHundredths(hundredths as Number) as Void {
        if (hundredths < 0 || hundredths > 99) {
            throw new Lang.InvalidValueException("Hundredths must be between 0 and 99");
        }
    }
}
