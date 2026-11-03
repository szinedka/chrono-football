import Toybox.Lang;

module PossessionMatrix {
    enum Outcome {
        SHOT,
        SHORT_PASS,
        LONG_BALL,
        INTERCEPTION,
        FREE_KICK,
        OFFSIDE_OR_OUT
    }

    function resolve(hundredths as Number) as Outcome {
        if (hundredths < 0 || hundredths > 99) {
            throw new Lang.InvalidValueException("Hundredths must be between 0 and 99");
        }

        switch (hundredths % 10) {
            case 0:
                return SHOT;
            case 1:
            case 2:
            case 3:
                return SHORT_PASS;
            case 4:
            case 5:
                return LONG_BALL;
            case 6:
            case 7:
                return INTERCEPTION;
            case 8:
                return FREE_KICK;
            case 9:
                return OFFSIDE_OR_OUT;
            default:
                throw new Lang.InvalidValueException("Invalid possession digit");
        }
    }
}
