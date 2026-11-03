import Toybox.Application;
import Toybox.WatchUi;

class ChronoFootballApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        var chronometer = new Chronometer(new GarminClock());
        var preview = new PossessionMatrixListener();
        chronometer.setStopListener(preview.method(:onChronometerStopped));
        var controller = new ChronometerController(chronometer);
        var view = new ChronometerView(controller, preview);
        return [view, new ChronometerInputDelegate(controller, view)];
    }
}
