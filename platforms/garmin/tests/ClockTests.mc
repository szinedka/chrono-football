import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

class FakeClock {
    private var _milliseconds as Number;

    function initialize(milliseconds as Number) {
        _milliseconds = milliseconds;
    }

    function setMilliseconds(milliseconds as Number) as Void {
        _milliseconds = milliseconds;
    }

    function nowMilliseconds() as Number {
        return _milliseconds;
    }
}

function readClock(clock as MillisecondClock) as Number {
    return clock.nowMilliseconds();
}

(:test)
function fakeClockReturnsControlledReadings(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    if (readClock(clock) != 100) {
        return false;
    }
    clock.setMilliseconds(1350);
    return readClock(clock) == 1350 && readClock(clock) == 1350;
}

(:test)
function fakeClockCanSimulateRollover(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(2147483647);
    if (readClock(clock) != 2147483647) {
        return false;
    }
    clock.setMilliseconds(-2147483647 - 1);
    return readClock(clock) == -2147483647 - 1;
}

(:test)
function garminClockReadsSystemTimer(logger as Test.Logger) as Boolean {
    var clock = new GarminClock();
    var before = System.getTimer();
    var reading = readClock(clock);
    var after = System.getTimer();
    if (before <= after) {
        return reading >= before && reading <= after;
    }
    return reading >= before || reading <= after;
}
