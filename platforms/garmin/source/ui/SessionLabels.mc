import Toybox.Lang;

module SessionLabels {
    function player(player as SessionPlayer.Id) as String {
        switch (player) {
            case SessionPlayer.P1:
                return "P1";
            case SessionPlayer.P2:
                return "P2";
            default:
                throw new Lang.InvalidValueException("Unknown player");
        }
    }

    function turn(player as SessionPlayer.Id, phase as SessionPhase.Value) as String {
        var playerLabel = SessionLabels.player(player);
        switch (phase) {
            case SessionPhase.PASSING:
                return playerLabel + " PASS";
            case SessionPhase.SHOOTING:
                return playerLabel + " SHOOT";
            case SessionPhase.GOALKEEPER:
                return playerLabel + " SAVE";
            default:
                throw new Lang.InvalidValueException("Unknown session phase");
        }
    }

    function moment(moment as SessionMoment.Value) as String {
        switch (moment) {
            case SessionMoment.SHORT_PASS:
                return "SHORT PASS";
            case SessionMoment.LONG_BALL:
                return "LONG BALL";
            case SessionMoment.INTERCEPTION:
                return "INTERCEPTION";
            case SessionMoment.FREE_KICK:
                return "FREE KICK";
            case SessionMoment.OFFSIDE_OR_OUT:
                return "OFFSIDE / OUT";
            case SessionMoment.SHOT_AWARDED:
                return "SHOT AWARDED";
            case SessionMoment.SHOT_ON_TARGET:
                return "ON TARGET";
            case SessionMoment.SHOT_MISSED:
                return "MISSED";
            case SessionMoment.SAVE:
                return "SAVED";
            case SessionMoment.CORNER:
                return "CORNER";
            case SessionMoment.GOAL:
                return "GOAL";
            default:
                throw new Lang.InvalidValueException("Unknown session moment");
        }
    }
}
