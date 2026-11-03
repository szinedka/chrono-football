import Toybox.Lang;
import Toybox.Test;

class RecordingChronometerListener {
    var events as Array<ChronometerStoppedEvent>;

    function initialize() {
        events = [];
    }

    function onChronometerStopped(event as ChronometerStoppedEvent) as Void {
        events.add(event);
    }
}

class FailingChronometerListener {
    function onChronometerStopped(event as ChronometerStoppedEvent) as Void {
        throw new Lang.InvalidValueException("Listener failed");
    }
}

class ReentrantChronometerListener {
    private var _chronometer as Chronometer;

    function initialize(chronometer as Chronometer) {
        _chronometer = chronometer;
    }

    function onChronometerStopped(event as ChronometerStoppedEvent) as Void {
        _chronometer.start();
    }
}

(:test)
function chronometerEmitsOneEventPerStop(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var chronometer = new Chronometer(clock);
    var listener = new RecordingChronometerListener();
    chronometer.setStopListener(listener.method(:onChronometerStopped));
    chronometer.start();
    clock.setMilliseconds(150);
    chronometer.elapsedMilliseconds();
    if (listener.events.size() != 0 || chronometer.stop() != 50l ||
        listener.events.size() != 1) {
        return false;
    }
    var first = listener.events[0];
    if (first.getActionId() != 1l || first.getElapsedMilliseconds() != 50l) {
        return false;
    }
    clock.setMilliseconds(200);
    chronometer.start();
    clock.setMilliseconds(275);
    if (chronometer.stop() != 125l || listener.events.size() != 2) {
        return false;
    }
    var second = listener.events[1];
    return second.getActionId() == 2l && second.getElapsedMilliseconds() == 125l &&
        first.getActionId() == 1l && first.getElapsedMilliseconds() == 50l;
}

(:test)
function chronometerDoesNotEmitForInvalidOrFailedStops(logger as Test.Logger) as Boolean {
    var clock = new FailingClock(100);
    var chronometer = new Chronometer(clock);
    var listener = new RecordingChronometerListener();
    chronometer.setStopListener(listener.method(:onChronometerStopped));
    try {
        chronometer.stop();
        return false;
    } catch (error instanceof Lang.OperationNotAllowedException) {
        if (listener.events.size() != 0) {
            return false;
        }
    }
    chronometer.start();
    clock.setFailure(true);
    try {
        chronometer.stop();
        return false;
    } catch (error instanceof Lang.InvalidValueException) {
        if (listener.events.size() != 0 || !chronometer.isRunning()) {
            return false;
        }
    }
    clock.setFailure(false);
    chronometer.stop();
    try {
        chronometer.stop();
        return false;
    } catch (error instanceof Lang.OperationNotAllowedException) {
        return listener.events.size() == 1 && listener.events[0].getActionId() == 1l;
    }
}

(:test)
function chronometerCanReplaceOrClearListener(logger as Test.Logger) as Boolean {
    var chronometer = new Chronometer(new FakeClock(100));
    var first = new RecordingChronometerListener();
    var second = new RecordingChronometerListener();
    chronometer.setStopListener(first.method(:onChronometerStopped));
    chronometer.setStopListener(second.method(:onChronometerStopped));
    chronometer.start();
    chronometer.stop();
    chronometer.setStopListener(null);
    chronometer.start();
    chronometer.stop();
    chronometer.setStopListener(first.method(:onChronometerStopped));
    chronometer.start();
    chronometer.stop();
    return first.events.size() == 1 && first.events[0].getActionId() == 3l &&
        second.events.size() == 1 && second.events[0].getActionId() == 1l;
}

(:test)
function chronometerSurfacesListenerFailureAfterStop(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var chronometer = new Chronometer(clock);
    var failingListener = new FailingChronometerListener();
    chronometer.setStopListener(failingListener.method(:onChronometerStopped));
    chronometer.start();
    clock.setMilliseconds(150);
    try {
        chronometer.stop();
        return false;
    } catch (error instanceof Lang.InvalidValueException) {
        if (chronometer.isRunning()) {
            return false;
        }
    }
    var listener = new RecordingChronometerListener();
    chronometer.setStopListener(listener.method(:onChronometerStopped));
    clock.setMilliseconds(200);
    chronometer.start();
    clock.setMilliseconds(225);
    return chronometer.stop() == 75l && listener.events.size() == 1 &&
        listener.events[0].getActionId() == 2l &&
        listener.events[0].getElapsedMilliseconds() == 75l;
}

(:test)
function chronometerRejectsReentrantStartDuringNotification(logger as Test.Logger) as Boolean {
    var chronometer = new Chronometer(new FakeClock(100));
    var listener = new ReentrantChronometerListener(chronometer);
    chronometer.setStopListener(listener.method(:onChronometerStopped));
    chronometer.start();
    try {
        chronometer.stop();
        return false;
    } catch (error instanceof Lang.OperationNotAllowedException) {
        if (chronometer.isRunning()) {
            return false;
        }
    }
    chronometer.setStopListener(null);
    chronometer.start();
    return chronometer.stop() == 0l;
}
