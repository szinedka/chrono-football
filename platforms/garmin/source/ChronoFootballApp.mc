import Toybox.Application;
import Toybox.WatchUi;

class ChronoFootballApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        var controller = new ChronometerController(new Chronometer(new GarminClock()));
        var view = new ChronometerView(controller);
        return [view, new ChronometerInputDelegate(controller, view)];
    }
}
