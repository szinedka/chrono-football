import Toybox.Lang;
import Toybox.WatchUi;

class GoalTargetPickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }

    function onAccept(values as Array) as Boolean {
        if (values.size() != 1) {
            throw new Lang.InvalidValueException("Expected one goal target");
        }
        var goalTarget = values[0];
        if (!(goalTarget instanceof Number)) {
            throw new Lang.InvalidValueException("Goal target must be a number");
        }

        var session = new PossessionSession(goalTarget);
        var chronometer = new Chronometer(new GarminClock());
        chronometer.setStopListener(session.method(:onChronometerStopped));
        var controller = new ChronometerController(chronometer);
        var view = new ChronometerView(controller, session);
        var delegate = new ChronometerInputDelegate(controller, view, session);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onCancel() as Boolean {
        return true;
    }
}
