import Toybox.Lang;

module GoalkeeperRule {
    enum Outcome {
        SAVE,
        CORNER,
        GOAL
    }

    function resolve(hundredths as Number) as Outcome {
        StopwatchValue.validateHundredths(hundredths);
        if (hundredths == 0) {
            return SAVE;
        }
        var digit = hundredths % 10;
        return (digit == 0 || digit == 5) ? CORNER : GOAL;
    }
}
