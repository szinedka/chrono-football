import Toybox.Lang;

module PossessionOutcomeLabel {
    function text(outcome as PossessionMatrix.Outcome) as String {
        switch (outcome) {
            case PossessionMatrix.SHOT:
                return "SHOT";
            case PossessionMatrix.SHORT_PASS:
                return "SHORT PASS";
            case PossessionMatrix.LONG_BALL:
                return "LONG BALL";
            case PossessionMatrix.INTERCEPTION:
                return "INTERCEPTION";
            case PossessionMatrix.FREE_KICK:
                return "FREE KICK";
            case PossessionMatrix.OFFSIDE_OR_OUT:
                return "OFFSIDE / OUT";
            default:
                throw new Lang.InvalidValueException("Unknown possession outcome");
        }
    }
}
