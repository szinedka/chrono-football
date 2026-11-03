import Toybox.Application;
import Toybox.WatchUi;

class ChronoFootballApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        var chronometer = new Chronometer(new GarminClock());
        var session = new PossessionSession();
        chronometer.setStopListener(session.method(:onChronometerStopped));
        var controller = new ChronometerController(chronometer);
        var view = new ChronometerView(controller, session);
        return [view, new ChronometerInputDelegate(controller, view)];
    }
}
