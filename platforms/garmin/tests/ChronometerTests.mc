import Toybox.Lang;
import Toybox.Test;

class FailingClock {
    private var _milliseconds as Number;
    private var _fail as Boolean;

    function initialize(milliseconds as Number) {
        _milliseconds = milliseconds;
        _fail = false;
    }

    function setFailure(fail as Boolean) as Void {
        _fail = fail;
    }

    function setMilliseconds(milliseconds as Number) as Void {
        _milliseconds = milliseconds;
    }

    function nowMilliseconds() as Number {
        if (_fail) {
            throw new Lang.InvalidValueException("Clock read failed");
        }
        return _milliseconds;
    }
}

(:test)
function chronometerMeasuresElapsedTime(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var chronometer = new Chronometer(clock);
    if (chronometer.isRunning()) {
        return false;
    }
    chronometer.start();
    if (!chronometer.isRunning()) {
        return false;
    }
    clock.setMilliseconds(1350);
    if (chronometer.elapsedMilliseconds() != 1250l || !chronometer.isRunning()) {
        return false;
    }
    clock.setMilliseconds(1400);
    return chronometer.stop() == 1300l && !chronometer.isRunning();
}

(:test)
function chronometerRejectsElapsedReadWhenStopped(logger as Test.Logger) as Boolean {
    var chronometer = new Chronometer(new FakeClock(100));
    try {
        chronometer.elapsedMilliseconds();
        return false;
    } catch (error instanceof Lang.OperationNotAllowedException) {
        return !chronometer.isRunning();
    }
}

(:test)
function chronometerResumesWithoutCountingStoppedTime(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var chronometer = new Chronometer(clock);
    chronometer.start();
    clock.setMilliseconds(150);
    if (chronometer.stop() != 50l) {
        return false;
    }
    clock.setMilliseconds(200);
    chronometer.start();
    if (chronometer.elapsedMilliseconds() != 50l) {
        return false;
    }
    clock.setMilliseconds(250);
    if (chronometer.stop() != 100l) {
        return false;
    }
    clock.setMilliseconds(2000);
    chronometer.start();
    clock.setMilliseconds(2010);
    return chronometer.stop() == 110l;
}

(:test)
function chronometerResumesAcrossCounterRollover(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(2147483645);
    var chronometer = new Chronometer(clock);
    chronometer.start();
    clock.setMilliseconds(2147483646);
    if (chronometer.stop() != 1l) {
        return false;
    }
    clock.setMilliseconds(2147483647);
    chronometer.start();
    clock.setMilliseconds(-2147483647);
    return chronometer.stop() == 3l;
}

(:test)
function chronometerRejectsDuplicateStart(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var chronometer = new Chronometer(clock);
    chronometer.start();
    clock.setMilliseconds(200);
    try {
        chronometer.start();
        return false;
    } catch (error instanceof Lang.OperationNotAllowedException) {
        clock.setMilliseconds(500);
        return chronometer.stop() == 400l;
    }
}

(:test)
function chronometerRejectsStopWhenNotRunning(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var chronometer = new Chronometer(clock);
    try {
        chronometer.stop();
        return false;
    } catch (error instanceof Lang.OperationNotAllowedException) {
        if (chronometer.isRunning()) {
            return false;
        }
    }
    chronometer.start();
    chronometer.stop();
    try {
        chronometer.stop();
        return false;
    } catch (error instanceof Lang.OperationNotAllowedException) {
        return !chronometer.isRunning();
    }
}

(:test)
function chronometerCrossesSignedCounterBoundary(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(2147483647);
    var chronometer = new Chronometer(clock);
    chronometer.start();
    clock.setMilliseconds(-2147483647 - 1);
    return chronometer.stop() == 1l;
}

(:test)
function chronometerCrossesCounterZero(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(-2);
    var chronometer = new Chronometer(clock);
    chronometer.start();
    clock.setMilliseconds(3);
    return chronometer.stop() == 5l;
}

(:test)
function chronometerPreservesStateWhenClockFails(logger as Test.Logger) as Boolean {
    var clock = new FailingClock(100);
    var chronometer = new Chronometer(clock);
    clock.setFailure(true);
    try {
        chronometer.start();
        return false;
    } catch (error instanceof Lang.InvalidValueException) {
        if (chronometer.isRunning()) {
            return false;
        }
    }
    clock.setFailure(false);
    chronometer.start();
    clock.setFailure(true);
    try {
        chronometer.stop();
        return false;
    } catch (error instanceof Lang.InvalidValueException) {
        if (!chronometer.isRunning()) {
            return false;
        }
    }
    clock.setFailure(false);
    clock.setMilliseconds(250);
    if (chronometer.stop() != 150l) {
        return false;
    }
    clock.setFailure(true);
    try {
        chronometer.start();
        return false;
    } catch (error instanceof Lang.InvalidValueException) {
        if (chronometer.isRunning()) {
            return false;
        }
    }
    clock.setFailure(false);
    clock.setMilliseconds(300);
    chronometer.start();
    clock.setMilliseconds(350);
    return chronometer.stop() == 200l;
}
