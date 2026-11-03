import Toybox.Lang;
import Toybox.Test;

(:test)
function chronometerInputStartsAndStops(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var chronometer = new Chronometer(clock);
    var listener = new RecordingChronometerListener();
    chronometer.setStopListener(listener.method(:onChronometerStopped));
    var controller = new ChronometerController(chronometer);
    var view = new ChronometerView(controller, new PossessionMatrixListener());
    var input = new ChronometerInputDelegate(controller, view);
    if (controller.isRunning() || controller.hasResult() ||
        !ChronometerFormat.format(controller.displayMilliseconds()).equals("00:00:00")) {
        return false;
    }
    if (!input.onSelect() || !controller.isRunning()) {
        return false;
    }
    clock.setMilliseconds(350);
    if (!ChronometerFormat.format(controller.displayMilliseconds()).equals("00:00:25")) {
        return false;
    }
    if (!input.onSelect() || controller.isRunning() || !controller.hasResult() ||
        listener.events.size() != 1 ||
        listener.events[0].getElapsedMilliseconds() != 250l ||
        !ChronometerFormat.format(controller.displayMilliseconds()).equals("00:00:25")) {
        return false;
    }
    clock.setMilliseconds(400);
    if (!input.onSelect() || !controller.isRunning() || controller.hasResult() ||
        !ChronometerFormat.format(controller.displayMilliseconds()).equals("00:00:25")) {
        return false;
    }
    clock.setMilliseconds(470);
    return input.onSelect() && !controller.isRunning() &&
        listener.events.size() == 2 &&
        listener.events[1].getActionId() == 2l &&
        listener.events[1].getElapsedMilliseconds() == 320l &&
        ChronometerFormat.format(controller.displayMilliseconds()).equals("00:00:32");
}

(:test)
function chronometerRefreshFollowsViewLifecycle(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var controller = new ChronometerController(new Chronometer(clock));
    var view = new ChronometerView(controller, new PossessionMatrixListener());
    var input = new ChronometerInputDelegate(controller, view);
    view.onShow();
    input.onSelect();
    view.requestRefresh();
    view.onHide();
    clock.setMilliseconds(350);
    view.onShow();
    input.onSelect();
    view.onHide();
    return !controller.isRunning() && controller.displayMilliseconds() == 250l;
}

(:test)
function chronometerUiKeepsStoppedValueAfterListenerFailure(logger as Test.Logger) as Boolean {
    var clock = new FakeClock(100);
    var chronometer = new Chronometer(clock);
    var listener = new FailingChronometerListener();
    chronometer.setStopListener(listener.method(:onChronometerStopped));
    var controller = new ChronometerController(chronometer);
    var view = new ChronometerView(controller, new PossessionMatrixListener());
    var input = new ChronometerInputDelegate(controller, view);
    view.onShow();
    input.onSelect();
    clock.setMilliseconds(350);
    try {
        input.onSelect();
        return false;
    } catch (error instanceof Lang.InvalidValueException) {
        view.onHide();
        return !controller.isRunning() && controller.hasResult() &&
            controller.displayMilliseconds() == 250l;
    }
}
