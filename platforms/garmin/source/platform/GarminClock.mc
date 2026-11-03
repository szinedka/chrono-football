import Toybox.Lang;
import Toybox.System;

class GarminClock {
    function nowMilliseconds() as Number {
        return System.getTimer();
    }
}
