import Toybox.Lang;

module ShootingRule {
    enum Outcome {
        ON_TARGET,
        MISS
    }

    function resolve(hundredths as Number) as Outcome {
        StopwatchValue.validateHundredths(hundredths);
        var digit = hundredths % 10;
        return (digit == 0 || digit == 5) ? ON_TARGET : MISS;
    }
}
