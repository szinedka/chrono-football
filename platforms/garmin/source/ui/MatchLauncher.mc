import Toybox.Lang;
import Toybox.WatchUi;

module MatchLauncher {
    function open(settings as MatchSettings) as Void {
        var clock = new GarminClock();
        var session = new PossessionSession(settings);
        var chronometer = new Chronometer(clock);
        chronometer.setStopListener(session.method(:onChronometerStopped));
        var controller = new ChronometerController(chronometer, session);
        var view = new ChronometerView(controller, session);
        var delegate = new ChronometerInputDelegate(controller, view, session);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
}
